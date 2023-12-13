//TODO fix designer responsive when kayboard come out
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/dashboard/witget/air.quality.widget.dart';
import 'package:rpe_c/presentation/screens/sensorsDetailScreen/sensors.detail.screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Item> _items = [
    Item('air quality', Colors.white),
  ];
  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 0);
  double _page = 0;

  Color caughtColor = Colors.grey;
  final DatabaseService _databaseService = DatabaseService();
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
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateTables();
    });
    super.initState();
  }

  List<Device> dataDevices = <Device>[];
  List<Upload> dataUpload = <Upload>[];

  void _updateTables() async {
    List<Device> _dataDevices = await _databaseService.getAllDevices();
    List<Upload> _dataUpload = await _databaseService.getAllUploads();
    // logger.w(_dataUpload);

    // TODO write logic for Widget
    setState(() {
      dataDevices = _dataDevices;
      dataUpload = _dataUpload;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Row(
                    children: [
                      if (dataDevices.length > 0)...[
                      Expanded(
                          child: ItemBuilder(
                        items: _items,
                        index: index,
                        devices: dataDevices
                      ))],
                    ],
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < _items.length; i++)
              Container(
                margin: const EdgeInsets.all(2),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1.5),
                    color: _page - i > 1 || _page - i < -1
                        ? Colors.transparent
                        : _page - i > 0
                            ? Colors.grey.withOpacity(1 - (_page - i))
                            : Colors.grey.withOpacity(1 - (i - _page))),
              )
          ],
        )
      ],
    );
  }
}
