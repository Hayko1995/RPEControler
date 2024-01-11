//TODO fix designer responsive when kayboard come out
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/clusterControlScreen/clusterControl.screen.dart';
import 'package:rpe_c/presentation/screens/preDefinesScreen/preDefines.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/sensors.screen.dart';

import 'package:rpe_c/presentation/widgets/predefine.widgets.dart';

class ClustersScreen extends StatefulWidget {
  const ClustersScreen({super.key});

  @override
  _ClustersScreenState createState() => _ClustersScreenState();
}

Widget widget(context, cluster,  widgetKey) {
  final Function(bool?) toggleCheckboxState;

  return GestureDetector(
    key: widgetKey,
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRouter.clusterControlRouter,
        arguments: ClusterControlArgs(cluster: cluster),
      );
    },
    onLongPress: () {},
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
    child: Center(child: Text(cluster.clusterName)),),
  );
}

class _ClustersScreenState extends State<ClustersScreen> {
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

  List<Widget> getSensors() {
    List<Widget> sensorList = [];
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    List<Cluster> data = meshNotifier.getAllClusters!;
    logger.i(data);
    for (var i = 0; i < data.length; i++) {
      sensorList
          .add(widget(context, data.elementAt(i), GlobalKey()));

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
                  children: getSensors()))
        ],
      ),
    );
  }
}
