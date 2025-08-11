import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../toast_manager_export.dart';

/// Демо-страница для тестирования Toast Manager
class ToastManagerDemo extends StatefulWidget {
  const ToastManagerDemo({super.key});

  @override
  State<ToastManagerDemo> createState() => _ToastManagerDemoState();
}

class _ToastManagerDemoState extends State<ToastManagerDemo> {
  @override
  void initState() {
    super.initState();
    // Toast Manager уже инициализирован в app.dart с глобальным navigatorKey
  }

  @override
  void dispose() {
    ToastManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast Manager Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              ToastUtils.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Все тосты очищены')),
              );
            },
            tooltip: 'Очистить все тосты',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              final stats = ToastUtils.getStats();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(stats)));
            },
            tooltip: 'Статистика',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Базовые тосты'),
            _buildBasicToastsSection(),

            const SizedBox(height: 24),
            _buildSectionTitle('Тосты с действиями'),
            _buildActionToastsSection(),

            const SizedBox(height: 24),
            _buildSectionTitle('Специальные тосты'),
            _buildSpecialToastsSection(),

            const SizedBox(height: 24),
            _buildSectionTitle('Тестирование очереди'),
            _buildQueueTestSection(),

            const SizedBox(height: 24),
            _buildSectionTitle('Настройки позиции'),
            _buildPositionTestSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBasicToastsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Успех',
                Colors.green,
                Icons.check_circle,
                () => ToastUtils.success(
                  'Операция выполнена успешно',
                  subtitle: 'Данные сохранены в базу',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Ошибка',
                Colors.red,
                Icons.error,
                () => ToastUtils.error(
                  'Произошла ошибка',
                  subtitle: 'Не удалось подключиться к серверу',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Предупреждение',
                Colors.orange,
                Icons.warning,
                () => ToastUtils.warning(
                  'Внимание!',
                  subtitle: 'Низкий уровень заряда батареи',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Информация',
                Colors.blue,
                Icons.info,
                () => ToastUtils.info(
                  'Новое обновление',
                  subtitle: 'Доступна версия 2.1.0',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionToastsSection() {
    return Column(
      children: [
        _buildDemoButton(
          'Подтверждение действия',
          Colors.amber,
          Icons.help_outline,
          () => ToastUtils.confirmAction(
            title: 'Удалить файл?',
            subtitle: 'Это действие нельзя отменить',
            confirmLabel: 'Удалить',
            onConfirm: () {
              ToastUtils.success('Файл удален');
            },
            type: ToastType.error,
          ),
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Сохранение',
          Colors.blue,
          Icons.save,
          () => ToastUtils.saveAction(
            title: 'Сохранить изменения?',
            subtitle: 'Файл был изменен',
            onSave: () {
              ToastUtils.success('Файл сохранен');
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Отмена действия',
          Colors.orange,
          Icons.undo,
          () => ToastUtils.undoAction(
            title: 'Элемент удален',
            subtitle: 'Нажмите "Отменить" чтобы восстановить',
            onUndo: () {
              ToastUtils.info('Действие отменено');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialToastsSection() {
    return Column(
      children: [
        _buildDemoButton(
          'Прогресс операции',
          Colors.teal,
          Icons.refresh,
          () => ToastUtils.progress(
            title: 'Синхронизация данных',
            subtitle: 'Пожалуйста, подождите...',
            duration: const Duration(seconds: 5),
          ),
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Тост с кастомными действиями',
          Colors.purple,
          Icons.settings,
          () => ToastUtils.withActions(
            title: 'Настройки изменены',
            subtitle: 'Требуется перезапуск приложения',
            actions: [
              ToastAction(
                label: 'Позже',
                onPressed: () => ToastUtils.info('Перезапуск отложен'),
                icon: Icons.schedule,
              ),
              ToastAction(
                label: 'Перезапустить',
                onPressed: () => ToastUtils.success('Перезапуск...'),
                color: Colors.green,
                icon: Icons.refresh,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildDemoButton('Копирование в буфер', Colors.indigo, Icons.copy, () {
          const text = 'Пример текста для копирования';
          Clipboard.setData(const ClipboardData(text: text));

          ToastUtils.withActions(
            title: 'Текст скопирован',
            subtitle: text,
            actions: [
              ToastAction(
                label: 'Вставить',
                onPressed: () => ToastUtils.info('Текст вставлен'),
                icon: Icons.paste,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildQueueTestSection() {
    return Column(
      children: [
        _buildDemoButton(
          'Добавить 5 тостов подряд',
          Colors.cyan,
          Icons.queue,
          () {
            for (int i = 1; i <= 5; i++) {
              Future.delayed(Duration(milliseconds: i * 100), () {
                ToastUtils.info(
                  'Тост номер $i',
                  subtitle: 'Автоматически добавлен в очередь',
                );
              });
            }
          },
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Приоритетная ошибка',
          Colors.red[700]!,
          Icons.priority_high,
          () => ToastUtils.error(
            'Критическая ошибка!',
            subtitle: 'Этот тост имеет высокий приоритет и пройдет вперед',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Очистить очередь',
                Colors.grey,
                Icons.clear_all,
                () {
                  ToastManager.clearQueue();
                  ToastUtils.info('Очередь очищена');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Скрыть все',
                Colors.grey[700]!,
                Icons.visibility_off,
                () {
                  ToastManager.dismissAll();
                  ToastUtils.info('Все тосты скрыты');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPositionTestSection() {
    return Column(
      children: [
        // Top positions
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Сверху',
                Colors.blue,
                Icons.vertical_align_top,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост сверху',
                    subtitle: 'Позиция: ToastPosition.top',
                    type: ToastType.info,
                    position: ToastPosition.top,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Сверху слева',
                Colors.blue[700]!,
                Icons.north_west,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост сверху слева',
                    subtitle: 'Позиция: ToastPosition.topLeft',
                    type: ToastType.info,
                    position: ToastPosition.topLeft,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Сверху справа',
                Colors.blue[300]!,
                Icons.north_east,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост сверху справа',
                    subtitle: 'Позиция: ToastPosition.topRight',
                    type: ToastType.info,
                    position: ToastPosition.topRight,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom positions
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Снизу',
                Colors.green,
                Icons.vertical_align_bottom,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост снизу',
                    subtitle: 'Позиция: ToastPosition.bottom',
                    type: ToastType.success,
                    position: ToastPosition.bottom,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Снизу слева',
                Colors.green[700]!,
                Icons.south_west,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост снизу слева',
                    subtitle: 'Позиция: ToastPosition.bottomLeft',
                    type: ToastType.success,
                    position: ToastPosition.bottomLeft,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Снизу справа',
                Colors.green[300]!,
                Icons.south_east,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост снизу справа',
                    subtitle: 'Позиция: ToastPosition.bottomRight',
                    type: ToastType.success,
                    position: ToastPosition.bottomRight,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Side positions
        Row(
          children: [
            Expanded(
              child: _buildDemoButton(
                'Слева',
                Colors.purple,
                Icons.west,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост слева',
                    subtitle: 'Позиция: ToastPosition.left',
                    type: ToastType.warning,
                    position: ToastPosition.left,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDemoButton(
                'Справа',
                Colors.orange,
                Icons.east,
                () => ToastManager.show(
                  ToastConfig(
                    id: ToastManager.generateId(),
                    title: 'Тост справа',
                    subtitle: 'Позиция: ToastPosition.right',
                    type: ToastType.error,
                    position: ToastPosition.right,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Тест прогресс-бара',
          Colors.indigo,
          Icons.timer,
          () => ToastManager.show(
            ToastConfig(
              id: ToastManager.generateId(),
              title: 'Тост с прогресс-баром',
              subtitle: 'Наведите мышь чтобы остановить таймер',
              type: ToastType.info,
              duration: const Duration(seconds: 10),
              showProgressBar: true,
              showCloseButton: true,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Отложенный тост',
          Colors.amber[700]!,
          Icons.schedule,
          () {
            // Симулируем отложенный тост
            ToastManager.showPending(
              ToastConfig(
                id: ToastManager.generateId(),
                title: 'Отложенный тост',
                subtitle: 'Этот тост был создан как отложенный',
                type: ToastType.warning,
                duration: const Duration(seconds: 6),
                showProgressBar: true,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildDemoButton(
          'Длинный тост без кнопки закрытия',
          Colors.deepOrange,
          Icons.timer,
          () => ToastManager.show(
            ToastConfig(
              id: ToastManager.generateId(),
              title:
                  'Очень длинный заголовок тоста который может не поместиться в одну строку',
              subtitle:
                  'Также очень длинное описание, которое демонстрирует как тост обрабатывает большие объемы текста и переносы строк',
              type: ToastType.warning,
              duration: const Duration(seconds: 8),
              showCloseButton: false,
              dismissible: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
