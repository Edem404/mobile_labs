import 'package:flutter/material.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/home_page/room_list.dart';
import 'package:mobile_project/services/network_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NetworkService _networkService;
  bool _wasConnected = true;
  final List<String> rooms = [];

  @override
  void initState() {
    super.initState();
    _networkService = context.read<NetworkService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _networkService.addListener(_handleConnectionChange);
    });
  }

  void _handleConnectionChange() {
    if (!_networkService.isConnected && _wasConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection!'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_networkService.isConnected && !_wasConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connected to internet!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    _wasConnected = _networkService.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: const Center(
        child: Column(
          children: [
            Expanded(
              child: RoomList(),
            ),
          ],
        ),
      ),
    );
  }
}
