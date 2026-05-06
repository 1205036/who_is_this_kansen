import 'package:injectable/injectable.dart';

import '../entities/unlock_progress.dart';
import '../repositories/unlock_progress_repository.dart';

@injectable
class UnlockKansen {
  const UnlockKansen(this._repository);

  final UnlockProgressRepository _repository;

  Future<UnlockKansenResult> call(String kansenId) async {
    final current = await _repository.loadProgress();
    final updated = current.unlock(kansenId);
    final added = updated.unlockedCount != current.unlockedCount;

    if (added) {
      await _repository.saveProgress(updated);
    }

    return UnlockKansenResult(progress: updated, added: added);
  }
}

class UnlockKansenResult {
  const UnlockKansenResult({required this.progress, required this.added});

  final UnlockProgress progress;
  final bool added;
}
