import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/utils/animation_utils.dart';
import '../../../../app/utils/theme_utils.dart';
import '../../../../app/utils/responsive_utils.dart';
import '../create_store_control.dart';

class StoreInfoWidget extends ConsumerWidget {
  const StoreInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createStoreControllerProvider);
    final controller = ref.read(createStoreControllerProvider.notifier);

    return AnimatedAppearance(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Информация о хранилище',
            style: ThemeUtils.getHeadingStyle(
              context,
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 16),
            ),
          ),
          const SizedBox(height: 16),

          // Поле имени
          _buildInputField(
            context: context,
            label: 'Название хранилища *',
            hint: 'Введите название хранилища',
            value: state.name,
            onChanged: controller.updateName,
            icon: Icons.storage,
          ),

          const SizedBox(height: 16),

          // Поле описания
          _buildInputField(
            context: context,
            label: 'Описание (опционально)',
            hint: 'Добавьте описание хранилища',
            value: state.description,
            onChanged: controller.updateDescription,
            icon: Icons.description,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ThemeUtils.getLabelStyle(context)),
        const SizedBox(height: 8),

        AnimatedColorContainer(
          color: Colors.transparent,
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            maxLines: maxLines,
            style: GoogleFonts.inter(
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 16),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: ThemeUtils.getSubtitleStyle(context, opacity: 0.5),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: ThemeUtils.getBorderColor(context),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: ThemeUtils.getBorderColor(context, opacity: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: ThemeUtils.getSurfaceColor(context, elevation: 1),
              contentPadding: ResponsiveUtils.responsive(
                context,
                mobile: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                tablet: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                desktop: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
