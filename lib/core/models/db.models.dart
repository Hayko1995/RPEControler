import 'dart:convert';

class CR {
  final int? id;
  final int nodeNumber;
  final int nodeType;
  final int nodeSubType;
  final String location;
  final int stackType;
  final int numChild;
  final int status;
  final int parentNodeNum;
  final String macAddress;

  CR({
    this.id,
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
      'id': id,
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

  factory CR.fromMap(Map<String, dynamic> map) {
    return CR(
      id: map['id']?.toInt() ?? 0,
      nodeNumber: map['nodeNumber'] ?? 0,
      nodeType: map['nodeType'] ?? 0,
      nodeSubType: map['nodeSubType'] ?? 0,
      location: map['location'] ?? "",
      stackType: map['stackType'] ?? 0,
      numChild: map['numChild'] ?? 0,
      status: map['status'] ?? 0,
      parentNodeNum: map['parentNodeNum'] ?? 0,
      macAddress: map['macAddress'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CR.fromJson(String source) => CR.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'CR(id: $id, nodeNumber: $nodeNumber, groups: $nodeType,  mac: $nodeSubType,  description: $location, positionX $stackType, positionY $numChild, status $status, parentNodeNum $parentNodeNum, macAddress $macAddress )';
}
