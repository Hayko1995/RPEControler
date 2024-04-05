import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final fieldText = TextEditingController(text: 'http://192.168.0.1');
  String url = "http://192.168.0.1";
  final DatabaseService _databaseService = DatabaseService();


  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    Widget buildMenuItems(BuildContext context) => Container(
      child: Wrap(
        runSpacing: 3,
        children: [
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: fieldText,
                      onChanged: (text) {
                        url = text;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    _databaseService
                        .insertNetwork(RpeNetwork(url: url, preDef: 1));
                    meshNotifier.sendE1();
                  },
                  child: const Text("Save"),
                ),
              ]),
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
            title: const Text("Something"),
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
