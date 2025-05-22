import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/pages/my_settings_page/my_settings_state.dart';
import 'package:usb_serial/usb_serial.dart';

class MySettingsCubit extends Cubit<MySettingsState> {
  MySettingsCubit() : super(const MySettingsState());
  static const portBaudRate = 115200;
  UsbPort? _port;

  Future<void> connectToDevice(String? qrResult) async {
    emit(state.copyWith(isLoading: true));

    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      emit(state.copyWith(
          errorMessage: 'There is no connected device',
          isLoading: false,
      ),
      );
      return;
    }

    if (qrResult == null) {
      emit(state.copyWith(
          errorMessage: 'QR-code reading error',
          isLoading: false,
      ),
      );
      return;
    }

    final data = jsonDecode(qrResult) as Map<String, dynamic>;
    final parsedId = data['id'] as int?;
    final parsedLogin = data['login'] as String?;
    final parsedPassword = data['password'] as String?;

    final device = devices.first;
    final port = await device.create();
    if (port == null || !(await port.open())) {
      emit(state.copyWith(
          errorMessage: 'Connection failed to: ${device.deviceName}',
          isLoading: false,
      ),
      );
      return;
    }

    _port = port;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      portBaudRate,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    final formatted = '$parsedId:$parsedLogin:$parsedPassword';
    await _port!.write(Uint8List.fromList(formatted.codeUnits));

    _port!.inputStream!.listen((data) {
      final response = String.fromCharCodes(data);
      if (response.contains('OK:')) {
        final intValue = int.tryParse(response.substring(3)) ?? 0;
        emit(state.copyWith(
          deviceId: intValue.toString(),
          isConnected: true,
          isLoading: false,
        ),
        );
      } else {
        emit(state.copyWith(
            errorMessage: 'Device response error',
            isLoading: false,
        ),
        );
      }
    });

    emit(state.copyWith(isLoading: true));
  }

  Future<void> sendNewId(String newId) async {
    if (_port != null) {
      final command = 'NEW:$newId';
      await _port!.write(Uint8List.fromList(command.codeUnits));
      emit(state.copyWith(lastCommand: command));
    } else {
      emit(state.copyWith(errorMessage: 'Port is not open'));
    }
  }

  Future<void> closePort() async {
    if (_port != null) {
      await _port!.close();
      _port = null;
      emit(state.copyWith(isPortClosed: true, isConnected: false));
    } else {
      emit(state.copyWith(errorMessage: 'Port already closed'));
    }
  }
}
