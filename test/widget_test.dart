import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:who_is_this_kansen/app/presentation/app.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('prototype shell shows quiz and dex entry points', (
    tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      TranslationProvider(
        child: const KansenApp(bootSplashDuration: Duration.zero),
      ),
    );
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();

    expect(find.text(t.quiz.modeDiscovery.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.modeRandom.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.modeDex.toUpperCase()), findsOneWidget);

    await tester.tap(find.text(t.quiz.modeDiscovery.toUpperCase()));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump(const Duration(milliseconds: 420));

    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
