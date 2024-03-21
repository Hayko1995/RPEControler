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
                InkWell(
                  child: const Text("Delete"),
                  onTap: () {
                    MeshCluster meshCluster = MeshCluster();
                    // print(cluster);
                    // Cluster(clusterName: ClusterId 1,  aa, devices: 00158D0000506820,00158D0000506830,00158D000050683B,
                    String clusterId = cluster.clusterId.toString();
                    if (clusterId.length < 2) {
                      clusterId = '0$clusterId';
                    }

                    String command = meshCluster.sendDeleteCluster(
                        cluster.netNumber, clusterId);
                    bool response =
                        meshNotifier.sendCommand(command, cluster.netNumber);
                    if (response) {
                      meshNotifier.deleteCluster(cluster.clusterId);
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
          color: Colors.white,
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

  Color caughtColor = Colors.grey;

  List<String> data = [];

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
