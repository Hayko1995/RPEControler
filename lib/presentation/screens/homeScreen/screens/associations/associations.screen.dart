//TODO fix designer responsive when kayboard come out
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.accociation.dart';
import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/associationControlScreen/associationControl.screen.dart';

class AssociationsScreen extends StatefulWidget {
  const AssociationsScreen({super.key});

  @override
  AssociationsScreenState createState() => AssociationsScreenState();
}

Widget widget(context, association, widgetKey) {
  final Function(bool?) toggleCheckboxState;
  final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
  return GestureDetector(
    key: widgetKey,
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRouter.associationControlRouter,
        arguments: AssociationControlArgs(association: association),
      );
    },
    onLongPress: () {
      showMenu(
        items: <PopupMenuEntry>[
          PopupMenuItem(
            //value: this._index,
            child: Column(
              children: [
                InkWell(
                  child: const Text("Delete"),
                  onTap: () {
                    MeshAssociation meshAssociation = MeshAssociation();
                    // print(cluster);
                    // Cluster(clusterName: ClusterId 1,  aa, devices: 00158D0000506820,00158D0000506830,00158D000050683B,
                    String associationId = association.associationId.toString();
                    if (associationId.length < 2) {
                      associationId = '0$associationId';
                    }
                    String command = meshAssociation.sendDeleteAssociation(
                        association.netNumber, associationId);
                    // bool response =
                    //     meshNotifier.sendCommand(command, association.netNumber);
                    bool response = false;
                    if (response) {
                      meshNotifier.deleteAssociation(association.associationId);
                    }
                    Navigator.pop(context);
                  },
                ),
                InkWell(
                  child: association.status == 1
                      ? Text("Disable")
                      : Text("Enabled"),
                  onTap: () async {
                    MeshCluster meshCluster = MeshCluster();
                    // print(cluster);
                    // Cluster(clusterName: ClusterId 1,  aa, devices: 00158D0000506820,00158D0000506830,00158D000050683B,
                    String clusterId = association.associationId.toString();
                    if (clusterId.length < 2) {
                      clusterId = '0$clusterId';
                    }
                    String command = '';
                    if (association.status == 1) {
                      command = meshCluster.sendDisableCluster(
                          association.netNumber, clusterId);
                      bool response = await meshNotifier.sendCommand(
                          command, association.netNumber);
                      if (response) {
                        meshNotifier.disableCluster(association.clusterId);
                      }
                    }
                    if (association.status == 0) {
                      command = meshCluster.sendEnableCluster(
                          association.netNumber, clusterId);
                      bool response = await meshNotifier.sendCommand(
                          command, association.netNumber);
                      if (response) {
                        meshNotifier.enableCluster(association.associationId);
                      }
                    }
                    Navigator.pop(context);
                  },
                )
                // OutlinedButton(onPressed: buttonCall, child: Text("data"))
              ],
            ),
          )
        ],
        context: context,
        position: _getRelativeRect(widgetKey),
      );
    },
    child: Container(
      decoration: BoxDecoration(
          color: association.status == 1 ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Center(child: Text(association.associationName)),
    ),
  );
}

class AssociationsScreenState extends State<AssociationsScreen> {
  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);

  double _page = 0;
  bool openDelete = false;
  bool openDisable = false;
  bool openEnable = false;
  bool setThreshold = false;
  bool openThreshold = false;
  bool openSetTimer = false;

  List networkIds = [];

  Color caughtColor = Colors.grey;

  List<String> data = [];
  String dropdownValue = '';

  @override
  void initState() {
    _pageController.addListener(() {
      if (_pageController.page != null) {
        _page = _pageController.page!;

        setState(() {});
      }
    });
    // final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    // ReadCache.getString(key: AppKeys.userData).then(
    //   (token) => {
    //     userNotifier.getUserData(context: context, token: token),
    //   },
    // );
    super.initState();
  }

  List getAssociationsNetworks(associations) {
    networkIds = [];
    for (Association association in associations) {
      bool res = networkIds.contains(association.netNumber);
      if (!res) {
        networkIds.add(association.netNumber);
      }
    }

    if (networkIds.length == 0) {
      networkIds.add("None");
    }

    return networkIds;
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    networkIds = getAssociationsNetworks(meshNotifier.getAllAssociations);

    dropdownValue = networkIds.first;

    List<Widget> getAssociations() {
      List<Widget> sensorList = [];
      List<Association> data = meshNotifier.getAllAssociations!;

      for (var i = 0; i < data.length; i++) {
        sensorList.add(widget(context, data.elementAt(i), GlobalKey()));

        // sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
      }
      logger.i(sensorList.length);

      return sensorList;
    }

    Future<void> deleteAll() async {
      MeshAssociation meshAssociation = MeshAssociation();
      String command = meshAssociation.sendDeleteAllAssociations(dropdownValue);
      bool result = await meshNotifier.sendCommand(command, dropdownValue);
      if (result) {
        meshNotifier.deleteClusterViaNetId(dropdownValue);
      }
    }

    Future<void> enableAll() async {
      //todo Ask to Harry
      // MeshCluster meshCluster = MeshCluster();
      // String command = meshCluster.sendDeleteAllCluster(dropdownValue);
      // bool result = await meshNotifier.sendCommand(command, dropdownValue);
      // if (result) {
      //   meshNotifier.deleteClusterViaNetId(dropdownValue);
      // }
    }

    Future<void> disableAll() async {
      //todo Ask to Harry
      MeshCluster meshCluster = MeshCluster();
      // String command = meshCluster.sendDeleteAllCluster(dropdownValue);
      // bool result = await meshNotifier.sendCommand(command, dropdownValue);
      // if (result) {
      //   // meshNotifier.deleteClusterViaNetId(dropdownValue);
      // }
    }

    void deleteAllView() {
      openDelete = !openDelete;
      if (openDelete) {
        openDisable = false;
        openEnable = false;
        openThreshold = false;
        openSetTimer = false;
      }
      setState(() {});
    }

    void disableAllView() {
      openDisable = !openDisable;
      if (openDisable) {
        openDelete = false;
        openEnable = false;
        openThreshold = false;
        openSetTimer = false;
      }
      setState(() {});
    }

    void enableAllView() {
      openEnable = !openEnable;
      if (openEnable) {
        openDelete = false;
        openDisable = false;
        openThreshold = false;
        openSetTimer = false;
      }
      setState(() {});
    }

    void setThreshold() {
      openThreshold = !openThreshold;
      if (openThreshold) {
        openEnable = false;
        openDelete = false;
        openDisable = false;
        openSetTimer = false;
      }
      setState(() {});
    }

    void setTimer() {
      openSetTimer = !openSetTimer;
      if (openThreshold) {
        openEnable = false;
        openDelete = false;
        openDisable = false;
        openThreshold = false;
      }
      setState(() {});
    }

    void syncAll() {
      setState(() {});
    }

    List<Widget> getControl() {
      List<Widget> controlPage = [];
      if (openDelete) {
        controlPage = [];
        controlPage.add(Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu<String>(
                  initialSelection: networkIds.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      networkIds.map<DropdownMenuEntry<String>>((value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                OutlinedButton(
                    onPressed: deleteAll, child: const Text("Delete All")),
              ],
            )
          ],
        ));
      }
      if (openEnable) {
        controlPage = [];
        controlPage.add(Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu<String>(
                  initialSelection: networkIds.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      networkIds.map<DropdownMenuEntry<String>>((value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                OutlinedButton(
                    onPressed: enableAll, child: const Text("Enable All")),
              ],
            )
          ],
        ));
      }
      if (openDisable) {
        controlPage = [];
        controlPage.add(Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu<String>(
                  initialSelection: networkIds.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      networkIds.map<DropdownMenuEntry<String>>((value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                OutlinedButton(
                    onPressed: disableAll, child: const Text("Disable All")),
              ],
            )
          ],
        ));
      }
      return controlPage;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: deleteAllView, child: Text("Delete All")),
                OutlinedButton(
                    onPressed: disableAllView, child: Text("Disable All")),
                OutlinedButton(
                    onPressed: enableAllView, child: Text("Enable All")),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: syncAll, child: Text("Sync All")),
              ],
            ),
            Row(
              children: getControl(),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GridView.count(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    crossAxisCount: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: getAssociations()))
          ],
        ),
      ),
    );
  }
}

RelativeRect _getRelativeRect(GlobalKey key) {
  return RelativeRect.fromSize(_getWidgetGlobalRect(key), const Size(200, 200));
}

Rect _getWidgetGlobalRect(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  debugPrint('Widget position: ${offset.dx} ${offset.dy}');
  return Rect.fromLTWH(offset.dx / 3.1, offset.dy * 1.05, renderBox.size.width,
      renderBox.size.height);
}
