import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  test('tracks unlocked kansen IDs immutably', () {
    const progress = UnlockProgress(unlockedKansenIds: {'z23'});

    final updated = progress.unlock('bismarck_zwei');

    expect(progress.isUnlocked('bismarck_zwei'), isFalse);
    expect(updated.isUnlocked('z23'), isTrue);
    expect(updated.isUnlocked('bismarck_zwei'), isTrue);
    expect(updated.unlockedCount, 2);
  });

  test('does not duplicate existing unlocks', () {
    const progress = UnlockProgress(unlockedKansenIds: {'z23'});

    final updated = progress.unlock('z23');

    expect(updated.unlockedCount, 1);
    expect(updated.unlockedKansenIds, {'z23'});
  });
}
