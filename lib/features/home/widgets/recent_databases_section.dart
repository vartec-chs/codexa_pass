import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recent_database_card.dart';
import '../home_control.dart';
import '../../../app/utils/animation_utils.dart';
import '../../../app/utils/theme_utils.dart';
import '../../../app/utils/responsive_utils.dart';

class RecentDatabasesSection extends ConsumerWidget {
  final HomeActions homeActions;

  const RecentDatabasesSection({super.key, required this.homeActions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentDatabases = ref.watch(recentDatabasesProvider);
    return _buildSlivers(context, recentDatabases);
  }

  Widget _buildSlivers(
    BuildContext context,
    List<RecentDatabase> recentDatabases,
  ) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Недавние хранилища',
                    style: ThemeUtils.getHeadingStyle(context, fontSize: 20),
                  ),
                  if (recentDatabases.isNotEmpty)
                    AnimatedAppearance(
                      delay: const Duration(milliseconds: 600),
                      child: TextButton(
                        onPressed: homeActions.clearRecentDatabases,
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          textStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Очистить'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (recentDatabases.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: AnimatedAppearance(
              delay: const Duration(milliseconds: 700),
              child: _buildEmptyStateContent(context),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.adaptivePadding(context).horizontal,
            ),
            sliver: ResponsiveUtils.isDesktop(context)
                ? _buildDesktopGrid(recentDatabases)
                : _buildMobileList(recentDatabases),
          ),
      ],
    );
  }

  Widget _buildEmptyStateContent(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedAppearance(
            delay: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.3,
                ),
                shape: BoxShape.circle,
                boxShadow: ThemeUtils.getAdaptiveShadow(context, elevation: 2),
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 48,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedAppearance(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Нет недавних хранилищ',
              style: ThemeUtils.getHeadingStyle(
                context,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ).copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedAppearance(
            delay: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Создайте новое или откройте существующее хранилище для начала работы',
                style: ThemeUtils.getSubtitleStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(List<RecentDatabase> recentDatabases) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final database = recentDatabases[index];
        return AnimatedAppearance(
          delay: Duration(milliseconds: 600 + (index * 100)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index < recentDatabases.length - 1 ? 12 : 0,
            ),
            child: RecentDatabaseCard(
              database: database,
              onTap: () => homeActions.openRecentDatabase(database),
              onRemove: () => homeActions.removeFromRecent(database.path),
            ),
          ),
        );
      }, childCount: recentDatabases.length),
    );
  }

  Widget _buildDesktopGrid(List<RecentDatabase> recentDatabases) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final database = recentDatabases[index];
        return AnimatedAppearance(
          delay: Duration(milliseconds: 600 + (index * 100)),
          child: RecentDatabaseCard(
            database: database,
            onTap: () => homeActions.openRecentDatabase(database),
            onRemove: () => homeActions.removeFromRecent(database.path),
          ),
        );
      }, childCount: recentDatabases.length),
    );
  }
}

class RecentDatabase {
  final String name;
  final String path;
  final DateTime lastOpened;
  final int entriesCount;

  RecentDatabase({
    required this.name,
    required this.path,
    required this.lastOpened,
    required this.entriesCount,
  });
}
