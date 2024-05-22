import 'dart:async';
import 'dart:io';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.theme.dart';
import 'package:rpe_c/app/providers/app.provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/core/service/background.service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';


// import 'web_url/configure_nonweb.dart'
//     if (dart.library.html) 'web_url/configure_web.dart';

Future<void> main() async {

  DartPingIOS.register();
  // configureApp();
  /////////////////Background service
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  /////////////////Background service
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true); // ble tuned off

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // appWindow.size = const Size(600, 1000);
    runApp(const Core());
    // appWindow.show();

    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(600, 1000);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "RPE Test";
      win.show();
    });
  }

  runApp(const Core());
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child:Consumer<ThemeNotifier>(
        builder: (context, notifier, _) {
          return MaterialApp(
            title: 'RPE Controls',
            // supportedLocales: AppLocalization.all,
            theme: notifier.darkTheme ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splashRoute,
          );
        },
      ),
    );
  }
}
