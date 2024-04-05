import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/core/service/mesh.service.dart';

class SensorTimersScreen extends StatefulWidget {
  final String mac;

  const SensorTimersScreen({super.key, required this.mac});

  @override
  _SensorTimersScreenState createState() => _SensorTimersScreenState();
}

class _SensorTimersScreenState extends State<SensorTimersScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];
  late RpeDevice dataDevice;
  List<String> typeOfTimer = <String>['One Time', "Periodic"];
  List<String> typeOfControl = <String>["Below", "Above", "Inside", "Outside"];
  List<String> stateOfTimer = <String>['ON', "Off"];
  bool openCheckboxes = false;
  Map<String, bool> values = {
    'MA': false,
    'TU': false,
    'WE': false,
    "TH": false,
    "FR": false,
    "SA": false,
    "SU": false,
  };

  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _endDate = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _trresholdName = new TextEditingController();
  final TextEditingController _energyCost = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    dataDevice = meshNotifier.getDeviceByMac(widget.mac);
    String timerType = typeOfTimer.first;
    String controlType = typeOfControl.first;
    String timerState = stateOfTimer.first;

    var selectedIndexes = [];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    child: SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: DropdownMenu<String>(
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                timerType = value!;
                                if (timerType == 'Periodic') {
                                  openCheckboxes = true;
                                } else {
                                  openCheckboxes = false;
                                }
                              });
                            },
                            label: const Text("Sensor Type"),
                            dropdownMenuEntries: typeOfTimer
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          child: DropdownMenu<String>(
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                timerType = value!;
                              });
                            },
                            label: const Text("Threshold Type"),
                            dropdownMenuEntries: typeOfControl
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ),
                      ]),
                )),
                SizedBox(
                  height: 10,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: DropdownMenu<String>(
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              timerType = value!;
                            });
                          },
                          label: const Text("Set Control"),
                          dropdownMenuEntries: typeOfTimer
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        child: DropdownMenu<String>(
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              timerType = value!;
                            });
                          },
                          label: const Text("Timer Type"),
                          dropdownMenuEntries: typeOfControl
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      SizedBox(
                        child: DropdownMenu<String>(
                          label: const Text("set Action"),
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              timerState = value!;
                            });
                          },
                          dropdownMenuEntries: stateOfTimer
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: TextField(
                            onChanged: (text) {
                              _trresholdName.text = text;
                            },
                            controller: _trresholdName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: 30,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextField(
                          onChanged: (text) {
                            _energyCost.text = text;
                          },
                          controller: _energyCost,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Energy Coast',
                          ),
                        ),
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Save')),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
