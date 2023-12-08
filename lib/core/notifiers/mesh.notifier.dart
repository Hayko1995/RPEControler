import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class MeshNotifier with ChangeNotifier {
  final backgroundService = FlutterBackgroundService();
  int? id = 0;
  int? get getId => id;

  int? temperature = 0;
  int? get getTemperature => temperature;

  MeshNotifier() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _count++;
      notifyListeners();
    });
  }
  int _count = 42;
  int get count => _count;

  final String _time = "aaa";
  String get time => _time;

  Future updateService(int _id, int _temperature) async {
    id = _id;
    temperature = _temperature;
    // notifyListeners();
  }

  void listenForNotificationData() {

    backgroundService.on('update').listen((event) async {
      print('received data message in feed: $event');
    }, onError: (e, s) {
      print('error listening for updates: $e, $s');
    }, onDone: () {
      print('background listen closed');
    });
  }
}
