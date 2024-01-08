import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/screens/assosiation.screen.dart';
import 'package:rpe_c/presentation/screens/manipulation/screens/clustering.screen.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final List<SalomonBottomBarItem> bottomNavBarIcons = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.group_work_outlined),
    title: const Text("Association"),
    selectedColor: Colors.blue,
  ),

  /// Search
  SalomonBottomBarItem(
    icon: const Icon(Icons.add),
    title: const Text("Clustering"),
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
  final DatabaseService _databaseService = DatabaseService();

  TextEditingController textController = TextEditingController();
  String displayText = "";

  List<String> manipulationType = <String>['Clustering', 'Associations'];
  List<String> sensorsType = <String>['All', 'Light', 'Buzzers'];
  List dataDevices = [];
  List _items = [];
  List items = [];
  String dropdownValue = "Clustering";
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final screens = [
      ClusteringScreen(),
      AssosiationScreen()
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
    return SingleChildScrollView(
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text("Save"),
                  ),
                ]),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: (dropdownValue == "Clustering")
                        ? ClusteringScreen()
                        : AssosiationScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ManipulationsArgs {
  final int preDef;

  const ManipulationsArgs({required this.preDef});
}


