import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  /// One async-preferences handle shared across all repositories.
  @lazySingleton
  SharedPreferencesAsync get sharedPreferences => SharedPreferencesAsync();

  /// The Flutter root asset bundle, registered so the catalog repository can
  /// declare its dependency on `AssetBundle` rather than reaching for the
  /// global `rootBundle` symbol directly.
  @lazySingleton
  AssetBundle get assetBundle => rootBundle;
}
