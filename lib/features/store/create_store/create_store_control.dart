import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../../../app/utils/path.dart';
import '../../../app/logger/app_logger.dart';
import 'models/create_store_models.dart';

final createStoreControllerProvider =
    StateNotifierProvider<CreateStoreController, CreateStoreState>((ref) {
      return CreateStoreController();
    });

class CreateStoreController extends StateNotifier<CreateStoreState> {
  CreateStoreController() : super(const CreateStoreState(useDefaultPath: true));

  void updateName(String name) {
    state = state.copyWith(name: name);
    _validateForm();
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
    _validateForm();
  }

  void updateMasterPassword(String password) {
    state = state.copyWith(masterPassword: password);
    _validateForm();
  }

  void updateConfirmPassword(String password) {
    state = state.copyWith(confirmPassword: password);
    _validateForm();
  }

  void setUseDefaultPath(bool useDefault) {
    state = state.copyWith(
      useDefaultPath: useDefault,
      selectedPath: useDefault ? null : state.selectedPath,
    );
    _validateForm();
  }

  Future<void> selectCustomPath() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Выберите папку для хранения',
      );

      if (selectedDirectory != null) {
        // Пользователь выбрал папку
        state = state.copyWith(
          selectedPath: selectedDirectory,
          useDefaultPath: false,
        );
        _validateForm();
        logInfo('Selected directory: $selectedDirectory');
      } else {
        // Пользователь отменил выбор - возвращаемся к стандартной папке
        state = state.copyWith(useDefaultPath: true, selectedPath: null);
        _validateForm();
        logInfo('Directory selection cancelled, using default path');
      }
    } catch (e) {
      logError('Error selecting directory: $e');
      // При ошибке также возвращаемся к стандартной папке
      state = state.copyWith(
        useDefaultPath: true,
        selectedPath: null,
        error: 'Ошибка выбора папки, используется стандартная папка',
      );
      _validateForm();
    }
  }

  Future<String> getDefaultStorePath() async {
    final appDir = await getAppDir();
    return path.join(appDir, 'stores');
  }

  Future<String> getFullStorePath() async {
    final storeName = state.name.trim();
    if (state.useDefaultPath || state.selectedPath == null) {
      final defaultPath = await getDefaultStorePath();
      return path.join(defaultPath, '$storeName.db');
    } else {
      return path.join(state.selectedPath!, '$storeName.db');
    }
  }

  void _validateForm() {
    final isValid =
        state.name.trim().isNotEmpty &&
        state.masterPassword.trim().isNotEmpty &&
        state.confirmPassword.trim().isNotEmpty &&
        state.masterPassword == state.confirmPassword &&
        state.masterPassword.length >= 8 &&
        (state.useDefaultPath || state.selectedPath != null);

    state = state.copyWith(isFormValid: isValid);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> createStore() async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final fullPath = await getFullStorePath();
      final file = File(fullPath);

      // Проверяем, что директория существует
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Проверяем, что файл не существует
      if (await file.exists()) {
        state = state.copyWith(
          isLoading: false,
          error: 'Файл с таким именем уже существует',
        );
        return;
      }

      // TODO: Здесь будет логика создания базы данных
      logInfo('Creating store at: $fullPath');

      // Имитация создания базы данных
      await Future.delayed(const Duration(milliseconds: 500));

      // Создаем пустой файл как заглушку
      await file.create();

      logInfo('Store created successfully: ${state.name}');

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      logError('Failed to create store: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка создания хранилища: $e',
      );
    }
  }

  void reset() {
    state = const CreateStoreState(useDefaultPath: true);
  }
}
