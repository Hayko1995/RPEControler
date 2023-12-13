import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';

class PredefineDetail extends StatefulWidget {
  final PredefinePackageArgs predefinePackageArguments;
  const PredefineDetail({
    super.key,
    required this.predefinePackageArguments,
  });

  @override
  State<PredefineDetail> createState() => _PredefineDetailState();
}

class _PredefineDetailState extends State<PredefineDetail> {
  final DatabaseService _databaseService = DatabaseService();
  List<Device> dataDevices = <Device>[];

  void _updateData() async {
    List<Device> devices = await _databaseService.getDevices(widget.predefinePackageArguments.mac);
    // logger.w(_dataUpload);


    // TODO write logic for Widget
    setState(() {
      dataDevices = devices;
    });
  }

  @override
  void initState() {

    Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _updateData();
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;

    itemDashboard(String title) => GestureDetector(
        onTap: () {
          // Navigator.of(context).pushNamed(
          //   AppRouter.sensorDetailsRoute,
          //   arguments: SensorDetailsArgs(data: data),
          // );
        },
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
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ));

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      // List<Map<String, Object>> data = widget.sensorDetailsArguments.data;
      List<Device> data = dataDevices;
      print("object/////////////////////////////");
      print(dataDevices);
      for (var i = 0; i < data.length; i++) {
        sensorList.add(itemDashboard(data.elementAt(i).nodeNumber.toString()));
        // logger.e(data.elementAt(i).nodeNumber);
        // sensorList.add(Container(
        //   width: MediaQuery.sizeOf(context).width,
        //   height: 30,
        //   child:
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //     Icon(EvaIcons.bulb, color: Colors.red),
        //     Text(data.elementAt(i).nodeNumber.toString()),
        //     Icon(EvaIcons.battery, color: Colors.red),
        //   ]),
        // ));
      }
      return sensorList;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Predefine Package'),
        ),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: getSensors())),
        ));
  }
}

class PredefinePackageArgs {
  final String mac;
  const PredefinePackageArgs({required this.mac});
}
