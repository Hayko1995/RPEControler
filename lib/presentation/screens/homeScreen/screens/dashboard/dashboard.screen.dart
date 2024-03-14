//TODO fix designer responsive when kayboard come out
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/widgets/predefine.widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
    List<RpeNetwork> data = meshNotifier.networks!;
    // logger.w(data);
    int airQualityNumber = 0;
    for (var i = 0; i < data.length; i++) {
      if (data.elementAt(i).preDef == AppConstants.airQuality) {
        airQualityNumber++;
      }
      // sensorList.add(sensorWidget(context, data.elementAt(i), GlobalKey()));
    }
    if (airQualityNumber > 0) {
      sensorList.add(airQualityWidget(context, data.elementAt(0), 0,
          "dashboard", airQualityNumber, GlobalKey()));
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
