import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/manipulation/manipulation.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/widget/device.widget.dart';

class Sensors extends StatefulWidget {
  final SensorArgs predefineSensorsArguments;

  const Sensors({super.key, required this.predefineSensorsArguments});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  List<RpeDevice> dataDevices = <RpeDevice>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    dataDevices = meshNotifier.allDevices!;

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      // List<Map<String, Object>> data = widget.sensorDetailsArguments.data;
      List<RpeDevice> data = dataDevices;
      for (var i = 0; i < data.length; i++) {
        if (data.elementAt(i).netId == widget.predefineSensorsArguments.netId) {
          sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
        }
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
    super.dispose();
  }
}

class SensorArgs {
  final List<String> mac;
  final String netId;

  const SensorArgs({required this.mac, required this.netId});
}
