import 'package:flutter/material.dart';
import 'package:codexa_pass/app/common/widget/swipe_button.dart';

/// Демонстрационная страница с примерами использования SwipeButton
class SwipeButtonDemo extends StatefulWidget {
  const SwipeButtonDemo({super.key});

  @override
  State<SwipeButtonDemo> createState() => _SwipeButtonDemoState();
}

class _SwipeButtonDemoState extends State<SwipeButtonDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _lastAction = '';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _simulateAction(String action) async {
    setState(() {
      _isLoading = true;
      _lastAction = action;
    });

    _showSnackBar('$action выполняется...');

    // Имитируем выполнение действия
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('$action выполнено успешно!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('SwipeButton Demo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок
            Text(
              'Примеры использования SwipeButton',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Переиспользуемый компонент для подтверждения действий',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            if (_isLoading) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text('Выполняется: $_lastAction'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Базовый пример
            _buildSection(
              'Базовое использование',
              'Стандартная кнопка с настройками по умолчанию',
              SwipeButton(
                onSwipeComplete: () => _simulateAction('Базовое действие'),
                text: 'Свайпните для подтверждения',
              ),
            ),

            // Пример с опасным действием
            _buildSection(
              'Опасное действие',
              'Красная кнопка для удаления или других критических действий',
              SwipeButtonStyles.danger(
                onSwipeComplete: () => _simulateAction('Удаление'),
              ),
            ),

            // Пример с успешным действием
            _buildSection(
              'Успешное действие',
              'Зеленая кнопка для подтверждения или сохранения',
              SwipeButtonStyles.success(
                onSwipeComplete: () => _simulateAction('Сохранение'),
              ),
            ),

            // Пример с предупреждением
            _buildSection(
              'Предупреждение',
              'Оранжевая кнопка для действий, требующих внимания',
              SwipeButtonStyles.warning(
                onSwipeComplete: () => _simulateAction('Важное действие'),
              ),
            ),

            // Пример с информацией
            _buildSection(
              'Информация',
              'Синяя кнопка для информационных действий',
              SwipeButtonStyles.info(
                onSwipeComplete: () => _simulateAction('Просмотр информации'),
              ),
            ),

            // Кастомизированный пример
            _buildSection(
              'Кастомная кнопка',
              'Полностью настроенная кнопка с уникальным дизайном',
              SwipeButton(
                onSwipeComplete: () => _simulateAction('Кастомное действие'),
                text: 'Свайп для магии ✨',
                icon: Icons.auto_awesome,
                height: 70,
                backgroundColor: Colors.purple.withOpacity(0.1),
                sliderColor: Colors.purple,
                textColor: Colors.purple.shade700,
                borderColor: Colors.purple.shade300,
                iconColor: Colors.white,
                borderRadius: 35,
                sliderBorderRadius: 30,
                fontSize: 18,
                iconSize: 28,
                threshold: 0.7,
              ),
            ),

            // Современный стиль
            _buildSection(
              'Современный стиль',
              'Кнопка с минималистичным дизайном и квадратными углами',
              SwipeButton(
                onSwipeComplete: () => _simulateAction('Современное действие'),
                text: 'Свайп для продолжения',
                icon: Icons.arrow_forward_ios,
                height: 60,
                backgroundColor: Colors.grey.shade100,
                sliderColor: Colors.black87,
                textColor: Colors.black87,
                borderColor: Colors.grey.shade300,
                iconColor: Colors.white,
                borderRadius: 12,
                sliderBorderRadius: 8,
                fontSize: 16,
                iconSize: 20,
                borderWidth: 1,
              ),
            ),

            // Компактная кнопка
            _buildSection(
              'Компактная кнопка',
              'Меньший размер для использования в ограниченном пространстве',
              SwipeButton(
                onSwipeComplete: () => _simulateAction('Компактное действие'),
                text: 'Свайп →',
                height: 45,
                fontSize: 14,
                iconSize: 20,
                borderRadius: 22.5,
              ),
            ),

            // Широкая кнопка
            _buildSection(
              'Широкая кнопка',
              'Увеличенная высота для лучшей видимости',
              SwipeButton(
                onSwipeComplete: () => _simulateAction('Широкое действие'),
                text: 'Свайпните для продолжения процесса',
                height: 80,
                fontSize: 18,
                iconSize: 32,
                borderRadius: 40,
                icon: Icons.play_arrow,
              ),
            ),

            // Продвинутая кнопка с двойным подтверждением
            _buildSection(
              'Двойное подтверждение',
              'Требует двух свайпов для выполнения критического действия',
              AdvancedSwipeButton(
                onSwipeComplete: () => _simulateAction('Критическое действие'),
                text: 'Критическое действие',
                icon: Icons.warning_amber,
                requiresDoubleConfirmation: true,
                backgroundColor: Colors.red.withOpacity(0.1),
                sliderColor: Colors.red,
                textColor: Colors.red.shade700,
                timeoutDuration: const Duration(seconds: 10),
                onTimeout: () =>
                    _showSnackBar('Время для подтверждения истекло'),
              ),
            ),

            // Отключенная кнопка
            _buildSection(
              'Отключенная кнопка',
              'Неактивная кнопка для демонстрации состояния',
              SwipeButton(
                onSwipeComplete: () {},
                text: 'Действие недоступно',
                enabled: false,
                backgroundColor: Colors.grey.withOpacity(0.1),
                sliderColor: Colors.grey,
                textColor: Colors.grey,
                borderColor: Colors.grey.shade300,
              ),
            ),

            const SizedBox(height: 32),

            // Информация об использовании
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Как использовать:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Добавьте import для SwipeButton'),
                    const Text(
                      '2. Используйте готовые стили или создайте свой',
                    ),
                    const Text('3. Установите onSwipeComplete callback'),
                    const Text('4. Настройте внешний вид по необходимости'),
                    const SizedBox(height: 16),
                    Text(
                      'Особенности:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Анимации и тактильная обратная связь'),
                    const Text('• Настраиваемые цвета и размеры'),
                    const Text('• Готовые стили для разных типов действий'),
                    const Text('• Поддержка двойного подтверждения'),
                    const Text('• Автоматический сброс при неполном свайпе'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, Widget swipeButton) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            swipeButton,
          ],
        ),
      ),
    );
  }
}
