import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/protocol/protocol.cluster.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/widgets/sensor.Threshold.widget.dart';
import 'package:rpe_c/presentation/widgets/sensor.setTimers.widget.dart';

Widget sensorWidget(context, data, widgetKey) {
  final Function(bool?) toggleCheckboxState;

  return GestureDetector(
      key: widgetKey,
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.sensorDetailsRoute,
          arguments: SensorDetailsArgs(mac: data.macAddress),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 3),
            Text(data.name.toString().toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ));
//
}

class ClusterControlScreen extends StatefulWidget {
  final ClusterControlArgs clusterControlsArguments;

  const ClusterControlScreen(
      {super.key, required this.clusterControlsArguments});

  @override
  State<ClusterControlScreen> createState() => _ClusterControlScreenState();
}

class _ClusterControlScreenState extends State<ClusterControlScreen> {
  List<RpeDevice> dataDevices = <RpeDevice>[];
  bool isSwitched = true;

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // var themeFlag = _themeNotifier.darkTheme;
    final meshNotifier = Provider.of<MeshNotifier>(context, listen: true);
    dataDevices = meshNotifier.allDevices!;

    List<Widget> getControl() {
      List<Widget> controlSet = [];
      Cluster cluster = widget.clusterControlsArguments.cluster;
      if (cluster.type == 0.toString()) {
        // buttonActivators
        controlSet.add(Switch(
          value: isSwitched,
          onChanged: (value) async {
            MeshCluster meshCluster = MeshCluster();
            String clusterId = cluster.clusterId.toString();
            if (clusterId.length < 2) {
              clusterId = '0$clusterId';
            }
            String command = '';
            if (value) {
              command = meshCluster.sendClusterOn(cluster.netNumber, clusterId);
            } else {
              command =
                  meshCluster.sendClusterOff(cluster.netNumber, clusterId);
            }
            bool result = await meshNotifier.sendCommand(command, cluster.netNumber);
            if (result) {
              setState(() {
                print(isSwitched);
                isSwitched = value;
              });
            }

          },
        ));
      }
      if (widget.clusterControlsArguments.cluster.type == 1.toString()) {
        // dimmerActivators
        controlSet.add(RangeSlider(
          values: _currentRangeValues,
          max: 100,
          divisions: 5,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ));
      }
      if (widget.clusterControlsArguments.cluster.type == 2.toString()) {
        // dimmerActivators
        controlSet.add(RangeSlider(
          values: _currentRangeValues,
          max: 100,
          divisions: 5,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ));
      }
      if (widget.clusterControlsArguments.cluster.type == 3.toString()) {
        // dimmerActivators
        controlSet.add(RangeSlider(
          values: _currentRangeValues,
          max: 100,
          divisions: 5,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ));
      }
      if (widget.clusterControlsArguments.cluster.type == 4.toString()) {
        // dimmerActivators
        controlSet.add(RangeSlider(
          values: _currentRangeValues,
          max: 100,
          divisions: 5,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ));
      }

      return controlSet;
    }

    List<Widget> getSensors() {
      List<Widget> sensorList = [];
      Cluster data = widget.clusterControlsArguments.cluster;
      List<String> clusterDeviceList = data.devices.split(',');

      for (var device in dataDevices) {
        if (clusterDeviceList.contains(device.macAddress)) {
          sensorList.add(sensorWidget(context, device, GlobalKey()));
        }
      }
      return sensorList;
    }

    void _showThresholdDialog() => showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return  SensorThresholdScreen(mac: "00158d0000506820");
      },
    );

    void _showTimerDialog() => showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SensorSetTImerScreen(mac: "00158d0000506820");
      },
    );

    Future<void> setThreshold() async {
      _showThresholdDialog();
    }

    Future<void> setTimer() async {
      _showTimerDialog();
    }


    return Scaffold(
        appBar: AppBar(
          title: const Text('Cluster Control'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Cluster name "),
                Text(
                  widget.clusterControlsArguments.cluster.clusterName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Cluster type "),
                Text(
                  widget.clusterControlsArguments.cluster.type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Cluster type "),
                Text(
                  widget.clusterControlsArguments.cluster.type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                OutlinedButton(
                    onPressed: setTimer, child: const Text("Set Timer")),
                OutlinedButton(
                    onPressed: setThreshold, child: const Text("Set Threshold")),
              ],
            ),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getControl()),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GridView.count(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: getSensors())),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ClusterControlArgs {
  final Cluster cluster;

  const ClusterControlArgs({required this.cluster});
}
