import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../create_store_control.dart';

class MasterPasswordWidget extends ConsumerStatefulWidget {
  const MasterPasswordWidget({super.key});

  @override
  ConsumerState<MasterPasswordWidget> createState() =>
      _MasterPasswordWidgetState();
}

class _MasterPasswordWidgetState extends ConsumerState<MasterPasswordWidget> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createStoreControllerProvider);
    final controller = ref.read(createStoreControllerProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Мастер-пароль',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Поле мастер-пароля
        _buildPasswordField(
          label: 'Мастер-пароль *',
          hint: 'Введите мастер-пароль',
          value: state.masterPassword,
          onChanged: controller.updateMasterPassword,
          isVisible: _isPasswordVisible,
          onVisibilityToggle: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
          theme: theme,
        ),

        const SizedBox(height: 16),

        // Поле подтверждения пароля
        _buildPasswordField(
          label: 'Подтвердите пароль *',
          hint: 'Повторите мастер-пароль',
          value: state.confirmPassword,
          onChanged: controller.updateConfirmPassword,
          isVisible: _isConfirmPasswordVisible,
          onVisibilityToggle: () => setState(
            () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
          ),
          theme: theme,
          isConfirmField: true,
          passwordsMatch:
              state.masterPassword == state.confirmPassword &&
              state.confirmPassword.isNotEmpty,
        ),

        const SizedBox(height: 16),

        // Информация о требованиях к паролю
        _buildPasswordRequirements(theme, state.masterPassword),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required ThemeData theme,
    bool isConfirmField = false,
    bool passwordsMatch = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              Icons.lock,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isConfirmField && value.isNotEmpty)
                  Icon(
                    passwordsMatch ? Icons.check_circle : Icons.error,
                    color: passwordsMatch ? Colors.green : Colors.red,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onVisibilityToggle,
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isConfirmField && value.isNotEmpty && !passwordsMatch
                    ? Colors.red.withOpacity(0.5)
                    : theme.colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isConfirmField && value.isNotEmpty && !passwordsMatch
                    ? Colors.red
                    : theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(ThemeData theme, String password) {
    final requirements = [
      {'text': 'Минимум 8 символов', 'isValid': password.length >= 8},
      {
        'text': 'Содержит буквы и цифры',
        'isValid':
            password.contains(RegExp(r'[a-zA-Z]')) &&
            password.contains(RegExp(r'[0-9]')),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Требования к паролю:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...requirements
              .map(
                (req) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        req['isValid'] as bool
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: req['isValid'] as bool
                            ? Colors.green
                            : theme.colorScheme.onSurface.withOpacity(0.4),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        req['text'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: req['isValid'] as bool
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
