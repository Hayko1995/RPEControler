import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sensor details Page'),
        ),
        body: Center(
            child: SizedBox(
                child: Column(
          children: <Widget>[buildMenuItems(context)],
        ))));
  }
}

Widget buildMenuItems(BuildContext context) => Container(
      child: Wrap(
        runSpacing: 3,
        children: [
          ListTile(
            leading: const Icon(Icons.nightlight_outlined),
            title: const Text("Black theme "),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => {},
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("info"),
            onTap: () => {},
          ),
        ],
      ),
    );
