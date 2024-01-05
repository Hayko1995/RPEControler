import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/widgets.dart';

class ClusteringScreen extends StatefulWidget {
  @override
  State<ClusteringScreen> createState() => _ClusteringScreenState();
}

class _ClusteringScreenState extends State<ClusteringScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final List<ActiveArea> _people = [
    ActiveArea(),
  ];
  final GlobalKey _draggableKey = GlobalKey();
  List<Widget> slideble = [];

  void _itemDroppedOnCustomerCart({
    required Item item,
    required ActiveArea customer,
  }) {
    setState(() {
      if (!customer.items.contains(item)) {
        customer.items.add(item);
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
    List<Device> devices = await _databaseService.getAllDevices();
    for (int i = 0; i < devices.length; i++) {
      items.add(
        Item(
            name: devices[i].name, imageProvider: AssetImage(devices[i].image)),
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
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.7,
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
    manipulationWidgets.add(
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
    );
    manipulationWidgets.addAll(_people.map(_buildPersonWithDropZone).toList());
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Column(
        children: manipulationWidgets,
      ),
    );
  }

  Widget _buildPersonWithDropZone(ActiveArea customer) {
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
