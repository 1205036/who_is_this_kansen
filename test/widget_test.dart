import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import 'package:who_is_this_kansen/app/presentation/app.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

bool _isFontFetchError(Object exception) {
  final summary = exception.toString();
  return summary.contains('google_fonts') || summary.contains('Baloo2');
}

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    // Tests can't reach the network and Baloo2 isn't bundled. Disabling
    // runtime fetching makes google_fonts throw synchronously instead of
    // attempting an HTTP fetch; `pumpUntilFound` drops the resulting
    // exceptions so unrelated tests don't fail.
    GoogleFonts.config.allowRuntimeFetching = false;

    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    if (!getIt.isRegistered<ThemeModeCubit>()) {
      configureDependencies();
    }
  });

  setUp(() async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    // NOTE: deliberately NOT calling `getIt.reset()` here. The
    // `KansenCatalogProvider` memoises the catalog future on first read;
    // re-creating it per test forces every test to re-load 91 entries via
    // `rootBundle`, which hangs forever after the first pumpWidget. Keeping
    // the locator state shared lets tests 2/3 read the future test 1 already
    // resolved — the same trick production relies on to keep the home
    // button snappy.
  });

  /// Pumps the app and waits — using real wall time so the catalog
  /// `FutureBuilder` can resolve — until [finder] matches at least one
  /// widget. Any unrelated unhandled exceptions are re-thrown;
  /// google_fonts/Baloo2 fetch errors are silently consumed. On timeout,
  /// dumps the widget tree so the failure is debuggable.
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (DateTime.now().isAfter(deadline)) {
        final widgetTypes =
            tester.allWidgets
                .map((w) => w.runtimeType.toString())
                .toSet()
                .toList()
              ..sort();
        final textWidgets = tester
            .widgetList<Text>(find.byType(Text))
            .map((w) => w.data ?? w.textSpan?.toPlainText() ?? '<no-data>')
            .toList();
        final richTexts = tester
            .widgetList<RichText>(find.byType(RichText))
            .map((w) => w.text.toPlainText())
            .toList();
        debugPrint('--- pumpUntilFound TIMEOUT for $finder ---');
        debugPrint('widget types (${widgetTypes.length}): $widgetTypes');
        debugPrint('Text widgets (${textWidgets.length}): $textWidgets');
        debugPrint('RichText widgets (${richTexts.length}): $richTexts');
        final scaffoldEl = tester
            .elementList(find.byType(Scaffold))
            .firstOrNull;
        if (scaffoldEl != null) {
          debugPrint('current route: ${ModalRoute.of(scaffoldEl)}');
        }
        throw TestFailure(
          'pumpUntilFound: $finder did not appear within $timeout',
        );
      }
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pump();
      final pending = tester.takeException();
      if (pending != null && !_isFontFetchError(pending)) {
        throw pending;
      }
    }
  }

  Future<void> bootApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      TranslationProvider(
        child: const KansenApp(bootSplashDuration: Duration.zero),
      ),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  testWidgets('boots into landing screen showing all three mode buttons', (
    tester,
  ) async {
    await bootApp(tester);
    await pumpUntilFound(tester, find.text(t.quiz.modeDiscovery.toUpperCase()));

    expect(find.text(t.quiz.modeDiscovery.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.modeRandom.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.modeDex.toUpperCase()), findsOneWidget);
  });

  testWidgets('tapping Discovery routes to the difficulty selection screen', (
    tester,
  ) async {
    await bootApp(tester);

    await pumpUntilFound(tester, find.text(t.quiz.modeDiscovery.toUpperCase()));

    await tester.tap(find.text(t.quiz.modeDiscovery.toUpperCase()));
    await pumpUntilFound(
      tester,
      find.text(t.quiz.difficultyEasy.toUpperCase()),
    );

    expect(find.text(t.quiz.difficultyEasy.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.difficultyMedium.toUpperCase()), findsOneWidget);
    expect(find.text(t.quiz.difficultyHard.toUpperCase()), findsOneWidget);
  });

  testWidgets('tapping Dex routes to the Kansendex screen', (tester) async {
    await bootApp(tester);
    await pumpUntilFound(tester, find.text(t.quiz.modeDex.toUpperCase()));

    await tester.tap(find.text(t.quiz.modeDex.toUpperCase()));
    await pumpUntilFound(tester, find.text(t.kansendex.segmentAll));

    expect(find.text(t.kansendex.segmentAll), findsOneWidget);
  });
}
