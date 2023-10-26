class MeshModel {
  MeshModel({
    required this.received,
    required this.data,
  });
  late final bool received;
  late final MeshData data;

  MeshModel.fromJson(Map<String, dynamic> json) {
    received = json['received'];
    data = MeshData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['received'] = received;
    _data['data'] = data.toJson();
    return _data;
  }
}

class MeshData {
  MeshData({
    required this.id,
    required this.temperature,
  });
  late final int? id;
  late final int? temperature;

  MeshData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['temperature'] = temperature;
    return _data;
  }
}
