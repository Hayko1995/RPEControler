import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';

class SensorsDetail extends StatefulWidget {
  final SensorDetailsArgs sensorDetailsArguments;
  const SensorsDetail({
    Key? key,
    required this.sensorDetailsArguments,
  }) : super(key: key);

  @override
  State<SensorsDetail> createState() => _SensorsDetailState();
}

class _SensorsDetailState extends State<SensorsDetail> {
  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      // List<Map<String, Object>> data = widget.sensorDetailsArguments.data;
      List<Map<String, Object>> data = [];
      for (var i = 0; i < data.length; i++) {
        sensorList.add(Container(
          width: MediaQuery.sizeOf(context).width,
          height: 30,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(EvaIcons.bulb, color: Colors.red),
            Text(data.elementAt(i)["name"].toString()),
            Text(data.elementAt(i)["group"].toString()),
            Icon(EvaIcons.battery, color: Colors.red),
          ]),
        ));
      }
      return sensorList;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor details Page'),
      ),
      body: Center(
        child: Column(children: getSensors()),
      ),
    );
  }
}

class SensorDetailsArgs {
  final List<Map<String, Object>> data;
  const SensorDetailsArgs({required this.data});
}
