import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/sensor.history.screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final List<SalomonBottomBarItem> bottomNavBarIcons = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.info),
    title: const Text("Device summary"),
    selectedColor: Colors.blue,
  ),

  /// Search
  SalomonBottomBarItem(
    icon: const Icon(Icons.add),
    title: const Text("Watcher"),
    selectedColor: Colors.blue,
  ),

  SalomonBottomBarItem(
    icon: const Icon(Icons.timer),
    title: const Text("Editor"),
    selectedColor: Colors.blue,
  ),
];

class sensorDetailsScreen extends StatefulWidget {
  final SensorDetailsArgs sensorDetailsArguments;

  const sensorDetailsScreen({super.key, required this.sensorDetailsArguments});

  @override
  State<sensorDetailsScreen> createState() => _sensorDetailsScreenState();
}

class _sensorDetailsScreenState extends State<sensorDetailsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Timer _timer;
  List<Device> dataDevices = <Device>[];

  // void _updateData() async {
  //   // List<Device> devices =
  //   //     await _databaseService.getDevices(widget.sensorDetailsArguments.mac);
  //   // logger.w(_dataUpload);
  //
  //   // TODO write logic for Widget
  //   if (mounted) {
  //     setState(() {
  //       dataDevices = devices;
  //     });
  //   }
  // }

  @override
  void initState() {
    // _updateData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //   _updateData();
    });
    super.initState();
  }

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;
    final screens = [
      SensorHistoryScreen(
        deviceId: widget.sensorDetailsArguments.deviceId,
      ),
      SensorHistoryScreen(
        deviceId: widget.sensorDetailsArguments.deviceId,
      ),
      SensorHistoryScreen(
        deviceId: widget.sensorDetailsArguments.deviceId,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor details"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: bottomNavBarIcons,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class SensorDetailsArgs {
  final String deviceId;

  const SensorDetailsArgs({required this.deviceId});
}
