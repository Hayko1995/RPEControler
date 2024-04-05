import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/logger/logger.dart';
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

  List<Associations> _assotiations = [];

  List<Associations>? get getAllAssociations => _assotiations;

  RpeDevice? get getDevice => _device;

  List<RpeDevice>? _allDevices = [];

  List<RpeDevice>? get allDevices => _allDevices;
  final MeshAPI meshAPI = MeshAPI();

  MeshNotifier() {
    Timer.periodic(const Duration(milliseconds: AppConstants.uiUpdateInterval),
        (timer) {
      // _count++;
      getNetworks();
      _getAllDevices();
      getClusters();
      getAssociations();
    });
  }

  Future getNetworks() async {
    networks = await _databaseService.getAllNetworks();
    return networks;
  }

  Future getClusters() async {
    _clusters = await _databaseService.getAllClusters();
  }

  Future getAssociations() async {
    _assotiations = await _databaseService.getAllAssociations();
  }

  Future sendClusterCommand(singleNet, netId, clusterId, clusterNodes) async {
    //todo add cluster command

    final MeshAPI meshAPI = MeshAPI();
    String url = await _databaseService.getUrlByNetId([netId]);
    meshAPI.createCluster(
        singleNet, netId, clusterId, clusterNodes, url); //todo Ask Harry
  }

  Future sendAssociationCommand(singleNet, netId, clusterId, clusterNodes) async {
    //todo add cluster command

    final MeshAPI meshAPI = MeshAPI();
    String url = await _databaseService.getUrlByNetId([netId]);
    meshAPI.createCluster(
        singleNet, netId, clusterId, clusterNodes, url); //todo Ask Harry
  }

  Future sendE1() async {
    //todo add cluster command

    final MeshAPI meshAPI = MeshAPI();
    meshAPI.meshE1();
  }

  Future sendActivationCommand(command, netId) async {
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

  updateDevice(device) async {
    _databaseService.updateDevice(device);
  }

  sendCommand(String command, String netId) async {
    String url = await _databaseService.getUrlByNetId([netId]);
    bool result = await meshAPI.sendToMesh(command, url);
    logger.i(result);
    return result;
  }

  insertCluster(clusterId, clusterName, type, netNumber, items, status) async {
    await _databaseService.insertCluster(Cluster(
        clusterId: clusterId,
        clusterName: clusterName,
        type: type,
        netNumber: netNumber,
        devices: items,
        status: status));
  }

  insertAssociation(associationId, associationName, type, netNumber,
      fromDevices, toDevices, status) async {
    await _databaseService.insertAssociation(Associations(
      associationId: associationId,
      associationName: associationName,
      type: type,
      netNumber: netNumber,
      fromDevices: fromDevices,
      toDevices: toDevices,
      status: status,
    ));
  }

  deleteCluster(clusterId) async {
    await _databaseService.deleteCluster(clusterId);
  }

  deleteAssociation(associationId) async {
    await _databaseService.deleteAssociation(associationId);
  }

  disableCluster(clusterId) async {
    await _databaseService.disableCluster(clusterId);
  }

  enableCluster(clusterId) async {
    await _databaseService.enableCluster(clusterId);
  }

  deleteClusterViaNetId(netId) async {
    await _databaseService.deleteClusterViaNetId(netId);
  }
  deleteAssociationViaNetId(netId) async {
    // await _databaseService.deleteClusterViaNetId(netId);
    await _databaseService.deleteAssociationViaNetId(netId);
  }
}
