import 'dart:async';

import 'package:cache_manager/cache_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
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
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late List<RpeNetwork> devices;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    meshNotifier.getNetworks();
    Future.delayed(const Duration(milliseconds: 2000), () {
      devices = meshNotifier.networks!;
      if (devices.isEmpty) {
        Navigator.of(context).pushNamed(AppRouter.qrScanRoute);
      }
    });

    _databaseService
        .insertNetwork(RpeNetwork(url: ApiRoutes.esp32Url, preDef: 1));
    // }
    // enable QR scan if not have network in DB

    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        appBar: AppBar(
          title: const Text("RPE Controls"),
          backgroundColor: Colors.blue,
        ),
        drawer: const Menu(),
        body: const DoubleBackToCloseApp(
            snackBar: SnackBar(content: Text('Tap back again to leave')),
            child: Row(
              children: [Dashboard()],
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
