import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';

Widget sensorWidget(context, data, widgetKey) {
  final Function(bool?) toggleCheckboxState;

  final value = data.sensorVal.split(',');
  int deviceType = data.deviceType;
  // logger.i(data);

  final meshNotifier = Provider.of<MeshNotifier>(context, listen: false);

  void changeState() {
    String status = data.status;
    print("aaaaaaaaaaa");
    String command;
    if (status == "ON") {
      data.status = "OFF";
      command = "94" + "01" + "05" + data.nodeNumber + data.netId;
    } else {
      data.status = "ON";
      command = "94" + "02" + "05" + data.nodeNumber + data.netId;
    }
    // meshNotifier.sendActivationCommand(command, data.netId);

    meshNotifier.updateDevice(data);
    print("////////");
    print(data);
  }

  return GestureDetector(
      key: widgetKey,
      onTap: () {
        changeState();
        if (data.deviceType == 0) {
          changeState();
        }
      },
      onLongPress: () {
        Navigator.of(context).pushNamed(
          AppRouter.sensorDetailsRoute,
          arguments: SensorDetailsArgs(mac: data.macAddress),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(data.image),
              fit: BoxFit.fill,
            ),
            color: data.status == "ON" ? Colors.green : Colors.white,
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
                style: Theme.of(context).textTheme.titleMedium),
            Text(value[0].toString().toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ));
//
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
// }
