import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_project/custom_widget/custom_drawer.dart';
import 'package:mobile_project/pages/home_page/home/home_cubit.dart';
import 'package:mobile_project/pages/home_page/home/home_state.dart';
import 'package:mobile_project/pages/home_page/room_list/room_list.dart';
import 'package:mobile_project/services/network_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(context.read<NetworkService>())..init(),
      child: Scaffold(
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
        body: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
          previous.isConnected != current.isConnected,
          listener: (context, state) {
            final message = state.isConnected
                ? 'Connected to internet!'
                : 'No internet connection!';
            final color = state.isConnected ? Colors.green : Colors.red;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: color),
            );
          },
          child: const RoomList(),
        ),
      ),
    );
  }
}
