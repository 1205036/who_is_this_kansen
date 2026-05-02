import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:who_is_this_kansen/main.dart';

void main() {
  testWidgets('prototype shell shows quiz and dex entry points', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const KansenApp());

    expect(find.text('Who Is This Kansen'), findsOneWidget);
    expect(find.byType(TextField, skipOffstage: false), findsOneWidget);
    expect(find.text('Submit Guess', skipOffstage: false), findsOneWidget);

    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}
