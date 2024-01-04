import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/widgets.dart';

class ManipulationScreen extends StatefulWidget {
  final ManipulationsArgs manipulationsArgs;

  const ManipulationScreen({super.key, required this.manipulationsArgs});

  @override
  State<ManipulationScreen> createState() => _ManipulationScreenState();
}

class _ManipulationScreenState extends State<ManipulationScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final List<Customer> _people = [
    Customer(),
  ];
  final GlobalKey _draggableKey = GlobalKey();
  List<Widget> slideble = [];

  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      // if (!customer.items.contains(item) ) {
        customer.items.add(item);
      // }
    });
  }

  List<String> list = <String>['Clustering', 'Associations'];
  List dataDevices = [];
  List _items = [];
  List items = [];

  void _updateData() async {
    List<Device> devices = await _databaseService.getAllDevices();
    for (int i = 0; i < devices.length; i++) {
      items.add(
        Item(
            name: devices[i].name, imageProvider: AssetImage(devices[i].image)),
      );
    }

    // TODO write logic for Widget
    if (mounted) {
      setState(() {
        _items = items;
      });
    }
  }

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < devices.length; i++) {}

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Manipulation Page',
      ),
    );
  }

  Widget _buildContent() {
    String dropdownValue = list.first;
    return Stack(
      children: [
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownMenu<String>(
                      initialSelection: list.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      dropdownMenuEntries:
                          list.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: Text("Save"),
                    ),
                  ]),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Row(
                  children: [
                    _buildPeopleRow(),
                    Expanded(
                      child: _buildMenuList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        photoProvider: item.imageProvider,
      ),
      child: DeviceListItem(
        name: item.name,
        photoProvider: item.imageProvider,
      ),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Column(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItems, rejectedItems) {
            return ManipulationList(
              hasItems: customer.items.isNotEmpty,
              highlighted: candidateItems.isNotEmpty,
              customer: customer,
            );
          },
          onAccept: (item) {
            _itemDroppedOnCustomerCart(
              item: item,
              customer: customer,
            );
          },
        ),
      ),
    );
  }
}

class ManipulationsArgs {
  final int preDef;

  const ManipulationsArgs({required this.preDef});
}
