import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService extends ChangeNotifier {
  bool _isConnected = true;
  late StreamSubscription<dynamic> _subscription;

  bool get isConnected => _isConnected;

  NetworkService() {
    _subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) {
      final hasConnection = result != ConnectivityResult.none;
      if (hasConnection != _isConnected) {
        _isConnected = hasConnection;
        notifyListeners();
      }
    });

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
