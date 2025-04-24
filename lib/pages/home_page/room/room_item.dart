import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

class Room {
  final String name;
  bool showDetails;
  final ValueNotifier<int> valueNotifier;
  Timer? _timer;

  Room({
    required this.name,
    this.showDetails = false,
    int initialValue = 0,
  }) : valueNotifier = ValueNotifier<int>(initialValue);

  void startUpdatingValue() {
    stopUpdatingValue();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      valueNotifier.value = Random().nextInt(101) - 50;
    });
  }

  void stopUpdatingValue() {
    _timer?.cancel();
    _timer = null;
  }

  int get value => valueNotifier.value;
}
