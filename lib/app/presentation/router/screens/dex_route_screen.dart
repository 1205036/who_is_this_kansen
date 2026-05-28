import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_routes.dart';
import 'package:who_is_this_kansen/catalog/presentation/kansen_catalog_provider.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/kansendex/presentation/screens/kansendex_screen.dart';

class DexRouteScreen extends StatelessWidget {
  const DexRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KansendexScreen(
      kansenFuture: getIt<KansenCatalogProvider>().future,
      onSelected: (kansen) =>
          context.push(AppRoutes.detailFor(kansen.id), extra: kansen),
    );
  }
}
