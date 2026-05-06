import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'service_locator.config.dart';

/// Application-wide service locator. Resolved by `injectable`-generated
/// bindings; see `app_module.dart` for external dependencies (rootBundle,
/// SharedPreferencesAsync) that aren't constructible by injectable directly.
final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
GetIt configureDependencies() => getIt.init();
