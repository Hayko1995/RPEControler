import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/models/mesh.model.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final DatabaseService _databaseService = DatabaseService();

  await _databaseService.insertLightSensors(LightSensors(
      name: "name",
      mac: "0.0.0.0",
      groups: 1,
      description: "description",
      positionX: 0.0,
      positionY: 0.0));
  print("write done ");
  await _databaseService.insertLightSensors(LightSensors(
      name: "name",
      groups: 1,
      mac: "0.0.0.0",
      description: "description",
      positionX: 0.0,
      positionY: 0.0));
  await _databaseService.insertLightSensors(LightSensors(
      name: "name",
      mac: "0.0.0.0",
      groups: 1,
      description: "description",
      positionX: 0.0,
      positionY: 0.0));

  final breed = await _databaseService.lightSensor(1);

  /// OPTIONAL, using custom notification channel id
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

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
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

Future<String> getData() async {
  final MeshAPI _mashAPI = MeshAPI();
  var products = await _mashAPI.meshUpdate();
  if (products != Null) {
    var data = MeshModel.fromJson(jsonDecode(products)).data;
    String jsonUser = jsonEncode(data);
    return Future.value(jsonUser);
  }
  return Future.value("");
}

Future<String> initMesh() async {
  final MeshAPI _mashAPI = MeshAPI();
  // _mashAPI.sendToMesh("E3FF060001FA");
  // _mashAPI.meshE1();
  _mashAPI.meshTime();

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

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
    }

    // test using external plugin

    Future<String> data1 = initMesh();
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