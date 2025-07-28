import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'models.dart';

/// Сборщик информации об устройстве и приложении
class DeviceInfoCollector {
  /// Получение информации об устройстве
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData.addAll({
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'product': androidInfo.product,
          'androidId': androidInfo.id,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
          'systemFeatures': androidInfo.systemFeatures,
          'supportedAbis': androidInfo.supportedAbis,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData.addAll({
          'platform': 'iOS',
          'name': iosInfo.name,
          'model': iosInfo.model,
          'localizedModel': iosInfo.localizedModel,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'utsname': {
            'machine': iosInfo.utsname.machine,
            'nodename': iosInfo.utsname.nodename,
            'release': iosInfo.utsname.release,
            'sysname': iosInfo.utsname.sysname,
            'version': iosInfo.utsname.version,
          },
        });
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceData.addAll({
          'platform': 'Windows',
          'computerName': windowsInfo.computerName,
          'numberOfCores': windowsInfo.numberOfCores,
          'systemMemoryInMegabytes': windowsInfo.systemMemoryInMegabytes,
          'userName': windowsInfo.userName,
          'majorVersion': windowsInfo.majorVersion,
          'minorVersion': windowsInfo.minorVersion,
          'buildNumber': windowsInfo.buildNumber,
          'platformId': windowsInfo.platformId,
          'csdVersion': windowsInfo.csdVersion,
          'servicePackMajor': windowsInfo.servicePackMajor,
          'servicePackMinor': windowsInfo.servicePackMinor,
          'suitMask': windowsInfo.suitMask,
          'productType': windowsInfo.productType,
          'reserved': windowsInfo.reserved,
        });
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceData.addAll({
          'platform': 'Linux',
          'name': linuxInfo.name,
          'version': linuxInfo.version,
          'id': linuxInfo.id,
          'idLike': linuxInfo.idLike,
          'versionCodename': linuxInfo.versionCodename,
          'versionId': linuxInfo.versionId,
          'prettyName': linuxInfo.prettyName,
          'buildId': linuxInfo.buildId,
          'variant': linuxInfo.variant,
          'variantId': linuxInfo.variantId,
          'machineId': linuxInfo.machineId,
        });
      } else if (Platform.isMacOS) {
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceData.addAll({
          'platform': 'macOS',
          'computerName': macOsInfo.computerName,
          'hostName': macOsInfo.hostName,
          'arch': macOsInfo.arch,
          'model': macOsInfo.model,
          'kernelVersion': macOsInfo.kernelVersion,
          'majorVersion': macOsInfo.majorVersion,
          'minorVersion': macOsInfo.minorVersion,
          'patchVersion': macOsInfo.patchVersion,
          'osRelease': macOsInfo.osRelease,
          'activeCPUs': macOsInfo.activeCPUs,
          'memorySize': macOsInfo.memorySize,
          'cpuFrequency': macOsInfo.cpuFrequency,
          'systemGUID': macOsInfo.systemGUID,
        });
      } else {
        deviceData.addAll({
          'platform': 'Unknown',
          'error': 'Unsupported platform',
        });
      }

      // Добавляем общую информацию
      deviceData.addAll({
        'collectedAt': DateTime.now().toIso8601String(),
        'dartVersion': Platform.version,
        'operatingSystem': Platform.operatingSystem,
        'operatingSystemVersion': Platform.operatingSystemVersion,
        'environment': Platform.environment.keys
            .take(10)
            .toList(), // Только ключи для безопасности
      });
    } catch (e) {
      deviceData['error'] = 'Failed to get device info: $e';
      debugPrint('Failed to collect device info: $e');
    }

    return deviceData;
  }

  /// Получение информации о приложении
  static Future<Map<String, dynamic>> getAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return {
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'buildSignature': packageInfo.buildSignature,
        'installerStore': packageInfo.installerStore,
        'collectedAt': DateTime.now().toIso8601String(),
        'isDebugMode': kDebugMode,
        'isProfileMode': kProfileMode,
        'isReleaseMode': kReleaseMode,
      };
    } catch (e) {
      debugPrint('Failed to collect app info: $e');
      return {
        'error': 'Failed to get app info: $e',
        'collectedAt': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Создание информации о сессии
  static Future<SessionInfo> createSessionInfo(String sessionId) async {
    final deviceInfo = await getDeviceInfo();
    final appInfo = await getAppInfo();

    return SessionInfo(
      sessionId: sessionId,
      startTime: DateTime.now(),
      deviceInfo: deviceInfo,
      appInfo: appInfo,
    );
  }

  /// Получение системной информации для диагностики
  static Map<String, dynamic> getSystemDiagnostics() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
      'numberOfProcessors': Platform.numberOfProcessors,
      'pathSeparator': Platform.pathSeparator,
      'isLinux': Platform.isLinux,
      'isMacOS': Platform.isMacOS,
      'isWindows': Platform.isWindows,
      'isAndroid': Platform.isAndroid,
      'isIOS': Platform.isIOS,
      'isFuchsia': Platform.isFuchsia,
      'dartVersion': Platform.version,
      'collectedAt': DateTime.now().toIso8601String(),
    };
  }
}
