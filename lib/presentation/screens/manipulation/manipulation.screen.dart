import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';

class ManipulationScreen extends StatefulWidget {
  final ManipulationsArgs manipulationsArgs;

  const ManipulationScreen({super.key, required this.manipulationsArgs});

  @override
  State<ManipulationScreen> createState() => _ManipulationScreenState();
}

class _ManipulationScreenState extends State<ManipulationScreen> {
  List<String> list = <String>['Clustering', 'Associations'];
  final DatabaseService _databaseService = DatabaseService();
  late Timer _timer;
  List<RpeNetwork> dataDevices = <RpeNetwork>[];
  List<RpeNetwork> data = <RpeNetwork>[];
  List<Widget> aa = [];

  @override
  void initState() {
    super.initState();
  }

  List cluster = [];
  List<Widget> slideble = [];

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;
    String dropdownValue = list.first;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Manipulation Page'),
          backgroundColor: Colors.blue,
        ),
        onEndDrawerChanged: (isOpened) {
          setState(() {});
        },
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: ListView.builder(
                    itemCount: slideble.length,
                    itemBuilder: (BuildContext context, int index) {
                      return slideble[index];
                    },
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  _showPopupMenu();
                },
                child: const Text('Add Device'),
              ),
            ],
          ),
        ));
  }

  Widget addSlideble(name) {
    return Slidable(
      key: const ValueKey(1),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(title: Text(name)),
    );
  }

  void _showPopupMenu() async {
    final devices = await _databaseService.getAllDevices();
    List<PopupMenuEntry<dynamic>> _popUpMenu = [];
    for (int i = 0; i < devices.length; i++) {
      _popUpMenu.add(PopupMenuItem(
        value: i,
        child: Text(devices[i].name),
      ));
    }
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: _popUpMenu,
      elevation: 8.0,
    ).then((value) {
      if (value != null)
        setState(() {
          slideble.add(addSlideble(devices[value].name));
        });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ManipulationsArgs {
  final int preDef;

  const ManipulationsArgs({required this.preDef});
}
