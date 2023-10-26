import 'dart:convert';
import 'dart:ffi';

class LightSensors {
  final int? id;
  final String name;
  final String mac;
  final int groups;
  final String description;
  final double positionX;
  final double positionY;

  LightSensors({
    this.id,
    required this.name,
    required this.mac,
    required this.groups,
    required this.description,
    required this.positionX,
    required this.positionY,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groups': groups,
      'description': description,
      'positionX': positionX,
      'positionY': positionY
    };
  }

  factory LightSensors.fromMap(Map<String, dynamic> map) {
    return LightSensors(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      mac: map['mac'] ?? '',
      groups: map['groups'] ?? '',
      description: map['description'] ?? '',
      positionX: map['positionX'] ?? Null,
      positionY: map['positionY'] ?? Null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LightSensors.fromJson(String source) =>
      LightSensors.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'LightSensor(id: $id, name: $name, groups: $groups,  mac: $mac,  description: $description, positionX $positionX, positionY $positionY )';
}
