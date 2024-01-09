import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/core/service/mesh.service.dart';

class SensorHistoryScreen extends StatefulWidget {
  final String mac;

  const SensorHistoryScreen({super.key, required this.mac});

  @override
  _SensorHistoryScreenState createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends State<SensorHistoryScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];
  late Device dataDevice;
  final TextEditingController deviceNameController = TextEditingController();
  late bool editable = false;
  late String newName = "";
  late String deviceName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    Future.delayed(const Duration(microseconds: 300), () {
      dataDevice = meshNotifier.getDeviceByMac(widget.mac);
      deviceName = dataDevice.name;
      setState(() {});
    });

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
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
                          dataDevice.name = newName;
                          deviceName = dataDevice.name;
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
                height: MediaQuery.sizeOf(context).height * 0.6,
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
                                'assets/images/icons/air-quality-sensor.png')),
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
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          color: Colors.blue),
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
                                          : Text("Device Name $deviceName" )
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
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Location "),
                                      Text("Network status"),
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
                              )
                            ]))
                      ]),
                )),
          ],
        ));
  }
}
