// ignore_for_file: body_might_complete_normally_nullable

import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:rpe_c/presentation/screens/assosiationScreen/assosiation.screen.dart';
import 'package:rpe_c/presentation/screens/bluetooth/device_screen.dart';
import 'package:rpe_c/presentation/screens/clusterControlScreen/clusterControl.screen.dart';
import 'package:rpe_c/presentation/screens/clusteringScreen/clustering.screen.dart';
import 'package:rpe_c/presentation/screens/controllerScreen/controller.screen.dart';
import 'package:rpe_c/presentation/screens/esp32/esp32.view.dart';
import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/screens/dashboard/dashboard.screen.dart';
import 'package:rpe_c/presentation/screens/ipScanScreen/ipScan.screen.dart';
import 'package:rpe_c/presentation/screens/loginScreen/login.view.dart';
import 'package:rpe_c/presentation/screens/manipulation/manipulation.screen.dart';
import 'package:rpe_c/presentation/screens/notificationsScreen/notifications.screen.dart';
import 'package:rpe_c/presentation/screens/onBoardingScreen/onBoarding.screen.dart';
import 'package:rpe_c/presentation/screens/qrScan/configureNetwork.dart';
import 'package:rpe_c/presentation/screens/qrScan/qrScan.screen.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/sensors.screen.dart';
import 'package:rpe_c/presentation/screens/settings/settings.screen.dart';
import 'package:rpe_c/presentation/screens/signUpScreen/signup.screen.dart';
import 'package:rpe_c/presentation/screens/splashScreen/splash.screen.dart';

class AppRouter {
  static const String splashRoute = "/splash";
  static const String onBoardRoute = "/onBoard";
  static const String productRoute = "/product";
  static const String loginRoute = "/login";
  static const String signUpRoute = "/signUp";
  static const String appSettingsRoute = "/appSettings";
  static const String homeRoute = "/home";
  static const String watcherRoute = "/watcher";
  static const String controllerRoute = "/controller";
  static const String searchRoute = "/search";
  static const String profileRoute = "/profile";
  static const String accountInfo = "/accountInfo";
  static const String categoryRoute = "/category";
  static const String sensorDetailsRoute = "/sensorDetails";
  static const String manipulationsRoute = "/manipulation";
  static const String sensorsRoute = "/sensor";
  static const String editProfileRoute = "/editProfile";
  static const String changePassRoute = "/changePassword";
  static const String ipScanRoute = "/ipScan";
  static const String qrScanRoute = "/qrScan";
  static const String notifications = "/notifications";
  static const String dashboardRoute = "/dashboard";
  static const String settingsRoute = "/settings";
  static const String esp32Route = "/esp32";
  static const String networkConfigRouter = '/networkConfig';
  static const String clusterControlRouter = '/clusterControl';
  static const String clusteringRouter = '/clustering';
  static const String associationsRouter = '/associations';
  static const String bleDeviceRouter = '/bleDevice';

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case sensorDetailsRoute:
        {
          return MaterialPageRoute(
            builder: (context) => SensorDetailsScreen(
              sensorDetailsArguments: ModalRoute.of(context)!.settings.arguments
                  as SensorDetailsArgs,
            ),
            settings: settings,
          );
        }

      case bleDeviceRouter:
        {
          return MaterialPageRoute(
            builder: (context) => DeviceScreen(
              bleArgs: ModalRoute.of(context)!.settings.arguments as BleArgs,
            ),
            settings: settings,
          );
        }
      case clusteringRouter:
        {
          return MaterialPageRoute(
            builder: (context) => ClusteringScreen(
              clusteringArguments:
                  ModalRoute.of(context)!.settings.arguments as ClusteringArgs,
            ),
            settings: settings,
          );
        }
      case associationsRouter:
        {
          return MaterialPageRoute(
            builder: (context) => AssociationScreen(
              associationArguments:
                  ModalRoute.of(context)!.settings.arguments as AssociationArgs,
            ),
            settings: settings,
          );
        }
      case clusterControlRouter:
        {
          return MaterialPageRoute(
            builder: (context) => ClusterControlScreen(
              clusterControlsArguments: ModalRoute.of(context)!
                  .settings
                  .arguments as ClusterControlArgs,
            ),
            settings: settings,
          );
        }
      case manipulationsRoute:
        {
          return MaterialPageRoute(
            builder: (context) => ManipulationScreen(
              manipulationsArgs: ModalRoute.of(context)!.settings.arguments
                  as ManipulationsArgs,
            ),
            settings: settings,
          );
        }
      case settingsRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const SettingsScreen(),
          );
        }
      case notifications:
        {
          return MaterialPageRoute(
            builder: (_) => const NotificationsScreen(),
          );
        }
      case esp32Route:
        {
          return MaterialPageRoute(
            builder: (_) => ESP32Screen(),
          );
        }
      case ipScanRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ipScanScreen(),
          );
        }
      case dashboardRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const DashboardScreen(), //todo change
          );
        }
      case qrScanRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const QRScanScreen(), //todo change
          );
        }
      case sensorsRoute:
        {
          return MaterialPageRoute(
            builder: (context) => Sensors(
              predefineSensorsArguments:
                  ModalRoute.of(context)!.settings.arguments as SensorArgs,
            ),
            settings: settings,
          );
        }

      case homeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          );
        }
      case ipScanRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ipScanScreen(),
          );
        }
      case controllerRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ControllerScreen(),
          );
        }
      case splashRoute:
        {
          return ConcentricPageRoute(
            fullscreenDialog: true,
            builder: (_) => const SplashScreen(),
          );
        }
      case onBoardRoute:
        {
          return MaterialPageRoute(
            builder: (_) => OnBoardingScreen(),
          );
        }
      case loginRoute:
        {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(),
          );
        }
      case networkConfigRouter:
        {
          return MaterialPageRoute(
            builder: (context) => ConfigureNetworkScreen(
              networkConfigArguments: ModalRoute.of(context)!.settings.arguments
                  as NetworkConfigArgs,
            ),
            settings: settings,
          );
        }
      case signUpRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          );
        }
    }
  }
}
