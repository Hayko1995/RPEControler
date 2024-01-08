import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/widget/device.widget.dart';

import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
import 'package:rpe_c/presentation/widgets/predefine.widgets.dart';

class PredefineScreen extends StatefulWidget {
  final PreDefineArgs predefineArguments;

  const PredefineScreen({super.key, required this.predefineArguments});

  @override
  State<PredefineScreen> createState() => _PredefineScreenState();
}

class _PredefineScreenState extends State<PredefineScreen> {
  final DatabaseService _databaseService = DatabaseService();
  late Timer _timer;
  List<RpeNetwork> dataDevices = <RpeNetwork>[];
  List<RpeNetwork> data = <RpeNetwork>[];
  // var meshNotifier;

  @override
  void initState() {
    super.initState();
    print("initState");
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    meshNotifier.predefines(widget.predefineArguments.preDef);
    Future.delayed(const Duration(seconds: 1), () {
      dataDevices = meshNotifier.getPredefines!;
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Predefine Package'),
          backgroundColor: Colors.blue,
        ),
        body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: List.generate(dataDevices.length, (index) {
                    if (dataDevices[index].preDef == AppConstants.airQuality) {}
                    return airQualityWidget(context, dataDevices[index], index,
                        "predefine", 0, GlobalKey());
                  }),
                ))));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class PreDefineArgs {
  final int preDef;

  const PreDefineArgs({required this.preDef});
}
