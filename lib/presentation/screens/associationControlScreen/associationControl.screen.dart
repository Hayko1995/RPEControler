import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/sensor.Threshold.screen.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/screens/sensor.setTimers.screen.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';

Widget sensorWidget(context, data, widgetKey) {
  final Function(bool?) toggleCheckboxState;

  return GestureDetector(
      key: widgetKey,
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.sensorDetailsRoute,
          arguments: SensorDetailsArgs(mac: data.macAddress),
        );
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 5),
                    color: Theme.of(context).primaryColor.withOpacity(.2),
                    spreadRadius: 2,
                    blurRadius: 5)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 3),
              Text(data.name.toString().toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
      ));
//
}

class AssociationControlScreen extends StatefulWidget {
  final AssociationControlArgs associationControlArguments;

  const AssociationControlScreen(
      {super.key, required this.associationControlArguments});

  @override
  State<AssociationControlScreen> createState() =>
      _AssociationControlScreenState();
}

class _AssociationControlScreenState extends State<AssociationControlScreen> {
  List<RpeDevice> dataDevices = <RpeDevice>[];
  bool isSwitched = true;

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    dataDevices = meshNotifier.allDevices!;

    List<Widget> getTOSensors() {
      List<Widget> tosensorList = [];
      Association data = widget.associationControlArguments.association;
      List<String> clusterDeviceList = data.toDevices.split(',');

      for (var device in dataDevices) {
        if (clusterDeviceList.contains(device.macAddress)) {
          tosensorList.add(sensorWidget(context, device, GlobalKey()));
        }
      }
      return tosensorList;
    }

    List<Widget> getFromSensors() {
      List<Widget> fromSensorList = [];
      Association data = widget.associationControlArguments.association;
      List<String> clusterDeviceList = data.toDevices.split(',');

      for (var device in dataDevices) {
        if (clusterDeviceList.contains(device.macAddress)) {
          fromSensorList.add(sensorWidget(context, device, GlobalKey()));
        }
      }
      return fromSensorList;
    }

    void _showThresholdDialog() => showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose your favourite programming language!'),
              content: SingleChildScrollView(
                child: SensorThresholdScreen(mac: "00158d0000506820"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Abort'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

    void _showTimerDialog() => showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Choose your favourite programming language!'),
              content: SingleChildScrollView(
                child: SensorSetTImerScreen(mac: "00158d0000506820"),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Abort'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

    Future<void> setThreshold() async {
      _showThresholdDialog();
    }

    Future<void> setTimer() async {
      _showTimerDialog();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Asscoiation Control'),
          backgroundColor: Colors.blue,
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Asscoiation name "),
              Text(
                widget.associationControlArguments.association.associationName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Asscoiation type "),
              Text(
                widget.associationControlArguments.association.type,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                  onPressed: setThreshold, child: const Text("Set Threshold")),
              OutlinedButton(
                  onPressed: setTimer, child: const Text("Set Timer")),
            ],
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text("from"), Text("to")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: getFromSensors()),
                        Column(children: getTOSensors())
                      ],
                    )
                  ],
                )),
          )
        ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AssociationControlArgs {
  final Association association;

  const AssociationControlArgs({required this.association});
}
