import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  test('loads progress through repository abstraction', () async {
    const progress = UnlockProgress(unlockedKansenIds: {'z23'});
    final repository = _FakeUnlockProgressRepository(progress);
    final useCase = LoadUnlockProgress(repository);

    final result = await useCase();

    expect(result, same(progress));
    expect(repository.loadCount, 1);
  });
}

class _FakeUnlockProgressRepository implements UnlockProgressRepository {
  _FakeUnlockProgressRepository(this.progress);

  UnlockProgress progress;
  var loadCount = 0;

  @override
  Future<UnlockProgress> loadProgress() async {
    loadCount += 1;
    return progress;
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) async {
    this.progress = progress;
  }
}
