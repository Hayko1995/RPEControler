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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockMeshNotifier extends Mock implements MeshNotifier {}

void main() {
  Provider.debugCheckInvalidValueType = null;

  final articlesFromService = [
    RpeNetwork(
        name: "e1",
        num: 0,
        date: 1,
        associations: '{}',
        clusters: "{}",
        domain: 1,
        ipAddr: "192.168.1.1",
        macAddr: "aaaaa",
        numOfNodes: 1,
        url: "192.168.1.1"),
    RpeNetwork(
        name: "e1",
        num: 0,
        date: 1,
        associations: '{}',
        clusters: "{}",
        domain: 1,
        ipAddr: "192.168.1.1",
        macAddr: "aaaaa",
        numOfNodes: 1,
        url: "192.168.1.1")
  ];
  List<RpeDevice> rpeDevices = [];
  final mock = MockMeshNotifier();

  testWidgets("Device Test ", (tester) async {
    when(mock.networks).thenReturn(articlesFromService);
    when(mock.getDeviceByNetId(any)).thenReturn(rpeDevices);

    await tester.pumpWidget(MaterialApp(
      home: Provider<MeshNotifier>(
        create: (_) => mock,
        child: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    ));
    await tester.pump(Duration(seconds: 15));
    await tester.pumpAndSettle();
    var widget = find.byKey(Key("network Widget 0"));
    expect(widget, findsOneWidget);
    widget = find.byKey(Key("network Widget 1"));
    expect(widget, findsOneWidget);
  });
}
