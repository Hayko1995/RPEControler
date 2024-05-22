import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.theme.dart';
import 'package:rpe_c/app/providers/app.provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW line we added


  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    }
  testWidgets('tap on the floating action button, verify counter',
      (tester) async {
    // Load app widget.
    await tester.pumpWidget(MultiProvider(
      providers: AppProvider.providers,
      child:Consumer<ThemeNotifier>(
        builder: (context, notifier, _) {
          return MaterialApp(
            title: 'RPE Controls',
            // supportedLocales: AppLocalization.all,
            theme: notifier.darkTheme ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.homeRoute,
          );
        },
      ),
    ));
    await tester.pump(Duration(seconds: 1));

  });
}
