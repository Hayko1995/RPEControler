import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/widget/widget.dart';

class SensorSetTImerScreen extends StatefulWidget {
  final String mac;

  const SensorSetTImerScreen({super.key, required this.mac});

  @override
  _SensorSetTImerScreenState createState() => _SensorSetTImerScreenState();
}

class _SensorSetTImerScreenState extends State<SensorSetTImerScreen> {
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
  String timerType = '';

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
    timerType = typeOfTimer.first;
    String controlType = typeOfControl.first;
    String timerState = stateOfTimer.first;
    String secEndTime = '';
    String actionType = "00";
    String sensorActionNumber = "00";

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

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 600,
                  child: Padding(
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
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
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
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
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
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.4,
                                    child: TextField(
                                      controller: _startDate,
                                      //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          //icon of text field
                                          labelText:
                                              "Enter Date" //label text of field
                                          ),
                                      readOnly: true,
                                      // when true user cannot edit text
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            //get today's date
                                            firstDate: DateTime(2000),
                                            //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          TimeOfDay? pickeTime =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now());

                                          if (pickeTime != null) {
                                            print(
                                                pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                            String formattedDate =
                                                DateFormat('dd:MM:yy').format(
                                                    pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                            print(
                                                formattedDate); //formatted date output using intl package =>  2022-07-04
                                            //You can format date as per your need

                                            setState(() {
                                              _startDate.text =
                                                  "$formattedDate ${pickeTime.hour}:${pickeTime.minute}"; //set foratted date to TextField value.
                                            });
                                          } else {
                                            print("Date is not selected");
                                          }
                                        }
                                      },
                                    )),
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
                                  onSelected: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      timerType = value!;
                                    });
                                  },
                                  label: const Text("Status"),
                                  dropdownMenuEntries: typeOfControl
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                  onPressed: () async {
                                    if (timerType == 'One Time') {
                                      timerType = "00";
                                      actionType = "00";
                                      String timerName = "timer"; //todo change
                                      String control = '1'; // todo change
                                      var d1 = DateTime.now();
                                      // var d1t2 = parseInt(d1.time() / 1000);
                                      // var StartTimeinSec = d1t2 - 946713600;
                                      var secStartTime = DateTime(1546114320000)
                                          .toIso8601String();
                                      if (timerType == "Off") {
                                        timerType = '01';
                                        secEndTime = '00000000';
                                      } else {
                                        var EndTimeinSec =
                                            DateTime(1546114320000 - 946684800)
                                                .toIso8601String();
                                        timerType = '11';
                                        actionType = "10";
                                        sensorActionNumber = '00';
                                      }
                                    } else {
                                      timerType = "01";
                                      actionType = "11";
                                      sensorActionNumber = '01';
                                    }
                                    MeshTimer meshTimer = MeshTimer();
                                    String command = meshTimer.sendSetTimer(
                                        dataDevice.dNum,
                                        dataDevice.netId,
                                        '00',
                                        "1F7723",
                                        '000000',
                                        timerType,
                                        actionType,
                                        sensorActionNumber,
                                        "00000000",
                                        'FF',
                                        'FF',
                                        "01");
                                    bool response = await meshNotifier
                                        .sendCommand(command, dataDevice.netId);
                                  },
                                  child: const Text('Save')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
