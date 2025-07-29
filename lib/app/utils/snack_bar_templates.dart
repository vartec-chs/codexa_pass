import 'package:flutter/material.dart';
import 'snack_bar_message.dart';

/// Готовые шаблоны уведомлений для типичных сценариев
class SnackBarTemplates {
  /// Ошибка сети
  static void showNetworkError({VoidCallback? onRetry}) {
    SnackBarManager.showError(
      'Нет подключения к интернету',
      subtitle: 'Проверьте сетевое соединение и попробуйте снова',
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
      customIcon: const Icon(Icons.wifi_off_outlined),
      duration: const Duration(seconds: 8),
    );
  }

  /// Успешное подключение к сети
  static void showNetworkSuccess() {
    SnackBarManager.showSuccess(
      'Подключение восстановлено',
      subtitle: 'Интернет-соединение работает стабильно',
      customIcon: const Icon(Icons.wifi_outlined),
      duration: const Duration(seconds: 3),
    );
  }

  /// Успешный вход в систему
  static void showLoginSuccess(String username) {
    SnackBarManager.showSuccess(
      'Добро пожаловать, $username!',
      subtitle: 'Вы успешно авторизованы в системе',
      customIcon: const Icon(Icons.person_outline),
    );
  }

  /// Ошибка авторизации
  static void showLoginError({VoidCallback? onRetry}) {
    SnackBarManager.showError(
      'Ошибка авторизации',
      subtitle: 'Неверный логин или пароль',
      actionLabel: onRetry != null ? 'Попробовать снова' : null,
      onAction: onRetry,
      customIcon: const Icon(Icons.lock_outline),
    );
  }

  /// Файл сохранен
  static void showFileSaved(String fileName) {
    SnackBarManager.showSuccess(
      'Файл сохранен',
      subtitle: fileName,
      customIcon: const Icon(Icons.save_outlined),
    );
  }

  /// Файл удален
  static void showFileDeleted(String fileName, {VoidCallback? onUndo}) {
    SnackBarManager.showWarning(
      'Файл удален',
      subtitle: fileName,
      actionLabel: onUndo != null ? 'Отменить' : null,
      onAction: onUndo,
      customIcon: const Icon(Icons.delete_outline),
      duration: const Duration(seconds: 6),
    );
  }

  /// Текст скопирован в буфер
  static void showCopiedToClipboard(String text) {
    final displayText = text.length > 30 ? '${text.substring(0, 30)}...' : text;
    SnackBarManager.showInfo(
      'Скопировано в буфер обмена',
      subtitle: displayText,
      customIcon: const Icon(Icons.content_copy_outlined),
      duration: const Duration(seconds: 2),
    );
  }

  /// Доступно обновление
  static void showUpdateAvailable({VoidCallback? onUpdate}) {
    SnackBarManager.showInfo(
      'Доступно обновление',
      subtitle: 'Новая версия приложения готова к установке',
      actionLabel: onUpdate != null ? 'Обновить' : null,
      onAction: onUpdate,
      customIcon: const Icon(Icons.system_update_outlined),
      duration: const Duration(seconds: 10),
    );
  }

  /// Синхронизация в процессе
  static void showSyncInProgress() {
    SnackBarManager.showInfo(
      'Синхронизация данных',
      subtitle: 'Обновление информации с сервером...',
      showProgress: true,
      customIcon: const Icon(Icons.sync_outlined),
      duration: const Duration(seconds: 8),
    );
  }

  /// Синхронизация завершена
  static void showSyncCompleted() {
    SnackBarManager.showSuccess(
      'Синхронизация завершена',
      subtitle: 'Все данные актуальны',
      customIcon: const Icon(Icons.sync_outlined),
    );
  }

  /// Ошибка валидации формы
  static void showValidationError(String fieldName) {
    SnackBarManager.showError(
      'Ошибка валидации',
      subtitle: 'Проверьте правильность заполнения поля "$fieldName"',
      customIcon: const Icon(Icons.error_outline),
    );
  }

  /// Форма успешно отправлена
  static void showFormSubmitted() {
    SnackBarManager.showSuccess(
      'Данные отправлены',
      subtitle: 'Ваша информация успешно сохранена',
      customIcon: const Icon(Icons.check_circle_outline),
    );
  }

  /// Низкий заряд батареи
  static void showLowBattery(int batteryLevel) {
    SnackBarManager.showWarning(
      'Низкий заряд батареи',
      subtitle: 'Осталось $batteryLevel%. Подключите зарядное устройство',
      customIcon: const Icon(Icons.battery_alert_outlined),
      duration: const Duration(seconds: 6),
    );
  }

  /// Режим энергосбережения
  static void showPowerSaveMode() {
    SnackBarManager.showInfo(
      'Режим энергосбережения активен',
      subtitle: 'Некоторые функции могут быть ограничены',
      customIcon: const Icon(Icons.battery_saver_outlined),
    );
  }

  /// Превышен лимит попыток
  static void showRateLimitExceeded(Duration waitTime) {
    final minutes = waitTime.inMinutes;
    final seconds = waitTime.inSeconds % 60;

    String timeText = '';
    if (minutes > 0) {
      timeText = '${minutes}м ${seconds}с';
    } else {
      timeText = '${seconds}с';
    }

    SnackBarManager.showError(
      'Превышен лимит попыток',
      subtitle: 'Попробуйте снова через $timeText',
      customIcon: const Icon(Icons.timer_outlined),
      duration: const Duration(seconds: 8),
    );
  }

  /// Сессия истекла
  static void showSessionExpired({VoidCallback? onLogin}) {
    SnackBarManager.showWarning(
      'Сессия истекла',
      subtitle: 'Необходимо войти в систему заново',
      actionLabel: onLogin != null ? 'Войти' : null,
      onAction: onLogin,
      customIcon: const Icon(Icons.access_time_outlined),
      duration: const Duration(seconds: 8),
    );
  }

  /// Новые уведомления
  static void showNewNotifications(int count) {
    SnackBarManager.showInfo(
      count == 1 ? 'Новое уведомление' : 'Новых уведомлений: $count',
      subtitle: 'Нажмите для просмотра',
      customIcon: const Icon(Icons.notifications_outlined),
    );
  }

  /// Обслуживание сервера
  static void showMaintenanceMode() {
    SnackBarManager.showWarning(
      'Технические работы',
      subtitle: 'Сервис временно недоступен. Попробуйте позже',
      customIcon: const Icon(Icons.build_outlined),
      duration: const Duration(seconds: 10),
    );
  }

  /// Резервное копирование
  static void showBackupStarted() {
    SnackBarManager.showInfo(
      'Создание резервной копии',
      subtitle: 'Сохранение данных в облачное хранилище...',
      showProgress: true,
      customIcon: const Icon(Icons.backup_outlined),
      duration: const Duration(seconds: 10),
    );
  }

  /// Резервное копирование завершено
  static void showBackupCompleted() {
    SnackBarManager.showSuccess(
      'Резервная копия создана',
      subtitle: 'Ваши данные надежно сохранены',
      customIcon: const Icon(Icons.cloud_done_outlined),
    );
  }

  /// Превышен размер файла
  static void showFileSizeExceeded(String maxSize) {
    SnackBarManager.showError(
      'Файл слишком большой',
      subtitle: 'Максимальный размер: $maxSize',
      customIcon: const Icon(Icons.file_present_outlined),
    );
  }

  /// Неподдерживаемый формат файла
  static void showUnsupportedFileFormat(String extension) {
    SnackBarManager.showError(
      'Неподдерживаемый формат',
      subtitle: 'Файлы .$extension не поддерживаются',
      customIcon: const Icon(Icons.file_present_outlined),
    );
  }

  /// Загрузка завершена
  static void showDownloadCompleted(String fileName) {
    SnackBarManager.showSuccess(
      'Загрузка завершена',
      subtitle: fileName,
      customIcon: const Icon(Icons.download_done_outlined),
    );
  }

  /// Ошибка загрузки
  static void showDownloadError({VoidCallback? onRetry}) {
    SnackBarManager.showError(
      'Ошибка загрузки',
      subtitle: 'Не удалось загрузить файл',
      actionLabel: onRetry != null ? 'Повторить' : null,
      onAction: onRetry,
      customIcon: const Icon(Icons.download_outlined),
    );
  }

  /// Настройки сохранены
  static void showSettingsSaved() {
    SnackBarManager.showSuccess(
      'Настройки сохранены',
      subtitle: 'Изменения применены успешно',
      customIcon: const Icon(Icons.settings_outlined),
    );
  }

  /// Темная/светлая тема
  static void showThemeChanged(bool isDarkMode) {
    SnackBarManager.showInfo(
      isDarkMode ? 'Темная тема включена' : 'Светлая тема включена',
      subtitle: 'Перезапустите приложение для полного применения',
      customIcon: Icon(
        isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
      ),
    );
  }

  /// Язык изменен
  static void showLanguageChanged(String languageName) {
    SnackBarManager.showInfo(
      'Язык изменен',
      subtitle: 'Выбран язык: $languageName',
      customIcon: const Icon(Icons.language_outlined),
    );
  }

  /// Подписка истекает
  static void showSubscriptionExpiring(int daysLeft, {VoidCallback? onRenew}) {
    SnackBarManager.showWarning(
      'Подписка истекает',
      subtitle: daysLeft == 1
          ? 'Подписка истекает завтра'
          : 'Подписка истекает через $daysLeft дней',
      actionLabel: onRenew != null ? 'Продлить' : null,
      onAction: onRenew,
      customIcon: const Icon(Icons.card_membership_outlined),
      duration: const Duration(seconds: 8),
    );
  }

  /// Покупка совершена
  static void showPurchaseCompleted(String productName) {
    SnackBarManager.showSuccess(
      'Покупка совершена',
      subtitle: productName,
      customIcon: const Icon(Icons.shopping_cart_outlined),
    );
  }

  /// Кеш очищен
  static void showCacheCleared(String size) {
    SnackBarManager.showSuccess(
      'Кеш очищен',
      subtitle: 'Освобождено $size дискового пространства',
      customIcon: const Icon(Icons.cleaning_services_outlined),
    );
  }
}
