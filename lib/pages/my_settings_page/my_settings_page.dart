import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/my_settings_page/my_settings_cubit.dart';
import 'package:mobile_project/pages/my_settings_page/my_settings_state.dart';
import 'package:mobile_project/pages/my_settings_page/qr_scan_page.dart';

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  Future<void> _openQrScanner(BuildContext context) async {
    final qrCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (qrCode != null && context.mounted) {
      context.read<MySettingsCubit>().connectToDevice(qrCode);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR-code reading error')),
      );
    }
  }

  void _showEditIdDialog(BuildContext context, bool isConnected) {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Device not connected')),
      );
      return;
    }

    final TextEditingController controller = TextEditingController();
    final cubit = context.read<MySettingsCubit>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter New Device ID'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter the new ID'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newId = controller.text.trim();
                if (newId.isNotEmpty) {
                  cubit.sendNewId(newId);
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MySettingsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Current device settings'),
          backgroundColor: const Color(0xFFD86FFF),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: BlocConsumer<MySettingsCubit, MySettingsState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
              if (state.lastCommand != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sent command: ${state.lastCommand}')),
                );
              }
              if (state.isPortClosed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully closed')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.deviceId != null)
                    Text('User device id: ${state.deviceId}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _openQrScanner(context),
                    child: const Text('Connect by QR-code'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        _showEditIdDialog(context, state.isConnected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                    ),
                    child: const Text('Edit device user id'),
                  ),
                  const SizedBox(height: 10),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () =>
                            context.read<MySettingsCubit>().closePort(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Close port'),
                      );
                    },
                  ),
                  if (state.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
