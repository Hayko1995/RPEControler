//TODO fix designer responsive when kayboard come out
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/clusterControlScreen/clusterControl.screen.dart';

class ClustersScreen extends StatefulWidget {
  const ClustersScreen({super.key});

  @override
  ClustersScreenState createState() => ClustersScreenState();
}

Widget widget(context, cluster, widgetKey) {
  final Function(bool?) toggleCheckboxState;
  final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);

  return GestureDetector(
    key: widgetKey,
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRouter.clusterControlRouter,
        arguments: ClusterControlArgs(cluster: cluster),
      );
    },
    onLongPress: () {
      showMenu(
        items: <PopupMenuEntry>[
          PopupMenuItem(
            //value: this._index,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: InkWell(
                    child: Row(
                      children: [
                        const Text("Delete"),
                      ],
                    ),
                    onTap: () async {
                      MeshCluster meshCluster = MeshCluster();
                      // print(cluster);
                      // Cluster(clusterName: ClusterId 1,  aa, devices: 00158D0000506820,00158D0000506830,00158D000050683B,
                      String clusterId = cluster.clusterId.toString();
                      if (clusterId.length < 2) {
                        clusterId = '0$clusterId';
                      }
                      String command = meshCluster.sendDeleteCluster(
                          cluster.netNumber, clusterId);
                      bool response = await meshNotifier.sendCommand(
                          command, cluster.netNumber);
                      if (response) {
                        meshNotifier.deleteCluster(cluster.clusterId);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: InkWell(
                    child: cluster.status == 1
                        ? Row(
                            children: [
                              Text("Disable"),
                            ],
                          )
                        : Row(
                            children: [
                              Text("Enabled"),
                            ],
                          ),
                    onTap: () async {
                      MeshCluster meshCluster = MeshCluster();
                      // print(cluster);
                      // Cluster(clusterName: ClusterId 1,  aa, devices: 00158D0000506820,00158D0000506830,00158D000050683B,
                      String clusterId = cluster.clusterId.toString();
                      if (clusterId.length < 2) {
                        clusterId = '0$clusterId';
                      }
                      String command = '';
                      if (cluster.status == 1) {
                        command = meshCluster.sendDisableCluster(
                            cluster.netNumber, clusterId);
                        bool response = await meshNotifier.sendCommand(
                            command, cluster.netNumber);
                        if (response) {
                          meshNotifier.disableCluster(cluster.clusterId);
                        }
                      }
                      if (cluster.status == 0) {
                        command = meshCluster.sendEnableCluster(
                            cluster.netNumber, clusterId);
                        bool response = await meshNotifier.sendCommand(
                            command, cluster.netNumber);
                        if (response) {
                          meshNotifier.enableCluster(cluster.clusterId);
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
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
          color: cluster.status == 1 ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Center(child: Text(cluster.clusterName)),
    ),
  );
}

class ClustersScreenState extends State<ClustersScreen> {
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

  List getClusterNetworks(clusters) {
    networkIds = [];
    for (Cluster cluster in clusters) {
      bool res = networkIds.contains(cluster.netNumber);
      if (!res) {
        networkIds.add(cluster.netNumber);
      }
    }

    if (networkIds.length == 0) {
      networkIds.add("None");
    }

    return networkIds;
  }

  @override
  Widget build(BuildContext context) {
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);
    networkIds = getClusterNetworks(meshNotifier.getAllClusters);
    dropdownValue = networkIds.first;

    List<Widget> getCluster() {
      List<Widget> sensorList = [];
      final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
      List<Cluster> data = meshNotifier.getAllClusters!;
      // logger.i(data);
      for (var i = 0; i < data.length; i++) {
        sensorList.add(widget(context, data.elementAt(i), GlobalKey()));

        // sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
      }
      setState(() {});
      return sensorList;
    }

    Future<void> deleteAll() async {
      MeshCluster meshCluster = MeshCluster();
      String command = meshCluster.sendDeleteAllCluster(dropdownValue);
      bool result = await meshNotifier.sendCommand(command, dropdownValue);
      if (result) {
        meshNotifier.deleteClusterViaNetId(dropdownValue);
      }
    }

    Future<void> enableAll() async {
      //todo
      MeshCluster meshCluster = MeshCluster();
      String command = meshCluster.sendEnableAllClusters(dropdownValue);
      bool result = await meshNotifier.sendCommand(command, dropdownValue);
      if (result) {
        // meshNotifier.enableAllClusters(clusterId); //todo
      }
    }

    Future<void> disableAll() async {
      //todo
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GridView.count(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: getCluster()))
        ],
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
