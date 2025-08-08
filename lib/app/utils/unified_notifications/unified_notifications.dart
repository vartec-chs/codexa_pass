/// Unified Notification System для Flutter приложений
///
/// Объединенная система уведомлений, которая совмещает возможности
/// SnackBar и Top/Overlay уведомлений в единый API.
///
/// Основные возможности:
/// - Top и Bottom позиционированные уведомления
/// - Приоритетные ошибки с автопрерыванием
/// - Умные очереди сообщений
/// - Прогресс-бары и анимации
/// - Расширения и шаблоны
/// - Гибкая конфигурация
///
/// Пример использования:
/// ```dart
/// import 'package:codexa_pass/app/utils/unified_notifications/unified_notifications.dart';
///
/// // Простое уведомление
/// UnifiedNotification.success('Готово!');
///
/// // С дополнительными параметрами
/// UnifiedNotification.error(
///   'Ошибка загрузки',
///   context: context,
///   subtitle: 'Проверьте подключение',
///   position: NotificationPosition.top,
/// );
///
/// // Прогресс
/// UnifiedNotification.progress(
///   'Загрузка...',
///   progress: 75.0,
///   context: context,
/// );
/// ```

library;

// Основные компоненты
export 'notification_config.dart';
export 'notification_manager.dart';
export 'notification_widget.dart';
export 'notification_extensions.dart';
export 'unified_notification.dart';

// Примеры
export 'examples/unified_notification_demo.dart';
