import 'package:flutter/material.dart';
import 'package:codexa_pass/app/common/widget/messenger_demo_widget.dart';
import 'package:codexa_pass/app/common/widget/simple_messenger_test.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/examples/app_integration_example.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/examples/modern_snack_bar_demo.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/examples/snack_bar_fix_test.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/examples/modern_banner_demo.dart';

class TestDemo extends StatelessWidget {
  const TestDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger Test Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Карточка с информацией
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.message,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ScaffoldMessengerManager',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Современный менеджер уведомлений с поддержкой очереди, '
                      'тем и SOLID принципов',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Варианты демо
            Text(
              'Выберите тип демонстрации:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Простое демо
            Card(
              child: ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Простое демо'),
                subtitle: const Text('Быстрый тест с отладочной панелью'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SimpleMessengerTest(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Полное демо
            Card(
              child: ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Полное демо'),
                subtitle: const Text('Все возможности и настройки'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: const Text('Полное демо')),
                      body: const SingleChildScrollView(
                        child: MessengerDemoWidget(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Встроенное демо
            Card(
              child: ListTile(
                leading: const Icon(Icons.integration_instructions),
                title: const Text('Встроенное демо'),
                subtitle: const Text('Примеры интеграции'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AppExample()),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Современные SnackBar
            Card(
              child: ListTile(
                leading: const Icon(Icons.auto_awesome),
                title: const Text('Современные SnackBar'),
                subtitle: const Text('Анимации и современный UI'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ModernSnackBarDemo(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Тест исправлений
            Card(
              child: ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: const Text('Тест исправлений'),
                subtitle: const Text('Проверка видимости и расположения'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SnackBarFixTest(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Современные MaterialBanner
            Card(
              child: ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: const Text('Современные MaterialBanner'),
                subtitle: const Text('Баннеры с современным дизайном'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ModernBannerDemo(),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Быстрый тест
            const QuickMessengerDemo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWelcomeDemo(context),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Демо'),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('О ScaffoldMessengerManager'),
        content: const Text(
          'Этот менеджер предоставляет:\n\n'
          '• Очередь SnackBar с автообработкой\n'
          '• 4 типа уведомлений (Error, Warning, Info, Success)\n'
          '• MaterialBanner для важных сообщений\n'
          '• Готовые пресеты для типичных сценариев\n'
          '• Поддержка тем и кастомизация\n'
          '• SOLID принципы и тестируемость\n'
          '• Расширения для удобного использования\n'
          '• Отладочная панель для разработки',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  void _showWelcomeDemo(BuildContext context) {
    // Демонстрационная последовательность
    context.showInfo('Добро пожаловать в демо!');

    Future.delayed(const Duration(seconds: 1), () {
      context.showSuccess('Загрузка компонентов...');
    });

    Future.delayed(const Duration(seconds: 2), () {
      MessengerPresets.updateAvailable(
        onUpdate: () {
          context.showInfo('Начинается обновление демо...');
          Future.delayed(const Duration(seconds: 1), () {
            context.showSuccess('Демо готово к использованию!');
          });
        },
      );
    });
  }
}
