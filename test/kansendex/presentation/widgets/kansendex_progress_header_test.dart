import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansendex/presentation/models/kansendex_filter.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_progress_header.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('shows percentage and custom progress painter', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: KansenAppTheme.light(),
          home: const Scaffold(body: _HeaderTestHost()),
        ),
      ),
    );

    // Let the TweenAnimationBuilder finish animating progress to its target.
    await tester.pump(const Duration(milliseconds: 800));

    final progressPaint = tester.widget<CustomPaint>(
      find.byKey(const ValueKey('kansendex-progress-bar')),
    );
    final painter = progressPaint.painter! as KansendexProgressPainter;

    expect(find.text('25%'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('kansendex-search-field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('kansendex-filter-segment')),
      findsOneWidget,
    );
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(painter.progress, closeTo(0.25, 0.001));
  });
}

class _HeaderTestHost extends StatefulWidget {
  const _HeaderTestHost();

  @override
  State<_HeaderTestHost> createState() => _HeaderTestHostState();
}

class _HeaderTestHostState extends State<_HeaderTestHost> {
  late final TextEditingController _searchController;
  var _filter = KansendexFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KansendexProgressHeader(
      unlockedCount: 3,
      totalCount: 12,
      searchController: _searchController,
      filter: _filter,
      onFilterChanged: (filter) => setState(() => _filter = filter),
    );
  }
}
