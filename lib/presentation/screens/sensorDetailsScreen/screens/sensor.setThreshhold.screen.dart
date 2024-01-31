import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/core/service/mesh.service.dart';

class SensorSetThresholdScreen extends StatefulWidget {
  final String mac;

  const SensorSetThresholdScreen({super.key, required this.mac});

  @override
  _SensorSetThresholdScreenState createState() =>
      _SensorSetThresholdScreenState();
}

class _SensorSetThresholdScreenState extends State<SensorSetThresholdScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];
  late RpeDevice dataDevice;
  List<String> typeOfTimer = <String>['One Time', "Periodic"];
  List<String> typeOfControl = <String>["ON", "Off"];
  List<String> stateOfTimer = <String>['ON', "Off"];
  bool openCheckboxes = false;
  Map<String, bool> values = {
    'MA': false,
    'TU': false,
    'WE': false,
    "TH": false,
    "FR": false,
    "SA":false,
    "SU":false,
  };

  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _endDate = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _sms = new TextEditingController();


  @override
  void initState() {
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
                            initialSelection: typeOfTimer.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                timerType = value!;
                                if (timerType == 'Periodic') {
                                  openCheckboxes = true;
                                }
                                else {
                                  openCheckboxes = false;
                                }
                              });
                            },
                            label: const Text("Timer"),
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
                            label: const Text("Control"),
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
                if (openCheckboxes)
                  SizedBox(
                    width: 300,
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,

                      children: values.keys.map((String key) {
                        return SizedBox(
                          width: 40,
                          child: Column(
                            children: [
                              Text(key),
                              Checkbox(
                                value: values[key],
                                onChanged: (value) {
                                  setState(() {
                                    values[key] = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
                              _startDate.text = text;
                            },
                            controller: _startDate,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Start Date',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: 30,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextField(
                          onChanged: (text) {
                            _endDate.text = text;
                          },
                          controller: _endDate,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'End Date',
                          ),
                        ),
                      ),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: TextField(
                            onChanged: (text) {
                              _name.text = text;
                            },
                            controller: _name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: DropdownMenu<String>(
                          initialSelection: stateOfTimer.first,
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
                              _email.text = text;
                            },
                            controller: _email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Notify-Email',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: 30,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextField(
                          onChanged: (text) {
                            _sms.text = text;
                          },
                          controller: _sms,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'End Date',
                            labelText: 'Notify-sms',
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
