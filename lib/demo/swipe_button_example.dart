import 'package:flutter/material.dart';
import 'package:codexa_pass/app/common/widget/swipe_button.dart';

/// Простой пример использования SwipeButton
class SwipeButtonExample extends StatelessWidget {
  const SwipeButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwipeButton Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Простой пример
            SwipeButton(
              onSwipeComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Действие выполнено!')),
                );
              },
              text: 'Свайпните для подтверждения',
            ),

            const SizedBox(height: 32),

            // Пример с готовым стилем
            SwipeButtonStyles.danger(
              onSwipeComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Удаление выполнено!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Кастомизированный пример
            SwipeButton(
              onSwipeComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Кастомное действие выполнено!'),
                  ),
                );
              },
              text: 'Свайп для продолжения →',
              icon: Icons.play_arrow,
              height: 70,
              backgroundColor: Colors.blue.withOpacity(0.1),
              sliderColor: Colors.blue,
              textColor: Colors.blue.shade700,
              borderColor: Colors.blue.shade300,
              iconColor: Colors.white,
              borderRadius: 35,
              fontSize: 16,
              iconSize: 24,
            ),
          ],
        ),
      ),
    );
  }
}
