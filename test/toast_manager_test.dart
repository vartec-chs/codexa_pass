import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codexa_pass/app/utils/toast_manager/toast_manager_export.dart';

void main() {
  group('Toast Manager Tests', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      navigatorKey = GlobalKey<NavigatorState>();
      ToastManager.initialize(navigatorKey);
    });

    tearDown(() {
      ToastManager.dispose();
    });

    test('should generate unique IDs', () {
      final id1 = ToastManager.generateId();
      final id2 = ToastManager.generateId();

      expect(id1, isNot(equals(id2)));
      expect(id1, startsWith('toast_'));
      expect(id2, startsWith('toast_'));
    });

    test('should add toasts to queue', () {
      expect(ToastManager.queueLength, equals(0));

      ToastUtils.info('Test toast');

      expect(ToastManager.queueLength, equals(1));
    });

    test('should prioritize error toasts', () {
      ToastUtils.info('Info toast');
      ToastUtils.error('Error toast');

      expect(ToastManager.queueLength, equals(2));
    });

    test('should clear queue', () {
      ToastUtils.info('Test toast 1');
      ToastUtils.info('Test toast 2');

      expect(ToastManager.queueLength, equals(2));

      ToastManager.clearQueue();

      expect(ToastManager.queueLength, equals(0));
    });

    test('should create toast config correctly', () {
      final config = ToastConfig(
        id: 'test_id',
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        type: ToastType.success,
        position: ToastPosition.top,
      );

      expect(config.id, equals('test_id'));
      expect(config.title, equals('Test Title'));
      expect(config.subtitle, equals('Test Subtitle'));
      expect(config.type, equals(ToastType.success));
      expect(config.position, equals(ToastPosition.top));
    });

    test('should get correct colors for types', () {
      final successColors = ToastColors.forType(ToastType.success, false);
      final errorColors = ToastColors.forType(ToastType.error, false);

      expect(
        successColors.backgroundColor,
        isNot(equals(errorColors.backgroundColor)),
      );
      expect(successColors.iconColor, isNot(equals(errorColors.iconColor)));
    });

    test('should get correct icons for types', () {
      expect(ToastIcons.getIcon(ToastType.success), equals(Icons.check_circle));
      expect(ToastIcons.getIcon(ToastType.error), equals(Icons.error));
      expect(ToastIcons.getIcon(ToastType.warning), equals(Icons.warning));
      expect(ToastIcons.getIcon(ToastType.info), equals(Icons.info));
    });
  });
}
