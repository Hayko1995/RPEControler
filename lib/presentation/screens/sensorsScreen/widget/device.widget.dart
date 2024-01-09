import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/presentation/screens/sensorDetailsScreen/sensors.detail.screen.dart';
import 'package:rpe_c/presentation/screens/sensorsScreen/sensors.screen.dart';

void checkBoxCallBack(bool? checkBoxState) {
  if (checkBoxState != null) {
    print("object");
  }
}

void buttonCall() {
  print("object");
}

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
      onLongPress: () {
        showMenu(
          items: <PopupMenuEntry>[
            const PopupMenuItem(
              //value: this._index,
              child: Column(
                children: [
                  GFToggle(
                    value: true,
                    enabledThumbColor: Colors.blue,
                    enabledTrackColor: Colors.green,
                    type: GFToggleType.custom,
                    onChanged: checkBoxCallBack,
                  ),
                  OutlinedButton(onPressed: buttonCall, child: Text("data"))
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
