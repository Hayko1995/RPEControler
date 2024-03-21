import 'package:flutter/material.dart';

class Item {
  const Item({
    required this.name,
    required this.nodeNumber,
    required this.netId,
    required this.macAddress,
    required this.nodeType,
    required this.imageProvider,
  });

  final String name;
  final String nodeNumber;
  final String netId;
  final String nodeType;
  final String macAddress;
  final ImageProvider imageProvider;
}

class ActiveArea {
  ActiveArea({
    List<Item>? items,
  }) : items = items ?? [];

  late List<Item> items;
  late int size = 150;
}
