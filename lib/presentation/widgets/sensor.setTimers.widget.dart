import 'dart:async';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/widget/custom.widget.dart';

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
  String timerId = '01';

  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _endDate = new TextEditingController();
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

    CacheManagerUtils.conditionalCache(
      key: AppKeys.timerId,
      valueType: ValueType.StringValue,
      actionIfNull: () {
        WriteCache.setString(key: AppKeys.timerId, value: '00');
        timerId = "00";
      },
      actionIfNotNull: () async {
        timerId = await ReadCache.getString(key: AppKeys.timerId);
      },
    );

    dataDevice = meshNotifier.getDeviceByMac(widget.mac);
    if (dataDevice.isActivation == 1) {
      typeOfControl = ["ON", "Off"];
    }
    allClusters == meshNotifier.getAllClusters;
    timerType = typeOfTimer.first;

    String hexEndTimer = '';

    String sensorActionNumber = "00";
    String timeAndData = '';
    String hexStartTime = '';
    String command = "";
    String secStartTime = "";
    String secEndTime = "";

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

    String hexPadding(num) {
      if (num < 16777217) {
        if (num < 65536) {
          if (num < 4096) {
            if (num < 256) {
              num = num.toRadixString(16);
              num = '0000' + num;
            } else {
              num = num.toRadixString(16);
              num = '000' + num;
            }
          } else {
            num = num.toRadixString(16);
            num = '0000' + num;
          }
        } else {
          if (num < 1048576) {
            num = num.toRadixString(16);
            num = '000' + num;
          } else {
            num = num.toRadixString(16);
            num = '00' + num;
          }
        }
      } else {
        if (num < 268435456) {
          num = num.toRadixString(16);
          num = '0' + num;
        } else {
          num = num.toRadixString(16);
        }
      }
      return num;
    }

    Future<void> saveAction() async {
      {
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

          String startDay = _startDate.text.toString();
          print(startDay);
          int day = int.parse((startDay.substring(0, 2)));

          int mounts = int.parse(startDay.substring(3, 5));
          int year = int.parse("20" + startDay.substring(6, 8));
          int hour = int.parse(startDay.substring(9, 11));
          int minute = int.parse(startDay.substring(12));

          var d2 = DateTime.now();
          int dh = d2.millisecondsSinceEpoch ~/ 1000;
          var d1 = DateTime(year, mounts, day, hour, minute);
          var d1t2 = d1.millisecondsSinceEpoch ~/ 1000;
          int StartTimeInSec = d1t2 - 946713600;
          hexStartTime = StartTimeInSec.toRadixString(16);

          hexEndTimer = '00000000';
          String timStatus = '';
          if (timerStatus == "ON") {
            timStatus = '01';
          } else {
            timStatus = '00';
          }
          if (actionType == "Off") {
            timerType = '01';
            secEndTime = '00000000';
          } else {
            String endDay = _endDate.text.toString();
            print(endDay);
            int day = int.parse((endDay.substring(0, 2)));

            int mounts = int.parse(endDay.substring(3, 5));
            int year = int.parse("20" + endDay.substring(6, 8));
            int hour = int.parse(endDay.substring(9, 11));
            int minute = int.parse(endDay.substring(12));

            var d2 = DateTime.now();
            int dh = d2.millisecondsSinceEpoch ~/ 1000;
            var d1 = DateTime(year, mounts, day, hour, minute);
            var d1t2 = d1.millisecondsSinceEpoch ~/ 1000;
            int endTimeInSec = d1t2 - 946713600;
            hexStartTime = endTimeInSec.toRadixString(16);

            timerType = '11';
          }

          command = meshTimer.sendSetTimer(
              dataDevice.nodeNumber,
              dataDevice.netId,
              timerId,
              hexStartTime,
              hexEndTimer,
              timerType,
              actionType,
              sensorActionNumber,
              hexEndTimer,
              'FF',
              'FF',
              timStatus);
          bool response =
              await meshNotifier.sendCommand(command, dataDevice.netId);

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

          String inStartTime = _startTime.text.toString();

          String inEndTime = _endTime.text.toString();
          int hStartTime = int.parse((inStartTime.substring(0, 2)));
          int mStartTime = int.parse(inStartTime.substring(3));
          int startTimeinSec = (3600 * hStartTime) + (60 * mStartTime);

          secStartTime = hexPadding(startTimeinSec);

          int hEndTime = int.parse((inEndTime.substring(0, 2)));
          int mEndTime = int.parse(inEndTime.substring(3));
          int endTimeinSec = (3600 * hEndTime) + (60 * mEndTime);
          secEndTime = hexPadding(endTimeinSec);
          print("secEndTime");
          print(secEndTime);

          int suDay;
          int mDay;
          int tDay;
          int wDay;
          int thDay;
          int fDay;
          int saDay;
          if (values['MA'] == true) {
            suDay = 1;
          } else {
            suDay = 0;
          }
          if (values["TU"] == true) {
            mDay = 2;
          } else {
            mDay = 0;
          }
          if (values['WE'] == true) {
            tDay = 4;
          } else {
            tDay = 0;
          }
          if (values['TH'] == true) {
            wDay = 8;
          } else {
            wDay = 0;
          }
          if (values['FR'] == true) {
            thDay = 16;
          } else {
            thDay = 0;
          }
          if (values['SA'] == true) {
            fDay = 32;
          } else {
            fDay = 0;
          }
          if (values['SU'] == true) {
            saDay = 64;
          } else {
            saDay = 0;
          }
          int days = suDay + mDay + tDay + wDay + thDay + fDay + saDay;
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
          String timStatus = '';
          if (timerStatus == "ON") {
            timStatus = '01';
          } else {
            timStatus = '00';
          }
          command = meshTimer.sendSetTimer(
              dataDevice.nodeNumber,
              dataDevice.netId,
              timerId,
              secStartTime,
              secEndTime,
              timerType,
              actionType,
              sensorActionNumber,
              weekDays,
              'FF',
              'FF',
              timStatus);
          print(command);
          bool response =
              await meshNotifier.sendCommand(command, dataDevice.netId);
        }
        int intTimerId = int.parse(timerId);
        intTimerId = intTimerId + 1;
        if (intTimerId < 9) {
          print(intTimerId);
          timerId = "0$intTimerId";
        } else {
          timerId = intTimerId.toString();
        }
        WriteCache.setString(key: AppKeys.timerId, value: timerId);
      }
    }

    return AlertDialog(
        actions: <Widget>[
          TextButton(
            child: const Text('Abort'),
            onPressed: () {
              print("aaaaaaccccccccccwwwwwwwww");
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              saveAction();
              Navigator.of(context).pop();
            },
          ),
        ],
        content: SingleChildScrollView(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    DropdownMenu<String>(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: DropdownMenu<String>(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (oneTimeOrPereudic)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
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
                                                  print(values);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (oneTimeOrPereudic)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
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
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
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
                            else
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.6,
                                          child: TextField(
                                            controller: _startDate,
                                            //editing controller of this TextField
                                            decoration: const InputDecoration(
                                                //icon of text field
                                                labelText:
                                                    "Start Date" //label text of field
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
                                    SizedBox(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.4,
                                          child: TextField(
                                            controller: _endDate,
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
                                                    _endDate.text =
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      child: TextField(
                                        onChanged: (text) {
                                          _name.text = text;
                                        },
                                        controller: _name,
                                        decoration: const InputDecoration(
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
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      dropdownMenuEntries: stateOfTimer
                                          .map<DropdownMenuEntry<String>>(
                                              (String value) {
                                        return DropdownMenuEntry<String>(
                                            value: value, label: value);
                                      }).toList(),
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ));
  }
}