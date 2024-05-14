// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:rpe_c/app/constants/app.colors.dart';
// import 'package:rpe_c/core/logger/logger.dart';
// import 'package:rpe_c/core/models/db.models.dart';
// import 'package:rpe_c/core/service/database.service.dart';
// import 'package:rpe_c/presentation/screens/homeScreen/home.screen.dart';
// import 'package:rpe_c/presentation/widgets/custom.text.field.dart';
// import '../../../widgets/service_tile.dart';
// import '../../../widgets/characteristic_tile.dart';
// import '../../../widgets/descriptor_tile.dart';
// import '../../../utils/snackbar.dart';
// import '../../../utils/extra.dart';
//
// class DeviceScreen extends StatefulWidget {
//   final BleArgs bleArgs;
//
//   const DeviceScreen({super.key, required this.bleArgs});
//
//   @override
//   State<DeviceScreen> createState() => _DeviceScreenState();
// }
//
// class _DeviceScreenState extends State<DeviceScreen> {
//   int? _rssi;
//   int? _mtuSize;
//   BluetoothConnectionState _connectionState =
//       BluetoothConnectionState.disconnected;
//   List<BluetoothService> _services = [];
//   bool _isDiscoveringServices = false;
//   bool _isConnecting = false;
//   bool _isDisconnecting = false;
//
//   late StreamSubscription<BluetoothConnectionState>
//       _connectionStateSubscription;
//   late StreamSubscription<bool> _isConnectingSubscription;
//   late StreamSubscription<bool> _isDisconnectingSubscription;
//   late StreamSubscription<int> _mtuSubscription;
//   final TextEditingController userEmailController = TextEditingController();
//   final TextEditingController userPassController = TextEditingController();
//   final DatabaseService _databaseService = DatabaseService();
//   late BluetoothDescriptor descriptor;
//
//   final NetworkInfo _networkInfo = NetworkInfo();
//   String _connectionStatus = 'Unknown';
//   String? wifiName = "";
//   String? wifiBSSID = "";
//
//   late StreamSubscription<List<int>> _lastValueSubscription;
//   List<int> _value = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initNetworkInfo();
//
//     _connectionStateSubscription =
//         widget.bleArgs.device.connectionState.listen((state) async {
//       _connectionState = state;
//       if (state == BluetoothConnectionState.connected) {
//         _services = []; // must rediscover services
//       }
//       if (state == BluetoothConnectionState.connected && _rssi == null) {
//         _rssi = await widget.bleArgs.device.readRssi();
//       }
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     _mtuSubscription = widget.bleArgs.device.mtu.listen((value) {
//       _mtuSize = value;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     _isConnectingSubscription =
//         widget.bleArgs.device.isConnecting.listen((value) {
//       _isConnecting = value;
//
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     _isDisconnectingSubscription =
//         widget.bleArgs.device.isDisconnecting.listen((value) {
//       _isDisconnecting = value;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     Future.delayed(Duration(milliseconds: 3000), () async {
//       if (_connectionState.toString().split('.')[1] == "connected") {
//         await onDiscoverServicesPressed();
//       }
//
//       _services.first.characteristics.first.onValueReceived.listen((value) {
//         _value = value;
//         if (value.first == 123) {
//           try {
//             // logger.w(utf8.decode(value));
//             Map<String, dynamic> map = jsonDecode(utf8.decode(value));
//             String ip = map['IP'];
//             var _ip = "";
//             for (int i = 2; i <= ip.length - 2; i += 2) {
//               final hex = ip.substring(i, i + 2);
//               final number = int.parse(hex, radix: 16);
//               _ip += number.toString() + ".";
//             }
//             ip = _ip.substring(0, _ip.length - 1);
//             _databaseService
//                 .insertNetwork(RpeNetwork(url: "http://" + ip, preDef: 1));
//
//             MaterialPageRoute route =
//                 MaterialPageRoute(builder: (context) => HomeScreen());
//
//             Navigator.of(context).push(route);
//           } on Exception catch (_) {
//             print('another time ');
//           }
//         }
//       });
//     });
//   }
//
//   Future<void> _initNetworkInfo() async {
//     String? wifiIPv4, wifiIPv6, wifiGatewayIP, wifiBroadcast, wifiSubmask;
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiName = await _networkInfo.getWifiName();
//         } else {
//           wifiName = await _networkInfo.getWifiName();
//         }
//       } else {
//         wifiName = await _networkInfo.getWifiName();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi Name', error: e);
//       wifiName = 'Failed to get Wifi Name';
//     }
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         } else {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         }
//       } else {
//         wifiBSSID = await _networkInfo.getWifiBSSID();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi BSSID', error: e);
//       wifiBSSID = 'Failed to get Wifi BSSID';
//     }
//
//     try {
//       wifiIPv4 = await _networkInfo.getWifiIP();
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi IPv4', error: e);
//       wifiIPv4 = 'Failed to get Wifi IPv4';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiIPv6 = await _networkInfo.getWifiIPv6();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi IPv6', error: e);
//       wifiIPv6 = 'Failed to get Wifi IPv6';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiSubmask = await _networkInfo.getWifiSubmask();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi submask address', error: e);
//       wifiSubmask = 'Failed to get Wifi submask address';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiBroadcast = await _networkInfo.getWifiBroadcast();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi broadcast', error: e);
//       wifiBroadcast = 'Failed to get Wifi broadcast';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
//       }
//     } on PlatformException catch (e) {
//       logger.i('Failed to get Wifi gateway address', error: e);
//       wifiGatewayIP = 'Failed to get Wifi gateway address';
//     }
//
//     setState(() {
//       _connectionStatus = 'Wifi Name: $wifiName\n'
//           'Wifi BSSID: $wifiBSSID\n'
//           'Wifi IPv4: $wifiIPv4\n'
//           'Wifi IPv6: $wifiIPv6\n'
//           'Wifi Broadcast: $wifiBroadcast\n'
//           'Wifi Gateway: $wifiGatewayIP\n'
//           'Wifi Submask: $wifiSubmask\n';
//
//       print(_connectionStatus);
//     });
//   }
//
//   @override
//   void dispose() {
//     _connectionStateSubscription.cancel();
//     _mtuSubscription.cancel();
//     _isConnectingSubscription.cancel();
//     _isDisconnectingSubscription.cancel();
//     super.dispose();
//   }
//
//   bool get isConnected {
//     return _connectionState == BluetoothConnectionState.connected;
//   }
//
//   Future onConnectPressed() async {
//     try {
//       await widget.bleArgs.device.connectAndUpdateStream();
//       Snackbar.show(ABC.c, "Connect: Success", success: true);
//     } catch (e) {
//       if (e is FlutterBluePlusException &&
//           e.code == FbpErrorCode.connectionCanceled.index) {
//         // ignore connections canceled by the user
//       } else {
//         Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//             success: false);
//       }
//     }
//   }
//
//   Future onCancelPressed() async {
//     try {
//       await widget.bleArgs.device.disconnectAndUpdateStream(queue: false);
//       Snackbar.show(ABC.c, "Cancel: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
//     }
//   }
//
//   Future onDisconnectPressed() async {
//     try {
//       await widget.bleArgs.device.disconnectAndUpdateStream();
//       Snackbar.show(ABC.c, "Disconnect: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Disconnect Error:", e),
//           success: false);
//     }
//   }
//
//   Future onDiscoverServicesPressed() async {
//     if (mounted) {
//       setState(() {
//         _isDiscoveringServices = true;
//       });
//     }
//     try {
//       _services = await widget.bleArgs.device.discoverServices();
//       Guid guid = Guid('00ff');
//       if (_services[2].characteristics.first.serviceUuid == guid) {
//         _services = [_services[2]];
//       }
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Discover Services Error:", e),
//           success: false);
//     }
//     if (mounted) {
//       setState(() {
//         _isDiscoveringServices = false;
//       });
//     }
//   }
//
//   Future onRequestMtuPressed() async {
//     try {
//       await widget.bleArgs.device.requestMtu(512, predelay: 0);
//       Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e),
//           success: false);
//     }
//   }
//
//   List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
//     return _services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map((c) => _buildCharacteristicTile(c))
//                 .toList(),
//           ),
//         )
//         .toList();
//   }
//
//   CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
//     return CharacteristicTile(
//       characteristic: c,
//       descriptorTiles:
//           c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
//     );
//   }
//
//   Widget buildSpinner(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(14.0),
//       child: AspectRatio(
//         aspectRatio: 1.0,
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.black12,
//           color: Colors.black26,
//         ),
//       ),
//     );
//   }
//
//   Widget buildRemoteId(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text('${widget.bleArgs.device.remoteId}'),
//     );
//   }
//
//   Widget buildRssiTile(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         isConnected
//             ? const Icon(Icons.bluetooth_connected)
//             : const Icon(Icons.bluetooth_disabled),
//         Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''),
//             style: Theme.of(context).textTheme.bodySmall)
//       ],
//     );
//   }
//
//   Widget buildGetServices(BuildContext context) {
//     return IndexedStack(
//       index: (_isDiscoveringServices) ? 1 : 0,
//       children: <Widget>[
//         TextButton(
//           child: const Text("Get Services"),
//           onPressed: onDiscoverServicesPressed,
//         ),
//         const IconButton(
//           icon: SizedBox(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation(Colors.grey),
//             ),
//             width: 18.0,
//             height: 18.0,
//           ),
//           onPressed: null,
//         )
//       ],
//     );
//   }
//
//   Widget buildMtuTile(BuildContext context) {
//     return ListTile(
//         title: const Text('MTU Size'),
//         subtitle: Text('$_mtuSize bytes'),
//         trailing: IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: onRequestMtuPressed,
//         ));
//   }
//
//   Widget buildConnectButton(BuildContext context) {
//     return Row(children: [
//       if (_isConnecting || _isDisconnecting) buildSpinner(context),
//       TextButton(
//           onPressed: _isConnecting
//               ? onCancelPressed
//               : (isConnected ? onDisconnectPressed : onConnectPressed),
//           child: Text(
//             _isConnecting ? "CANCEL" : (isConnected ? "DISCONNECT" : "CONNECT"),
//             style: Theme.of(context)
//                 .primaryTextTheme
//                 .labelLarge
//                 ?.copyWith(color: Colors.white),
//           ))
//     ]);
//   }
//
//   Future pair(ssid, pass) async {
//     BluetoothCharacteristic c = _services.first.characteristics.first;
//     List<int> byteIntList = utf8.encode('{"ssid":$ssid,"password": "$pass"}');
//     await c.write(byteIntList, allowLongWrite: true);
//     Snackbar.show(ABC.c, "Write: Success", success: true);
//
//     await c.setNotifyValue(true);
//
//     print("notify");
//     // Snackbar.show(ABC.c, "$op : Success", success: true);
//     if (c.properties.read) {
//       int i = 0;
//       List<int> result = await c.read();
//       // utf8.decode(result);
//
//       // _databaseService.insertNetwork(RpeNetwork(
//       //     name:
//       //     url: ,
//       //     domain: widget.networkConfigArguments.type));
//
//       // Navigator.of(context)
//       //     .pushReplacementNamed(AppRouter.homeRoute);
//     }
//   }
//
//   Future reset() async {
//     BluetoothCharacteristic c = _services.first.characteristics.first;
//     List<int> byteIntList = utf8.encode('{"request":"reset"}');
//     await c.write(byteIntList, allowLongWrite: true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: Snackbar.snackBarKeyC,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.bleArgs.device.platformName),
//           actions: [buildConnectButton(context)],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height * 0.9,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Column(
//                         children: [
//                           Padding(
//                               padding: const EdgeInsets.fromLTRB(
//                                   35.0, 0.0, 35.0, 2.0),
//                               child: Text("WIFI name $wifiName")),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
//                             child: CustomTextField.customTextField(
//                               textEditingController: userPassController,
//                               hintText: 'Enter a password',
//                               validator: (val) =>
//                                   val!.isEmpty ? 'Enter a password' : null,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         MaterialButton(
//                           height: MediaQuery.of(context).size.height * 0.05,
//                           minWidth: MediaQuery.of(context).size.width * 0.4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           onPressed: () async {
//                             pair(wifiName, userPassController.text);
//                           },
//                           color: AppColors.rawSienna,
//                           child: const Text(
//                             'Connect ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         MaterialButton(
//                           height: MediaQuery.of(context).size.height * 0.05,
//                           minWidth: MediaQuery.of(context).size.width * 0.4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           onPressed: () async {
//                             reset();
//                           },
//                           color: AppColors.rawSienna,
//                           child: const Text(
//                             'Reset',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//
//               // buildRemoteId(context),
//               // ListTile(
//               //   leading: buildRssiTile(context),
//               //   title: Text(
//               //       'Device is ${_connectionState.toString().split('.')[1]}.'),
//               //   trailing: buildGetServices(context),
//               // ),
//               // buildMtuTile(context),
//               // ..._buildServiceTiles(context, widget.device),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class BleArgs {
//   final BluetoothDevice device; //todo need to create associations
//
//   const BleArgs({required this.device});
// }
