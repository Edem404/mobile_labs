import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mobile_project/services/mqtt_service.dart';

class Room {
  final String name;
  bool showDetails;
  final ValueNotifier<double> valueNotifier;
  MQTTService? _mqttService;
  StreamSubscription<double>? _subscription;

  Room({
    required this.name,
    this.showDetails = false,
    double initialValue = 0,
  }) : valueNotifier = ValueNotifier<double>(initialValue);

  void startUpdatingValue() {
    stopUpdatingValue();

    _mqttService = MQTTService();
    _subscription = _mqttService!.connectAndListen().listen((value) {
      valueNotifier.value = value;
    });
  }

  void stopUpdatingValue() {
    _subscription?.cancel();
    _mqttService?.disconnect();
    _subscription = null;
    _mqttService = null;
  }

  double get value => valueNotifier.value;
}
