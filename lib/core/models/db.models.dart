import 'dart:convert';

class device {
  final String nodeNumber;
  final String nodeType;
  final String nodeSubType;
  final String location;
  final String stackType;
  final String numChild;
  final String status;
  final String parentNodeNum;
  final String macAddress;

  device({
    required this.nodeNumber,
    required this.nodeType,
    required this.nodeSubType,
    required this.location,
    required this.stackType,
    required this.numChild,
    required this.status,
    required this.parentNodeNum,
    required this.macAddress,
  });

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
    };
  }

  factory device.fromMap(Map<String, dynamic> map) {
    return device(
      nodeNumber: map['nodeNumber'] ?? "",
      nodeType: map['nodeType'] ?? "",
      nodeSubType: map['nodeSubType'] ?? "",
      location: map['location'] ?? "",
      stackType: map['stackType'] ?? "",
      numChild: map['numChild'] ?? "",
      status: map['status'] ?? "",
      parentNodeNum: map['parentNodeNum'] ?? "",
      macAddress: map['macAddress'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory device.fromJson(String source) => device.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'Device(nodeNumber: $nodeNumber, groups: $nodeType,  nodeSubType: $nodeSubType,  location: $location, stackType $stackType, numChild $numChild, status $status, parentNodeNum $parentNodeNum, macAddress $macAddress )';
}
