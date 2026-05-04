import '../entities/unlock_progress.dart';
import '../repositories/unlock_progress_repository.dart';

class LoadUnlockProgress {
  const LoadUnlockProgress(this._repository);

  final UnlockProgressRepository _repository;

  Future<UnlockProgress> call() {
    return _repository.loadProgress();
  }
}
