//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import device_info_plus
import flutter_local_notifications
import network_info_plus
import package_info_plus
import shared_preferences_foundation
import sqflite

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FlutterLocalNotificationsPlugin.register(with: registry.registrar(forPlugin: "FlutterLocalNotificationsPlugin"))
  NetworkInfoPlusPlugin.register(with: registry.registrar(forPlugin: "NetworkInfoPlusPlugin"))
  FLTPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlusPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
