import 'dart:io';

import '../config/constants.dart';
import "package:path/path.dart" as p;
import 'package:path_provider/path_provider.dart';

Future<String> getAppDir() async {
  final directory = await getApplicationDocumentsDirectory();
  return p.join(directory.path, AppConstants.appFolderName);
}

Future<String> getAppLogDirPath() async {
  final appDir = await getAppDir();
  if (!await Directory(appDir).exists()) {
    await Directory(appDir).create(recursive: true);
  }
  return p.join(appDir, 'logs');
}

// crash dir
Future<String> getAppCrashDirPath() async {
  final appDir = await getAppDir();
  if (!await Directory(appDir).exists()) {
    await Directory(appDir).create(recursive: true);
  }
  return p.join(appDir, 'crash_reports');
}
