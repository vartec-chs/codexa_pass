import 'package:codexa_pass/app/utils/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/common/widget/screen_wrapper.dart';
import '../../../app/utils/snack_bar_message.dart';
import 'create_store_control.dart';
import 'models/create_store_models.dart';
import 'widgets/directory_selection_widget_new.dart';
import 'widgets/store_info_widget_new.dart';
import 'widgets/master_password_widget.dart';
import 'widgets/create_store_action_button.dart';

class CreateStore extends ConsumerStatefulWidget {
  const CreateStore({super.key});

  @override
  ConsumerState<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends ConsumerState<CreateStore> {
  @override
  void initState() {
    super.initState();
    // Сбрасываем состояние при входе на экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(createStoreControllerProvider.notifier).reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(createStoreControllerProvider);
    final controller = ref.read(createStoreControllerProvider.notifier);
    final theme = Theme.of(context);

    // Слушаем ошибки
    ref.listen<CreateStoreState>(createStoreControllerProvider, (
      previous,
      next,
    ) {
      if (next.error != null && next.error != previous?.error) {
        SnackBarManager.showError(next.error!);
        controller.clearError();
      }
    });

    return ScreenWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Создание хранилища',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => navigateBack(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Основной контент
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок и описание
                      _buildHeader(theme),

                      const SizedBox(height: 32),

                      // Информация о хранилище
                      const StoreInfoWidget(),

                      const SizedBox(height: 32),

                      // Выбор директории
                      const DirectorySelectionWidget(),

                      const SizedBox(height: 32),

                      // Мастер-пароль
                      const MasterPasswordWidget(),

                      const SizedBox(height: 100), // Отступ для кнопки
                    ],
                  ),
                ),
              ),

              // Кнопка действия (прибита к низу)
              const CreateStoreActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.3),
                theme.colorScheme.secondaryContainer.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.storage,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Новое хранилище',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Создайте безопасное хранилище для ваших паролей с надежным шифрованием',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
