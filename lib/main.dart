import 'dart:async';
import 'dart:io';

import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.theme.dart';
import 'package:rpe_c/app/providers/app.provider.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/core/service/background.service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


// import 'web_url/configure_nonweb.dart'
//     if (dart.library.html) 'web_url/configure_web.dart';

Future<void> main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }


  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true); // ble tuned off

  DartPingIOS.register();
  // configureApp();
  /////////////////Background service
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  /////////////////Background service
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  runApp(const Lava());
}

class Lava extends StatelessWidget {
  const Lava({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: const Core(),
    );
  }
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, _) {
        return MaterialApp(
          title: 'RPE Controls',
          // supportedLocales: AppLocalization.all,
          theme: notifier.darkTheme ? darkTheme : lightTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splashRoute,
        );
      },
    );
  }
}

//
// import 'package:flutter/material.dart';
//
// // Flutter code sample for [DropdownMenu]s. The first dropdown menu
// // has the default outlined border and demos using the
// // [DropdownMenuEntry] style parameter to customize its appearance.
// // The second dropdown menu customizes the appearance of the dropdown
// // menu's text field with its [InputDecorationTheme] parameter.
//
// void main() {
//   runApp(const DropdownMenuExample());
// }
//
// // DropdownMenuEntry labels and values for the first dropdown menu.
// enum ColorLabel {
//   blue('Blue', Colors.blue),
//   pink('Pink', Colors.pink),
//   green('Green', Colors.green),
//   yellow('Orange', Colors.orange),
//   grey('Grey', Colors.grey);
//
//   const ColorLabel(this.label, this.color);
//   final String label;
//   final Color color;
// }
//
// // DropdownMenuEntry labels and values for the second dropdown menu.
// enum IconLabel {
//   smile('Smile', Icons.sentiment_satisfied_outlined),
//   cloud(
//     'Cloud',
//     Icons.cloud_outlined,
//   ),
//   brush('Brush', Icons.brush_outlined),
//   heart('Heart', Icons.favorite);
//
//   const IconLabel(this.label, this.icon);
//   final String label;
//   final IconData icon;
// }
//
// class DropdownMenuExample extends StatefulWidget {
//   const DropdownMenuExample({super.key});
//
//   @override
//   State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
// }
//
// class _DropdownMenuExampleState extends State<DropdownMenuExample> {
//   final TextEditingController colorController = TextEditingController();
//   final TextEditingController iconController = TextEditingController();
//   ColorLabel? selectedColor;
//   IconLabel? selectedIcon;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.green,
//       ),
//       home: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     DropdownMenu<ColorLabel>(
//                       initialSelection: ColorLabel.green,
//                       // controller: colorController,
//                       // requestFocusOnTap is enabled/disabled by platforms when it is null.
//                       // On mobile platforms, this is false by default. Setting this to true will
//                       // trigger focus request on the text field and virtual keyboard will appear
//                       // afterward. On desktop platforms however, this defaults to true.
//                       // requestFocusOnTap: true,
//                       label: const Text('Color'),
//                       onSelected: (ColorLabel? color) {
//                         setState(() {
//                           selectedColor = color;
//                         });
//                       },
//                       dropdownMenuEntries: ColorLabel.values
//                           .map<DropdownMenuEntry<ColorLabel>>(
//                               (ColorLabel color) {
//                             return DropdownMenuEntry<ColorLabel>(
//                               value: color,
//                               label: color.label,
//                             );
//                           }).toList(),
//                     ),
//                     const SizedBox(width: 24),
//                   ],
//                 ),
//               ),
//               if (selectedColor != null && selectedIcon != null)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                         'You selected a ${selectedColor?.label} ${selectedIcon?.label}'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: Icon(
//                         selectedIcon?.icon,
//                         color: selectedColor?.color,
//                       ),
//                     )
//                   ],
//                 )
//               else
//                 const Text('Please select a color and an icon.')
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
