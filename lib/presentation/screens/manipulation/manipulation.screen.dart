import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/api/mesh.api.test.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/widget/device.widget.dart';

import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
import 'package:rpe_c/presentation/widgets/predefine.widgets.dart';

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

  List<Widget> slideble = [
    Slidable(
      key: const ValueKey(1),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {}),
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
      child: const ListTile(title: Text('device')),
    ),
    Slidable(
      key: const ValueKey(1),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {}),
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
      child: const ListTile(title: Text('Slide me')),
    ),
  ];

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
        endDrawer: DrawerWidget(
          Selected: (Widget option) {
            setState(() {
              slideble.add(option);
            });
          },
        ),

        // Drawer(
        //   elevation: 16.0,
        //   child: Column(
        //     children: <Widget>[
        //       Expanded(
        //         child: FilledButton(
        //           onPressed: () {
        //             aa.add(Slidable(
        //               key: const ValueKey(1),
        //
        //               // The end action pane is the one at the right or the bottom side.
        //               endActionPane: ActionPane(
        //                 motion: const ScrollMotion(),
        //                 // dismissible: DismissiblePane(onDismissed: () {}),
        //                 children: [
        //                   SlidableAction(
        //                     onPressed: (BuildContext context) {},
        //                     backgroundColor: const Color(0xFFFE4A49),
        //                     foregroundColor: Colors.white,
        //                     icon: Icons.delete,
        //                     label: 'Delete',
        //                   ),
        //                 ],
        //               ),
        //
        //               // The child of the Slidable is what the user sees when the
        //               // component is not dragged.
        //               child: const ListTile(title: Text('device')),
        //             ));
        //             setState(() {});
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text('add device '),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.7,
                child: ListView.builder(
                  itemCount: slideble.length,
                  itemBuilder: (BuildContext context, int index) {
                    return slideble[index];
                  },
                ),
              ),
            ],
          ),
        ));
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

class DrawerWidget extends StatefulWidget {
  final void Function(Widget) Selected;

  const DrawerWidget({
    Key? key,
    required this.Selected,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('first option'),
            onTap: () {
              widget.Selected(Slidable(
                key: const ValueKey(1),

                // The end action pane is the one at the right or the bottom side.
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  // dismissible: DismissiblePane(onDismissed: () {}),
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
                child: const ListTile(title: Text('device')),
              ));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
