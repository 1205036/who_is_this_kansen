import 'package:flutter/foundation.dart';

/// A typed feature-flag descriptor (PLAN item 26, Tier 2).
///
/// Flags gate real production features. Their [defaultValue] is what ships to
/// release today; a debug-menu override (debug builds only) or a future remote
/// source (Tier 3, deferred) can replace it at runtime. Register every flag in
/// `FeatureFlags`.
@immutable
sealed class FeatureFlag<T> {
  const FeatureFlag({
    required this.key,
    required this.label,
    required this.description,
    required this.defaultValue,
  });

  /// Stable storage/remote key; also the persisted-override identifier.
  final String key;

  /// Human-readable name shown in the debug menu.
  final String label;

  /// One-line explanation shown in the debug menu.
  final String description;

  /// Value used in release builds (until Tier 3 remote lands).
  final T defaultValue;

  /// Parse a persisted/remote string into [T]; falls back to [defaultValue]
  /// when [raw] is not a recognised encoding.
  T parse(String raw);

  /// Encode [value] for persistence.
  String format(T value);
}

/// An on/off flag.
final class BoolFlag extends FeatureFlag<bool> {
  const BoolFlag({
    required super.key,
    required super.label,
    required super.description,
    super.defaultValue = false,
  });

  @override
  bool parse(String raw) => switch (raw) {
    'true' => true,
    'false' => false,
    _ => defaultValue,
  };

  @override
  String format(bool value) => value ? 'true' : 'false';
}

/// A multi-value flag backed by a Dart enum.
final class EnumFlag<T extends Enum> extends FeatureFlag<T> {
  const EnumFlag({
    required super.key,
    required super.label,
    required super.description,
    required super.defaultValue,
    required this.values,
    this.labelOf,
  });

  /// Selectable options, usually `MyEnum.values`.
  final List<T> values;

  /// Optional human label per option; defaults to the enum's `name`.
  final String Function(T value)? labelOf;

  String optionLabel(T value) => labelOf?.call(value) ?? value.name;

  @override
  T parse(String raw) =>
      values.firstWhere((v) => v.name == raw, orElse: () => defaultValue);

  @override
  String format(T value) => value.name;
}
