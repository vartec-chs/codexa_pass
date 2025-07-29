import 'package:riverpod/riverpod.dart';

import 'app_logger.dart';

class LoggingProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    logInfo(
      '[RIVERPOD] ➕ ADD   ${provider.name ?? provider.runtimeType} = $value',
      tag: 'Riverpod',
    );
  }
}

@override
void didUpdateProvider(
  ProviderBase provider,
  Object? previousValue,
  Object? newValue,
  ProviderContainer container,
) {
  logInfo(
    '[RIVERPOD] ⬆️ UPDATE ${provider.name ?? provider.runtimeType}: $previousValue → $newValue',
    tag: 'Riverpod',
  );
}

@override
void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
  logInfo(
    '[RIVERPOD] ❌ DISPOSE ${provider.name ?? provider.runtimeType}',
    tag: 'Riverpod',
  );
}

@override
void didFail(
  ProviderBase provider,
  Object error,
  StackTrace stackTrace,
  ProviderContainer container,
) {
  logError(
    '[RIVERPOD] ⚠️ ERROR  ${provider.name ?? provider.runtimeType}: $error',
    stackTrace: stackTrace,
    tag: 'Riverpod',
  );
}
