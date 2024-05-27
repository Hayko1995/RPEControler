
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class Uart extends StatefulWidget {
  const Uart({super.key});

  @override
  State<Uart> createState() => _UartState();
}

class _UartState extends State<Uart> {
  final myController = TextEditingController(text: '');

  // A5 34 00 08 00 00 00 0C 00 E0 00 54 83

  final e1 = TextEditingController(text: 'A5');
  final e2 = TextEditingController(text: '34');
  final e3 = TextEditingController(text: '00');
  final e4 = TextEditingController(text: '08');
  final e5 = TextEditingController(text: '00');
  final e6 = TextEditingController(text: '00');
  final e7 = TextEditingController(text: '00');
  final e8 = TextEditingController(text: '0C');
  final e9 = TextEditingController(text: '00');
  final xCord = TextEditingController(text: 'E0');
  final e10 = TextEditingController(text: '00');
  final yCord = TextEditingController(text: '54');
  final e11 = TextEditingController(text: '83');

  var port;
  var portName = '';
  var sp;
  final config = SerialPortConfig();

  String meshResponse = '';
  String inputCommand = '';
  String netId = '01';
  String nodId = '01';
  String response = '';
  String responseSize = "";

  Widget uiWidget(context, port, name) {
    return Row(
      children: [
        Expanded(child: Text(name)),
        FilledButton(
          onPressed: () {
            sp = SerialPort(port);
            sp.openWrite();
          },
          child: const Text("Connect"),
        ),
      ],
    );
  }

  void sendOverUart(bytes) {
    print(sp.write(bytes));
    // sp.dispose();
  }

  Widget move(context, name, on) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          if (name == "UP") {
            int y = int.parse(yCord.text, radix: 16);
            y++;
            yCord.text = y.toRadixString(16);
          }
          if (name == "DOWN") {
            int y = int.parse(yCord.text, radix: 16);
            y--;
            yCord.text = y.toRadixString(16);
          }
          if (name == "LEFT") {
            int x = int.parse(xCord.text, radix: 16);
            x--;
            xCord.text = x.toRadixString(16);
          }
          if (name == "RIGHT") {
            int x = int.parse(xCord.text, radix: 16);
            x++;
            xCord.text = x.toRadixString(16);
          }
          //
          List<int> hexList = [];
          hexList.add(int.parse(e1.text, radix: 16));
          hexList.add(int.parse(e2.text, radix: 16));
          hexList.add(int.parse(e3.text, radix: 16));
          hexList.add(int.parse(e4.text, radix: 16));
          hexList.add(int.parse(e5.text, radix: 16));
          hexList.add(int.parse(e6.text, radix: 16));
          hexList.add(int.parse(e7.text, radix: 16));
          hexList.add(int.parse(e8.text, radix: 16));
          hexList.add(int.parse(e9.text, radix: 16));

          String _yCord = int.parse(yCord.text, radix: 16).toRadixString(16);
          String _xCord = int.parse(xCord.text, radix: 16).toRadixString(16);
          if (_yCord.length <= 2) {
            hexList.add(int.parse(_xCord, radix: 16));
            hexList.add(0);
          } else {
            hexList.add(int.parse(_xCord.substring(0, 2), radix: 16));
            hexList.add(int.parse(_xCord.substring(2), radix: 16));
          }
          hexList.add(int.parse(_yCord, radix: 16));

          List<int> d = [];
          var sum = 0;
          for (var i = 1; i < hexList.length - 1; i++) {
            sum += hexList[i];
          }
          try {
            print(sum);
            int res = sum ^ int.parse("FF", radix: 16);
            e11.text = res.toRadixString(16);
            hexList.add(res);
            Uint8List bytes = Uint8List.fromList(hexList);
            sendOverUart(bytes);
          } catch (e) {
            print(e);
          }
        },
        child: Container(
          width: 70,
          height: 70,
          color: Colors.blue,
          child: Center(
            child: Text(name),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      for (final name in SerialPort.availablePorts) {
        var serial = SerialPort(name);
        var serialName = serial.description;
        sensorList.add(uiWidget(context, name, serialName));
        serial.dispose();
      }
      return sensorList;
    }

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Commands"),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: getSensors())),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e1,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e2,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e3,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e4,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e5,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e6,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e7,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e8,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e9,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: xCord,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e10,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: yCord,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: e11,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  List<int> newData = [];
                                  newData.add(int.parse(e1.text, radix: 16));
                                  newData.add(int.parse(e2.text, radix: 16));
                                  newData.add(int.parse(e3.text, radix: 16));
                                  newData.add(int.parse(e4.text, radix: 16));
                                  newData.add(int.parse(e5.text, radix: 16));
                                  newData.add(int.parse(e6.text, radix: 16));
                                  newData.add(int.parse(e7.text, radix: 16));
                                  newData.add(int.parse(e8.text, radix: 16));
                                  newData.add(int.parse(e9.text, radix: 16));
                                  newData.add(int.parse(xCord.text, radix: 16));
                                  newData.add(int.parse(e10.text, radix: 16));
                                  newData.add(int.parse(yCord.text, radix: 16));
                                  newData.add(int.parse(e11.text, radix: 16));
                                  Uint8List _bytes =
                                  Uint8List.fromList(newData);
                                  sendOverUart(_bytes);
                                },
                                child: const Text("Send"),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Y Cord   "),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: yCord,
                                  onChanged: (text) {
                                    setState(() {
                                      nodId = text;
                                    });
                                  },
                                ),
                              ),
                              const Text("X cord   "),
                              SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: xCord,
                                  onChanged: (text) {
                                    setState(() {
                                      netId = text;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Row(children: [
                              SizedBox(
                                width: 87,
                              ),
                              move(context, 'UP', "01")
                            ]),
                            SizedBox(
                              height: 15,
                            ),
                            Row(children: [
                              move(context, 'LEFT', "01"),
                              move(context, 'DOWN', "01"),
                              move(context, 'RIGHT', "01")
                            ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
