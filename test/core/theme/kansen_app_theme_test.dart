import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';

void main() {
  test('light and dark themes expose app color tokens', () {
    final lightTokens = KansenAppTheme.light().extension<KansenThemeTokens>();
    final darkTokens = KansenAppTheme.dark().extension<KansenThemeTokens>();

    expect(lightTokens, isNotNull);
    expect(darkTokens, isNotNull);
    expect(lightTokens!.ink, isNot(darkTokens!.ink));
    expect(
      lightTokens.backdropGradient.length,
      darkTokens.backdropGradient.length,
    );
  });
}
