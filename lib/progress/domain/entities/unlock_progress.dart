class UnlockProgress {
  const UnlockProgress({required Set<String> unlockedKansenIds})
    : _unlockedKansenIds = unlockedKansenIds;

  final Set<String> _unlockedKansenIds;

  Set<String> get unlockedKansenIds => Set.unmodifiable(_unlockedKansenIds);

  int get unlockedCount => _unlockedKansenIds.length;

  bool isUnlocked(String kansenId) {
    return _unlockedKansenIds.contains(kansenId);
  }

  UnlockProgress unlock(String kansenId) {
    return UnlockProgress(unlockedKansenIds: {..._unlockedKansenIds, kansenId});
  }
}
