import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/widgets.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';

class ClusteringScreen extends StatefulWidget {
  @override
  State<ClusteringScreen> createState() => _ClusteringScreenState();
}

class _ClusteringScreenState extends State<ClusteringScreen> {
  final List<ActiveArea> _people = [
    ActiveArea(),
  ];
  final GlobalKey _draggableKey = GlobalKey();
  List<Widget> slideble = [];
  final fieldText = TextEditingController();

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
  List<String> clusters = <String>['New']; //todo change form DB
  List devices = [];
  List items = [];
  String newClusterName = "";

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    devices = meshNotifier.allDevices!;
    for (int i = 0; i < devices.length; i++) {
      if ((items.singleWhere((it) => it.macAddress == devices[i].macAddress,
              orElse: () => null)) ==
          null) {
        items.add(Item(
            name: devices[i].name,
            macAddress: devices[i].macAddress,
            imageProvider: AssetImage(devices[i].image)));
      }
    }
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
                    child: TextField(
                      controller: fieldText,
                      onChanged: (text) {
                        newClusterName = text;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Saved",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      fieldText.clear();
                      FocusScope.of(context).unfocus(); //hide kayboard
                      logger.i(_people[0].items.length);
                      List<String> clusterItems = [];
                      for (var item in _people[0].items) {
                        clusterItems.add(item.macAddress);
                      }
                      meshNotifier.insertCluster(
                          newClusterName, clusterItems.join(","));

                      Cluster(clusterName: newClusterName, devices: '');
                      setState(() {
                        newClusterName = '';
                      });
                    },
                    child: const Text("Save"),
                  ),
                ]),
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
            itemCount: items.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 12,
              );
            },
            itemBuilder: (context, index) {
              final item = items[index];
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
            return ManipulationCluster(
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
