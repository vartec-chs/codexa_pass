// import "package:talker_flutter/talker_flutter.dart";

// final Talker talker = TalkerFlutter.init(
//   settings: TalkerSettings(
//     enabled: true,
//     maxHistoryItems: 100,
//     useConsoleLogs: true,
//     useHistory: true,
//     timeFormat: TimeFormat.timeAndSeconds,
//   ),
// );

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Глобальный ключ для навигации (для Toast Manager и других overlay виджетов)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
