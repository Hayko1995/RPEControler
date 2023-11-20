import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:rpe_c/app/routes/api.routes.dart';
import "package:hex/hex.dart";
import 'package:convert/convert.dart';

class MeshAPI {
  final client = http.Client();
  final headers = {'Content-Type': 'application/text; charset=utf-8'};

  Future meshUpdate() async {
    //todo add problem response failure situation
    const subUrl = '/mesh/update';
    final Uri uri = Uri.parse(ApiRoutes.baseurl + subUrl);
    try {
      final http.Response response = await client.get(
        uri,
        headers: headers,
      );
      final body = response.body;
      print(body);
      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }

  Future sendToMesh(pktHdr) async {
    var result = [];
    List<String> lint = [];
    // List<String> aa = [];

    // for (var i = 0; i < pktHdr.length; i += 2) {
    //   result.add(int.parse(pktHdr.substring(i, i + 2), radix: 16));
    // }
    // print(result);
    // for (int i = 0; i < result.length; i++) {
    //   aa.add(result[i].toRadixString(16));
    // }
    // var command = aa.join("");
    //todo add problem response failure situation
    final Uri uri = Uri.parse("http://192.168.0.15/");

    print("Send111");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: pktHdr);
      final body = response.body;
      print("Send");
      var stringList = body.split(' ');
      stringList.removeLast();
      print("Send");
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }

  Future meshE1() async {
    String pktHdr = "E1FF060001FA";
    var result = [];
    List<String> lint = [];
    // List<String> aa = [];

    // for (var i = 0; i < pktHdr.length; i += 2) {
    //   result.add(int.parse(pktHdr.substring(i, i + 2), radix: 16));
    // }
    // print(result);
    // for (int i = 0; i < result.length; i++) {
    //   aa.add(result[i].toRadixString(16));
    // }
    // var command = aa.join("");
    print("result         aaaaaaaa");
    //todo add problem response failure situation
    final Uri uri = Uri.parse("http://192.168.0.15/");

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: pktHdr);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }

      print(lint);
      print("Heder //////////////////");
      print(lint[0] + "command type E1");
      print(lint[1] + " " + lint[2] + "data Langht");
      print(lint[2] + "number of nodes ");
      print(lint[3] + lint[4] + lint[5] + lint[6] + "rpe id ");
      print(lint[7] + "domain type ");
      print(lint[8] + "preset packege ");
      print(lint[9] + "network number ");
      print(lint[10] + lint[11] + lint[12] + lint[13] + "CR reported time");
      print(lint[14] + "reserved ");

      print("Body  //////////////////");
      // chage to for
      print(lint[14] + "node num");
      print(lint[15] + "node type");
      print(lint[16] + "node subtype");
      print(lint[17] + "node location");
      print(lint[18] + "stuck location");
      print(lint[19] + "stuck type");
      print(lint[20] + "number or child");
      print(lint[21] + "status");
      print(lint[22] + "parent node number");
      for (int i = 23; i < 23 + 9; i++) {
        print(lint[i] + "mac address");
      }

      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }

  String hexPadding(num) {
    if (num < 16777217) {
      if (num < 65536) {
        if (num < 4096) {
          if (num < 256) {
            num = num.toRadixString(16);
            num = '000000' + num;
          } else {
            num = num.toRadixString(16);
            num = '00000' + num;
          }
        } else {
          num = num.toRadixString(16);
          num = '0000' + num;
        }
      } else {
        if (num < 1048576) {
          num = num.toRadixString(16);
          num = '000' + num;
        } else {
          num = num.toRadixString(16);
          num = '00' + num;
        }
      }
    } else {
      if (num < 268435456) {
        num = num.toRadixString(16);
        num = '0' + num;
      } else {
        num = num.toRadixString(16);
      }
    }
    return (num);
  }

  Future meshTime() async {
    String pktHdr = "E1FF060001FA";
    var result = [];
    List<String> lint = [];

    var cmd = '38'; // new Broadcast time code = 0x38 instead of 8C
    var cmdSub = '00';
    var msgLen = '10';
    var msgNode = '00';
    var netNum = 'FF';
    var msgCount = '55';
    var weekday = '00';
    var daySecCount = '00000000';

    DateTime d1 = new DateTime.now();
    print(d1.microsecondsSinceEpoch);

    // var d1 = new Date();
    // //hb            console.log('T1: ' + d1);
    double d1t0 = d1.microsecondsSinceEpoch / 1000;
    int d1t2 = (d1t0 / 1000).toInt();
    int d1t3 = d1t2 - 946713600; //946684800 + 8hrs (28800);

    // var msg = 'Testing various methods:' +
    //     '1) Date.getTime()/1000   = ' +
    //     d1t0.toString() +
    //     '\n' +
    //     '2) (Date.getTime()-Date.getMilliseconds())/1000 = ' +
    //     d1t1.toString() +
    //     '\n' +
    //     '3) parseInt(Date.getTime()/1000)  = ' +
    //     d1t2.toString() +
    //     '\n' +
    //     '4) Seconds since 2000 = ' +
    //     d1t3.toString();

    // print(msg);

    // //hb            console.log(msg)
    // //console.log('prev time: ' + prev_d1t3);
    // //var pollRate = setInterval(pollCoord, 7000);
    // //          if ((d1t3 - prev_d1t3) > 43200) {  // 12 hrs different, re-send time synch.
    // //issue a time synch message to the coord

    String sd1t3 = d1t3.toRadixString(16);
    print(sd1t3);

    weekday = '0' + (d1.day).toRadixString(16);
    int daySecCount1 = (d1.hour * 3600) + (d1.minute * 60) + d1.second;

    daySecCount = daySecCount1.toRadixString(16);
    daySecCount = hexPadding(daySecCount1);

    // daySecCount = _daySecCount.toRadixString(16);
    print(daySecCount);
    // console.log('time in sec = ' + d1t3 + ' weekday' + weekday + '  Time of day = ' + daySecCount1);  // 0= sunday 1=monday
    String timePkt = cmd +
        cmdSub +
        msgLen +
        msgNode +
        netNum +
        msgCount +
        sd1t3 +
        weekday +
        daySecCount;
    //todo add problem response failure situation
    final Uri uri = Uri.parse("http://192.168.0.15/");

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: timePkt);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }

      return body;
    } catch (e) {
      print("service = internet problem");
      return Null;
    }
  }
}
