import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  test('unlocks a new kansen and saves progress', () async {
    final repository = _FakeUnlockProgressRepository(
      const UnlockProgress(unlockedKansenIds: {'z23'}),
    );
    final useCase = UnlockKansen(repository);

    final result = await useCase('bismarck_zwei');

    expect(result.added, isTrue);
    expect(result.progress.unlockedKansenIds, {'z23', 'bismarck_zwei'});
    expect(repository.savedProgress?.unlockedKansenIds, {
      'z23',
      'bismarck_zwei',
    });
    expect(repository.loadCount, 1);
    expect(repository.saveCount, 1);
  });

  test('does not save when kansen is already unlocked', () async {
    final repository = _FakeUnlockProgressRepository(
      const UnlockProgress(unlockedKansenIds: {'z23'}),
    );
    final useCase = UnlockKansen(repository);

    final result = await useCase('z23');

    expect(result.added, isFalse);
    expect(result.progress.unlockedKansenIds, {'z23'});
    expect(repository.savedProgress, isNull);
    expect(repository.loadCount, 1);
    expect(repository.saveCount, 0);
  });
}

class _FakeUnlockProgressRepository implements UnlockProgressRepository {
  _FakeUnlockProgressRepository(this.progress);

  UnlockProgress progress;
  UnlockProgress? savedProgress;
  var loadCount = 0;
  var saveCount = 0;

  @override
  Future<UnlockProgress> loadProgress() async {
    loadCount += 1;
    return progress;
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) async {
    saveCount += 1;
    savedProgress = progress;
    this.progress = progress;
  }
}
