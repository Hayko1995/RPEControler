import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/manipulation.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/widget/device.widget.dart';

class Sensors extends StatefulWidget {
  final SensorArgs sensorsArguments;

  const Sensors({super.key, required this.sensorsArguments});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  final DatabaseService _databaseService = DatabaseService();
  late Timer _timer;
  List<Device> dataDevices = <Device>[];

  void _updateData() async {
    List<Device> devices =
        await _databaseService.getDevices(widget.sensorsArguments.mac);
    // logger.w(_dataUpload);

    // TODO write logic for Widget
    if (mounted) {
      setState(() {
        dataDevices = devices;
      });
    }
  }

  @override
  void initState() {
    _updateData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      // List<Map<String, Object>> data = widget.sensorDetailsArguments.data;
      List<Device> data = dataDevices;
      for (var i = 0; i < data.length; i++) {
        sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
      }
      return sensorList;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Sensors Package'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.manipulationsRoute,
                          arguments: const ManipulationsArgs(preDef: 1),
                        );
                      },
                      child: const Text('Create associations'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GridView.count(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: getSensors())),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class SensorArgs {
  final List<String> mac;

  const SensorArgs({required this.mac});
}
