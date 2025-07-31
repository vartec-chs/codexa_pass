import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recent_database_card.dart';
import '../home_control.dart';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Недавние хранилища',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (recentDatabases.isNotEmpty)
                  TextButton(
                    onPressed: homeActions.clearRecentDatabases,
                    child: Text(
                      'Очистить',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (recentDatabases.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyStateContent(context),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final database = recentDatabases[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < recentDatabases.length - 1 ? 12 : 0,
                  ),
                  child: RecentDatabaseCard(
                    database: database,
                    onTap: () => homeActions.openRecentDatabase(database),
                    onRemove: () => homeActions.removeFromRecent(database.path),
                  ),
                );
              }, childCount: recentDatabases.length),
            ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_open_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Нет недавних хранилищ',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте новое или откройте существующее хранилище',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
