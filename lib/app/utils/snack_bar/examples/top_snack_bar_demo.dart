import 'package:flutter/material.dart';
import '../top_snack_bar.dart';

/// Демо-страница для Top Snack Bar
class TopSnackBarDemo extends StatefulWidget {
  const TopSnackBarDemo({super.key});

  @override
  State<TopSnackBarDemo> createState() => _TopSnackBarDemoState();
}

class _TopSnackBarDemoState extends State<TopSnackBarDemo> {
  @override
  void dispose() {
    // Очищаем ресурсы при закрытии страницы
    TopSnackBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Snack Bar Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              final queueInfo = TopSnackBarAdvanced.getQueueInfo();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(queueInfo.toString())));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Базовые примеры
            _buildSectionTitle('Базовые примеры'),
            const SizedBox(height: 16),

            _buildButtonGrid([
              _buildDemoButton(
                'Success',
                Colors.green,
                Icons.check,
                () => TopSnackBar.showSuccess(
                  context,
                  'Операция выполнена успешно!',
                  subtitle: 'Все данные сохранены',
                ),
              ),
              _buildDemoButton(
                'Error',
                Colors.red,
                Icons.error,
                () => TopSnackBar.showError(
                  context,
                  'Произошла ошибка',
                  subtitle: 'Проверьте подключение к интернету',
                ),
              ),
              _buildDemoButton(
                'Warning',
                Colors.orange,
                Icons.warning,
                () => TopSnackBar.showWarning(
                  context,
                  'Внимание!',
                  subtitle: 'Проверьте введенные данные',
                ),
              ),
              _buildDemoButton(
                'Info',
                Colors.blue,
                Icons.info,
                () => TopSnackBar.showInfo(
                  context,
                  'Информация',
                  subtitle: 'Новая версия доступна',
                ),
              ),
            ]),

            const SizedBox(height: 32),

            // Расширенные примеры
            _buildSectionTitle('Расширенные возможности'),
            const SizedBox(height: 16),

            _buildButtonGrid([
              _buildDemoButton(
                'Критическая ошибка',
                Colors.red[800]!,
                Icons.error_outline,
                () => TopSnackBarAdvanced.showCriticalError(
                  context,
                  'Критическая ошибка системы!',
                  subtitle: 'Требуется немедленное внимание',
                ),
              ),
              _buildDemoButton(
                'Важное предупреждение',
                Colors.deepOrange,
                Icons.priority_high,
                () => TopSnackBarAdvanced.showImportantWarning(
                  context,
                  'Важное предупреждение',
                  subtitle: 'Обратите внимание на это сообщение',
                ),
              ),
              _buildDemoButton(
                'Последовательность',
                Colors.purple,
                Icons.list,
                () => TopSnackBarAdvanced.showSequence(context, [
                  'Инициализация...',
                  'Загрузка данных...',
                  'Обработка...',
                  'Завершение',
                ], type: TopSnackBarType.info),
              ),
              _buildDemoButton(
                'Прогресс операции',
                Colors.teal,
                Icons.refresh,
                () => TopSnackBarAdvanced.showProgress(
                  context,
                  'Синхронизация данных',
                  onComplete: () => print('Операция завершена!'),
                  onCancel: () => print('Операция отменена'),
                ),
              ),
            ]),

            const SizedBox(height: 32),

            // Управление
            _buildSectionTitle('Управление'),
            const SizedBox(height: 16),

            _buildButtonGrid([
              _buildDemoButton(
                'Скрыть текущее',
                Colors.grey,
                Icons.visibility_off,
                () => TopSnackBar.hide(),
              ),
              _buildDemoButton(
                'Очистить очередь',
                Colors.grey[600]!,
                Icons.clear_all,
                () {
                  TopSnackBar.clearQueue();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Очередь очищена')),
                  );
                },
              ),
              _buildDemoButton('Пауза очереди', Colors.amber, Icons.pause, () {
                TopSnackBarAdvanced.pauseQueue();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Очередь приостановлена')),
                );
              }),
              _buildDemoButton(
                'Возобновить',
                Colors.green[600]!,
                Icons.play_arrow,
                () {
                  TopSnackBarAdvanced.resumeQueue();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Очередь возобновлена')),
                  );
                },
              ),
            ]),

            const SizedBox(height: 32),

            // Информация о состоянии
            _buildStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildButtonGrid(List<Widget> buttons) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: buttons,
    );
  }

  Widget _buildDemoButton(
    String title,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Состояние системы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            StreamBuilder<void>(
              stream: Stream.periodic(const Duration(milliseconds: 500)),
              builder: (context, snapshot) {
                final queueInfo = TopSnackBarAdvanced.getQueueInfo();
                return Column(
                  children: [
                    _buildStatusRow(
                      'Показывается сейчас',
                      queueInfo.isShowing ? 'Да' : 'Нет',
                      queueInfo.isShowing ? Colors.green : Colors.grey,
                    ),
                    _buildStatusRow(
                      'Всего в очереди',
                      queueInfo.totalCount.toString(),
                      queueInfo.totalCount > 0 ? Colors.blue : Colors.grey,
                    ),
                    _buildStatusRow(
                      'Ошибки',
                      queueInfo.errorCount.toString(),
                      queueInfo.errorCount > 0 ? Colors.red : Colors.grey,
                    ),
                    _buildStatusRow(
                      'Предупреждения',
                      queueInfo.warningCount.toString(),
                      queueInfo.warningCount > 0 ? Colors.orange : Colors.grey,
                    ),
                    if (queueInfo.nextMessageType != null)
                      _buildStatusRow(
                        'Следующее сообщение',
                        queueInfo.nextMessageType.toString().split('.').last,
                        Colors.purple,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
