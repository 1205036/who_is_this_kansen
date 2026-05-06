import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/progress/domain/usecases/load_unlock_progress.dart';
import 'package:who_is_this_kansen/progress/domain/usecases/unlock_kansen.dart';
import 'package:who_is_this_kansen/progress/presentation/bloc/unlock_progress_state.dart';

@lazySingleton
class UnlockProgressCubit extends Cubit<UnlockProgressState> {
  UnlockProgressCubit({
    required LoadUnlockProgress loadUnlockProgress,
    required UnlockKansen unlockKansen,
  }) : _loadUnlockProgress = loadUnlockProgress,
       _unlockKansen = unlockKansen,
       super(const UnlockProgressState());

  final LoadUnlockProgress _loadUnlockProgress;
  final UnlockKansen _unlockKansen;

  Future<void> load() async {
    emit(state.copyWith(status: UnlockProgressStatus.loading));
    try {
      final progress = await _loadUnlockProgress();
      emit(
        state.copyWith(progress: progress, status: UnlockProgressStatus.ready),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UnlockProgressStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<UnlockKansenResult?> unlock(String kansenId) async {
    try {
      final result = await _unlockKansen(kansenId);
      emit(
        state.copyWith(
          progress: result.progress,
          status: UnlockProgressStatus.ready,
          errorMessage: null,
        ),
      );
      return result;
    } catch (error) {
      emit(
        state.copyWith(
          status: UnlockProgressStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return null;
    }
  }
}
