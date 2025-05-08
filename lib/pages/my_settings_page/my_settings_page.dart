import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/my_settings_page/qr_scan_page.dart';
import 'package:usb_serial/usb_serial.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  String? receivedData;
  UsbPort? _port;
  String? qrResult;
  int? parsedId;
  String? parsedLogin;
  String? parsedPassword;
  bool isDeviceConnected = false;
  String? currentDeviceId;

  Future<void> _sendParsedData() async {
    if (_port == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Port closed')),
      );
      return;
    }

    final String formatted = '$parsedId:$parsedLogin:$parsedPassword';

    await _port!.write(Uint8List.fromList(formatted.codeUnits));
  }

  void _onConnectDevicePressed() async {
    final devices = await UsbSerial.listDevices();

    if (!mounted) return;
    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is no connected device')),
      );
      return;
    }

    final qrCode = await Navigator.push(
      context,
      MaterialPageRoute<String>(
          builder: (context) => const QrScannerPage(),
      ),
    );

    if (!mounted) return;

    if (qrCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR-code reading error')),
      );
      return;
    }

    setState(() {
      qrResult = qrCode.toString();

      final Map<String, dynamic> data =
      jsonDecode(qrResult!) as Map<String, dynamic>;

      parsedId = data['id'] as int?;
      parsedLogin = data['login'] as String?;
      parsedPassword = data['password'] as String?;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'parsed data: id=$parsedId, '
                  'login=$parsedLogin, password=$parsedPassword'),
        ),
      );
    });

    final device = devices.first;

    final UsbPort? port = await device.create();

    if (!mounted) return;
    if (port == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fail connecting to device: ${device.deviceName}'),
        ),
      );
      return;
    }

    final bool openSuccess = await port.open();
    if (!mounted) return;
    if (!openSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Port opening failed: ${device.deviceName}')),
      );
      return;
    }

    _port = port;

    await port.setDTR(true);
    await port.setRTS(true);
    await port.setPortParameters(
      115200,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    await _sendParsedData();

    port.inputStream!.listen((data) {
      final response = String.fromCharCodes(data);

      setState(() {
        receivedData = response;
      });

      if(!mounted) return;
      if(response.contains('OK:')) {
        final intValueString = response.substring(3);
        final int parsedValue = int.tryParse(intValueString) ?? 0;

        setState(() {
          currentDeviceId = parsedValue.toString();
        });

        isDeviceConnected = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CONNECTION: OK')),
        );
      } else {
        isDeviceConnected = false;
      }
    },
    );
  }

  void _onEditIdPressed() async {
    if (isDeviceConnected) {
      showDialog<void>(
        context: context,
        builder: (context) {
          String newId = '';
          return AlertDialog(
            title: const Text('Enter New Device ID'),
            content: TextField(
              onChanged: (value) {
                newId = value;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter the new ID',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (newId.isNotEmpty) {
                    _sendNewIdToDevice(newId);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid ID')),
                    );
                  }
                },
                child: const Text('Confirm'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device not connected')),
      );
    }
  }

  void _sendNewIdToDevice(String newId) async {
    if (_port != null) {
      final String command = 'NEW:$newId';

      await _port!.write(Uint8List.fromList(command.codeUnits));

      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sent command: $command')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Port is not open')),
      );
    }
  }


  void _onClosePortPressed() async {
    if (_port != null) {
      await _port!.close();
      setState(() {
        receivedData = 'Port closed';
        _port = null;
      });

      isDeviceConnected = false;
      currentDeviceId = '0';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully closed')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Port already closed')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current device settings'),
        backgroundColor: const Color(0xFFD86FFF),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentDeviceId != null)
              Text('User device id: $currentDeviceId'),
            ElevatedButton(
              onPressed: _onConnectDevicePressed,
              child: const Text('Connect by QR-code'),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _onEditIdPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
              ),
              child: const Text('Edit device user id'),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: _onClosePortPressed,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Close port'),
            ),
          ],
        ),
      ),
    );
  }
}
