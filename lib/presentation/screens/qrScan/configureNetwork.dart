//TODO fix responsively of page
//TODO add values to DB
//TODO read mDNS https://pub.dev/documentation/nsd/latest/

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rpe_c/app/constants/app.colors.dart';
import 'package:rpe_c/app/routes/app.routes.dart';
import 'package:rpe_c/core/logger/logger.dart';
import 'package:rpe_c/core/models/db.models.dart';
import 'package:rpe_c/core/notifiers/provisining.notifier.dart';
import 'package:rpe_c/core/service/database.service.dart';
import 'package:rpe_c/presentation/widgets/dimensions.widget.dart';
import 'package:rpe_c/core/notifiers/theme.notifier.dart';
import 'package:rpe_c/presentation/widgets/custom.text.field.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';

class ConfigureNetworkScreen extends StatefulWidget {
  const ConfigureNetworkScreen(
      {super.key, required this.networkConfigArguments});

  final NetworkConfigArgs networkConfigArguments;

  @override
  State<ConfigureNetworkScreen> createState() => _ConfigureNetworkState();
}

class _ConfigureNetworkState extends State<ConfigureNetworkScreen> {
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final NetworkInfo _networkInfo = NetworkInfo();
  String _connectionStatus = 'Unknown';
  String? wifiName = "";
  String? wifiBSSID = "";

  final provisioner = Provisioner.espTouch();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNetworkInfo();
    _provider();
  }

  Future<void> _provider() async {
    provisioner.listen((response) {
      _databaseService.insertNetwork(RpeNetwork(
          name: response.bssidText,
          url: response.ipAddressText!,
          domain: widget.networkConfigArguments.type));

      Navigator.of(context)
          .pushReplacementNamed(AppRouter.homeRoute);
    });

  }

  Future<void> _initNetworkInfo() async {
    String? wifiIPv4, wifiIPv6, wifiGatewayIP, wifiBroadcast, wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      logger.i('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';

      print(_connectionStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = themeNotifier.darkTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSizedBox2,
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                            child: Text("WIFI name $wifiName")),
                        vSizedBox1,
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                          child: CustomTextField.customTextField(
                            textEditingController: userPassController,
                            hintText: 'Enter a password',
                            validator: (val) =>
                                val!.isEmpty ? 'Enter a password' : null,
                          ),
                        )
                      ],
                    ),
                  ),
                  vSizedBox2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        height: MediaQuery.of(context).size.height * 0.05,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () async {
                          wifiName =
                              wifiName!.substring(1, wifiName!.length - 1);
                          try {
                            await provisioner
                                .start(ProvisioningRequest.fromStrings(
                              ssid: wifiName!,
                              bssid: wifiBSSID!,
                              password: userPassController.text,
                            ));

                            // If you are going to use this library in Flutter
                            // this is good place to show some Dialog and wait for exit
                            //
                            // Or simply you can delay with Future.delayed function
                            await Future.delayed(Duration(seconds: 20)); // todo add loading in ui
                            provisioner.stop();
                          } catch (e, s) {
                            print(e);
                          }

                          //TODO write host to db
                          //TODO need to config ESP32
                        },
                        color: AppColors.rawSienna,
                        child: const Text(
                          'Connect ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkConfigArgs {
  final String mac;
  final String url;
  final int type;

  const NetworkConfigArgs(
      {required this.mac, required this.url, required this.type});
}
