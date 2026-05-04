enum AppThemeMode {
  system(storageValue: 'system'),
  light(storageValue: 'light'),
  dark(storageValue: 'dark');

  const AppThemeMode({required this.storageValue});

  final String storageValue;

  static AppThemeMode fromStorageValue(String? storageValue) {
    return switch (storageValue) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      _ => AppThemeMode.system,
    };
  }
}
