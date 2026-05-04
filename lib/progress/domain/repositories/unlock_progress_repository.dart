import '../entities/unlock_progress.dart';

abstract interface class UnlockProgressRepository {
  Future<UnlockProgress> loadProgress();

  Future<void> saveProgress(UnlockProgress progress);
}
