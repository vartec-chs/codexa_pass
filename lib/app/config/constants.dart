import 'package:flutter/material.dart';

class AppConstants {
  // App
  static const String appName = 'Codexa Pass';
  static const String appVersion = '1.0.0';
  static const String dbExtension = 'codexa';
  static const String dbFileName = 'storage.$dbExtension';
  static const String appFolderName = 'Codexa';

  static const isDebug = true;
  static const isRelease = false;

  // logging
  static const String logPath = 'Codexa/logs';
  static const int maxLogFileSizeMB = 10; // Maximum log file size in MB
  static const int maxLogFiles = 5; // Maximum number of log files to keep

  // Window options
  static const Size defaultWindowSize = Size(600, 500);
  static const Size minWindowSize = Size(400, 500);
  static const Size maxWindowSize = Size(1000, 1000);
  static const isCenter = true;

  static const double mobileWidth = 600;

  // Password
  static const List<int> passwordRestrictions = [
    1,
    0,
  ]; // 1 - numbers, 0 - symbols
}
