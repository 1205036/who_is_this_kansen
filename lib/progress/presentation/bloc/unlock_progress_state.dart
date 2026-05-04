import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:who_is_this_kansen/progress/domain/entities/unlock_progress.dart';

part 'unlock_progress_state.freezed.dart';

@freezed
abstract class UnlockProgressState with _$UnlockProgressState {
  const UnlockProgressState._();

  const factory UnlockProgressState({
    @Default(UnlockProgress(unlockedKansenIds: <String>{}))
    UnlockProgress progress,
    @Default(UnlockProgressStatus.initial) UnlockProgressStatus status,
    String? errorMessage,
  }) = _UnlockProgressState;

  bool isUnlocked(String kansenId) {
    return progress.isUnlocked(kansenId);
  }
}

enum UnlockProgressStatus { initial, loading, ready, failure }
