import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/api/product.api.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/sensorsDetailScreen/sensors.detail.screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';

class ESP32Screen extends StatefulWidget {
  const ESP32Screen({Key? key}) : super(key: key);

  @override
  _ESP32ScreenState createState() => _ESP32ScreenState();
}

class _ESP32ScreenState extends State<ESP32Screen> {
  Color caughtColor = Colors.grey;

  final ProductAPI _esp32 = ProductAPI();

  String data = "";
  String rpe32Data = '';
  String rpe32time = '';
  String time = '';

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
    // final MeshAPI _mashAPI = MeshAPI();
    // _mashAPI.sendToMesh("E1FF060001FA");
    // final _data = await _esp32.updateData();
    // try {
    //   data = _data;
    // } catch (e) {
    //   data = "error";
    // }

    // DateTime dateToday = new DateTime.now();
    // String time = dateToday.toString().substring(0, 10);
    // DateTime now = DateTime.now();
    // String _time = DateFormat.Hms().format(now);
    // setState(() {
    //   rpe32Data = data + " ^C";
    //   rpe32time = _time;
    // });
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                rpe32Data,
                style: TextStyle(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  fontSize: 24.0,
                ),
              ),
            ),
            Center(
              child: Text(
                rpe32time,
                style: TextStyle(
                  color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                  fontSize: 24.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
