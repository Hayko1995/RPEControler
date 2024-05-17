import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Debug extends StatefulWidget {
  const Debug({super.key});

  @override
  State<Debug> createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  final myController = TextEditingController(text: '');
  final notID = TextEditingController(text: '');
  final netID = TextEditingController(text: '');
  final myIPController = TextEditingController(text: 'http://192.168.0.1');
  final netIDController = TextEditingController(text: '01');
  final nodIDController = TextEditingController(text: '01');
  final MeshAPI _mashAPI = MeshAPI();

  String meshResponse = '';
  String inputCommand = '';
  String netId = '01';
  String nodId = '01';
  String response = '';
  String responseSize = "";

  Future<void> sendCommand(command) async {
    String _resp = "";
    String _responseSize = "";
    String response = await _mashAPI.sendToMeshDebug(command, inputCommand);

    meshResponse = response;
    _responseSize = (response.length / 2).toString();
    if (response.length > 2) {
      for (int i = 0; i < response.length; i = i + 2) {
        _resp += response.substring(i, i + 2);
      }
    } else {
      _resp = response;
    }
    setState(() {
      meshResponse = _resp;
      responseSize = _responseSize.toString();
    });
  }

  Widget uiWidget(context, name, command) {
    return GestureDetector(
      onTap: () async {
        await sendCommand(command);
      },
      child: Container(
        width: 50,
        height: 50,
        color: Colors.blue,
        child: Center(
          child: Text(name),
        ),
      ),
    );
  }

  Widget onOff(context, name, on) {
    return GestureDetector(
      onTap: () async {
        String command = "94" + on + "05" + nodId + netId;
        await sendCommand(command);
      },
      child: Container(
        width: 70,
        height: 70,
        color: Colors.blue,
        child: Center(
          child: Text(name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      sensorList.add(uiWidget(context, 'E1', "E1FF060001FA"));
      sensorList.add(uiWidget(context, 'E3', "E3FF060001FA"));
      sensorList.add(uiWidget(context, 'E2', "E2FF060001FA"));
      return sensorList;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Commands"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: myIPController,
                        onChanged: (text) {
                          setState(() {
                            inputCommand = text;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: FilledButton(
                        child: const Text(
                          'save',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('ip', inputCommand);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GridView.count(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: getSensors())),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      onOff(context, 'ON', "01"),
                      const SizedBox(width: 10),
                      onOff(context, 'OFF', "02"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text("NodeId   "),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: nodIDController,
                                onChanged: (text) {
                                  setState(() {
                                    nodId = text;
                                  });
                                },
                              ),
                            ),
                            const Text("NetID   "),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: netIDController,
                                onChanged: (text) {
                                  setState(() {
                                    netId = text;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: TextField(
                        controller: myController,
                        onChanged: (text) {
                          setState(() {
                            inputCommand = text;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: FilledButton(
                        child: const Text(
                          'Send',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        onPressed: () {
                          sendCommand(inputCommand);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      child: Text(meshResponse),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Text("Size = $responseSize"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
