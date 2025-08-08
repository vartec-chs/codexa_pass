import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/recent_databases_section.dart';

// Провайдер для недавних баз данных
final recentDatabasesProvider =
    StateNotifierProvider<RecentDatabasesNotifier, List<RecentDatabase>>((ref) {
      return RecentDatabasesNotifier();
    });

class RecentDatabasesNotifier extends StateNotifier<List<RecentDatabase>> {
  RecentDatabasesNotifier() : super([]);

  void addRecentDatabase(RecentDatabase database) {
    // Удаляем дубликаты если есть
    state = state.where((db) => db.path != database.path).toList();

    // Добавляем в начало списка
    state = [database, ...state];

    // Ограничиваем количество недавних до 10
    if (state.length > 10) {
      state = state.take(10).toList();
    }
  }

  void removeRecentDatabase(String path) {
    state = state.where((db) => db.path != path).toList();
  }

  void clearRecentDatabases() {
    state = [];
  }

  void updateLastOpened(String path) {
    final index = state.indexWhere((db) => db.path == path);
    if (index != -1) {
      final database = state[index];
      final updatedDatabase = RecentDatabase(
        name: database.name,
        path: database.path,
        lastOpened: DateTime.now(),
        entriesCount: database.entriesCount,
      );

      // Обновляем и перемещаем в начало
      final newState = List<RecentDatabase>.from(state);
      newState.removeAt(index);
      newState.insert(0, updatedDatabase);
      state = newState;
    }
  }
}

// Провайдер для действий домашнего экрана
final homeActionsProvider = Provider<HomeActions>((ref) {
  return HomeActions(ref);
});

class HomeActions {
  final Ref _ref;

  HomeActions(this._ref);

  Future<void> createNewDatabase(BuildContext context) async {
    context.go(AppRoutes.createStore);
  }

  Future<void> openExistingDatabase(BuildContext context) async {
    context.go(AppRoutes.openStore);
  }

  Future<void> openRecentDatabase(RecentDatabase database) async {
    // TODO: Реализовать открытие недавней базы данных
    // Проверить существование файла
    // Открыть базу данных
    // Обновить время последнего открытия
    _ref.read(recentDatabasesProvider.notifier).updateLastOpened(database.path);
  }

  void removeFromRecent(String path) {
    _ref.read(recentDatabasesProvider.notifier).removeRecentDatabase(path);
  }

  void clearRecentDatabases() {
    _ref.read(recentDatabasesProvider.notifier).clearRecentDatabases();
  }
}
