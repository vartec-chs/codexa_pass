import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/home_header.dart';
import 'widgets/action_buttons_section.dart';
import 'widgets/recent_databases_section.dart';
import 'home_control.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeActions = ref.watch(homeActionsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Фиксированный хедер в составе CustomScrollView
            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(16.0),
                child: const HomeHeader(),
              ),
            ),
            // Отступ перед кнопками действий
            const SliverPadding(padding: EdgeInsets.only(top: 32.0)),
            // Секция с кнопками действий
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ActionButtonsSection(homeActions: homeActions),
              ),
            ),
            // Отступ после кнопок действий
            const SliverPadding(padding: EdgeInsets.only(bottom: 40.0)),
            // Секция с недавними базами данных
            RecentDatabasesSection(homeActions: homeActions),
            // Отступ внизу
            const SliverPadding(padding: EdgeInsets.only(bottom: 40.0)),
          ],
        ),
      ),
    );
  }
}
