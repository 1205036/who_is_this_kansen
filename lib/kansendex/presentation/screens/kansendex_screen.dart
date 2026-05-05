import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/catalog_load_state.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansendex/presentation/models/kansendex_filter.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_card.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_empty_state.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_progress_header.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

class KansendexScreen extends StatefulWidget {
  const KansendexScreen({
    super.key,
    required this.kansenFuture,
    required this.onSelected,
  });

  final Future<List<KansenViewModel>> kansenFuture;
  final ValueChanged<KansenViewModel> onSelected;

  @override
  State<KansendexScreen> createState() => _KansendexScreenState();
}

class _KansendexScreenState extends State<KansendexScreen> {
  late final TextEditingController _searchController;
  late final PageController _pageController;
  var _filter = KansendexFilter.all;
  var _searchText = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _filter.index);
    _searchController = TextEditingController()
      ..addListener(() {
        setState(() => _searchText = _searchController.text);
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KansenViewModel>>(
      future: widget.kansenFuture,
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
            return Column(
              children: [
                KansendexStickyHeader(
                  child: KansendexProgressHeader(
                    unlockedCount: unlockedCount,
                    totalCount: kansen.length,
                    searchController: _searchController,
                    filter: _filter,
                    onFilterChanged: _changeFilter,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      final nextFilter = KansendexFilter.values[index];
                      if (nextFilter == _filter) return;
                      FocusScope.of(context).unfocus();
                      if (_searchController.text.isNotEmpty) {
                        _searchController.clear();
                      }
                      setState(() => _filter = nextFilter);
                    },
                    children: [
                      _KansendexGrid(
                        kansen: _filteredKansen(
                          kansen,
                          progressState,
                          KansendexFilter.all,
                        ),
                        progressState: progressState,
                        onSelected: widget.onSelected,
                      ),
                      _KansendexGrid(
                        kansen: _filteredKansen(
                          kansen,
                          progressState,
                          KansendexFilter.locked,
                        ),
                        progressState: progressState,
                        onSelected: widget.onSelected,
                      ),
                      _KansendexGrid(
                        kansen: _filteredKansen(
                          kansen,
                          progressState,
                          KansendexFilter.unlocked,
                        ),
                        progressState: progressState,
                        onSelected: widget.onSelected,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<KansenViewModel> _filteredKansen(
    List<KansenViewModel> kansen,
    UnlockProgressState progressState,
    KansendexFilter filter,
  ) {
    final query = _searchText.trim().toLowerCase();
    return kansen.where((item) {
      final unlocked = progressState.isUnlocked(item.id);
      final matchesFilter = switch (filter) {
        KansendexFilter.all => true,
        KansendexFilter.locked => !unlocked,
        KansendexFilter.unlocked => unlocked,
      };
      final matchesSearch = switch (filter) {
        KansendexFilter.locked => true,
        KansendexFilter.unlocked =>
          query.isEmpty || item.name.toLowerCase().contains(query),
        KansendexFilter.all =>
          query.isEmpty ||
              (unlocked && item.name.toLowerCase().contains(query)),
      };
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _changeFilter(KansendexFilter filter) {
    if (filter == _filter) return;
    FocusScope.of(context).unfocus();
    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
    }
    setState(() => _filter = filter);
    _pageController.animateToPage(
      filter.index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}

class _KansendexGrid extends StatelessWidget {
  const _KansendexGrid({
    required this.kansen,
    required this.progressState,
    required this.onSelected,
  });

  final List<KansenViewModel> kansen;
  final UnlockProgressState progressState;
  final ValueChanged<KansenViewModel> onSelected;

  @override
  Widget build(BuildContext context) {
    if (kansen.isEmpty) {
      return const KansendexEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
