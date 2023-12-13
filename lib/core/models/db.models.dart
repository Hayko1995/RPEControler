import 'dart:convert';

class Device {
  final String nodeNumber;
  final String nodeType;
  final String nodeSubType;
  final String location;
  final String stackType;
  final String numChild;
  final String status;
  final String parentNodeNum;
  final String macAddress;
  final String name;
  final String networkTableMAC;

  Device(
      {required this.nodeNumber,
      required this.nodeType,
      required this.nodeSubType,
      required this.location,
      required this.stackType,
      required this.numChild,
      required this.status,
      required this.parentNodeNum,
      required this.macAddress,
      required this.name,
      required this.networkTableMAC});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'nodeNumber': nodeNumber,
      'nodeType': nodeType,
      'nodeSubType': nodeSubType,
      'location': location,
      'stackType': stackType,
      'numChild': numChild,
      'status': status,
      'parentNodeNum': parentNodeNum,
      'macAddress': macAddress,
      'name': name,
      'networkTableMAC': networkTableMAC
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
        nodeNumber: map['nodeNumber'] ?? "",
        nodeType: map['nodeType'] ?? "",
        nodeSubType: map['nodeSubType'] ?? "",
        location: map['location'] ?? "",
        stackType: map['stackType'] ?? "",
        numChild: map['numChild'] ?? "",
        status: map['status'] ?? "",
        parentNodeNum: map['parentNodeNum'] ?? "",
        macAddress: map['macAddress'] ?? "",
        name: map['name'] ?? "",
        networkTableMAC: map['networkTableMAC'] ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => '''Device(nodeNumber: $nodeNumber, groups: $nodeType,  
         nodeSubType: $nodeSubType,  location: $location,
         stackType $stackType, numChild $numChild,
         status $status, parentNodeNum $parentNodeNum, macAddress $macAddress,
         name $name, networkTableMAC $networkTableMAC )''';
}

class Upload {
  final String nodeType;
  final String nodeSubType;
  final String nodeNumber;
  final String nodeStatus;
  final String nodeMessageLen;
  final String timeStamp;
  final String uploadMessageType;
  final String messageSubType;
  final String sensorType;
  final String sensorValue;

  Upload(
      {required this.nodeType,
      required this.nodeSubType,
      required this.nodeNumber,
      required this.nodeStatus,
      required this.nodeMessageLen,
      required this.timeStamp,
      required this.uploadMessageType,
      required this.messageSubType,
      required this.sensorType,
      required this.sensorValue});

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'nodeType': nodeType,
      'nodeSubType': nodeSubType,
      'nodeNumber': nodeNumber,
      'nodeStatus': nodeStatus,
      'nodeMessageLen': nodeMessageLen,
      'timeStamp': timeStamp,
      'uploadMessageType': uploadMessageType,
      'messageSubType': messageSubType,
      'sensorType': sensorType,
      'sensorValue': sensorValue,
    };
  }

  factory Upload.fromMap(Map<String, dynamic> map) {
    return Upload(
      nodeType: map['nodeType'] ?? "",
      nodeSubType: map['nodeSubType'] ?? "",
      nodeNumber: map['nodeNumber'] ?? "",
      nodeStatus: map['nodeStatus'] ?? "",
      nodeMessageLen: map['nodeMessageLen'] ?? "",
      timeStamp: map['timeStamp'] ?? "",
      uploadMessageType: map['uploadMessageType'] ?? "",
      messageSubType: map['messageSubType'] ?? "",
      sensorType: map['sensorType'] ?? "",
      sensorValue: map['sensorValue'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Upload.fromJson(String source) => Upload.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      '''Update(nodeNumber: $nodeType, nodeSubType: $nodeSubType, 
        nodeNumber: $nodeNumber,  nodeMessageLen: $nodeStatus, nodeMessageLen 
        $nodeMessageLen, timeStamp $timeStamp, uploadMessageType 
        $uploadMessageType, messageSubType $messageSubType,
        sensorType $sensorType, sensorValue $sensorValue )''';
}

class Network {
  final String mac;
  final String ip;

  Network({
    required this.mac,
    required this.ip,
  });

  // Convert a Breed into a Map. The keys must correspond to the nodeNumbers of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'mac': mac,
      'val': ip,
    };
  }

  factory Network.fromMap(Map<String, dynamic> map) {
    return Network(
      mac: map['mac'] ?? "",
      ip: map['val'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Network.fromJson(String source) =>
      Network.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => '''Network(name: $mac, val: $ip,''';
}
