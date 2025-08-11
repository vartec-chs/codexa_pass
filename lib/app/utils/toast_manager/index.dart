/// Toast Manager - Система управления уведомлениями
///
/// Полнофункциональный менеджер тостов для Flutter приложения
/// с поддержкой очередей, анимаций, тем и приоритетов.
///
/// Основные возможности:
/// - Очередь тостов с приоритетами
/// - Максимум 3 активных тоста одновременно
/// - Красивые анимации появления/исчезновения
/// - Поддержка светлой и темной темы
/// - Типы: Success, Error, Warning, Info
/// - Позиционирование сверху или снизу
/// - Кастомные действия и кнопки
/// - Прогресс-бар времени отображения
/// - Overlay система для точного позиционирования
///
/// Быстрый старт:
/// ```dart
/// // Простые тосты
/// ToastUtils.success('Операция выполнена');
/// ToastUtils.error('Произошла ошибка');
/// ToastUtils.warning('Внимание!');
/// ToastUtils.info('Информация');
///
/// // Через контекст
/// context.showToastSuccess('Успех!');
/// context.showToastError('Ошибка!');
///
/// // С действиями
/// ToastUtils.confirmAction(
///   title: 'Удалить файл?',
///   confirmLabel: 'Удалить',
///   onConfirm: () => deleteFile(),
/// );
/// ```

library toast_manager;

export 'toast_manager.dart';
export 'toast_models.dart';
export 'toast_ui.dart';
export 'toast_utils.dart';
export 'demo/toast_demo.dart';
