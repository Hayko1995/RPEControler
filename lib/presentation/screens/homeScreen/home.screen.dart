import 'package:cache_manager/cache_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

final List<SalomonBottomBarItem> bottomNavBarIcons = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Dashboard"),
    selectedColor: Colors.blue,
  ),

  /// Search
  SalomonBottomBarItem(
    icon: const Icon(Icons.watch),
    title: const Text("Watcher"),
    selectedColor: Colors.blue,
  ),

  SalomonBottomBarItem(
    icon: const Icon(EvaIcons.shoppingCart),
    title: const Text("Editor"),
    selectedColor: Colors.blue,
  ),

  SalomonBottomBarItem(
    icon: const Icon(EvaIcons.person),
    title: const Text("associations"),
    selectedColor: Colors.blue,
  ),
];

final screens = [
  const Dashboard(),
  const WatcherScreen(),
  const ControllerScreen(),
  const ipScanScreen(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    // ReadCache.getString(key: AppKeys.userData).then(
    //   (token) => {
    //     userNotifier.getUserData(context: context, token: token),
    //   },
    // );
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
      body: Column(
        children: [
          screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor:
            themeFlag ? AppColors.rawSienna : const Color(0xff4B7191),
        unselectedItemColor: themeFlag ? Colors.white : const Color(0xff777777),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: bottomNavBarIcons,
      ),
    );
  }
}
