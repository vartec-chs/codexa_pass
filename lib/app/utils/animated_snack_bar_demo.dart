import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'snack_bar_message.dart';

/// Демонстрация анимированных SnackBar уведомлений
class AnimatedSnackBarDemoPage extends StatefulWidget {
  const AnimatedSnackBarDemoPage({super.key});

  @override
  State<AnimatedSnackBarDemoPage> createState() =>
      _AnimatedSnackBarDemoPageState();
}

class _AnimatedSnackBarDemoPageState extends State<AnimatedSnackBarDemoPage> {
  int _demoCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анимированные SnackBar'),

        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              SnackBarManager.clearQueue();
              SnackBarManager.showInfo('Очередь очищена');
              throw Exception('Test error');
            },
            tooltip: 'Очистить очередь',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Описание
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.indigo.shade50],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Новые анимации!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Плавное появление снизу\n'
                    '• Анимация масштабирования\n'
                    '• Bouncing иконки\n'
                    '• Последовательные анимации текста\n'
                    '• Анимированный прогресс-бар',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Базовые анимации
            _buildSection(
              'Основные анимации',
              Icons.play_circle_fill,
              Colors.purple,
              [
                _buildAnimatedButton(
                  'Slide + Fade анимация',
                  'Классическое появление',
                  Colors.blue,
                  Icons.slideshow,
                  () => SnackBarManager.showInfo(
                    'Плавное появление с эффектом slide и fade!',
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Elastic Scale эффект',
                  'Пружинящее масштабирование',
                  Colors.green,
                  Icons.open_in_full,
                  () => SnackBarManager.showSuccess(
                    'Elastic анимация с bouncing эффектом!',
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Bouncing Icon',
                  'Подпрыгивающая иконка',
                  Colors.orange,
                  Icons.sports_basketball,
                  () => SnackBarManager.showWarning(
                    'Смотрите как подпрыгивает иконка!',
                  ),
                ),
              ],
            ),

            // Сложные анимации
            _buildSection(
              'Сложные анимации',
              Icons.auto_fix_high,
              Colors.indigo,
              [
                _buildAnimatedButton(
                  'Последовательные тексты',
                  'Поэтапное появление контента',
                  Colors.teal,
                  Icons.text_fields,
                  () => SnackBarManager.showInfo(
                    'Заголовок появляется первым',
                    subtitle: 'А подзаголовок чуть позже с задержкой',
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Анимированный прогресс',
                  'Волновой эффект прогресс-бара',
                  Colors.deepPurple,
                  Icons.waves,
                  () => SnackBarManager.showInfo(
                    'Загрузка с анимацией',
                    subtitle: 'Смотрите на волновой эффект прогресса',
                    showProgress: true,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Прогресс с значением',
                  'Фиксированный прогресс с анимацией',
                  Colors.pink,
                  Icons.data_usage,
                  () => SnackBarManager.showSuccess(
                    'Загрузка завершена на 75%',
                    subtitle: 'Прогресс-бар с анимированным заполнением',
                    showProgress: true,
                    progress: 75.0,
                  ),
                ),
              ],
            ),

            // Интерактивные элементы
            _buildSection(
              'Интерактивные анимации',
              Icons.touch_app,
              Colors.red,
              [
                _buildAnimatedButton(
                  'Анимированная кнопка действия',
                  'Hover-эффекты на кнопках',
                  Colors.amber,
                  Icons.smart_button,
                  () => SnackBarManager.showWarning(
                    'Наведите мышь на кнопку',
                    subtitle: 'Посмотрите на hover-эффекты',
                    actionLabel: 'Действие',
                    onAction: () {
                      SnackBarManager.showSuccess('Кнопка нажата с анимацией!');
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Анимированное закрытие',
                  'Плавная кнопка закрытия',
                  Colors.cyan,
                  Icons.close_fullscreen,
                  () => SnackBarManager.showError(
                    'Кнопка X анимирована',
                    subtitle: 'Попробуйте навести мышь на кнопку закрытия',
                  ),
                ),
              ],
            ),

            // Демо-последовательность
            _buildSection(
              'Демо последовательности',
              Icons.playlist_play,
              Colors.brown,
              [
                _buildAnimatedButton(
                  'Каскадная анимация',
                  'Серия уведомлений с разными анимациями',
                  Colors.deepOrange,
                  Icons.waterfall_chart,
                  () => _showAnimationCascade(),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Прогресс-симуляция',
                  'Живая анимация загрузки',
                  Colors.lightGreen,
                  Icons.downloading,
                  () => _showProgressSimulation(),
                ),
                const SizedBox(height: 12),
                _buildAnimatedButton(
                  'Стресс-тест анимаций',
                  'Множественные уведомления',
                  Colors.redAccent,
                  Icons.speed,
                  () => _showAnimationStressTest(),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color.darken(0.3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAnimatedButton(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: color.darken(0.4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: color.darken(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_arrow, color: color.withOpacity(0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAnimationCascade() {
    final animations = [
      () => SnackBarManager.showInfo('1️⃣ Первое уведомление'),
      () => SnackBarManager.showWarning('2️⃣ Предупреждение появилось'),
      () => SnackBarManager.showError('3️⃣ Ошибка с анимацией'),
      () => SnackBarManager.showSuccess('4️⃣ Успех завершает каскад!'),
    ];

    for (int i = 0; i < animations.length; i++) {
      Timer(Duration(milliseconds: i * 600), animations[i]);
    }
  }

  void _showProgressSimulation() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      _demoCounter += Random().nextInt(15) + 5;

      if (_demoCounter >= 100) {
        _demoCounter = 100;
        timer.cancel();
        SnackBarManager.showSuccess(
          'Загрузка завершена!',
          subtitle: 'Все файлы успешно загружены',
          showProgress: true,
          progress: 100.0,
        );
        _demoCounter = 0;
      } else {
        SnackBarManager.showInfo(
          'Загрузка файлов...',
          subtitle: 'Обработано ${_demoCounter}% файлов',
          showProgress: true,
          progress: _demoCounter.toDouble(),
        );
      }
    });
  }

  void _showAnimationStressTest() {
    final messages = [
      ('🚀 Запуск теста', SnackBarType.info),
      ('⚡ Высокая нагрузка', SnackBarType.warning),
      ('🔥 Пиковая нагрузка', SnackBarType.error),
      ('📊 Сбор метрик', SnackBarType.info),
      ('✅ Тест пройден!', SnackBarType.success),
      ('🎯 Анимации работают!', SnackBarType.success),
    ];

    for (int i = 0; i < messages.length; i++) {
      Timer(Duration(milliseconds: i * 400), () {
        final (message, type) = messages[i];
        switch (type) {
          case SnackBarType.info:
            SnackBarManager.showInfo(message);
            break;
          case SnackBarType.warning:
            SnackBarManager.showWarning(message);
            break;
          case SnackBarType.error:
            SnackBarManager.showError(message);
            break;
          case SnackBarType.success:
            SnackBarManager.showSuccess(message);
            break;
        }
      });
    }
  }
}

extension ColorExtension on Color {
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }
}
