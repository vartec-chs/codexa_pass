import 'package:flutter/material.dart';
import 'package:codexa_pass/app/utils/scaffold_messenger_manager/index.dart';

/// Компактный виджет для быстрого тестирования ScaffoldMessengerManager
/// в режиме разработки. Можно легко добавить в любой экран.
class MessengerDebugPanel extends StatefulWidget {
  /// Показывать ли панель в production режиме
  final bool showInProduction;

  /// Позиция панели на экране
  final MessengerDebugPosition position;

  const MessengerDebugPanel({
    super.key,
    this.showInProduction = false,
    this.position = MessengerDebugPosition.bottomRight,
  });

  @override
  State<MessengerDebugPanel> createState() => _MessengerDebugPanelState();
}

class _MessengerDebugPanelState extends State<MessengerDebugPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.top,
      bottom: widget.position.bottom,
      left: widget.position.left,
      right: widget.position.right,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: _isExpanded ? 280 : 56,
          height: _isExpanded ? 200 : 56,
          child: _isExpanded ? _buildExpandedPanel() : _buildCollapsedPanel(),
        ),
      ),
    );
  }

  Widget _buildCollapsedPanel() {
    return InkWell(
      onTap: _togglePanel,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            // Индикатор очереди
            Positioned(
              top: 8,
              right: 8,
              child: StreamBuilder<int>(
                stream: Stream.periodic(
                  const Duration(milliseconds: 500),
                  (_) => ScaffoldMessengerManager.instance.queueLength,
                ),
                builder: (context, snapshot) {
                  final queueLength = snapshot.data ?? 0;
                  if (queueLength == 0) return const SizedBox.shrink();

                  return Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      queueLength > 9 ? '9+' : queueLength.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedPanel() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с кнопкой закрытия
          Row(
            children: [
              Text(
                'Messenger',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: _togglePanel,
                icon: const Icon(Icons.close),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Быстрые кнопки
          Expanded(
            child: Column(
              children: [
                // Первая строка кнопок
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickButton(
                        'Error',
                        Icons.error_outline,
                        Colors.red,
                        () => context.showError('Test error message'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildQuickButton(
                        'Warn',
                        Icons.warning_amber_outlined,
                        Colors.orange,
                        () => context.showWarning('Test warning'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Вторая строка кнопок
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickButton(
                        'Info',
                        Icons.info_outline,
                        Colors.blue,
                        () => context.showInfo('Test info message'),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildQuickButton(
                        'Success',
                        Icons.check_circle_outline,
                        Colors.green,
                        () => context.showSuccess('Test success'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Управляющие кнопки
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Queue',
                        Icons.queue,
                        () => _testQueue(),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildActionButton(
                        'Clear',
                        Icons.clear_all,
                        () => ScaffoldMessengerManager.instance
                            .clearSnackBarQueue(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Banner тест
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(
                    'Test Banner',
                    Icons.announcement,
                    () => MessengerPresets.updateAvailable(
                      onUpdate: () => context.showSuccess('Update started!'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 28,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _togglePanel() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _testQueue() {
    final messenger = ScaffoldMessengerManager.instance;
    messenger.showError('Queue test 1');
    messenger.showWarning('Queue test 2');
    messenger.showInfo('Queue test 3');
    messenger.showSuccess('Queue test 4');
  }
}

/// Позиции для размещения отладочной панели
enum MessengerDebugPosition { topLeft, topRight, bottomLeft, bottomRight }

extension MessengerDebugPositionExtension on MessengerDebugPosition {
  double? get top {
    switch (this) {
      case MessengerDebugPosition.topLeft:
      case MessengerDebugPosition.topRight:
        return 100.0;
      default:
        return null;
    }
  }

  double? get bottom {
    switch (this) {
      case MessengerDebugPosition.bottomLeft:
      case MessengerDebugPosition.bottomRight:
        return 100.0;
      default:
        return null;
    }
  }

  double? get left {
    switch (this) {
      case MessengerDebugPosition.topLeft:
      case MessengerDebugPosition.bottomLeft:
        return 16.0;
      default:
        return null;
    }
  }

  double? get right {
    switch (this) {
      case MessengerDebugPosition.topRight:
      case MessengerDebugPosition.bottomRight:
        return 16.0;
      default:
        return null;
    }
  }
}

/// Виджет-обертка для автоматического добавления отладочной панели
class MessengerDebugWrapper extends StatelessWidget {
  final Widget child;
  final bool showDebugPanel;
  final MessengerDebugPosition debugPosition;

  const MessengerDebugWrapper({
    super.key,
    required this.child,
    this.showDebugPanel = true,
    this.debugPosition = MessengerDebugPosition.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showDebugPanel) MessengerDebugPanel(position: debugPosition),
      ],
    );
  }
}
