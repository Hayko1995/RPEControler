import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/presentation/screens/sensorsDetailScreen/sensors.detail.screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    Key? key,
    required List<Item> items,
    required this.index,
  })  : _items = items,
        super(key: key);

  final List<Item> _items;
  final int index;

  @override
  Widget build(BuildContext context) {
    String value =
        "{first_name : fname,last_name : lname,gender : male, location : { state : state, country : country, place : place} }";
    Map valueMap = json.decode(value);
    // final sensordata = SensorDetailsArgs();
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).pushReplacementNamed(
                  AppRouter.predefinePackageRoute,
                  arguments: sensordata)
            },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            height: 200,
            color: _items[index].color,
            child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Center(
                    child: Container(
                        child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                        showAxisLine: false,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 180,
                        endAngle: 360,
                        maximum: 120,
                        canScaleToFit: true,
                        radiusFactor: 0.79,
                        pointers: const <GaugePointer>[
                          NeedlePointer(
                              needleEndWidth: 5,
                              needleLength: 0.7,
                              value: 82,
                              knobStyle: KnobStyle(knobRadius: 0)),
                        ],
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0,
                              endValue: 20,
                              startWidth: 0.45,
                              endWidth: 0.45,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: const Color(0xFFDD3800)),
                          GaugeRange(
                              startValue: 20.5,
                              endValue: 40,
                              startWidth: 0.45,
                              sizeUnit: GaugeSizeUnit.factor,
                              endWidth: 0.45,
                              color: const Color(0xFFFF4100)),
                          GaugeRange(
                              startValue: 40.5,
                              endValue: 60,
                              startWidth: 0.45,
                              sizeUnit: GaugeSizeUnit.factor,
                              endWidth: 0.45,
                              color: const Color(0xFFFFBA00)),
                          GaugeRange(
                              startValue: 60.5,
                              endValue: 80,
                              startWidth: 0.45,
                              sizeUnit: GaugeSizeUnit.factor,
                              endWidth: 0.45,
                              color: const Color(0xFFFFDF10)),
                          GaugeRange(
                              startValue: 80.5,
                              endValue: 100,
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 0.45,
                              endWidth: 0.45,
                              color: const Color(0xFF8BE724)),
                          GaugeRange(
                              startValue: 100.5,
                              endValue: 120,
                              startWidth: 0.45,
                              endWidth: 0.45,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: const Color(0xFF64BE00)),
                        ]),
                    RadialAxis(
                      showAxisLine: false,
                      showLabels: false,
                      showTicks: false,
                      startAngle: 180,
                      endAngle: 360,
                      maximum: 120,
                      radiusFactor: 0.85,
                      canScaleToFit: true,
                      pointers: <GaugePointer>[
                        MarkerPointer(
                            markerType: MarkerType.text,
                            text: 'Poor',
                            value: 20.5,
                            textStyle: GaugeTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Times'),
                            offsetUnit: GaugeSizeUnit.factor,
                            markerOffset: -0.12),
                        MarkerPointer(
                            markerType: MarkerType.text,
                            text: 'Average',
                            value: 60.5,
                            textStyle: GaugeTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Times'),
                            offsetUnit: GaugeSizeUnit.factor,
                            markerOffset: -0.12),
                        MarkerPointer(
                            markerType: MarkerType.text,
                            text: 'Good',
                            value: 100.5,
                            textStyle: GaugeTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Times'),
                            offsetUnit: GaugeSizeUnit.factor,
                            markerOffset: -0.12)
                      ],
                    ),
                  ],
                ))))));
  }
}

class Item {
  final String title;
  final Color color;

  Item(this.title, this.color);
}