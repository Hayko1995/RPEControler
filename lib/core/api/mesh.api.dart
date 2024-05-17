import 'package:http/http.dart' as http;
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:rpe_c/app/routes/api.routes.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';

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

  Future createCluster(
      singleNet, netNumber, clusterId, String clusterNodes, url) async {
    String command = "";
    //todo add problem response failure situation
    // if (singleNet) {
    // String singleNetCommand = "01";
    // command = '9100';
    //
    String clusterType = "00"; // need to understand
    String clusterStatus = "00"; //?
    String multiClusterId = "00"; //?
    MeshCluster meshCluster = MeshCluster();
    command = meshCluster.sendSetSingleNetCluster(netNumber, clusterId,
        clusterType, clusterStatus, multiClusterId, clusterNodes);
    logger.i(command);
    // }

    final Uri uri = Uri.parse(url);
    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      logger.w(body);
      return body;
    } catch (e) {
      return Null;
    }
  }

  Future sendActivationCommand(command, url) async {
    try {
      final Uri uri = Uri.parse(url);
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      //todo add response analizing function
      // logger.i(body);
    } catch (e) {
      logger.e("command is faled");
    }
  }

  Future sendToMeshDebug(command, url) async {
    final Uri uri = Uri.parse(url);

    try {
      final http.Response response =
      await client.post(uri, headers: headers, body: command);
      final body = response.body;
      return body; // todo change
      if (body == "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(" service = internet problem");
      return Null;
    }
  }
  Future sendToMesh(command, url) async {
    final Uri uri = Uri.parse(url);

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: command);
      final body = response.body;
      return true; // todo change
      if (body == "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(" service = internet problem");
      return Null;
    }
  }

  Future meshE1() async {
    //todo Remove from API and move to provider
    List<RpeNetwork> networks = await _databaseService.getAllNetworks();
    String netId = '';

    String command = "E1FF060001FA";
    List<String> lint = [];
    late http.Response response;
    RpeNetwork network;
    for (network in networks) {
      final Uri uri = Uri.parse(network.url);

      int length = 0;
      try {
        response = await client.post(uri, headers: headers, body: command);
        var body = response.body;
        for (int i = 0; i < body.length; i = i + 2) {
          lint.add(body.substring(i, i + 2));
        }
      } catch (e) {
        logger.e(e);
        continue;
      }

      if (response.body.length < 2) {
        continue;
      }

      String netNum = lint[10];
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
      netId = lint[10];

      network.numOfNodes = int.parse(lint[3]);
      network.domain = int.parse("0x${lint[8]}");
      network.preSetDomain = lint[9];
      network.netId = netId;
      network.nTim = (int.parse(lint[12]) * 65536) +
          (int.parse(lint[13]) * 256) +
          int.parse(lint[14]);
      network.ipAddr = network.url;
      await _databaseService.updateNetwork(network);

      int number;

      for (int i = 32; i <= length - 16; i = i + 16) {
        number = (i / 16).round();
        RpeDevice device = RpeDevice();
        device.dNetNum = netNum;
        device.networkTableMAC = network.name;
        device.name = "device $number";
        device.nodeNumber = lint[i];
        device.nodeType = lint[i + 1];
        device.nodeSubType = lint[i + 2];
        device.location = lint[i + 3];
        device.stackType = lint[i + 4];
        device.numChild = lint[i + 5];
        device.status = lint[i + 6];
        device.parentNodeNum = lint[i + 7];
        device.isActivation = 1; // add
        device.image = AppConstants.images["00"];
        device.netId = netId;
        if (AppConstants.images.containsKey(lint[i + 1])) {
          device.image = AppConstants.images[lint[i + 1]];
        }

        if (AppConstants.buttonActivators.contains(device.nodeType)) {
          device.deviceType = 0;
        }
        if (AppConstants.dimmerActivators.contains(device.nodeType)) {
          device.deviceType = 1;
        }
        if (AppConstants.buttonSensor.contains(device.nodeType)) {
          device.deviceType = 2;
        }
        if (AppConstants.dimmerSensor.contains(device.nodeType)) {
          device.deviceType = 3;
        }
        if (device.deviceType == 5) {
          device.deviceType = 4;
        }

        device.macAddress = lint[i + 8] +
            lint[i + 9] +
            lint[i + 10] +
            lint[i + 11] +
            lint[i + 12] +
            lint[i + 13] +
            lint[i + 14] +
            lint[i + 15];

        await _databaseService.insertDevice(device);
        // }
      }
    }
  }

  Future meshE3() async {
    //todo need to understand response size
    List<RpeNetwork> networks = await _databaseService.getAllNetworks();
    String command = "E3FF060001FA";
    List<String> lint = [];
    RpeNetwork network;
    // await sendMail();
    for (network in networks) {
      int length = 0;
      try {
        final http.Response response = await client.post(Uri.parse(network.url),
            headers: headers, body: command);
        final body = response.body;
        logger.i(body);
        for (int i = 0; i < body.length; i = i + 2) {
          lint.add(body.substring(i, i + 2));
        }
        if (response.body.length < 2) {
          continue;
        }
        length = int.parse("0x${lint[6]}");

        for (int i = 0; i < length - 1; i = i + 15) {
          String command = lint[i];

          String nodeType = lint[i + 1];
          String nodeSubType = lint[i + 2];
          String nodeNum = lint[i + 3];
          String netNum = lint[i + 4];
          String nodeStatus = lint[i + 5];
          String nodeMsglen =
              lint[i + 6]; //todo need to understand and integrate
          String nodeTimeStamp = lint[i + 7] + //todo need to convert to time
              lint[i + 8] +
              lint[i + 9] +
              lint[i + 10];
          String uploadmsgType = lint[i + 11]; //todo understand
          String messegeSubType = lint[i + 12]; //
          int sensorType = int.parse(lint[i + 13]);

          int sensorVal = int.parse("0x${lint[i + 14]}${lint[i + 15]}");

          RpeDevice device = await _databaseService.getDevicesByNodeNumType(
              nodeType, nodeSubType, nodeNum);

          List<String> sensorVals = device.sensorVal.split(',');
          sensorVals[sensorType] = sensorVal.toString();
          device.sensorVal = sensorVals.join(',');

          device.status = nodeStatus;
          await _databaseService.updateDevice(device);
        }
      } catch (e, stacktrace) {
        logger.e(stacktrace);
        return Null;
      }
    }
  }

  static String hexPadding(num) {
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

    List<RpeNetwork> networks = await _databaseService.getAllNetworks();
    String netId = '';
    late Uri uri;
    late http.Response response;
    RpeNetwork network;
    for (network in networks) {
      uri = Uri.parse(network.url);
    }

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
    // final Uri uri = Uri.parse(ApiRoutes.esp32Url);

    try {
      final http.Response response =
          await client.post(uri, headers: headers, body: timePkt);
      // final body = response.body;
      // var stringList = body.split(' ');
      // stringList.removeLast();
      // for (int i = 0; i < stringList.length; i++) {
      //   int integerData = int.parse(stringList[i]);
      //   lint.add(integerData.toRadixString(16));
      // }

      // return body;
    } catch (e) {

      logger.e('internet problem');
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
      return body;
    } catch (e) {
      logger.i(" service = internet problem");
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

      return body;
    } catch (e) {
      logger.e(" service = internet problem");
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

      return body;
    } catch (e) {
      logger.e(" service = internet problem");
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

      return body;
    } catch (e) {
      logger.e(" service = internet problem");
      return Null;
    }
  }
}
