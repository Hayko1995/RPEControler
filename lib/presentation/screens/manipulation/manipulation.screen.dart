import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/manipulation/screens/assosiation.screen.dart';
import 'package:rpe_c/presentation/screens/manipulation/screens/clustering.screen.dart';
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
      if (!customer.items.contains(item)) {
        customer.items.add(item);
      }
    });
  }

  List<String> manipulationType = <String>['Clustering', 'Associations'];
  List<String> sensorsType = <String>['All', 'Light', 'Buzzers'];
  List dataDevices = [];
  List _items = [];
  List items = [];
  String dropdownValue = "";

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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
          title: const Text(
        'Manipulation Page',
      )),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {

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
                      initialSelection: manipulationType.first,
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;

                        });
                      },
                      dropdownMenuEntries: manipulationType
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Text("Save"),
                    ),
                  ]),
              SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  child: (dropdownValue == "Clustering")
                      ? ClusteringScreen()
                      : AssosiationScreen()),
            ],
          ),
        ),
      ],
    );
  }
}

class ManipulationsArgs {
  final int preDef;

  const ManipulationsArgs({required this.preDef});
}
