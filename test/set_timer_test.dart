import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/common.dart';

import 'package:integration_test/integration_test.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/constants/app.theme.dart';
import 'package:rpe_c/app/providers/app.provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mockito/annotations.dart';
import 'package:nock/nock.dart';
import 'package:mockito/mockito.dart';
import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
import 'package:rpe_c/presentation/screens/homeScreen/screens/dashboard/dashboard.screen.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/widgets/utiles/sensor.setTimers.widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockMeshNotifier extends Mock implements MeshNotifier {
  @override
  Future getNetworkUrlByNetId(value){
    Future<String> futureString = Future.value("192.168.1.1");
    return futureString;
  }
}

void main() {
  Provider.debugCheckInvalidValueType = null;
  RpeDevice device =
      RpeDevice(name: "aaa", image: AppConstants.images['00'], deviceType: 1);
  var rpeNetwork =  RpeNetwork(name: 'aaaa');

  // getNetworkUrlByNetId
  final mock = MockMeshNotifier();

  testWidgets("Set Timer ", (tester) async {
    when(mock.getDeviceByMac(any)).thenReturn(device);
    when(mock.getNetworkByUrl(any)).thenReturn(rpeNetwork);

    await tester.pumpWidget(MaterialApp(
      home: Provider<MeshNotifier>(
        create: (_) => mock,
        child: Scaffold(
          body: SensorSetTImerScreen(
            mac: 'any',
          ),
        ),
      ),
    ));

    // find needed buttons
    await tester.pumpAndSettle();
    var confirmButton = find.byKey(Key('Confirm'),);
    expect(confirmButton, findsOneWidget);

    // find timer drop down and test it
    var timerType = find.byKey(Key('Timer type'),);
    expect(timerType, findsOneWidget);
    await tester.tap(timerType);
    await tester.pumpAndSettle();
    ///if you want to tap first item
    final dropdownItem = find.text('One Time').last;
    //
    await tester.tap(dropdownItem);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 3));

    var startTime = find.byKey(Key("startTime"));
    expect(startTime, findsOneWidget);
    await tester.enterText(startTime, TimeOfDay.now().toString());
    await tester.tap(confirmButton);
    await tester.pump(Duration(seconds: 5));
    //
    // // find open timer
    // var addTimer = find.byKey(Key("add timer"));
    // expect(addTimer, findsOneWidget);
    // await tester.tap(openTimersRow);
    // await tester.pump(Duration(seconds: 1));
    //
    // //open show timers menu
    // var timerType = find.byKey(Key("Timer type"));
    // expect(timerType, findsOneWidget);
    // // await tester.tap(openTimersRow);
    // // await tester.pump(Duration(seconds: 1));
  });
}
