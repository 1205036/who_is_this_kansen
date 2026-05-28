import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/app/presentation/notifications/unlock_toast_state.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

export 'package:who_is_this_kansen/app/presentation/notifications/unlock_toast_state.dart';

/// App-singleton transient channel for "you just unlocked X" toasts.
/// Decouples the notification source (quiz screen, future deep links, etc.)
/// from the visual host (the shell). Each `announce` bumps `generation` so
/// stale auto-dismiss timers don't clear a freshly-shown toast.
@lazySingleton
class UnlockToastCubit extends Cubit<UnlockToastState> {
  UnlockToastCubit() : super(const UnlockToastState());

  static const Duration _visibleFor = Duration(milliseconds: 1900);

  void announce(KansenViewModel kansen) {
    final next = state.generation + 1;
    emit(UnlockToastState(kansen: kansen, generation: next));
    Future<void>.delayed(_visibleFor).then((_) {
      if (state.generation != next) return;
      emit(state.copyWith(kansen: null));
    });
  }
}
