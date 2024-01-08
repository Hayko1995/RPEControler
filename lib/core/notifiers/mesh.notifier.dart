import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';

final DatabaseService _databaseService = DatabaseService();

class MeshNotifier with ChangeNotifier {
  int? id = 0;

  int? get getId => id;
  int? temperature = 0;

  int? get getTemperature => temperature;

  List<RpeNetwork>? networks = [];

  List<RpeNetwork>? get getAllNetworks => networks;

  List<RpeNetwork>? _predefines = [];
  List<Device>? _devices = [];

  List<RpeNetwork>? get getPredefines => _predefines;

  List<Device>? get getDevices => _devices;

  MeshNotifier() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // _count++;
      getNetworks();
    });
  }

  Future getNetworks() async {
    networks = await _databaseService.getAllNetworks();
    notifyListeners();
  }

  Future predefines(preDef) async {
    print("preDef");
    _predefines = await _databaseService.getNetworksByPreDef([preDef]);
    notifyListeners();
  }

  Future getDevicesByMac(mac) async {
    _devices = await _databaseService.getDevices(mac);
  }
}
