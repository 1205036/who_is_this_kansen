import 'package:flutter/widgets.dart';
import 'package:who_is_this_kansen/app/presentation/app.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const KansenApp()));
}
