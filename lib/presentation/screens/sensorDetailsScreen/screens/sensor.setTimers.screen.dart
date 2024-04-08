import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
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
  List<String> typeOfControl = <String>["ON", "Off", "Up", "Down"];
  List<String> stateOfTimer = <String>['ON', "Off"];
  List<String> types = <String>['Devices', 'Clusters'];
  bool oneTimeOrPereudic = false;
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
  String statusType = '';
  String controlType = '';
  String timerStatus = '';
  String actionType = '';

  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _startTime = new TextEditingController();
  final TextEditingController _endTime = new TextEditingController();
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

    String hexEndTimer = '';

    String sensorActionNumber = "00";
    String timeAndData = '';
    String hexStartTime = '';
    String command = "";

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
                                          oneTimeOrPereudic = true;
                                        } else {
                                          oneTimeOrPereudic = false;
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
                                        controlType = value!;
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
                        if (oneTimeOrPereudic)
                          SizedBox(
                            width: 300,
                            height: 70,
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
                        oneTimeOrPereudic
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.4,
                                        child: TextField(
                                          controller: _startTime,
                                          //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              //icon of text field
                                              labelText:
                                                  "Start Time" //label text of field
                                              ),
                                          readOnly: true,
                                          onTap: () async {
                                            TimeOfDay? pickeTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());

                                            if (pickeTime != null) {
                                              setState(() {
                                                _startTime.text =
                                                    "${pickeTime.hour}:${pickeTime.minute}";
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.4,
                                        child: TextField(
                                          controller: _endTime,
                                          //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              //icon of text field
                                              labelText:
                                                  "End Time" //label text of field
                                              ),
                                          readOnly: true,
                                          onTap: () async {
                                            TimeOfDay? pickeTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());

                                            if (pickeTime != null) {
                                              setState(() {
                                                _endTime.text =
                                                    "${pickeTime.hour}:${pickeTime.minute}";
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                        )),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                    SizedBox(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.4,
                                          child: TextField(
                                            controller: _startDate,
                                            //editing controller of this TextField
                                            decoration: const InputDecoration(
                                                //icon of text field
                                                labelText:
                                                    "Enter Date" //label text of field
                                                ),
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      //get today's date
                                                      firstDate: DateTime(2000),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                TimeOfDay? pickeTime =
                                                    await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now());

                                                if (pickeTime != null) {
                                                  String formattedDate =
                                                      DateFormat('dd:MM:yy').format(
                                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

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
                                      timerStatus = value!;
                                    });
                                  },
                                  label: const Text("Status"),
                                  dropdownMenuEntries: stateOfTimer
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
                                    MeshTimer meshTimer = MeshTimer();
                                    print(oneTimeOrPereudic);
                                    if (oneTimeOrPereudic == false) {
                                      timerType = "00";
                                      if (controlType == "ON") {
                                        actionType = "01";
                                      } else {
                                        actionType = "00";
                                      }

                                      String timerName = "timer"; //todo change

                                      String startDay =
                                          _startDate.text.toString();
                                      print(startDay);
                                      int day =
                                          int.parse((startDay.substring(0, 2)));

                                      int mounts =
                                          int.parse(startDay.substring(3, 5));
                                      int year = int.parse(
                                          "20" + startDay.substring(6, 8));
                                      int hour =
                                          int.parse(startDay.substring(9, 11));
                                      int minute =
                                          int.parse(startDay.substring(12));

                                      var d2 = DateTime.now();
                                      int dh =
                                          d2.millisecondsSinceEpoch ~/ 1000;
                                      var d1 = DateTime(
                                          year, mounts, day, hour, minute);
                                      var d1t2 =
                                          d1.millisecondsSinceEpoch ~/ 1000;
                                      int StartTimeInSec = d1t2 - 946713600;
                                      hexStartTime =
                                          StartTimeInSec.toRadixString(16);
                                      print(hexStartTime);
                                      print(d1);
                                      hexEndTimer = '00000000';
                                      command = meshTimer.sendSetTimer(
                                          dataDevice.dNum.toString(),
                                          dataDevice.netId,
                                          '01',
                                          hexStartTime,
                                          hexEndTimer,
                                          timerType,
                                          actionType,
                                          sensorActionNumber,
                                          hexEndTimer,
                                          'FF',
                                          'FF',
                                          timerStatus);

                                      if (timerType == "Off") {
                                        timerType = '01';
                                      } else {
                                        timerType = '11';
                                        sensorActionNumber = '00';
                                      }
                                    } else {
                                      timerType = "01";
                                      sensorActionNumber = '01';

                                      if (timerStatus == "ON") {
                                        timerStatus = '01';
                                      } else {
                                        timerStatus = '00';
                                      }

                                      String inStartTime =
                                          _startTime.text.toString();

                                      String inEndTime =
                                          _startTime.text.toString();
                                      int hStartTime = int.parse(
                                          (inStartTime.substring(0, 2)));
                                      int mStartTime =
                                          int.parse(inStartTime.substring(3));
                                      int startTimeinSec = (3600 * hStartTime) +
                                          (60 * mStartTime);

                                      String secStartTime =
                                          MeshAPI.hexPadding(startTimeinSec);

                                      int hEndTime = int.parse(
                                          (inEndTime.substring(0, 2)));
                                      int mEndTime =
                                          int.parse(inEndTime.substring(3));
                                      int endTimeinSec =
                                          (3600 * hEndTime) + (60 * mEndTime);
                                      String secEndTime =
                                          MeshAPI.hexPadding(endTimeinSec);

                                      int suDay;
                                      int mDay;
                                      int tDay;
                                      int wDay;
                                      int thDay;
                                      int fDay;
                                      int saDay;
                                      if (values[0] == true) {
                                        suDay = 1;
                                      } else {
                                        suDay = 0;
                                      }
                                      if (values[1] == true) {
                                        mDay = 2;
                                      } else {
                                        mDay = 0;
                                      }
                                      if (values[2] == true) {
                                        tDay = 4;
                                      } else {
                                        tDay = 0;
                                      }
                                      if (values[3] == true) {
                                        wDay = 8;
                                      } else {
                                        wDay = 0;
                                      }
                                      if (values[4] == true) {
                                        thDay = 16;
                                      } else {
                                        thDay = 0;
                                      }
                                      if (values[5] == true) {
                                        fDay = 32;
                                      } else {
                                        fDay = 0;
                                      }
                                      if (values[6] == true) {
                                        saDay = 64;
                                      } else {
                                        saDay = 0;
                                      }
                                      int days = suDay +
                                          mDay +
                                          tDay +
                                          wDay +
                                          thDay +
                                          fDay +
                                          saDay;
                                      if (days == 0) {
                                        print("days need to be not 0");
                                      }
                                      String weekDays;
                                      if (days < 16) {
                                        weekDays = days.toRadixString(16);
                                        weekDays = '0$weekDays';
                                      } else {
                                        weekDays = days.toRadixString(16);
                                      }
                                      String inTimType;
                                      if (days == 127) {
                                        // everyday of the week
                                        inTimType = '2';
                                      } else {
                                        inTimType = '4';
                                      }
                                      if (controlType == 'Off') {
                                        // off
                                        timerType = '0' + inTimType;
                                        secEndTime = '00000000';
                                      } else {
                                        timerType = '1' + inTimType;
                                      }
                                      command = meshTimer.sendSetTimer(
                                          dataDevice.dNum.toString(),
                                          dataDevice.netId,
                                          '01',
                                          secStartTime,
                                          secEndTime,
                                          timerType,
                                          actionType,
                                          sensorActionNumber,
                                          weekDays,
                                          'FF',
                                          'FF',
                                          timerStatus);
                                    }
                                    print(command);
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
