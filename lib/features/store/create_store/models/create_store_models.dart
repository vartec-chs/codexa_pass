class CreateStoreState {
  final String name;
  final String description;
  final String masterPassword;
  final String confirmPassword;
  final String? selectedPath;
  final bool useDefaultPath;
  final bool isFormValid;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const CreateStoreState({
    this.name = '',
    this.description = '',
    this.masterPassword = '',
    this.confirmPassword = '',
    this.selectedPath,
    this.useDefaultPath = true,
    this.isFormValid = false,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  CreateStoreState copyWith({
    String? name,
    String? description,
    String? masterPassword,
    String? confirmPassword,
    String? selectedPath,
    bool? useDefaultPath,
    bool? isFormValid,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return CreateStoreState(
      name: name ?? this.name,
      description: description ?? this.description,
      masterPassword: masterPassword ?? this.masterPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      selectedPath: selectedPath ?? this.selectedPath,
      useDefaultPath: useDefaultPath ?? this.useDefaultPath,
      isFormValid: isFormValid ?? this.isFormValid,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

enum DirectoryOption {
  default_('Использовать стандартную папку'),
  custom('Выбрать папку');

  const DirectoryOption(this.label);

  final String label;
}
