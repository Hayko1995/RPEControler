import 'dart:async';

import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/core/service/mesh.service.dart';

class ProvisionNotifier with ChangeNotifier {
  final provisioner = Provisioner.espTouch();

  ProvisionNotifier() {
    Timer.periodic(const Duration(milliseconds: AppConstants.uiUpdateInterval),
        (timer) {});
  }

  Future setConfig(ssid, bssid, password) async {
    provisioner.listen((response) {
      print("\n"
          "\n------------------------------------------------------------------------\n"
          "Device ($response) is connected to WiFi!"
          "\n------------------------------------------------------------------------\n");
    });
    await provisioner.start(ProvisioningRequest.fromStrings(
      ssid: ssid,
      bssid: bssid,
      password: password,
    ));
  }

  Future getResponse() async {
    notifyListeners();
  }
}
