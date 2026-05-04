import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  test('loads unlock progress from repository', () async {
    final repository = _FakeUnlockProgressRepository(
      const UnlockProgress(unlockedKansenIds: {'z23'}),
    );
    final cubit = UnlockProgressCubit(
      loadUnlockProgress: LoadUnlockProgress(repository),
      unlockKansen: UnlockKansen(repository),
    );

    await cubit.load();

    expect(cubit.state.status, UnlockProgressStatus.ready);
    expect(cubit.state.isUnlocked('z23'), isTrue);

    await cubit.close();
  });

  test('unlocks a kansen and emits updated progress', () async {
    final repository = _FakeUnlockProgressRepository(
      const UnlockProgress(unlockedKansenIds: {'z23'}),
    );
    final cubit = UnlockProgressCubit(
      loadUnlockProgress: LoadUnlockProgress(repository),
      unlockKansen: UnlockKansen(repository),
    );

    final result = await cubit.unlock('bismarck_zwei');

    expect(result?.added, isTrue);
    expect(cubit.state.status, UnlockProgressStatus.ready);
    expect(cubit.state.isUnlocked('z23'), isTrue);
    expect(cubit.state.isUnlocked('bismarck_zwei'), isTrue);
    expect(repository.saveCount, 1);

    await cubit.close();
  });
}

class _FakeUnlockProgressRepository implements UnlockProgressRepository {
  _FakeUnlockProgressRepository(this.progress);

  UnlockProgress progress;
  var saveCount = 0;

  @override
  Future<UnlockProgress> loadProgress() async {
    return progress;
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) async {
    saveCount += 1;
    this.progress = progress;
  }
}
