import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';

class MeshAPI {
  final client = http.Client();
  final headers = {'Content-Type': 'application/text; charset=utf-8'};
  final DatabaseService _databaseService = DatabaseService();

  Future changeWifi() async {
    logger.w("message");
    //todo add problem response failure situation
    const subUrl = '/wifiSwitch';
    final Uri uri = Uri.parse('http://esp32.local/wifiSwitch');
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
      return body;
    } catch (e) {
      return Null;
    }
  }

  Future sendToMesh(pktHdr) async {
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
    final Uri uri = Uri.parse(ApiRoutes.esp32Url);

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

  Future meshE1() async {
    List<RpeNetwork> networks = await _databaseService.getAllNetworks();

    String command = "E1FF060001FA";
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
    RpeNetwork network;
    for (network in networks) {
      final Uri uri = Uri.parse(network.url);
      int length = 0;
      var stringList;
      try {
        final http.Response response =
            await client.post(uri, headers: headers, body: command);
        final body = response.body;
        stringList = body.split(' ');
      } catch (e) {
        continue;
      }
      stringList.removeLast();
      for (int i = 0; i < stringList.length; i++) {
        int integerData = int.parse(stringList[i]);
        lint.add(integerData.toRadixString(16));
      }

      if (kDebugMode) {
        print(lint);
        print("${lint[0]} command type E1");
        print("${lint[1]}  ${lint[2]} data Langht");
        print("${lint[3]} number of nodes ");
        print("${lint[4]}${lint[5]}${lint[6]}${lint[7]} rpe net id ");
        print("${lint[8]} domain type ");
        print("${lint[9]} preset domain ");
        print("${lint[10]} network number ");
        print("${lint[11]}${lint[12]}${lint[13]}${lint[14]} CR reported time");
        print("${lint[15]} reserved ");
      }
      length = int.parse("0x${lint[1]}${lint[2]}");

      int CR_Reported_Time = (int.parse(lint[12]) * 65536) +
          (int.parse(lint[13]) * 256) +
          int.parse(lint[14]);
      int hr = CR_Reported_Time ~/ 3600;
      int a = (CR_Reported_Time - (hr * 3600)) ~/ 60;
      int min = (CR_Reported_Time - (hr * 3600)) ~/ 60;
      int sec = CR_Reported_Time - (hr * 3600) - (min * 60);
      String _hr;
      String _min;
      String _sec;
      if (hr < 10) _hr = '0$hr';
      if (min < 10) _min = '0$min';
      if (sec < 10) _sec = '0$sec';

      RpeNetwork(
        numOfNodes: int.parse(lint[3]),
        domain: int.parse(lint[8]),
        netId: (int.parse(lint[12]) * 65536) +
            (int.parse(lint[13]) * 256) +
            int.parse(lint[14]),
        ipAddr: network.url,
      );

      _databaseService.clearAllDevice();
      int number ;
      for (int i = 16; i <= length - 1; i = i + 16) {
        number = (i/16).round();
        await _databaseService.insertDevice(
          Device(
              networkTableMAC: network.name,
              name: "device $number",
              nodeNumber: lint[i],
              nodeType: lint[i + 1],
              nodeSubType: lint[i + 2],
              location: lint[i + 3],
              stackType: lint[i + 4],
              numChild: lint[i + 5],
              status: lint[i + 6],
              parentNodeNum: lint[i + 7],
              image: 'assets/images/icons/air-quality-sensor.png',
              macAddress: lint[i + 8] +
                  lint[i + 9] +
                  lint[i + 10] +
                  lint[i + 11] +
                  lint[i + 12] +
                  lint[i + 13] +
                  lint[i + 14] +
                  lint[i + 15]),

        );
      }

      if (AppConstants.debug) {
        List list = await _databaseService.getAllDevices();
        String debugString = '';
        list.forEach((row) => print(row));
        // logger.i(debugString);
      }
    }
  }

  Future meshE3() async {
    List<RpeNetwork> networks = await _databaseService.getAllNetworks();
    String command = "E3FF060001FA";
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
    RpeNetwork network;
    for (network in networks) {
      int length = 0;

      try {
        final http.Response response = await client.post(Uri.parse(network.url),
            headers: headers, body: command);
        final body = response.body;
        var stringList = body.split(' ');
        stringList.removeLast();
        print(stringList);
        for (int i = 0; i < stringList.length; i++) {
          int _integerData = int.parse(stringList[i]);
          lint.add(_integerData.toRadixString(16));
        }
        // print(lint);

        // print(lint[0] + " command type E3");
        // print(lint[1] + lint[2] + "wifiPacketLen");
        // print(lint[3] +
        //     lint[4] +
        //     lint[5] +
        //     lint[6] +
        //     lint[7] +
        //     lint[8] +
        //     lint[9] +
        //     lint[10] +
        //     " present nodes");
        // print(lint[11] + lint[12] + lint[13] + lint[14] + " rpe Net id ");
        // print(lint[15] + " rpe net id ");

        length = int.parse("0x${lint[1]}${lint[2]}");
        // print(lint.length);
        // _databaseService.clearAllUploads();

        for (int i = 16; i <= length - 1; i = i + 14) {
          // await _databaseService.insertUpload(RpeUpload(
          //     dType: int.parse(lint[i + 1]),
          //     dSubType: int.parse(lint[i + 2]),
          //     dNum: lint[i + 3] as int,
          //     dStatus: lint[i + 4] as int,
          //     nodeMessageLen: lint[i + 5],
          //     timeStamp: lint[i + 6],
          //     uploadMessageType: lint[i + 7],
          //     messageSubType: lint[i + 8],
          //     sensorType: lint[i + 9],
          //     sensorValue: lint[i + 10]));
          //
          // break; //todo remove
        }

        List list = await _databaseService.getAllUploads();
        list.forEach((row) => print(row));
      } catch (e) {
        logger.e(e);
        return Null;
      }
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

  Future meshTime() async {
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
    final Uri uri = Uri.parse(ApiRoutes.esp32Url);

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

  Future sendDomainNum() async {
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

    final Uri uri = Uri.parse(ApiRoutes.esp32Url);
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

  Future sendPreDefineNum() async {
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

    final Uri uri = Uri.parse(ApiRoutes.esp32Url);
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

  Future sendSetNetId() async {
    // SendSetNetId
    String netID = "  ";
    String sNetId = hexPadding(int.parse(netID));
    String sDomainNum;

    List<String> lint = [];
    String command = '33' + '00' + '0A' + '00' + 'FF' + '88' + sNetId;
    final Uri uri = Uri.parse(ApiRoutes.esp32Url);
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

  Future sendSetNetNum() async {
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
    final Uri uri = Uri.parse(ApiRoutes.esp32Url);
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
