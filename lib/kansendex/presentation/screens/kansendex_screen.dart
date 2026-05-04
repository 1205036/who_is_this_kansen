import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/catalog_load_state.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_card.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_progress_header.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

class KansendexScreen extends StatelessWidget {
  const KansendexScreen({
    super.key,
    required this.kansenFuture,
    required this.onSelected,
  });

  final Future<List<KansenViewModel>> kansenFuture;
  final ValueChanged<KansenViewModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KansenViewModel>>(
      future: kansenFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CatalogLoadError(error: snapshot.error);
        }
        final kansen = snapshot.data;
        if (kansen == null || kansen.isEmpty) {
          return const CatalogLoading();
        }
        return BlocBuilder<UnlockProgressCubit, UnlockProgressState>(
          builder: (context, progressState) {
            final unlockedCount = kansen
                .where((item) => progressState.isUnlocked(item.id))
                .length;

            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: KansendexProgressHeaderDelegate(
                    child: KansendexProgressHeader(
                      unlockedCount: unlockedCount,
                      totalCount: kansen.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: kansen.length,
                    itemBuilder: (context, index) {
                      final item = kansen[index];
                      final locked = !progressState.isUnlocked(item.id);
                      return KansendexCard(
                        kansen: item,
                        locked: locked,
                        onTap: locked ? null : () => onSelected(item),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
