import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

part 'unlock_toast_state.freezed.dart';

@freezed
abstract class UnlockToastState with _$UnlockToastState {
  const factory UnlockToastState({
    KansenViewModel? kansen,
    @Default(0) int generation,
  }) = _UnlockToastState;
}
