import 'package:flutter/material.dart';

class Item {
  const Item({
    required this.name,
    required this.macAddress,
    required this.imageProvider,
  });

  final String name;
  final String macAddress;
  final ImageProvider imageProvider;
}

class ActiveArea {
  ActiveArea({
    List<Item>? items,
  }) : items = items ?? [];

  final List<Item> items;
  late int size = 150;
}
