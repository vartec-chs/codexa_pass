class StoreCreateDto {
  final String name;
  final String masterPassword;
  final String? description;
  final String? path;

  StoreCreateDto({
    this.path,
    required this.name,
    this.description,
    required this.masterPassword,
  });
}
