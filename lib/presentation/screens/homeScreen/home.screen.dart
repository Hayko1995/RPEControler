import 'dart:async';

import 'package:cache_manager/cache_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/controllerScreen/controller.screen.dart';
import 'package:rpe_c/presentation/screens/dashboard/dashboard.screen.dart';
import 'package:rpe_c/presentation/screens/ipScanScreen/ipScan.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/widget/menu.widget.dart';
import 'package:rpe_c/presentation/screens/watcherScreen/watcher.screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/core/notifiers/user.notifier.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  final DatabaseService _databaseService = DatabaseService();

  Future _initCRNetwork() async {
    //TODO remove in production
    // if (kDebugMode) {
    _databaseService.insertNetwork(Network(
        mac: "mac address", ip: "http://172.17.0.42:9000", type: "AirQuality"));
    // }
    // enable QR scan if not have network in DB
    List devices = await _databaseService.getAllNetworks();
    if (devices.isEmpty) {
      return Navigator.of(context).pushNamed(AppRouter.qrScanRoute);
    }
  }

  @override
  void initState() {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    // ReadCache.getString(key: AppKeys.userData).then(
    //   (token) => {
    //     userNotifier.getUserData(context: context, token: token),
    //   },
    // );
    _timer = Timer(const Duration(seconds: 1), _initCRNetwork);
    super.initState();
  }

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        appBar: AppBar(
          title: const Text("RPE Controls"),
          backgroundColor: Colors.blue,
        ),
        drawer: const Menu(),
        body: Row(
          children: [Dashboard()],
        ));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
