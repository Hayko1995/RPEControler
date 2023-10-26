// ignore_for_file: body_might_complete_normally_nullable

import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:rpe_c/presentation/screens/mesh/meshStatus.screen.dart';
import 'package:rpe_c/presentation/screens/controllerScreen/controller.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
import 'package:rpe_c/presentation/screens/ipScanScreen/ipScan.screen.dart';
import 'package:rpe_c/presentation/screens/loginScreen/login.view.dart';
import 'package:rpe_c/presentation/screens/onBoardingScreen/onBoarding.screen.dart';
import 'package:rpe_c/presentation/screens/profileScreens/accountInformationScreen/account.information.screen.dart';
import 'package:rpe_c/presentation/screens/profileScreens/appSettingsScreen/app.setting.screen.dart';
import 'package:rpe_c/presentation/screens/profileScreens/changePasswordScreen/change.password.screen.dart';
import 'package:rpe_c/presentation/screens/profileScreens/editProfileScreen/edit.profile.screen.dart';
import 'package:rpe_c/presentation/screens/profileScreens/mainProfileScreen/profile.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsDetailScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/screens/settings/settings.screen.dart';
import 'package:rpe_c/presentation/screens/signUpScreen/signup.screen.dart';
import 'package:rpe_c/presentation/screens/splashScreen/splash.screen.dart';
import 'package:rpe_c/presentation/screens/watcherScreen/watcher.screen.dart';
import 'package:rpe_c/presentation/screens/qrScan/qrScan.screen.dart';
import 'package:rpe_c/presentation/screens/dashboard/dashboard.screen.dart';

class AppRouter {
  static const String splashRoute = "/splash";
  static const String onBoardRoute = "/onBoard";
  static const String productRoute = "/product";
  static const String loginRoute = "/login";
  static const String signUpRoute = "/signUp";
  static const String appSettingsRoute = "/appSettings";
  static const String homeRoute = "/home";
  static const String watcherRoute = "/watcher";
  static const String myHomeRoute = "/myHome";
  static const String controllerRoute = "/controller";
  static const String cartRoute = "/cart";
  static const String searchRoute = "/search";
  static const String profileRoute = "/profile";
  static const String accountInfo = "/accountInfo";
  static const String categoryRoute = "/category";
  static const String sensorDetailsRoute = "/productDetail";
  static const String editProfileRoute = "/editProfile";
  static const String changePassRoute = "/changePassword";
  static const String ipScanRoute = "/ipScan";
  static const String qrScanRoute = "/qrScan";
  static const String dashboardRoute = "/dashboard";
  static const String meshStatusRoute = "/meshStatus";
  static const String settingsRoute = "/settings";

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case editProfileRoute:
        {
          return MaterialPageRoute(
            builder: (_) => EditProfileScreen(),
          );
        }
      case settingsRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const SettingsScreen(),
          );
        }
      case ipScanRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ipScanScreen(),
          );
        }
      case appSettingsRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const AppSettings(),
          );
        }
      case meshStatusRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const MeshStatus(),
          );
        }
      case dashboardRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const Dashboard(), //todo change
          );
        }
      case qrScanRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const QRViewExample(), //todo change
          );
        }
      case sensorDetailsRoute:
        {
          return MaterialPageRoute(
            builder: (context) => SensorsDetail(
              sensorDetailsArguments: ModalRoute.of(context)!.settings.arguments
                  as SensorDetailsArgs,
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
      case watcherRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const WatcherScreen(),
          );
        }
      case myHomeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
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
      case signUpRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          );
        }
      case profileRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
          );
        }
      case accountInfo:
        {
          return MaterialPageRoute(
            builder: (_) => const AccountInformationScreen(),
          );
        }
      case changePassRoute:
        {
          return MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(),
          );
        }
    }
  }
}
