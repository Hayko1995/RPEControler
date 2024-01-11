import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/widgets.dart';

class AssosiationScreen extends StatefulWidget {
  @override
  State<AssosiationScreen> createState() => _AssosiationScreenState();
}

class _AssosiationScreenState extends State<AssosiationScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final List<ActiveArea> activeAreas = [
    ActiveArea(),
    ActiveArea(),
  ];
  final GlobalKey _draggableKey = GlobalKey();
  List<Widget> slideble = [];

  void _itemDroppedOnCustomerCart({
    required Item item,
    required ActiveArea customer,
  }) {
    print("item");

    setState(() {
      if (!customer.items.contains(item)) {
        customer.items.add(item);
        customer.size = customer.items.length * 150;
      }
    });
  }

  List<String> manipulatngType = <String>['Clustering', 'Associations'];
  List<String> sensorsType = <String>['All', 'Light', 'Buzzers'];
  List<String> clusters = <String>['New'];
  List dataDevices = [];
  List _items = [];
  List items = [];

  void _updateData() async {
    List<RpeDevice> devices = await _databaseService.getAllDevices();
    for (int i = 0; i < devices.length; i++) {
      items.add(
        Item(
            name: devices[i].name,
            macAddress: devices[i].macAddress,
            imageProvider: AssetImage(devices[i].image)),
      );
    }
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
    return _buildContent();
  }

  Widget _buildContent() {
    String dropdownValue = manipulatngType.first;
    return SingleChildScrollView(
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisSize: MainAxisSize.max, children: [
                  SizedBox(
                    height: 30,
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: const TextField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text("Save"),
                  ),
                ]),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.82,
                  child: Row(
                    children: [
                      _buildManipulationListRow(),
                      Expanded(
                        child: _buildDeviceList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    String dropdownValue = sensorsType.first;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<String>(
              initialSelection: sensorsType.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  print(1);
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  sensorsType.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
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
          ),
        ),
      ],
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

  Widget _buildManipulationListRow() {
    String dropdownValue = clusters.first;
    List<Widget> manipulationWidgets = [];
    // manipulationWidgets.add();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu<String>(
              initialSelection: clusters.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  clusters.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            Text("From"),
            SizedBox(
                height: (activeAreas[0].size / 1),
                child: _buildPersonWithDropZone(activeAreas[0])),
            const SizedBox(
              height: 20,
            ),
            Text("TO"),
            SizedBox(
                height: (activeAreas[1].size / 1),
                child: _buildPersonWithDropZone(activeAreas[1]))
          ],
        ),
      ),
    );
  }

  Widget _buildPersonWithDropZone(ActiveArea customer) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: DragTarget<Item>(
        builder: (context, candidateItems, rejectedItems) {
          return ManipulationAssociations(
            hasItems: customer.items.isNotEmpty,
            highlighted: candidateItems.isNotEmpty,
            customer: customer,
            function: methodInParent,
          );
        },
        onAccept: (item) {
          _itemDroppedOnCustomerCart(
            item: item,
            customer: customer,
          );
        },
      ),
    );
  }

  methodInParent() => setState(() {
        print("state");
      });
}
