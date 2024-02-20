import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.theme.dart';
import 'package:rpe_c/app/providers/app.provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:rpe_c/core/service/mesh.service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import 'web_url/configure_nonweb.dart'
//     if (dart.library.html) 'web_url/configure_web.dart';

Future<void> main() async {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  DartPingIOS.register();
  // configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await initializeService(); // intilayze background service
  runApp(const Lava());
}

class Lava extends StatelessWidget {
  const Lava({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: const Core(),
    );
  }
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
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
    );
  }
}
