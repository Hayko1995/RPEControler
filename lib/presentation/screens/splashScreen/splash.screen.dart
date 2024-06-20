import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:local_auth/local_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), _initiateCache);
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) =>
          setState(() =>
          _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),


      );
      if (authenticated) {
        Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
      }
    }
    on PlatformException catch (e) {}
  }

  Future _initiateCache() async {
    return CacheManagerUtils.conditionalCache(
      key: AppKeys.onBoardDone,
      valueType: ValueType.StringValue,
      actionIfNull: () {
        Navigator.of(context)
            .pushReplacementNamed(AppRouter.onBoardRoute)
            .whenComplete(() =>
            WriteCache.setString(
                key: AppKeys.onBoardDone, value: 'Something'));
      },
      actionIfNotNull: () {
        CacheManagerUtils.conditionalCache(
            key: AppKeys.userData,
            valueType: ValueType.StringValue,
            actionIfNull: () async {
              await _authenticate();
            },
            actionIfNotNull: () async {
              await _authenticate();
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'RPE Controls',
              style: TextStyle(
                color: themeFlag ? AppColors.creamColor : AppColors.mirage,
                fontSize: 39.0,
              ),
            ),
            OutlinedButton(
                child: Text(" Login "),
                style: OutlinedButton.styleFrom(),
                onPressed: () async {
                  await _authenticate();
                }),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
