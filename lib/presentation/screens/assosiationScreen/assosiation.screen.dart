import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/widgets.dart';

class AssociationScreen extends StatefulWidget {
  final AssociationArgs associationArguments;

  const AssociationScreen({super.key, required this.associationArguments});

  @override
  State<AssociationScreen> createState() => AssociationScreenState();
}

class AssociationScreenState extends State<AssociationScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final List<ActiveArea> activeAreas = [
    ActiveArea(),
    ActiveArea(),
  ];
  final GlobalKey _draggableKey = GlobalKey();
  List<Widget> slideble = [];
  final fieldText = TextEditingController();
  String newAssociationName = '';

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
    List<RpeDevice> devices =
        await _databaseService.getAllDevices(); //TODO change
    for (int i = 0; i < devices.length; i++) {
      items.add(
        Item(
            name: devices[i].name,
            netId: devices[i].netId,
            nodeType: devices[i].nodeType,
            nodeNumber: devices[i].nodeNumber,
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
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
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
                        newAssociationName = text;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () async {
                      fieldText.clear();
                      List<String> fromAssItems = [];
                      List<String> toAssItems = [];
                      String fromAssociationNodes = '';
                      String toAssociationNodes = '';
                      for (var item in activeAreas[0].items) {
                        fromAssItems.add(item.macAddress);
                        fromAssociationNodes =
                            fromAssociationNodes + item.nodeNumber;
                      }
                      for (var item in activeAreas[0].items) {
                        toAssItems.add(item.macAddress);
                        toAssociationNodes =
                            toAssociationNodes + item.nodeNumber;
                      }
                      String netNumber = activeAreas[0].items[0].netId;

                      bool singleNet = true;
                      List<Association> allAssociations =
                          meshNotifier.getAllAssociations!;
                      int _associationId = 0;
                      if (allAssociations.isEmpty) {
                        _associationId = 0;
                      } else {
                        _associationId = allAssociations.last.associationId;
                      }
                      _associationId = _associationId + 1;
                      String associationId = '';
                      if (_associationId > 9) {
                        associationId = _associationId.toString();
                      } else {
                        associationId = '0$_associationId';
                      }
                      // todo add command
                      // meshNotifier.sendClusterCommand(
                      //     singleNet,
                      //     activeAreas[0].items[0].netId,
                      //     associationId,
                      //     fromAssociationNodes);

                      meshNotifier.insertAssociation(
                          _associationId,
                          newAssociationName,
                          '00',
                          //todo change
                          netNumber,
                          fromAssItems.join(","),
                          toAssItems.join(","),
                          1);

                      for (var item in activeAreas[0].items) {
                        RpeDevice _dev =
                            meshNotifier.getDeviceByMac(item.macAddress);
                        List assosciationNames =
                            jsonDecode(_dev.associations)['associations'];
                        assosciationNames.add(newAssociationName);

                        Map<String, dynamic> _json = {
                          'associations': assosciationNames,
                        };
                        _dev.associations = jsonEncode(_json);
                        meshNotifier.updateDevice(_dev);
                      }

                      for (var item in activeAreas[1].items) {
                        RpeDevice _dev =
                            meshNotifier.getDeviceByMac(item.macAddress);
                        List assosciationNames =
                            jsonDecode(_dev.associations)['associations'];
                        assosciationNames.add(newAssociationName);

                        Map<String, dynamic> _json = {
                          'associations': assosciationNames,
                        };
                        _dev.associations = jsonEncode(_json);
                        meshNotifier.updateDevice(_dev);
                      }

                      RpeDevice dataDevice = meshNotifier
                          .getDeviceByMac(activeAreas[0].items[0].macAddress);

                      String _url = await meshNotifier
                          .getNetworkUrlByNetId(dataDevice.netId);
                      RpeNetwork network = meshNotifier.getNetworkByUrl(_url);
                      var networkTimers = jsonDecode(network.associations);
                      var networkTimersArr = networkTimers['associations'];
                      networkTimersArr.add(newAssociationName);
                      networkTimers['associations'] = networkTimersArr;
                      network.associations = jsonEncode(networkTimers);
                      meshNotifier.updateNetwork(network);

                      setState(() {
                        newAssociationName = '';
                        activeAreas[0].items = [];
                        activeAreas[1].items = [];
                      });
                    },
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
            const Text("From"),
            SizedBox(
                height: (activeAreas[0].size / 1),
                child: _buildPersonWithDropZone(activeAreas[0])),
            const SizedBox(
              height: 20,
            ),
            const Text("TO"),
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
        logger.i("state");
      });
}

class AssociationArgs {
  final Cluster? cluster; //todo need to create associations

  const AssociationArgs({this.cluster});
}
