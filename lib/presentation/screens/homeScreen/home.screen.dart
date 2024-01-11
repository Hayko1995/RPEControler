import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/homeScreen/screens/clusters/clusters.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/screens/dashboard/dashboard.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/widget/menu.widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

final List<SalomonBottomBarItem> bottomNavBarIcons = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.dashboard),
    title: const Text("Networks"),
    selectedColor: Colors.blue,
  ),

  /// Search
  SalomonBottomBarItem(
    icon: const Icon(Icons.group_work),
    title: const Text("Clusters"),
    selectedColor: Colors.blue,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.widgets),
    title: const Text("Widgets"),
    selectedColor: Colors.blue,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late List<RpeNetwork> devices;
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const DashboardScreen(), const ClustersScreen(), const DashboardScreen()];

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
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(content: Text('Tap back again to leave')),
          child: screens[_currentIndex],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: bottomNavBarIcons,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
