import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/utils/animation_utils.dart';
import '../../../../app/utils/theme_utils.dart';
import '../../../../app/utils/responsive_utils.dart';
import '../create_store_control.dart';

class MasterPasswordWidget extends ConsumerStatefulWidget {
  const MasterPasswordWidget({super.key});

  @override
  ConsumerState<MasterPasswordWidget> createState() =>
      _MasterPasswordWidgetState();
}

class _MasterPasswordWidgetState extends ConsumerState<MasterPasswordWidget>
    with TickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _lastResetKey = -1; // Отслеживаем последний resetKey

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationConstants.normal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AnimationConstants.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createStoreControllerProvider);
    final controller = ref.read(createStoreControllerProvider.notifier);

    // Безопасно сбрасываем состояние видимости паролей при сбросе формы
    if (_lastResetKey != -1 && _lastResetKey != state.resetKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isPasswordVisible = false;
            _isConfirmPasswordVisible = false;
          });
        }
      });
    }
    _lastResetKey = state.resetKey;

    return AnimatedAppearance(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Мастер-пароль',
            style: ThemeUtils.getHeadingStyle(
              context,
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 16),
            ),
          ),
          const SizedBox(height: 16),

          // Поле мастер-пароля
          _buildPasswordField(
            state: state,
            label: 'Мастер-пароль *',
            hint: 'Введите мастер-пароль',
            value: state.masterPassword,
            onChanged: controller.updateMasterPassword,
            isVisible: _isPasswordVisible,
            onVisibilityToggle: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),

          const SizedBox(height: 16),

          // Поле подтверждения пароля
          _buildPasswordField(
            state: state,
            label: 'Подтвердите пароль *',
            hint: 'Повторите мастер-пароль',
            value: state.confirmPassword,
            onChanged: controller.updateConfirmPassword,
            isVisible: _isConfirmPasswordVisible,
            onVisibilityToggle: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
            ),
            isConfirmField: true,
            passwordsMatch:
                state.masterPassword == state.confirmPassword &&
                state.confirmPassword.isNotEmpty,
          ),

          const SizedBox(height: 16),

          // Информация о требованиях к паролю
          AnimatedHeightContainer(
            show:
                (state.masterPassword.isNotEmpty ||
                    state.confirmPassword.isNotEmpty) &&
                !(state.masterPassword.length >= 3 &&
                    state.masterPassword.isNotEmpty &&
                    state.confirmPassword.isNotEmpty &&
                    state.masterPassword == state.confirmPassword),
            duration: AnimationConstants.normal,
            curve: AnimationConstants.easeInOut,
            child: _buildPasswordRequirements(state.masterPassword),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required dynamic state, // Добавляем state для доступа к resetKey
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    bool isConfirmField = false,
    bool passwordsMatch = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ThemeUtils.getLabelStyle(context)),
        const SizedBox(height: 8),

        AnimatedColorContainer(
          color: Colors.transparent,
          child: TextFormField(
            key: ValueKey(
              '${label}_${state.resetKey}',
            ), // Используем resetKey для принудительного обновления
            initialValue: value,
            onChanged: onChanged,
            obscureText: !isVisible,
            style: GoogleFonts.inter(
              fontSize: ResponsiveUtils.adaptiveFontSize(context, 16),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: ThemeUtils.getSubtitleStyle(context, opacity: 0.5),
              prefixIcon: AnimatedSwitcher(
                duration: AnimationConstants.fast,
                child: Icon(
                  Icons.lock,
                  key: ValueKey(isConfirmField),
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isConfirmField && value.isNotEmpty)
                    AnimatedSwitcher(
                      duration: AnimationConstants.fast,
                      child: Icon(
                        passwordsMatch ? Icons.check_circle : Icons.error,
                        key: ValueKey(passwordsMatch),
                        color: passwordsMatch ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onVisibilityToggle,
                    icon: AnimatedSwitcher(
                      duration: AnimationConstants.fast,
                      child: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        key: ValueKey(isVisible),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: ThemeUtils.getBorderColor(context),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: isConfirmField && value.isNotEmpty && !passwordsMatch
                      ? Colors.red.withOpacity(0.5)
                      : ThemeUtils.getBorderColor(context, opacity: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.responsive(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                borderSide: BorderSide(
                  color: isConfirmField && value.isNotEmpty && !passwordsMatch
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: ThemeUtils.getSurfaceColor(context),
              contentPadding: ResponsiveUtils.responsive(
                context,
                mobile: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                tablet: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                desktop: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(String password) {
    final state = ref.watch(createStoreControllerProvider);

    final requirements = [
      {
        'text': 'Минимум 3 символа',
        'isValid': password.length >= 3,
        'icon': Icons.format_size,
      },
      {
        'text': 'Пароли совпадают',
        'isValid':
            state.masterPassword.isNotEmpty &&
            state.confirmPassword.isNotEmpty &&
            state.masterPassword == state.confirmPassword,
        'icon': Icons.check_circle_outline,
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: AdaptiveCard(
        padding: ResponsiveUtils.responsive(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(20),
          desktop: const EdgeInsets.all(24),
        ),
        useGradient: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.security,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Требования к паролю',
                  style: ThemeUtils.getLabelStyle(
                    context,
                    fontSize: ResponsiveUtils.adaptiveFontSize(context, 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...requirements
                .where(
                  (req) => !(req['isValid'] as bool),
                ) // Показываем только невыполненные требования
                .map(
                  (req) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnimatedContainer(
                      duration: AnimationConstants.fast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (req['isValid'] as bool)
                            ? Colors.green.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (req['isValid'] as bool)
                              ? Colors.green.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: AnimationConstants.fast,
                            child: Icon(
                              (req['isValid'] as bool)
                                  ? Icons.check_circle_rounded
                                  : req['icon'] as IconData,
                              key: ValueKey(req['isValid']),
                              color: (req['isValid'] as bool)
                                  ? Colors.green
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.4),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            req['text'] as String,
                            style: GoogleFonts.inter(
                              fontSize: ResponsiveUtils.adaptiveFontSize(
                                context,
                                13,
                              ),
                              fontWeight: (req['isValid'] as bool)
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: (req['isValid'] as bool)
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                ,

            // Сообщение о том, что все требования выполнены
            if (requirements.every((req) => req['isValid'] as bool) &&
                state.masterPassword.isNotEmpty)
              AnimatedContainer(
                duration: AnimationConstants.normal,
                curve: AnimationConstants.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.green, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      'Все требования выполнены!',
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveUtils.adaptiveFontSize(context, 13),
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
