import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> initializeService() async {
  if (Platform.isAndroid && Platform.isIOS) {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: false,

        // notificationChannelId: 'my_foreground',
        // initialNotificationTitle: 'AWESOME SERVICE',
        // initialNotificationContent: 'Initializing',
        // foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

Future initMesh() async {
  final MeshAPI meshAPI = MeshAPI();
  await meshAPI.meshE1();
  // await meshAPI.meshTime();
  // logger.i("send E1");
}

Future<String> updateMesh() async {
  final MeshAPI _mashAPI = MeshAPI();
  // logger.i("send E3");
  await _mashAPI.meshE3();

  // _mashAPI.sendToMesh("E2E2E2E2");
  // _mashAPI.sendToMesh("38001000FF552ce6e811030000ca51");

  // _mashAPI.sendToMesh("38,00,10,00,FF,55, 10");
  // _mashAPI.sendToMesh("E1FF060001FA");
  // if (products != Null) {
  //   var data = MeshModel.fromJson(jsonDecode(products)).data;
  //   String jsonUser = jsonEncode(data);
  //   return Future.value(jsonUser);
  // }
  return Future.value("");
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  int id = 0;

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  if (service is AndroidServiceInstance) {
    //todo chang when autostart run background
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground

  initMesh();
  Timer.periodic(const Duration(milliseconds: AppConstants.uiUpdateInterval),
      (timer) async {
    if (service is AndroidServiceInstance) {
      print("aaaaaaaaaa");
    }

    updateMesh();
    // Future<String> data1 = updateMesh();
    // Future<String> data = getData();
    // String response = await data;
    // if (response != "") {
    //   service.invoke(
    //     'update',
    //     {
    //       "data": response,
    //     },
    //   );
    // }
  });
}
