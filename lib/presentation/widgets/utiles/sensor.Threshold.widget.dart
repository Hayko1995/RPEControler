import 'dart:convert';

import 'package:cache_manager/core/cache_manager_utils.dart';
import 'package:cache_manager/core/read_cache_service.dart';
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/app/constants/protocol/protocol.threshold.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/widgets/incrementValue.dart';

class SensorThresholdScreen extends StatefulWidget {
  final String mac;

  const SensorThresholdScreen({super.key, required this.mac});

  @override
  _SensorThresholdScreenState createState() => _SensorThresholdScreenState();
}

class _SensorThresholdScreenState extends State<SensorThresholdScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];
  late RpeDevice dataDevice;
  List<String> sensorType = [];
  List<String> typeOfThreshold = <String>[
    "Below",
    "Above",
    "Inside",
    "Outside"
  ];

  List<String> stateOfNotifications = <String>[
    "Nothing",
    "Alert",
    "Info",
    "Action",
    "Status",
    "Warning"
  ];
  List<String> typeOfTimer = <String>['One Time', "Periodic"];
  List<String> boolActivation = <String>['ON', "OFF"];
  bool openCheckboxes = false;
  bool needTimer = false;
  String sensorTypeValue = 'Battery_pwr_sen';
  String thresholdType = 'Below';
  String setnotificationType = "";
  String thresholdId = "01";
  String threshodStatus = "ON";
  String timerType = '';
  String statusType = '';
  String controlType = '';
  String thresholdStatus = '';
  String actionType = '';
  String timerId = '01';
  String opened = "Opened";
  String threshParam1 = '00000000';
  String threshParam2 = '00000000';

  List<String> stateOfthreshold = <String>['ON', "OFF"];
  List<String> types = <String>['Devices', 'Clusters'];
  bool oneTimeOrPereudic = false;
  String hexStartTime = '';
  String secStartTime = '';
  String hexEndTimer = '';
  String inTimType = '';
  String weekDays = '';
  String _thresholdType = 'Below';
  String actionValue = '';

  String secEndTime = '';
  Map<String, bool> values = {
    'MA': false,
    'TU': false,
    'WE': false,
    "TH": false,
    "FR": false,
    "SA": false,
    "SU": false,
  };

  bool isSwitched = true;
  final TextEditingController _trresholdName = new TextEditingController();

  final TextEditingController _startValueController =
      new TextEditingController();
  final TextEditingController _endValueController = new TextEditingController();

  final TextEditingController _startDate = new TextEditingController();
  final TextEditingController _endDate = new TextEditingController();
  final TextEditingController _startTime = new TextEditingController();
  final TextEditingController _endTime = new TextEditingController();
  final TextEditingController _actionValueController =
      new TextEditingController();

  String hexPadding(num) {
    if (num < 16777217) {
      if (num < 65536) {
        if (num < 4096) {
          if (num < 256) {
            num = num.toRadixString(16);
            num = '0000000' + num;
          } else {
            num = num.toRadixString(16);
            num = '00000' + num;
          }
        } else {
          num = num.toRadixString(16);
          num = '000000' + num;
        }
      } else {
        if (num < 1048576) {
          num = num.toRadixString(16);
          num = '00000' + num;
        } else {
          num = num.toRadixString(16);
          num = '00000' + num;
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

  @override
  void initState() {
    // sensorTypeValue = sensorType.first;

    setnotificationType = stateOfNotifications.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // CacheManagerUtils.conditionalCache(
    //   key: AppKeys.thresholdId,
    //   valueType: ValueType.StringValue,
    //   actionIfNull: () {
    //     WriteCache.setString(key: AppKeys.thresholdId, value: '00');
    //     thresholdId = "00";
    //   },
    //   actionIfNotNull: () async {
    //     thresholdId = await ReadCache.getString(key: AppKeys.thresholdId);
    //   },
    // );

    void getSubSensors(dataDevice) {
      sensorType = [];
      if (dataDevice.isActivation == 1) {
        int deviceType = hex.decode(dataDevice.nodeType)[0];
        int subDeviceType = hex.decode(dataDevice.nodeSubType)[0];
        var subSensorDict =
            AppConstants.deviceTypes[deviceType]['dSub'][subDeviceType]["senT"];
        for (var sensor in subSensorDict.values) {
          sensorType.add(AppConstants.sensorTypeId[sensor]);
        }
      }
    }

    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    dataDevice = meshNotifier.getDeviceByMac(widget.mac);

    thresholdId = dataDevice.thI.toRadixString(16);
    if (thresholdId.length < 2) {
      thresholdId = "0$thresholdId";
    }
    dataDevice.thI = dataDevice.thI++;
    getSubSensors(dataDevice);
    // thresholdType = typeOfThreshold.first;
    // threshodStatus = boolActivation.first;

    void oneTimeCommand() {
      timerType = "00";
      if (controlType == "ON") {
        actionType = "81";
      } else {
        actionType = "00";
      }

      String startDay = _startDate.text.toString();
      if (startDay == "") {
        showToast("Enter start date", context: context);
      } else {
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

        String endDay = _endDate.text.toString();
        if (endDay == '') {
          hexEndTimer = '00000000';
        } else {
          _thresholdType = _thresholdType.substring(1);
          _thresholdType = '5$_thresholdType';
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
        }
      }
    }

    void setWeek() {
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
      if (days == 0) {}
      if (days < 16) {
        weekDays = days.toRadixString(16);
        weekDays = '0$weekDays';
      } else {
        weekDays = days.toRadixString(16);
      }
      if (days == 127) {
        // everyday of the week
        inTimType = '2';
      } else {
        inTimType = '4';
      }
    }

    void periodicTimeCommand() {
      timerType = "01";
      if (controlType == "ON") {
        actionType = "81";
      } else {
        actionType = "00";
      }

      String inStartTime = _startTime.text.toString();

      int hStartTime =
          int.parse((inStartTime.substring(0, inStartTime.indexOf(":"))));
      int mStartTime =
          int.parse(inStartTime.substring(inStartTime.indexOf(":") + 1));
      int startTimeinSec = (3600 * hStartTime) + (60 * mStartTime);

      secStartTime = hexPadding(startTimeinSec);

      String inEndTime = _endTime.text.toString();
      if (inEndTime == '') {
        secEndTime = '00000000';
      } else {
        int hEndTime =
            int.parse((inEndTime.substring(0, inEndTime.indexOf(":"))));
        int mEndTime =
            int.parse(inEndTime.substring(inEndTime.indexOf(":") + 1));
        int endTimeinSec = (3600 * hEndTime) + (60 * mEndTime);
        secEndTime = hexPadding(endTimeinSec);
        _thresholdType = _thresholdType.substring(1);
        _thresholdType = '5$_thresholdType';
      }

      setWeek();

      if (controlType == 'Off') {
        // off
        timerType = '0' + inTimType;
        secEndTime = '00000000';
      } else {
        timerType = '1' + inTimType;
      }
    }

    Future<void> saveAction() async {
      MeshThreshold meshThreshold = MeshThreshold();

      int inStartThresh = 0;
      int inEndThres = 0;
      String secEndTime = "";
      String secStartTime = "";

      if (dataDevice.isActivation == 1) {
        if (boolActivation == "OFF") {
          threshParam1 = '00000000';
          threshParam2 = '00000000';
        } else {
          threshParam1 = '00000064';
          threshParam2 = '00000000';
        }
      }
      if (dataDevice.isActivation == 2) {
         actionValue = _actionValueController.text;
        logger.i(actionValue);
        threshParam1 = hexPadding(int.parse(actionValue));
        if (threshParam1 == '') {
          threshParam1 = '00000000';
        }
        threshParam2 = '00000000';
      }
      if (thresholdType == "Below") {
        _thresholdType = '1';
      }
      if (thresholdType == "Above") {
        _thresholdType = '2';
      }
      if (thresholdType == "Inside") {
        _thresholdType = '3';
      }
      if (thresholdType == "Outside") {
        _thresholdType = '4';
      }
      logger.w(_thresholdType);
      if (threshodStatus == "ON") {
        actionType = '81';
      } else {
        actionType = '00';
      }

      if (_thresholdType == '1' || _thresholdType == '2') {
        try {
          inStartThresh = int.parse(_startValueController.text);
          logger.e(inStartThresh);
        } catch (e) {
          inStartThresh = 0;
        }

        if (inStartThresh < 0) {
          int t2 = ~(inStartThresh) + 1;
          if (t2 < 256) {
            inStartThresh = 256 + inStartThresh;
          } else if (t2 < 65536) {
            inStartThresh = 65536 + inStartThresh;
          }
        }
        threshParam1 = hexPadding(inStartThresh);
        if (threshParam1 == '') {
          threshParam1 = '00000000';
        }
        threshParam2 = "00000000";
      } else {
        try {
          inStartThresh = int.parse(_startValueController.text);
        } catch (e) {
          inStartThresh = 0;
        }

        if (inStartThresh < 0) {
          int t2 = ~(inStartThresh) + 1;
          if (t2 < 256) {
            inStartThresh = 256 + inStartThresh;
          } else if (t2 < 65536) {
            inStartThresh = 65536 + inStartThresh;
          }
        }
        try {
          inEndThres = int.parse(_endValueController.text);
        } catch (e) {
          inEndThres = 0;
        }
        threshParam2 = hexPadding(inEndThres);
        if (threshParam2 == '') {
          threshParam2 = '00000000';
        }
      }

      if (needTimer) {
        _thresholdType = '4$_thresholdType';
        if (oneTimeOrPereudic == false) {
          oneTimeCommand();
        } else {
          periodicTimeCommand();
        }
      } else {
        secEndTime = '00000000';
        secStartTime = '00000000';
        weekDays = '00';
      }

      setWeek();
      if (sensorTypeValue == "Contact") {
        if (opened == "Opened") {
          threshParam1 = '00000064';
          threshParam2 = '00000000';
        } else {
          threshParam1 = '00000000';
          threshParam2 = '00000000';
        }
      }
      sensorTypeValue =
          AppConstants.sensorTypeIdRevers[sensorTypeValue]!.toRadixString(16);

      String clusterId = "00";
      String accTimerIndex = "00";
      String thVal = _thresholdType.toString();
      if (thVal.length < 2) {
        thVal = "0$thVal";
      }
      if (hexStartTime == "") {
        hexStartTime = '00000000';
      }
      if (hexEndTimer == "") {
        hexEndTimer = '00000000';
      }
      String command = meshThreshold.sendSetThreshold(
          dataDevice.nodeNumber,
          dataDevice.netId,
          thresholdId,
          threshParam1,
          threshParam2,
          thVal,
          actionType,
          thresholdId,
          sensorTypeValue,
          clusterId,
          accTimerIndex,
          '01',
          hexStartTime,
          hexEndTimer,
          weekDays);
      logger.i(command);
      bool response = await meshNotifier.sendCommand(command, dataDevice.netId);
      int intThresholdId = int.parse(thresholdId);
      intThresholdId = intThresholdId + 1;
      if (intThresholdId < 9) {
        timerId = "0$intThresholdId";
      } else {
        timerId = intThresholdId.toString();
      }
      WriteCache.setString(key: AppKeys.timerId, value: timerId);

      ////////////////////////
      Map<String, dynamic> newThreshold = {
        'sensorType': sensorTypeValue,
        'thresholdType': thresholdType.toString(),
        'thresholdId': thresholdId,
        'oneTime': oneTimeOrPereudic,
        'weeks': values,
        'control': controlType,
        'startDate': _startDate.text,
        'endDate': _endDate.text,
        'name': _trresholdName.text,
        'status': threshodStatus,
      };
      var thresholds = jsonDecode(dataDevice.thresholds);
      var thresholdsArr = thresholds['thresholds'];
      thresholdsArr.add(newThreshold);
      thresholds['timers'] = thresholdsArr;
      dataDevice.thresholds = jsonEncode(thresholds);
      meshNotifier.updateDevice(dataDevice);
      String _url = await meshNotifier.getNetworkUrlByNetId(dataDevice.netId);
      RpeNetwork network = meshNotifier.getNetworkByUrl(_url);
      var networkThresholds = jsonDecode(network.thresholds);
      var networkTimersArr = networkThresholds['thresholds'];
      networkTimersArr.add(_trresholdName.text);
      networkThresholds['thresholds'] = networkTimersArr;
      network.thresholds = jsonEncode(networkThresholds);
      meshNotifier.updateNetwork(network);
    }

    return AlertDialog(
      actions: <Widget>[
        TextButton(
          child: Text('Abort'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Confirm'),
          key: Key('Confirm'),
          onPressed: () {
            saveAction();
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: DropdownMenu<String>(
                          key: Key('Threshold type'),
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          initialSelection: sensorTypeValue,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              sensorTypeValue = value!;
                              setState(() {
                                typeOfThreshold = <String>[
                                  "Below",
                                  "Above",
                                  "Inside",
                                  "Outside"
                                ];
                              });
                            });
                          },
                          label: const Text("Sensor Type"),
                          dropdownMenuEntries: sensorType
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                      if (sensorTypeValue != "Contact")
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: SizedBox(
                            child: DropdownMenu<String>(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              initialSelection: thresholdType,
                              onSelected: (String? value) {
                                setState(() {
                                  thresholdType = value!;
                                });
                              },
                              label: const Text("Threshold Type"),
                              key: ValueKey(Object.hashAll(typeOfThreshold)),
                              dropdownMenuEntries: typeOfThreshold
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                            ),
                          ),
                        ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              if (sensorTypeValue != "Contact")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: NumberTextField(
                            max: 100,
                            min: 0,
                            controller: _startValueController,
                          )),
                    ),
                    if (thresholdType == "Inside" || thresholdType == "Outside")
                      SizedBox(
                        child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            child: NumberTextField(
                              max: 100,
                              min: 0,
                              controller: _endValueController,
                              // onChanged: (value) {
                              // _startValueController.value = value;
                            )),
                      )
                  ],
                ),
              if (sensorTypeValue == "Contact")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        child: DropdownMenu<String>(
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              opened = value!;
                            });
                          },
                          label: const Text("Opened"),
                          dropdownMenuEntries: ['Opened', 'Closed']
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextField(
                          onChanged: (text) {
                            _trresholdName.text = text;
                          },
                          controller: _trresholdName,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        ),
                      ),
                    ),
                    if (dataDevice.isActivation == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          child: DropdownMenu<String>(
                            initialSelection: threshodStatus,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.

                              setState(() {
                                threshodStatus = value!;
                              });
                            },
                            label: const Text("Action"),
                            dropdownMenuEntries: boolActivation
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ),
                      ),
                    if (dataDevice.isActivation == 2)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            child: NumberTextField(
                              max: 100,
                              min: 0,
                              controller: _actionValueController,
                            )),
                      ),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        child: DropdownMenu<String>(
                          label: const Text("set Notification"),
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              setnotificationType = value!;
                            });
                          },
                          initialSelection: stateOfNotifications.first,
                          dropdownMenuEntries: stateOfNotifications
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList(),
                        ),
                      ),
                    ),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("need timer"),
                      SizedBox(
                        child: Checkbox(
                          value: needTimer,
                          onChanged: (value) {
                            setState(() {
                              needTimer = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (needTimer)
                    SizedBox(
                        child: SizedBox(
                      child: Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  child: DropdownMenu<String>(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.6,
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
                              ]),
                          SizedBox(
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
                          oneTimeOrPereudic
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
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
                                                logger
                                                    .i("Date is not selected");
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
                                                logger
                                                    .i("Date is not selected");
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                      SizedBox(
                                        child: SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
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
                                                        firstDate:
                                                            DateTime(2000),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(2101));

                                                if (pickedDate != null) {
                                                  TimeOfDay? pickeTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now());

                                                  if (pickeTime != null) {
                                                    String formattedDate =
                                                        DateFormat('dd:MM:yy')
                                                            .format(
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
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
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
                                                        firstDate:
                                                            DateTime(2000),
                                                        //DateTime.now() - not to allow to choose before today.
                                                        lastDate:
                                                            DateTime(2101));

                                                if (pickedDate != null) {
                                                  TimeOfDay? pickeTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now());

                                                  if (pickeTime != null) {
                                                    String formattedDate =
                                                        DateFormat('dd:MM:yy')
                                                            .format(
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
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
                ],
              ),
            ]),
      ))),
    );
  }
}
