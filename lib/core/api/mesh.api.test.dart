import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class MeshAPI {
  final client = http.Client();
  final headers = {'Content-Type': 'application/text; charset=utf-8'};
  final DatabaseService _databaseService = DatabaseService();

  Future testChangeWifi() async {
    //todo add problem response failure situation
    const subUrl = '/wifiSwitch';
    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: "RPE-WiFi:RPas\$2024");
      final body = response.body;
      return "body";
    } catch (e) {
      logger.e(e);
      return Null;
    }
  }

  Future testMeshUpdate() async {
    //todo add problem response failure situation
    const subUrl = '/mesh/update';
    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response = await client.get(
        uri,
        headers: headers,
      );
      final body = response.body;
      return body;
    } catch (e) {
      return Null;
    }
  }

  Future testSendToMesh(pktHdr) async {
    List<String> lint = [];
    // List<String> aa = [];

    // for (var i = 0; i < pktHdr.length; i += 2) {
    //   result.add(int.parse(pktHdr.substring(i, i + 2), radix: 16));
    // }
    // print(result);
    // for (int i = 0; i < result.length; i++) {
    //   aa.add(result[i].toRadixString(16));
    // }
    // var command = aa.join(" " );
    //todo add problem response failure situation
    final Uri uri = Uri.parse("http://192.168.4.1");

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
      return body;
    } catch (e) {
      print(" service = internet problem");
      return Null;
    }
  }

  Future testMeshE1() async {
    List<Network> networks = await _databaseService.getAllNetworks();

    String command = "E1FF060001FA";
    List<String> lint = [];
    final Uri uri = Uri.parse("http://192.168.4.1");
    int length = 0;

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      var stringList = body.split(' ');
      return body;
    } catch (e) {
      logger.e(e);
      return Null;
    }
  }

  Future testMeshTime() async {
    List<String> lint = [];

    var cmd = '38';
    var cmdSub = '00';
    var msgLen = '10';
    var msgNode = '00';
    var netNum = 'FF';
    var msgCount = '55';
    var weekday = '00';
    var daySecCount = '00000000';

    DateTime d1 = new DateTime.now();

    double d1t0 = d1.microsecondsSinceEpoch / 1000;
    int d1t2 = (d1t0 / 1000).toInt();
    int d1t3 = d1t2 - 946713600; //946684800 + 8hrs (28800);

    String sd1t3 = d1t3.toRadixString(16);

    weekday = '0${(d1.day).toRadixString(16)}';
    int daySecCount1 = (d1.hour * 3600) + (d1.minute * 60) + d1.second;

    daySecCount = daySecCount1.toRadixString(16);
    daySecCount = hexPadding(daySecCount1);

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
    final Uri uri = Uri.parse("http://192.168.4.1");

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: timePkt);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int integerData = int.parse(stringList[i]);
        lint.add(integerData.toRadixString(16));
      }

      return body;
    } catch (e) {
      print(" service = internet problem");
      return Null;
    }
  }

  Future testSendDomainNum() async {
    //SendDomainNum
    int domainNum = 0x11;
    String sDomainNum;
    if (domainNum < 16) {
      sDomainNum = '0${domainNum.toRadixString(16)}';
    } else {
      sDomainNum = domainNum.toRadixString(16);
    }
    String comand = '30${sDomainNum}0600FF07';
    List<String> lint = [];

    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: comand);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int integerData = int.parse(stringList[i]);
        lint.add(integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print(" service = internet problem");
      return Null;
    }
  }

  Future testSendPreDefineNum() async {
    //sendPreDefineNum
    int domainNum = 0x11;
    String sDomainNum;
    if (domainNum < 16) {
      sDomainNum = '0${domainNum.toRadixString(16)}';
    } else {
      sDomainNum = domainNum.toRadixString(16);
    }
    String comand = '31' + sDomainNum + '06' + '00' + 'FF' + '09';
    List<String> lint = [];

    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: comand);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print(" service = internet problem");
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
    return num;
  }

  Future testSendSetNetId() async {
    // SendSetNetId
    String netID = "  ";
    String sNetId = hexPadding(int.parse(netID));
    String sDomainNum;

    List<String> lint = [];
    String command = '33' + '00' + '0A' + '00' + 'FF' + '88' + sNetId;
    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print(" service = internet problem");
      return Null;
    }
  }

  Future testSendSetNetNum() async {
    // SendSetNetId
    List<String> lint = [];
    String netNum = "  ";

    int sNetNum = int.parse(netNum);
    if (sNetNum < 16) {
      netNum = '0' + sNetNum.toRadixString(16);
    } else {
      netNum = sNetNum.toRadixString(16);
    }
    String command = '34' + netNum + '06' + '00' + 'FF' + '88';
    final Uri uri = Uri.parse("http://192.168.4.1");
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      var stringList = body.split(' ');
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int _integerData = int.parse(stringList[i]);
        lint.add(_integerData.toRadixString(16));
      }
      print(lint);
      return body;
    } catch (e) {
      print(" service = internet problem");
      return Null;
    }
  }
}
