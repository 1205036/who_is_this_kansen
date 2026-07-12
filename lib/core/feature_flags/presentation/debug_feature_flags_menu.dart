import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../domain/feature_flag.dart';
import '../domain/feature_flags.dart';
import '../domain/feature_flags_repository.dart';

/// Opens the debug-only feature-flag menu. Callers must gate on [kDebugMode];
/// the assert catches accidental release wiring.
Future<void> openDebugFeatureFlagsMenu(BuildContext context) {
  assert(kDebugMode, 'Feature-flag menu must never open in release builds.');
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _DebugFeatureFlagsSheet(),
  );
}

class _DebugFeatureFlagsSheet extends StatelessWidget {
  const _DebugFeatureFlagsSheet();

  @override
  Widget build(BuildContext context) {
    final repo = getIt<FeatureFlagsRepository>();
    final theme = Theme.of(context);
    return SafeArea(
      child: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Feature flags', style: theme.textTheme.titleLarge),
                          Text(
                            'Debug only • flags gate production features',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: repo.clearAllOverrides,
                      child: const Text('Reset all'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: FeatureFlags.all.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) =>
                      _FlagTile(repo: repo, flag: FeatureFlags.all[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FlagTile extends StatelessWidget {
  const _FlagTile({required this.repo, required this.flag});

  final FeatureFlagsRepository repo;
  final FeatureFlag flag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overridden = repo.hasOverride(flag);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(flag.label, style: theme.textTheme.titleMedium),
              ),
              if (overridden) ...[
                Text(
                  'overridden',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
                IconButton(
                  tooltip: 'Reset to default',
                  icon: const Icon(Icons.restart_alt),
                  onPressed: () => repo.clearOverride(flag),
                ),
              ],
            ],
          ),
          Text(flag.description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          _control(context),
        ],
      ),
    );
  }

  Widget _control(BuildContext context) {
    // Bind to a local so the sealed-type pattern can promote it (an instance
    // field is not promotable).
    final flag = this.flag;
    switch (flag) {
      case BoolFlag():
        return Align(
          alignment: Alignment.centerLeft,
          child: Switch(
            value: repo.valueOf(flag),
            onChanged: (value) => repo.setOverride(flag, value),
          ),
        );
      case EnumFlag():
        final selected = repo.valueOf(flag);
        return Wrap(
          spacing: 8,
          children: [
            for (final option in flag.values)
              ChoiceChip(
                label: Text(flag.optionLabel(option)),
                selected: selected == option,
                onSelected: (_) => repo.setOverride(flag, option),
              ),
          ],
        );
    }
  }
}
