import 'package:flutter/material.dart';

class Item {
  const Item({
    required this.name,
    required this.imageProvider,
  });

  final String name;

  final ImageProvider imageProvider;
}

class Customer {
  Customer({
    List<Item>? items,
  }) : items = items ?? [];

  final List<Item> items;
}