import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/core/notifiers/mesh.notifier.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

final customWidth03 =
    CustomSliderWidths(trackWidth: 22, progressBarWidth: 20, shadowWidth: 50);

final customColors03 = CustomSliderColors(
    trackColors: [HexColor('#FFF8CB'), HexColor('#B9FFFF')],
    progressBarColors: [HexColor('#FFC84B'), HexColor('#00BFD5')],
    shadowColor: HexColor('#5FC7B0'),
    dynamicGradient: true,
    shadowMaxOpacity: 0.05);

final info03 = InfoProperties(
    bottomLabelStyle: TextStyle(
        color: HexColor('#002D43'), fontSize: 20, fontWeight: FontWeight.w700),
    bottomLabelText: 'Goal',
    mainLabelStyle: const TextStyle(
        color: Color.fromRGBO(97, 169, 210, 1),
        fontSize: 30.0,
        fontWeight: FontWeight.w200),
    modifier: (double value) {
      final kcal = value.toInt();
      return '$kcal C';
    });
final CircularSliderAppearance appearance03 = CircularSliderAppearance(
    customWidths: customWidth03,
    customColors: customColors03,
    infoProperties: info03,
    size: 250.0,
    startAngle: 180,
    angleRange: 340);
final viewModel03 = ExampleViewModel(
    appearance: appearance03,
    min: 500,
    max: 2300,
    value: 1623,
    pageColors: [HexColor('#D9FFF7'), HexColor('#FFFFFF')]);

class Temperature extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  const Temperature(this.initPos, this.label, this.itemColor, {super.key});

  @override
  TemperatureState createState() => TemperatureState();
}

class TemperatureState extends State<Temperature> {
  Offset position = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  // final example03 = ExamplePage(
  //   viewModel: viewModel03,
  // );

  @override
  Widget build(BuildContext context) {
    double val =
        context.watch<MeshNotifier>().id!.toDouble(); //todo read from db
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          height: MediaQuery.sizeOf(context).height * 0.3,
          child:
              // PageView(
              // controller: controller,
              // children: <Widget>[
              //   example03,
              // ],
              SleekCircularSlider(
            onChangeStart: (double value) {},
            onChangeEnd: (double value) {},
            // innerWidget: viewModel.innerWidget,
            appearance: appearance03,
            min: 0,
            max: 2300,
            initialValue: val,
            // pageColors: [HexColor('#D9FFF7'), HexColor('#FFFFFF')]);
          )),
    );
    // ););

    //     appearance: appearance03,
    // min: 500,
    // max: 2300,
    // value: 1623,
    // pageColors: [HexColor('#D9FFF7'), HexColor('#FFFFFF')]);

    // SleekCircularSlider(
    //   appearance: CircularSliderAppearance(
    //       customWidths: CustomSliderWidths(progressBarWidth: 5)),
    //   min: 10,
    //   max: 28,
    //   initialValue: 28,
    // ));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ExampleViewModel {
  final List<Color> pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget? innerWidget;

  ExampleViewModel(
      {required this.pageColors,
      required this.appearance,
      this.min = 0,
      this.max = 100,
      this.value = 50,
      this.innerWidget});
}
