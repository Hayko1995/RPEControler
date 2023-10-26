import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/sensorsDetailScreen/sensors.detail.screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
  List<String> data = [];

  @override
  void initState() {
    // final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    // ReadCache.getString(key: AppKeys.userData).then(
    //   (token) => {
    //     userNotifier.getUserData(context: context, token: token),
    //   },
    // );
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateTables();
    });

    super.initState();
  }

  void _updateTables() async {
    List<String> _data = await _databaseService.getAllTableNames();
    setState(() {
      data = _data;
    });
  }

  List<Widget> benefitMaker() {
    List<Widget> widgets = [];
    IconData icon = EvaIcons.questionMark;
    Color color = Colors.blue;
    Map<dynamic, dynamic> data1 = AppConstants.userData;
    for (var i = 0; i < data.length; i++) {
      // String name = AppConstants.userData.keys.elementAt(i);
      if (data[i] == AppConstants.light) {
        print(data[i]);
        icon = EvaIcons.bulb;
        // for (var j = 0; j < data[name].length; j++) {
        //   if (data[name].elementAt(j)['warning']) {
        //     color = Colors.red;
        //   }
        // }
        widgets.add(
          itemDashboard(AppConstants.userData.keys.elementAt(i), icon, color,
              data1[AppConstants.userData.keys.elementAt(i)]),
        );
        color = Colors.blue;
      }
      // if (data[i] == "electricity") {
      //   icon = EvaIcons.flashOutline;
      //   for (var j = 0; j < data[name].length; j++) {
      //     if (data[name].elementAt(j)['warning']) {
      //       color = Colors.red;
      //     }
      //   }
      //   widgets.add(
      //     itemDashboard(name, icon, color, data[name]),
      //   );
      //   color = Colors.blue;
      // }
      // if (data[i] == "water") {
      //   icon = EvaIcons.droplet;
      //   for (var j = 0; j < data[name].length; j++) {
      //     if (data[name].elementAt(j)['warning']) {
      //       color = Colors.red;
      //     }
      //   }
      //   widgets.add(
      //     itemDashboard(name, icon, color, data[name]),
      //   );
      //   color = Colors.blue;
      // }
    }

    // widgets.add(
    //   itemDashboard(name, icon, color),
    // );
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: benefitMaker()),
      ),
    );
  }

// itemDashboard('Videos', EvaIcons.flashOutline, Colors.deepOrange),
  itemDashboard(String title, IconData iconData, Color background,
          List<Map<String, Object>> data) =>
      GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRouter.sensorDetailsRoute,
              arguments: SensorDetailsArgs(data: data),
            );
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
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: Colors.white)),
                const SizedBox(height: 3),
                Text(title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
          ));
}
