import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_progress_header.dart';

void main() {
  testWidgets('shows percentage and custom progress painter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KansenAppTheme.light(),
        home: const Scaffold(
          body: KansendexProgressHeader(unlockedCount: 3, totalCount: 12),
        ),
      ),
    );

    final progressPaint = tester.widget<CustomPaint>(
      find.byKey(const ValueKey('kansendex-progress-bar')),
    );
    final painter = progressPaint.painter as KansendexProgressPainter;

    expect(find.text('25%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(painter.progress, 0.25);
  });
}
