import 'dart:convert';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.keys.dart';
import 'package:rpe_c/core/logger/logger.dart';
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
  late String emailString = '';
  late List emails = [];
  late double electricityPrice;
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _power = new TextEditingController();

  void _addEmail() => showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // <-- SEE HERE
            title: const Text('Your Emails'),
            content: SingleChildScrollView(
                child: TextField(
              controller: _email,
              //editing controller of this TextField
              decoration: const InputDecoration(
                  //icon of text field
                  labelText: "Add Emails" //label text of field
                  ),
            )),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  emails.add(_email.text);
                  logger.e(jsonEncode(emails));

                  WriteCache.setString(
                      key: AppKeys.emails, value: jsonEncode(emails));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void _showEmails() => showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // <-- SEE HERE
            title: const Text('Your Emails'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(emails.toString()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    _power.text = "0";
    CacheManagerUtils.conditionalCache(
      key: AppKeys.emails,
      valueType: ValueType.StringValue,
      actionIfNull: () {
        WriteCache.setString(key: AppKeys.emails, value: '[]');
        emails = [];
      },
      actionIfNotNull: () async {
        emailString = await ReadCache.getString(key: AppKeys.emails);
        // List<String> servicesList = ["one", "Two", "Thee"];
        // print();
        emails = jsonDecode(emailString);
      },
    );
    CacheManagerUtils.conditionalCache(
      key: AppKeys.electricityPrice,
      valueType: ValueType.DoubleValue,
      actionIfNull: () {
        WriteCache.setDouble(key: AppKeys.electricityPrice, value: 0);
      },
      actionIfNotNull: () async {
        electricityPrice =
            await ReadCache.getDouble(key: AppKeys.electricityPrice);
        _power.text = electricityPrice.toString();
      },
    );

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
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Show Emails"),
                          onTap: () => _showEmails()),
                    ),
                    FilledButton(
                      onPressed: () {
                        _addEmail();
                      },
                      child: const Text("Add"),
                    ),
                  ]),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: TextField(
                        controller: _power,
                        //editing controller of this TextField
                        decoration: const InputDecoration(
                            //icon of text field
                            labelText: "Add Power" //label text of field
                            ),
                        onTap: () {
                          _power.text = '';
                        },
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        double value = double.parse(_power.text);
                        WriteCache.setDouble(
                            key: AppKeys.electricityPrice, value: value);
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ]),
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
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  child: Column(
            children: <Widget>[buildMenuItems(context)],
          ))),
        ));
  }
}
