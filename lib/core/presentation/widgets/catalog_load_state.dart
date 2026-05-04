import 'package:flutter/cupertino.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';

class CatalogLoading extends StatelessWidget {
  const CatalogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: KansenThemeTokens.of(context).ink.withValues(alpha: 0.72),
      ),
    );
  }
}

class CatalogLoadError extends StatelessWidget {
  const CatalogLoadError({super.key, required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          t.catalog.loadError(error: '$error'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: KansenThemeTokens.of(context).ink.withValues(alpha: 0.72),
          ),
        ),
      ),
    );
  }
}
