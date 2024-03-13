import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
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

  List<RpeNetwork>? get getPredefines => _predefines;

  List<RpeDevice>? _devices = [];

  List<RpeDevice>? get getDevices => _devices;
  RpeDevice? _device;
  List<Cluster> _clusters = [];

  List<Cluster>? get getAllClusters => _clusters;

  RpeDevice? get getDevice => _device;

  List<RpeDevice>? _allDevices = [];

  List<RpeDevice>? get allDevices => _allDevices;

  MeshNotifier() {
    Timer.periodic(const Duration(milliseconds: AppConstants.uiUpdateInterval),
        (timer) {
      // _count++;
      getNetworks();
      _getAllDevices();
      getClusters();
    });
  }

  Future getNetworks() async {
    networks = await _databaseService.getAllNetworks();
    return networks;
  }

  Future getClusters() async {
    _clusters = await _databaseService.getAllClusters();
  }

  Future sendClusterCommand() async {
    //todo add cluster command
  }

  Future sendActivationCommand(command, netId) async {
    final MeshAPI meshAPI = MeshAPI();
    String url = await _databaseService.getUrlByNetId([netId]);
    meshAPI.sendActivationCommand(command, url);
  }

  Future predefines(preDef) async {
    _predefines = await _databaseService.getNetworksByPreDef([preDef]);
    notifyListeners();
  }

  getDeviceByMac(mac) {
    for (RpeDevice device in _allDevices!) {
      if (device.macAddress == mac) {
        return device;
      }
    }
  }

  _getAllDevices() async {
    _allDevices = await _databaseService.getAllDevices();
    notifyListeners();
  }

  Future updateDevice(device) async {
    _databaseService.updateDevice(device);
  }

  insertCluster(clusterName, type, items) async {
    await _databaseService.insertCluster(
        Cluster(clusterName: clusterName, type: type, devices: items));
  }
}
