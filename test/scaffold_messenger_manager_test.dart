import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/app/utils/scaffold_messenger_manager/index.dart';

// Мок для тестирования очереди
class MockSnackBarQueueManager implements SnackBarQueueManager {
  final List<SnackBarData> _queue = [];

  @override
  void enqueue(SnackBarData data) => _queue.add(data);

  @override
  SnackBarData? dequeue() => _queue.isEmpty ? null : _queue.removeAt(0);

  @override
  bool get isEmpty => _queue.isEmpty;

  @override
  bool get isNotEmpty => _queue.isNotEmpty;

  @override
  int get length => _queue.length;

  @override
  void clear() => _queue.clear();
}

// Мок для тестирования билдера
class MockSnackBarBuilder implements SnackBarBuilder {
  final List<SnackBarData> builtData = [];

  @override
  SnackBar build(BuildContext context, SnackBarData data) {
    builtData.add(data);
    return SnackBar(content: Text(data.message));
  }
}

// Мок для тестирования билдера баннеров
class MockBannerBuilder implements BannerBuilder {
  final List<BannerData> builtData = [];

  @override
  MaterialBanner build(BuildContext context, BannerData data) {
    builtData.add(data);
    return MaterialBanner(
      content: Text(data.message),
      actions: [TextButton(onPressed: () {}, child: Text('OK'))],
    );
  }
}

void main() {
  group('ScaffoldMessengerManager Tests', () {
    late MockSnackBarQueueManager mockQueueManager;
    late MockSnackBarBuilder mockSnackBarBuilder;
    late MockBannerBuilder mockBannerBuilder;
    late ScaffoldMessengerManager manager;

    setUp(() {
      mockQueueManager = MockSnackBarQueueManager();
      mockSnackBarBuilder = MockSnackBarBuilder();
      mockBannerBuilder = MockBannerBuilder();
      manager = ScaffoldMessengerManager.instance;

      // Настройка моков
      manager.configure(
        queueManager: mockQueueManager,
        snackBarBuilder: mockSnackBarBuilder,
        bannerBuilder: mockBannerBuilder,
      );
    });

    tearDown(() {
      mockQueueManager.clear();
      mockSnackBarBuilder.builtData.clear();
      mockBannerBuilder.builtData.clear();
    });

    group('SnackBar Queue Tests', () {
      test('should enqueue snackbar data', () {
        // Arrange
        const data = SnackBarData(
          message: 'Test message',
          type: SnackBarType.info,
        );

        // Act
        manager.showSnackBar(data);

        // Assert
        expect(mockQueueManager.length, 1);
      });

      test('should clear queue', () {
        // Arrange
        manager.showError('Error 1');
        manager.showError('Error 2');
        expect(mockQueueManager.length, 2);

        // Act
        manager.clearSnackBarQueue();

        // Assert
        expect(mockQueueManager.length, 0);
        expect(mockQueueManager.isEmpty, true);
      });

      test('should enqueue multiple messages', () {
        // Act
        manager.showError('Error');
        manager.showWarning('Warning');
        manager.showInfo('Info');
        manager.showSuccess('Success');

        // Assert
        expect(mockQueueManager.length, 4);
      });
    });

    group('SnackBar Methods Tests', () {
      test('showError should create error snackbar with correct type', () {
        // Act
        manager.showError('Test error', showCopyButton: true);

        // Assert
        expect(mockQueueManager.length, 1);
        final dequeuedData = mockQueueManager.dequeue();
        expect(dequeuedData?.message, 'Test error');
        expect(dequeuedData?.type, SnackBarType.error);
        expect(dequeuedData?.showCopyButton, true);
      });

      test('showWarning should create warning snackbar', () {
        // Act
        manager.showWarning('Test warning');

        // Assert
        final dequeuedData = mockQueueManager.dequeue();
        expect(dequeuedData?.message, 'Test warning');
        expect(dequeuedData?.type, SnackBarType.warning);
      });

      test('showInfo should create info snackbar', () {
        // Act
        manager.showInfo('Test info');

        // Assert
        final dequeuedData = mockQueueManager.dequeue();
        expect(dequeuedData?.message, 'Test info');
        expect(dequeuedData?.type, SnackBarType.info);
      });

      test('showSuccess should create success snackbar', () {
        // Act
        manager.showSuccess('Test success');

        // Assert
        final dequeuedData = mockQueueManager.dequeue();
        expect(dequeuedData?.message, 'Test success');
        expect(dequeuedData?.type, SnackBarType.success);
      });
    });

    group('Utility Methods Tests', () {
      test('queueLength should return correct count', () {
        // Act
        manager.showError('Error 1');
        manager.showError('Error 2');
        manager.showError('Error 3');

        // Assert
        expect(manager.queueLength, 3);
      });

      test('isQueueEmpty should return correct state', () {
        // Initially empty
        expect(manager.isQueueEmpty, true);

        // Add item
        manager.showError('Error');
        expect(manager.isQueueEmpty, false);

        // Clear
        manager.clearSnackBarQueue();
        expect(manager.isQueueEmpty, true);
      });
    });

    group('SnackBarData Tests', () {
      test('should create snackbar data with all properties', () {
        // Arrange
        void testAction() {}
        void testCopy() {}

        // Act
        final data = SnackBarData(
          message: 'Test message',
          type: SnackBarType.error,
          duration: Duration(seconds: 5),
          actionLabel: 'Action',
          onActionPressed: testAction,
          showCopyButton: true,
          onCopyPressed: testCopy,
        );

        // Assert
        expect(data.message, 'Test message');
        expect(data.type, SnackBarType.error);
        expect(data.duration, Duration(seconds: 5));
        expect(data.actionLabel, 'Action');
        expect(data.onActionPressed, testAction);
        expect(data.showCopyButton, true);
        expect(data.onCopyPressed, testCopy);
      });

      test('copyWith should update only specified properties', () {
        // Arrange
        const original = SnackBarData(
          message: 'Original',
          type: SnackBarType.info,
          showCopyButton: false,
        );

        // Act
        final updated = original.copyWith(
          message: 'Updated',
          showCopyButton: true,
        );

        // Assert
        expect(updated.message, 'Updated');
        expect(updated.type, SnackBarType.info); // unchanged
        expect(updated.showCopyButton, true);
      });
    });

    group('BannerData Tests', () {
      test('should create banner data with all properties', () {
        // Arrange
        final actions = [TextButton(onPressed: () {}, child: Text('OK'))];
        const margin = EdgeInsets.all(8);

        // Act
        final data = BannerData(
          message: 'Test banner',
          type: BannerType.warning,
          actions: actions,
          forceActionsBelow: true,
          margin: margin,
          elevation: 4,
        );

        // Assert
        expect(data.message, 'Test banner');
        expect(data.type, BannerType.warning);
        expect(data.actions, actions);
        expect(data.forceActionsBelow, true);
        expect(data.margin, margin);
        expect(data.elevation, 4);
      });

      test('copyWith should update only specified properties', () {
        // Arrange
        const original = BannerData(
          message: 'Original',
          type: BannerType.info,
          forceActionsBelow: false,
        );

        // Act
        final updated = original.copyWith(
          message: 'Updated',
          forceActionsBelow: true,
        );

        // Assert
        expect(updated.message, 'Updated');
        expect(updated.type, BannerType.info); // unchanged
        expect(updated.forceActionsBelow, true);
      });
    });

    group('Theme Provider Tests', () {
      testWidgets(
        'DefaultSnackBarThemeProvider should provide correct colors',
        (tester) async {
          // Arrange
          final themeProvider = DefaultSnackBarThemeProvider();

          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (context) {
                  // Act & Assert
                  expect(
                    themeProvider.getIcon(SnackBarType.error),
                    Icons.error_outline,
                  );
                  expect(
                    themeProvider.getIcon(SnackBarType.warning),
                    Icons.warning_amber_outlined,
                  );
                  expect(
                    themeProvider.getIcon(SnackBarType.info),
                    Icons.info_outline,
                  );
                  expect(
                    themeProvider.getIcon(SnackBarType.success),
                    Icons.check_circle_outline,
                  );

                  expect(
                    themeProvider.getDefaultDuration(SnackBarType.error),
                    Duration(seconds: 8),
                  );
                  expect(
                    themeProvider.getDefaultDuration(SnackBarType.success),
                    Duration(seconds: 3),
                  );

                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets('DefaultBannerThemeProvider should provide correct icons', (
        tester,
      ) async {
        // Arrange
        final themeProvider = DefaultBannerThemeProvider();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Act & Assert
                expect(
                  themeProvider.getIcon(BannerType.error),
                  Icons.error_outline,
                );
                expect(
                  themeProvider.getIcon(BannerType.warning),
                  Icons.warning_amber_outlined,
                );

                final leading = themeProvider.getLeading(
                  context,
                  BannerType.info,
                );
                expect(leading, isA<Icon>());

                return Container();
              },
            ),
          ),
        );
      });
    });
  });
}
