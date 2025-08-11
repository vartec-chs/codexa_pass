import 'package:flutter/material.dart';
import 'package:codexa_pass/app/common/widget/messenger_demo_widget.dart';
import 'package:codexa_pass/app/common/widget/messenger_debug_panel.dart';

/// Простой тестовый экран с отладочной панелью
class SimpleMessengerTest extends StatelessWidget {
  const SimpleMessengerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MessengerDebugWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Messenger Test'), centerTitle: true),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        'Тестирование ScaffoldMessengerManager',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Используйте отладочную панель в правом нижнем углу '
                        'для быстрого тестирования уведомлений.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Быстрый тест для начинающих
              QuickMessengerDemo(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showFullDemo(context),
          icon: const Icon(Icons.launch),
          label: const Text('Полное демо'),
        ),
      ),
    );
  }

  static void _showFullDemo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Полное демо')),
          body: const SingleChildScrollView(child: MessengerDemoWidget()),
        ),
      ),
    );
  }
}
