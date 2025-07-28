import "package:talker_flutter/talker_flutter.dart";


final Talker talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    maxHistoryItems: 100,
    useConsoleLogs: true,
    useHistory: true,
    timeFormat: TimeFormat.timeAndSeconds,
  ),
);

