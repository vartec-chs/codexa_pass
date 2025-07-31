// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'features/home/index.dart';
// import 'app/theme/app_theme.dart';

// class HomeScreenDemo extends ConsumerStatefulWidget {
//   const HomeScreenDemo({super.key});

//   @override
//   ConsumerState<HomeScreenDemo> createState() => _HomeScreenDemoState();
// }

// class _HomeScreenDemoState extends ConsumerState<HomeScreenDemo> {
//   @override
//   void initState() {
//     super.initState();
//     // Добавляем тестовые данные
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _addTestData();
//     });
//   }

//   void _addTestData() {
//     final notifier = ref.read(recentDatabasesProvider.notifier);

//     // Добавляем тестовые недавние базы данных
//     notifier.addRecentDatabase(
//       RecentDatabase(
//         name: 'Личные пароли',
//         path: 'C:/Users/User/Documents/personal.db',
//         lastOpened: DateTime.now().subtract(const Duration(hours: 2)),
//         entriesCount: 42,
//       ),
//     );

//     notifier.addRecentDatabase(
//       RecentDatabase(
//         name: 'Рабочие аккаунты',
//         path: 'C:/Users/User/Documents/work.db',
//         lastOpened: DateTime.now().subtract(const Duration(days: 1)),
//         entriesCount: 15,
//       ),
//     );

//     notifier.addRecentDatabase(
//       RecentDatabase(
//         name: 'Семейные пароли',
//         path: 'C:/Users/User/Documents/family.db',
//         lastOpened: DateTime.now().subtract(const Duration(days: 3)),
//         entriesCount: 28,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CodeXa Pass - Demo',
//       theme: AppTheme.lightTheme(),
//       darkTheme: AppTheme.darkTheme(),
//       themeMode: ThemeMode.system, // Автоматическое переключение темы
//       home: const HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
