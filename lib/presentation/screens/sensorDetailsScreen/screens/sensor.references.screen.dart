import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';

class SensorReferencesScreen extends StatefulWidget {
  final String mac;

  const SensorReferencesScreen({super.key, required this.mac});

  @override
  _SensorReferencesScreenState createState() => _SensorReferencesScreenState();
}

class _SensorReferencesScreenState extends State<SensorReferencesScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
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
    dataDevice = meshNotifier.getDeviceByMac(widget.mac);
    deviceName = dataDevice.name;
    location = dataDevice.location;

    return Padding(
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
                    child: editable ? const Text('Save') : const Text('Edit'),
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
                            child: Image.asset(
                                dataDevice.image)),
                        SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      editable
                                          ? SizedBox(
                                              width: 210,
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.blue),
                                                      //<-- SEE HERE
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                  ),
                                                  onChanged: (text) {
                                                    newName = text;
                                                  }),
                                            )
                                          : Text("Device Name $deviceName")
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Device Type"),
                                      Text("Device Type"),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Network "),
                                      Text("Network status"),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      editable
                                          ? SizedBox(
                                              width: 210,
                                              child: TextField(
                                                  decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 2,
                                                              color:
                                                                  Colors.blue),
                                                      //<-- SEE HERE
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                          Row(
                            children: [
                              IconButton(
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
                                Row(
                                  children: [
                                    Text("Timer 1 set on time 13:00"),
                                    OutlinedButton(
                                        onPressed: () {},
                                        child: Text("delete")),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Timer 2 set on time 14:55"),
                                    OutlinedButton(
                                        onPressed: () {},
                                        child: Text("delete")),
                                  ],
                                ),
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
                                  children: [
                                    Text("Thrashold set 15%"),
                                    OutlinedButton(
                                        onPressed: () {},
                                        child: Text("delete")),
                                  ],
                                ),
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
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("In zone 1 "),
                                    OutlinedButton(
                                        onPressed: () {},
                                        child: Text("delete")),
                                  ],
                                ),
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
                              const Text("Association with other Devices ")
                            ],
                          ),
                          if (associationsOpen)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("have assosiation with vzgo 1  "),
                                    OutlinedButton(
                                        onPressed: () {},
                                        child: Text("delete")),
                                  ],
                                ),
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
        ));
  }
}
