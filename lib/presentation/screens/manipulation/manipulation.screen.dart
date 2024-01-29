import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/clusterControlScreen/clusterControl.screen.dart';
import 'package:rpe_c/presentation/screens/assosiationScreen/assosiation.screen.dart';
import 'package:rpe_c/presentation/screens/clusteringScreen/clustering.screen.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final List<SalomonBottomBarItem> bottomNavBarIcons = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.group_work_outlined),
    title: const Text("Clustering"),
    selectedColor: Colors.blue,
  ),

  /// Search
  SalomonBottomBarItem(
    icon: const Icon(Icons.add),
    title: const Text("Association"),
    selectedColor: Colors.blue,
  ),
];

class ManipulationScreen extends StatefulWidget {
  final ManipulationsArgs manipulationsArgs;

  const ManipulationScreen({super.key, required this.manipulationsArgs});

  @override
  State<ManipulationScreen> createState() => _ManipulationScreenState();
}

class _ManipulationScreenState extends State<ManipulationScreen> {
  TextEditingController textController = TextEditingController();
  String displayText = "";

  List<String> manipulationType = <String>['Clustering', 'Associations'];
  List<String> sensorsType = <String>['All', 'Light', 'Buzzers'];
  List dataDevices = [];
  List items = [];
  String dropdownValue = "Clustering";
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ClusteringScreen(
          clusteringArguments: ClusteringArgs(cluster: null)),
      const AssociationScreen(
        associationArguments: AssociationArgs(cluster: null),
      )
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          'Manipulation Page',
        ),
        backgroundColor: Colors.blue,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: bottomNavBarIcons,
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: (dropdownValue == "Clustering")
                      ? const ClusteringScreen(
                          clusteringArguments: ClusteringArgs(cluster: null))
                      : const AssociationScreen(
                          associationArguments: AssociationArgs(cluster: null),
                        )),
            ],
          ),
        ),
      ],
    );
  }
}

class ManipulationsArgs {
  final int preDef;

  const ManipulationsArgs({required this.preDef});
}
