import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
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
    title: const Text("Set Threshold"),
    selectedColor: Colors.blue,
  ),

  SalomonBottomBarItem(
    icon: const Icon(Icons.timer),
    title: const Text("Editor"),
    selectedColor: Colors.blue,
  ),
];

class SensorDetailsScreen extends StatefulWidget {
  final SensorDetailsArgs sensorDetailsArguments;

  const SensorDetailsScreen({super.key, required this.sensorDetailsArguments});

  @override
  State<SensorDetailsScreen> createState() => _SensorDetailsScreenState();
}

class _SensorDetailsScreenState extends State<SensorDetailsScreen> {
  late RpeDevice dataDevice;

  @override
  void initState() {
    super.initState();
  }

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;

    final screens = [
      SensorHistoryScreen(
        mac: widget.sensorDetailsArguments.mac,
      ),
      SensorHistoryScreen(
        mac: widget.sensorDetailsArguments.mac,
      ),
      SensorHistoryScreen(
        mac: widget.sensorDetailsArguments.mac,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            screens[_currentIndex],
          ],
        ),
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
    super.dispose();
  }
}

class SensorDetailsArgs {
  final String mac;

  const SensorDetailsArgs({required this.mac});
}
