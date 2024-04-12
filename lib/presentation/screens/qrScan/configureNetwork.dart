//TODO fix responsively of page
//TODO add values to DB
//TODO read mDNS https://pub.dev/documentation/nsd/latest/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/screens/bluetooth/bluetooth_off_screen.dart';
import 'package:rpe_c/presentation/screens/bluetooth/scan_screen.dart';

class ConfigureNetworkScreen extends StatefulWidget {
  const ConfigureNetworkScreen(
      {super.key, required this.networkConfigArguments});

  final NetworkConfigArgs networkConfigArguments;

  @override
  State<ConfigureNetworkScreen> createState() => _ConfigureNetworkState();
}

class _ConfigureNetworkState extends State<ConfigureNetworkScreen> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final NetworkInfo _networkInfo = NetworkInfo();
  String _connectionStatus = 'Unknown';
  String? wifiName = "";
  String? wifiBSSID = "";

  @override
  void initState() {
    super.initState();

    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? const ScanScreen()
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
//     var themeFlag = themeNotifier.darkTheme;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
//         resizeToAvoidBottomInset: true,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             vSizedBox2,
//             SizedBox(
//               width: MediaQuery.sizeOf(context).width,
//               height: MediaQuery.sizeOf(context).height * 0.9,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Column(
//                       children: [
//                         Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
//                             child: Text("WIFI name $wifiName")),
//                         vSizedBox1,
//                         Padding(
//                           padding:
//                               const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
//                           child: CustomTextField.customTextField(
//                             textEditingController: userPassController,
//                             hintText: 'Enter a password',
//                             validator: (val) =>
//                                 val!.isEmpty ? 'Enter a password' : null,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   vSizedBox2,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       MaterialButton(
//                         height: MediaQuery.of(context).size.height * 0.05,
//                         minWidth: MediaQuery.of(context).size.width * 0.4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         onPressed: () async {
//                           wifiName =
//                               wifiName!.substring(1, wifiName!.length - 1);
//                           try {
//                             await provisioner
//                                 .start(ProvisioningRequest.fromStrings(
//                               ssid: wifiName!,
//                               bssid: wifiBSSID!,
//                               password: userPassController.text,
//                             ));
//
//                             // If you are going to use this library in Flutter
//                             // this is good place to show some Dialog and wait for exit
//                             //
//                             // Or simply you can delay with Future.delayed function
//                             await Future.delayed(Duration(
//                                 seconds: 20)); // todo add loading in ui
//                             provisioner.stop();
//                           } catch (e, s) {
//                             print(e);
//                           }
//
//                           //TODO write host to db
//                           //TODO need to config ESP32
//                         },
//                         color: AppColors.rawSienna,
//                         child: const Text(
//                           'Connect ',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}

class NetworkConfigArgs {
  final String mac;
  final String url;
  final int type;

  const NetworkConfigArgs(
      {required this.mac, required this.url, required this.type});
}
