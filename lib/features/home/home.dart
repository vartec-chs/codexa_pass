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
        child: Column(
          children: [
            // Фиксированный хедер
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(16.0),
              child: const HomeHeader(),
            ),
            // Скроллируемый контент
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ActionButtonsSection(homeActions: homeActions),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                  RecentDatabasesSection(homeActions: homeActions),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
