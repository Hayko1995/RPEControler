// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rpe_c/app/constants/app.constants.dart';
// import 'package:rpe_c/app/routes/app.routes.dart';
// import 'package:rpe_c/core/logger/logger.dart';
// import 'package:rpe_c/utils/extra.dart';
// import 'package:rpe_c/utils/snackbar.dart';
// import 'package:rpe_c/widgets/scan_result_tile.dart';
// import 'package:rpe_c/widgets/system_device_tile.dart';
//
// import 'device_screen.dart';
//
// class ScanScreen extends StatefulWidget {
//   const ScanScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//   List<BluetoothDevice> _systemDevices = [];
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     Permission.location.isDenied.then((value) {
//       if (value) {
//         Permission.location.request();
//       }
//     });
//
//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       // _scanResults = results;
//       for (var result in results) {
//         String name = result.advertisementData.advName;
//         if (name.isNotEmpty) {
//           if (result.advertisementData.advName.substring(0, 4) ==
//               AppConstants.advName) {
//             if (!_scanResults.contains(result)) {
//               _scanResults.add(result);
//             }
//           }
//         }
//       }
//
//       if (mounted) {
//         setState(() {});
//       }
//     }, onError: (e) {
//       Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });
//
//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       logger.i(state);
//       _isScanning = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       onScanPressed();
//     });
//   }
//
//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }
//
//   Future onScanPressed() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
//           success: false);
//     }
//     try {
//       // android is slow when asking for all advertisements,
//       // so instead we only ask for 1/8 of them
//       int divisor = Platform.isAndroid ? 8 : 1;
//       await FlutterBluePlus.startScan(
//           timeout: const Duration(seconds: 15),
//           continuousUpdates: true,
//           continuousDivisor: divisor);
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
//           success: false);
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
//           success: false);
//     }
//   }
//
//   void onConnectPressed(BluetoothDevice device) {
//     device.connectAndUpdateStream().catchError((e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//           success: false);
//     });
//
//     onStopPressed();
//     MaterialPageRoute route = MaterialPageRoute(
//         builder: (context) => DeviceScreen(
//               bleArgs: BleArgs(device: device),
//             ),
//         settings: RouteSettings(name: AppRouter.bleDeviceRouter));
//     onStopPressed();
//     Navigator.of(context).push(route);
//   }
//
//   Future onRefresh() {
//     if (_isScanning == false) {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     }
//     if (mounted) {
//       setState(() {});
//     }
//     return Future.delayed(Duration(milliseconds: 500));
//   }
//
//   Widget buildScanButton(BuildContext context) {
//     if (FlutterBluePlus.isScanningNow) {
//       return FloatingActionButton(
//         child: const Icon(Icons.stop),
//         onPressed: onStopPressed,
//         backgroundColor: Colors.red,
//       );
//     } else {
//       return FloatingActionButton(
//           child: const Text("SCAN"), onPressed: onScanPressed);
//     }
//   }
//
//   List<Widget> _buildSystemDeviceTiles(BuildContext context) {
//     return _systemDevices
//         .map(
//           (d) => SystemDeviceTile(
//             device: d,
//             onOpen: () => Navigator.of(context).pushNamed(
//                 AppRouter.bleDeviceRouter,
//                 arguments: BleArgs(device: d)),
//             onConnect: () => onConnectPressed(d),
//           ),
//         )
//         .toList();
//   }
//
//   List<Widget> _buildScanResultTiles(BuildContext context) {
//     return _scanResults
//         .map(
//           (r) => ScanResultTile(
//             result: r,
//             onTap: () => onConnectPressed(r.device),
//           ),
//         )
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find Devices'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: ListView(
//           children: <Widget>[
//             ..._buildSystemDeviceTiles(context),
//             ..._buildScanResultTiles(context),
//           ],
//         ),
//       ),
//       floatingActionButton: buildScanButton(context),
//     );
//   }
// }
