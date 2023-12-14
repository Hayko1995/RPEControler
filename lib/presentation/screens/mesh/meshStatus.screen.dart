import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/api/mesh.api.test.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class MeshCommands extends StatelessWidget {
  const MeshCommands({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MeshAPI _mashAPI = MeshAPI();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor details Page'),
      ),
      body: Center(
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                FilledButton(
                  onPressed: () {
                    _mashAPI.testMeshE1();
                  },
                  child: const Text('Send E1'),
                ),
                FilledButton(
                  onPressed: () {
                    _mashAPI.testMeshTime();
                  },
                  child: const Text('SetTime'),
                ),
                FilledButton(
                  onPressed: () {
                    _mashAPI.testSendDomainNum();
                  },
                  child: const Text('sendDomainNum'),
                ),
                FilledButton(
                  onPressed: () {
                    _mashAPI.testSendSetNetId();
                  },
                  child: const Text('sendSetNetId'),
                ),
                FilledButton(
                  onPressed: () {
                    _mashAPI.testSendPreDefineNum();
                  },
                  child: const Text('sendPreDefineNum'),
                ),
                FilledButton(
                  onPressed: () {
                    _mashAPI.testSendSetNetNum();
                  },
                  child: const Text('sendSetNetNum'),
                ),
              ],
            )),
      ),
    );
  }
}
