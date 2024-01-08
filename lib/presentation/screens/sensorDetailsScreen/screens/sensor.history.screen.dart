import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:rpe_c/presentation/widgets/custom.text.field.dart';

class SensorHistoryScreen extends StatefulWidget {
  final String deviceId;

  const SensorHistoryScreen({super.key, required this.deviceId});

  @override
  _SensorHistoryScreenState createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends State<SensorHistoryScreen> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];
  final TextEditingController deviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: SizedBox(
            // width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.6,
            child: SizedBox(
              // width: MediaQuery.sizeOf(context).width ,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                                  Text("Device Name "),
                                  Text("Name"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Device Type"),
                                  Text("Device Type"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Network "),
                                  Text("Network status"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Location "),
                                  Text("Network status"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
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
            )));
  }
}
