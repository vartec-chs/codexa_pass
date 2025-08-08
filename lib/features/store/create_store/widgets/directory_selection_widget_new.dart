import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/utils/animation_utils.dart';
import '../../../../app/utils/theme_utils.dart';
import '../../../../app/utils/responsive_utils.dart';
import '../create_store_control.dart';
import '../models/create_store_models.dart';

class DirectorySelectionWidget extends ConsumerWidget {
  const DirectorySelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createStoreControllerProvider);
    final controller = ref.read(createStoreControllerProvider.notifier);

    return AnimatedAppearance(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Расположение хранилища',
            style: ThemeUtils.getHeadingStyle(
              context,
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 16),
            ),
          ),
          const SizedBox(height: 16),
          _buildDirectoryOptions(context, state, controller),
          const SizedBox(height: 12),
          _buildPathInfo(context, state, controller),
        ],
      ),
    );
  }

  Widget _buildDirectoryOptions(
    BuildContext context,
    CreateStoreState state,
    CreateStoreController controller,
  ) {
    return Column(
      children: [
        _buildDirectoryOption(
          context: context,
          title: 'Использовать стандартную папку',
          subtitle: 'Хранилище будет создано в папке приложения',
          icon: Icons.folder_special,
          isSelected: state.useDefaultPath,
          onTap: () => controller.setUseDefaultPath(true),
        ),
        const SizedBox(height: 12),
        _buildDirectoryOption(
          context: context,
          title: 'Выбрать папку',
          subtitle: 'Укажите собственное расположение',
          icon: Icons.folder_open,
          isSelected: !state.useDefaultPath,
          onTap: () {
            controller.setUseDefaultPath(false);
            controller.selectCustomPath();
          },
        ),
      ],
    );
  }

  Widget _buildDirectoryOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedColorContainer(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2)
          : Colors.transparent,
      duration: AnimationConstants.fast,
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.responsive(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.responsive(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          child: AnimatedContainer(
            duration: AnimationConstants.fast,
            padding: ResponsiveUtils.responsive(
              context,
              mobile: const EdgeInsets.all(20),
              tablet: const EdgeInsets.all(24),
              desktop: const EdgeInsets.all(28),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.responsive(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                    : ThemeUtils.getBorderColor(context, opacity: 0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AnimationConstants.fast,
                  padding: ResponsiveUtils.responsive(
                    context,
                    mobile: const EdgeInsets.all(12),
                    tablet: const EdgeInsets.all(14),
                    desktop: const EdgeInsets.all(16),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.15)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.responsive(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: AnimationConstants.fast,
                    child: Icon(
                      icon,
                      key: ValueKey('$icon-$isSelected'),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                      size: ResponsiveUtils.responsive(
                        context,
                        mobile: 24,
                        tablet: 26,
                        desktop: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            16,
                          ),
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: ThemeUtils.getSubtitleStyle(
                          context,
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  duration: AnimationConstants.fast,
                  scale: isSelected ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathInfo(
    BuildContext context,
    CreateStoreState state,
    CreateStoreController controller,
  ) {
    return FutureBuilder<String>(
      future: state.useDefaultPath
          ? controller.getDefaultStorePath()
          : Future.value(state.selectedPath ?? ''),
      builder: (context, snapshot) {
        final path = snapshot.data ?? '';
        if (path.isEmpty) return const SizedBox.shrink();

        return AnimatedHeightContainer(
          show: path.isNotEmpty,
          child: AdaptiveCard(
            padding: ResponsiveUtils.responsive(
              context,
              mobile: const EdgeInsets.all(16),
              tablet: const EdgeInsets.all(18),
              desktop: const EdgeInsets.all(20),
            ),
            useGradient: true,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    state.useDefaultPath ? Icons.folder_special : Icons.folder,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.useDefaultPath
                            ? 'Стандартная папка'
                            : 'Выбранная папка',
                        style: ThemeUtils.getLabelStyle(
                          context,
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        path,
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveUtils.adaptiveFontSize(
                            context,
                            14,
                          ),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
