import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.threshold.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/widgets/utiles/sensor.Threshold.widget.dart';
import 'package:rpe_c/presentation/widgets/utiles/sensor.setTimers.widget.dart';

class SensorDetailsScreen extends StatefulWidget {
  final SensorDetailsArgs sensorDetailsArguments;

  const SensorDetailsScreen({super.key, required this.sensorDetailsArguments});

  @override
  _SensorDetailsScreenState createState() => _SensorDetailsScreenState();
}

class _SensorDetailsScreenState extends State<SensorDetailsScreen> {
  Color caughtColor = Colors.grey;
  MeshTimer meshTimer = MeshTimer();
  MeshThreshold meshThreshold = MeshThreshold();
  List<String> data = [];
  late RpeDevice dataDevice;
  final TextEditingController deviceNameController = TextEditingController();
  late bool editable = false;
  late String newName = "";
  late String newLocation = "";
  late String location = "";
  late String deviceName = "";
  late bool timersOpen = false;
  late bool thresholdOpen = false;
  late bool zonesOpen = false;
  late bool associationsOpen = false;
  late bool deviceOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    dataDevice = meshNotifier.getDeviceByMac(widget.sensorDetailsArguments.mac);
    deviceName = dataDevice.name;
    location = dataDevice.location;
    List deviceTimersList;
    List deviceThresholdList;
    List deviceClusterList;
    List deviceAssociationList;
    try {
      deviceTimersList = jsonDecode(dataDevice.timers)['timers'];
    } catch (e) {
      deviceTimersList = [];
    }
    try {
      deviceThresholdList = jsonDecode(dataDevice.thresholds)['thresholds'];
    } catch (e) {
      deviceThresholdList = [];
    }
    try {
      deviceClusterList = jsonDecode(dataDevice.clusters)['clusters'];
    } catch (e) {
      deviceClusterList = [];
    }
    try {
      deviceAssociationList =
          jsonDecode(dataDevice.associations)['associations'];
    } catch (e) {
      deviceAssociationList = [];
    }

    void _showThresholdDialog() => showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return SensorThresholdScreen(
                mac: widget.sensorDetailsArguments.mac);
          },
        );

    void _showTimerDialog() => showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return SensorSetTImerScreen(mac: widget.sensorDetailsArguments.mac);
          },
        );

    Future<void> setThreshold() async {
      _showThresholdDialog();
    }

    Future<void> setTimer() async {
      _showTimerDialog();
    }

    void deleteThreshold(RpeDevice device, data) async {
      String command = meshThreshold.sendDeleteThreshold(
          device.nodeNumber, device.netId, data['thresholdId']);
      bool response = await meshNotifier.sendCommand(command, device.netId);
      response = true; //todo
      if (response) {
        deviceThresholdList.remove(data);
        Map<String, dynamic> _json = {
          'thresholds': deviceThresholdList,
        };
        dataDevice.thresholds = jsonEncode(_json);
        meshNotifier.updateDevice(dataDevice);

        String _url = await meshNotifier.getNetworkUrlByNetId(dataDevice.netId);
        var network = meshNotifier.getNetworkByUrl(_url);
        var networkTimers = jsonDecode(network.timers);
        List? networkTimersArr = networkTimers['thresholds'];
        networkTimersArr?.remove(data['name']);
        networkTimers['thresholds'] = networkTimersArr;
        network.timers = jsonEncode(networkTimers);

        meshNotifier.updateNetwork(network);
      }
    }

    void deleteTimer(RpeDevice device, data) async {
      String command = meshTimer.sendDeleteTimer(
          device.nodeNumber, device.netId, data['timerId']);
      bool response = await meshNotifier.sendCommand(command, device.netId);
      response = true; //todo
      if (response) {
        deviceTimersList.remove(data);
        Map<String, dynamic> _json = {
          'timers': deviceTimersList,
        };
        dataDevice.timers = jsonEncode(_json);
        meshNotifier.updateDevice(dataDevice);

        String _url = await meshNotifier.getNetworkUrlByNetId(dataDevice.netId);
        var network = meshNotifier.getNetworkByUrl(_url);
        var networkTimers = jsonDecode(network.timers);
        var networkTimersArr = networkTimers['timers'];
        networkTimersArr.remove(data['name']);
        networkTimers['timers'] = networkTimersArr;
        network.timers = jsonEncode(networkTimers);
        meshNotifier.updateNetwork(network);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Sensor details"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              editable = !editable;
                              if (editable == false) {
                                if (newName != "") {
                                  dataDevice.name = newName;
                                  deviceName = newName;
                                }
                                if (newLocation != "") {
                                  dataDevice.location = newLocation;
                                  location = dataDevice.location;
                                }
                                meshNotifier.updateDevice(dataDevice);
                              }
                              // meshNotifier.
                            });
                          },
                          child: editable
                              ? const Text('Save')
                              : const Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      // width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.25,
                      child: SizedBox(
                        // width: MediaQuery.sizeOf(context).width ,

                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.3,
                                  child: Image.asset(dataDevice.image)),
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child: Column(children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            editable
                                                ? SizedBox(
                                                    width: 210,
                                                    child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .blue),
                                                            //<-- SEE HERE
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                        ),
                                                        onChanged: (text) {
                                                          newName = text;
                                                        }),
                                                  )
                                                : Text(
                                                    "Device Name $deviceName")
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Device Type"),
                                            Text("Device Type"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("Network "),
                                            Text("Network status"),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            editable
                                                ? SizedBox(
                                                    width: 210,
                                                    child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .blue),
                                                            //<-- SEE HERE
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                        ),
                                                        onChanged: (text) {
                                                          newLocation = text;
                                                        }),
                                                  )
                                                : Text("location $location")
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("status "),
                                            Text("Network status"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]))
                            ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                if (dataDevice.deviceType < 3)
                                  Row(
                                    children: [
                                      IconButton(
                                        key:Key("Open Timers"),
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            timersOpen = !timersOpen;
                                          });
                                        },
                                      ),
                                      const Row(
                                        children: [
                                          Text("Assigned Timers "),
                                        ],
                                      )
                                    ],
                                  ),
                                if (timersOpen)
                                  Column(
                                    children: [
                                      OutlinedButton(
                                        key: Key("add timer"),
                                          onPressed: setTimer,
                                          child: Text("Add timer")),
                                      for (var timer in deviceTimersList)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(timer['name'].toString()),
                                            OutlinedButton(
                                                onPressed: () {
                                                  deleteTimer(
                                                      dataDevice, timer);
                                                },
                                                child: Text("Delete")),
                                          ],
                                        )
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          thresholdOpen = !thresholdOpen;
                                        });
                                      },
                                    ),
                                    const Text("Assigned Thresholds "),
                                  ],
                                ),
                                if (thresholdOpen)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                              onPressed: setThreshold,
                                              child: Text("Add Threshold")),
                                        ],
                                      ),
                                      for (var threshold in deviceThresholdList)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(threshold['name'].toString()),
                                            OutlinedButton(
                                                onPressed: () {
                                                  deleteThreshold(
                                                      dataDevice, threshold);
                                                },
                                                child: Text("Delete")),
                                          ],
                                        )
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          zonesOpen = !zonesOpen;
                                        });
                                      },
                                    ),
                                    const Text("Zones/Clusters ")
                                  ],
                                ),
                                if (zonesOpen)
                                  Row(
                                    children: [
                                      for (String cluster in deviceClusterList)
                                        Text("$cluster, ")
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          associationsOpen = !associationsOpen;
                                        });
                                      },
                                    ),
                                    const Text(
                                        "Association with other Devices ")
                                  ],
                                ),
                                if (associationsOpen)
                                  Row(
                                    children: [
                                      for (var association
                                          in deviceAssociationList)
                                        Text("$association, ")
                                    ],
                                  ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          deviceOpen = !deviceOpen;
                                        });
                                      },
                                    ),
                                    const Text("Device Preferences")
                                  ],
                                ),
                                if (deviceOpen)
                                  const Column(
                                    children: [
                                      Text(
                                          "in this place will be device preferences :)"),
                                    ],
                                  ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}

class SensorDetailsArgs {
  final String mac;

  const SensorDetailsArgs({required this.mac});
}
