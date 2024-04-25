import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.threshold.dart';
import 'package:rpe_c/app/constants/protocol/protocol.time.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';

class NetworkDetailsScreen extends StatefulWidget {
  final NetworkDetailsArgs networkDetailsArguments;

  const NetworkDetailsScreen(
      {super.key, required this.networkDetailsArguments});

  @override
  _NetworkDetailsScreenState createState() => _NetworkDetailsScreenState();
}

class _NetworkDetailsScreenState extends State<NetworkDetailsScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  MeshTimer meshTimer = MeshTimer();
  MeshThreshold meshThreshold = MeshThreshold();
  List<String> data = [];
  late RpeNetwork dataNetwork;
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
    dataNetwork =
        meshNotifier.getNetworkByUrl(widget.networkDetailsArguments.url);
    deviceName = dataNetwork.name;
    List deviceTimersList;
    List deviceThresholdList;
    List deviceClusterList;
    List deviceAssociationList;
    try {
      deviceTimersList = jsonDecode(dataNetwork.timers)['timers'];
    } catch (e) {
      deviceTimersList = [];
    }
    try {
      deviceThresholdList = jsonDecode(dataNetwork.thresholds)['thresholds'];
    } catch (e) {
      deviceThresholdList = [];
    }
    try {
      deviceClusterList = jsonDecode(dataNetwork.clusters)['clusters'];
    } catch (e) {
      deviceClusterList = [];
    }
    try {
      deviceAssociationList =
          jsonDecode(dataNetwork.associations)['associations'];
    } catch (e) {
      deviceAssociationList = [];
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
                                  dataNetwork.name = newName;
                                  deviceName = newName;
                                }
                                meshNotifier.updateNetwork(dataNetwork);
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
                              ),
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
                                            // editable
                                            //     ? SizedBox(
                                            //         width: 210,
                                            //         child: TextField(
                                            //             decoration:
                                            //                 InputDecoration(
                                            //               enabledBorder:
                                            //                   UnderlineInputBorder(
                                            //                 borderSide:
                                            //                     const BorderSide(
                                            //                         width: 2,
                                            //                         color: Colors
                                            //                             .blue),
                                            //                 //<-- SEE HERE
                                            //                 borderRadius:
                                            //                     BorderRadius
                                            //                         .circular(
                                            //                             50.0),
                                            //               ),
                                            //             ),
                                            //             onChanged: (text) {
                                            //               newLocation = text;
                                            //             }),
                                            //       )
                                            //     :
                                            // Text("location $location")
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
                                      for (var timer in deviceTimersList)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("$timer, "),
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
                                        children: [],
                                      ),
                                      for (var threshold in deviceThresholdList)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("$threshold, "),
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

class NetworkDetailsArgs {
  final String url;

  const NetworkDetailsArgs({required this.url});
}
