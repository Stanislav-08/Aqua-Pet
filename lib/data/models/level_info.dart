class LevelInfo {
  final int level;
  final int stage;

  final int totalXp;

  final int currentLevelXp;
  final int nextLevelXp;

  final int xpIntoLevel;
  final int xpNeeded;

  final double progress;

  const LevelInfo({
    required this.level,
    required this.stage,
    required this.totalXp,
    required this.currentLevelXp,
    required this.nextLevelXp,
    required this.xpIntoLevel,
    required this.xpNeeded,
    required this.progress,
  });
}