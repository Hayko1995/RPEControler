import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class MeshStatus extends StatelessWidget {
  const MeshStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sensor details Page'),
        ),
        body: Center(
            child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.1,
          child: Row(children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  try {
                    final data = snapshot.data!;
                    final map = jsonDecode(data["data"]!);
                    context.watch<MeshNotifier>().updateService(
                        map['id'], map['temperature']); //todo store in db
                    return Row(
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        const Text("mesh id = "),
                        Text(context.watch<MeshNotifier>().id.toString()),
                        const Text("    "),
                        const Text("device temperature = "),
                        Text(context.watch<MeshNotifier>().id.toString()),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    );
                  } catch (e) {
                    return const Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("Error"),
                        Text("Error"),
                      ],
                    );
                  }
                }
              },
            ),
          ]),
        )));
  }
}
