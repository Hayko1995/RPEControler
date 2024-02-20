import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/core/service/mesh.service.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/widget/widget.dart';

class SensorSetThresholdScreen extends StatefulWidget {
  final String mac;

  const SensorSetThresholdScreen({super.key, required this.mac});

  @override
  _SensorSetThresholdScreenState createState() =>
      _SensorSetThresholdScreenState();
}

class _SensorSetThresholdScreenState extends State<SensorSetThresholdScreen> {
  Color caughtColor = Colors.grey;
  List<String> data = [];
  late RpeDevice dataDevice;
  late List<RpeDevice> allDevices;
  late List<Cluster> allClusters = [];
  List<String> typeOfTimer = <String>['One Time', "Periodic"];
  List<String> typeOfControl = <String>["ON", "Off"];
  List<String> stateOfTimer = <String>['ON', "Off"];
  List<String> types = <String>['Devices', 'Clusters'];
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
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _sms = new TextEditingController();
  final TextEditingController _trresholdName = new TextEditingController();
  final TextEditingController _energyCost = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    dataDevice = meshNotifier.getDeviceByMac(widget.mac);
    allClusters == meshNotifier.getAllClusters;
    String timerType = typeOfTimer.first;
    String controlType = typeOfControl.first;
    String timerState = stateOfTimer.first;

    var selectedIndexes = [];
    List<RpeDevice> data = meshNotifier.allDevices!;

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      List<RpeDevice> data = meshNotifier.allDevices!;
      // List<Map<String, Object>> data = widget.sensorDetailsArguments.data;
      for (var i = 0; i < data.length; i++) {
        sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
      }
      return sensorList;
    }

    Future openDevices() {
      String dropdownValue = types.first;
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 600,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownMenu<String>(
                    initialSelection: types.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries:
                        types.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: getSensors())),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Future openTimerSheet() {
      String dropdownValue = types.first;
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 600,
            child:Padding(
              padding: const EdgeInsets.all(12.0),
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
                                      } else {
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
                              openDevices();
                            },
                            child: const Text('Save')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Future openThresholdSheet() {
      String dropdownValue = types.first;
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 600,
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
          );
        },
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text("This Device"),
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          openDevices();
                        },
                        child: const Text('change device')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text("Set Timer"),
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          openTimerSheet();
                        },
                        child: const Text('Set timer')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text("Set Threshold"),
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          openThresholdSheet();
                        },
                        child: const Text('Set Threshold')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text("This Device"),
                      ),
                    ),
                    FilledButton(
                        onPressed: () {
                          openDevices();
                        },
                        child: const Text('change device')),
                  ],
                ),



              ],
            )),
      ),
    );
  }
}
