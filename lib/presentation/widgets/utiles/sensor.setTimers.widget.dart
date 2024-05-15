import 'dart:async';
import 'dart:convert';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';

import '../custom.widget.dart';

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
  late RpeNetwork network;
  late List<RpeDevice> allDevices;
  late List<Cluster> allClusters = [];
  List<String> typeOfTimer = <String>['One Time', "Periodic"];

  List<String> typeOfControl = <String>["ON", "Off", "Up", "Down"];
  List<String> stateOfTimer = <String>['ON', "Off"];

  List<String> types = <String>['Devices', 'Clusters'];
  bool oneTimeOrPereudic = false;
  Map<String, bool> values = {
    'MA': true,
    'TU': true,
    'WE': true,
    "TH": true,
    "FR": true,
    "SA": true,
    "SU": true,
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
    timerStatus = stateOfTimer.first;
    controlType = typeOfControl.first;

    // CacheManagerUtils.conditionalCache(
    //   key: AppKeys.timerId,
    //   valueType: ValueType.StringValue,
    //   actionIfNull: () {
    //     WriteCache.setString(key: AppKeys.timerId, value: '00');
    //     timerId = "00";
    //   },
    //   actionIfNotNull: () async {
    //     timerId = await ReadCache.getString(key: AppKeys.timerId);
    //   },
    // );

    dataDevice = meshNotifier.getDeviceByMac(widget.mac);
    timerId = dataDevice.timI.toRadixString(16);
    if (int.parse(timerId) < 9) {
      timerId = '0$timerId';
    }
    logger.i(timerId);
    dataDevice.timI = dataDevice.timI++;
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

    Future<void> oneTimeCommand(meshTimer) async {
      timerType = "00";
      if (controlType == "ON") {
        actionType = "81";
      } else {
        actionType = "00";
      }

      String startDay = _startDate.text.toString();
      logger.i(startDay);
      int day = int.parse((startDay.substring(0, 2)));

      int mounts = int.parse(startDay.substring(3, 5));
      int year = int.parse("20" + startDay.substring(6, 8));
      int hour = int.parse(startDay.substring(9, 11));
      int minute = int.parse(startDay.substring(12));

      var d2 = DateTime.now();
      int dh = d2.millisecondsSinceEpoch ~/ 1000;
      var d1 = DateTime(year, mounts, day, hour, minute);
      var d1t2 = d1.millisecondsSinceEpoch ~/ 1000;
      int StartTimeInSec = d1t2;
      hexStartTime = StartTimeInSec.toRadixString(16);

      String timStatus = '';
      if (timerStatus == "ON") {
        timStatus = '01';
      } else {
        timStatus = '00';
      }
      if (actionType == "00") {
        timerType = '01';
        secEndTime = '00000000';
      } else {
        String endDay = _endDate.text.toString();
        if (endDay == '') {
          hexEndTimer = '00000000';
        } else {
          logger.i(endDay);
          int day = int.parse((endDay.substring(0, 2)));

          int mounts = int.parse(endDay.substring(3, 5));
          int year = int.parse("20" + endDay.substring(6, 8));
          int hour = int.parse(endDay.substring(9, 11));
          int minute = int.parse(endDay.substring(12));

          var d1 = DateTime(year, mounts, day, hour, minute);
          var d1t2 = d1.millisecondsSinceEpoch ~/ 1000;
          int endTimeInSec = d1t2 - 946713600;

          hexEndTimer = endTimeInSec.toRadixString(16);
        }
        if (timerType == "Off") {
          timerType = '01';
        } else {
          timerType = '11';
          sensorActionNumber = '00';
        }
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
          "FF",
          'FF',
          '08',
          timStatus);
      logger.i(dataDevice.nodeNumber + " " + dataDevice.netId + " " + timerId);
      logger.i(hexStartTime + " " + hexEndTimer);
      logger.i("$timerType $actionType $sensorActionNumber $timStatus");
      bool response = await meshNotifier.sendCommand(command, dataDevice.netId);
    }

    Future<void> periodicTimeCommand(meshTimer) async {
      timerType = "01";
      sensorActionNumber = '01';

      String inStartTime = _startTime.text.toString();

      int hStartTime = int.parse((inStartTime.substring(0, 2)));
      int mStartTime = int.parse(inStartTime.substring(3));
      int startTimeinSec = (3600 * hStartTime) + (60 * mStartTime);

      secStartTime = hexPadding(startTimeinSec);
      logger.w(secStartTime.toString());

      String inEndTime = _endTime.text.toString();
      if (inEndTime == '') {
        secEndTime = '00000000';
      } else {
        int hEndTime = int.parse((inEndTime.substring(0, 2)));
        int mEndTime = int.parse(inEndTime.substring(3));
        int endTimeinSec = (3600 * hEndTime) + (60 * mEndTime);
        secEndTime = hexPadding(endTimeinSec);
      }

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
        logger.i("days need to be not 0");
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
      logger.i("node config " +
          dataDevice.nodeNumber +
          " " +
          dataDevice.netId +
          " " +
          timerId);
      logger.i("timers $hexStartTime  $hexEndTimer");
      logger.i("$timerType $actionType $sensorActionNumber $timStatus");
      bool response = await meshNotifier.sendCommand(command, dataDevice.netId);
    }

    Future<void> saveAction() async {
      {
        MeshTimer meshTimer = MeshTimer();
        logger.i(oneTimeOrPereudic);
        if (oneTimeOrPereudic == false) {
          oneTimeCommand(meshTimer);
        } else {
          periodicTimeCommand(meshTimer);
        }
        int intTimerId = int.parse(timerId);
        intTimerId = intTimerId + 1;
        if (intTimerId < 9) {
          timerId = "0$intTimerId";
        } else {
          timerId = intTimerId.toString();
        }
        // WriteCache.setString(key: AppKeys.timerId, value: timerId);
        // dataDevice
        Map<String, dynamic> newTimer = {
          'timerId': timerId,
          'oneTime': oneTimeOrPereudic,
          'weeks': values,
          'control': controlType,
          'startDate': _startDate.text,
          'endDate': _endDate.text,
          'name': _name.text,
          'status': timerStatus,
        };
        var timers = jsonDecode(dataDevice.timers);
        // logger.i(timers);
        var timersArr = timers['timers'];
        timersArr.add(newTimer);
        timers['timers'] = timersArr;
        dataDevice.timers = jsonEncode(timers);
        meshNotifier.updateDevice(dataDevice);
        String _url = await meshNotifier.getNetworkUrlByNetId(dataDevice.netId);
        network = meshNotifier.getNetworkByUrl(_url);
        var networkTimers = jsonDecode(network.timers);
        var networkTimersArr = networkTimers['timers'];
        networkTimersArr.add(_name.text);
        networkTimers['timers'] = networkTimersArr;
        network.timers = jsonEncode(networkTimers);
        // logger.i(network);
        meshNotifier.updateNetwork(network);
      }
    }

    return AlertDialog(
        actions: <Widget>[
          TextButton(
            child: const Text('Abort'),
            onPressed: () {
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
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                      child: DropdownButton<String>(
                                        value: typeOfTimer.first,
                                        items: typeOfTimer.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            timerType = value!;
                                            if (timerType == 'Periodic') {
                                              oneTimeOrPereudic = true;
                                            } else {
                                              oneTimeOrPereudic = false;
                                            }
                                          });
                                        },
                                        isExpanded: true,
                                        alignment: Alignment.center,


                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: DropdownMenu<String>(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
                                        initialSelection: typeOfControl.first,
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
                                                  logger.i(values);
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
                                              logger.i("Date is not selected");
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
                                              logger.i("Date is not selected");
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
                                                      firstDate: DateTime(2024),
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
                                                  logger.i(
                                                      "Date is not selected");
                                                }
                                              }
                                            },
                                          )),
                                    ),
                                    SizedBox(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.6,
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
                                                  logger.i(
                                                      "Date is not selected");
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
                                      initialSelection: stateOfTimer.first,
                                      onSelected: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          timerStatus = value!;
                                          logger.i(timerStatus);
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
