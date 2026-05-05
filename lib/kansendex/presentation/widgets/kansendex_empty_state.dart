import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

class KansendexEmptyState extends StatelessWidget {
  const KansendexEmptyState({super.key});

  static const assetPath =
      'assets/kansen/ui/kansendex_empty_state_little_shipgirl.webp';

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          key: const ValueKey('kansendex-empty-state-scroll'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            28,
            0,
            28,
            MediaQuery.viewInsetsOf(context).bottom + 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    assetPath,
                    key: const ValueKey('kansendex-empty-state-image'),
                    width: 184,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.kansendex.noUnlockedEntriesFound,
                    key: const ValueKey('kansendex-empty-state-message'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      color: tokens.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
