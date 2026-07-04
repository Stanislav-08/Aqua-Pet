import 'dart:math' as math;
import 'package:aqua_pet/data/models/level_info.dart';

class LevelService {
  LevelService._();

  /// XP curve.
  ///
  /// Increase BASE_XP to make every level slower.
  /// Increase EXPONENT to make higher levels much slower.
  static const int baseXp = 100;
  static const double exponent = 1.5;

  /// XP rewards
  static const int xpPer250ml = 5;
  static const int dailyGoalBonus = 50;

  static const int streakMultiplier = 10;
  static const int streakCap = 100;

  static const int dailyXpCap = 200;

  /// Total XP required to REACH a level.
  /// Level 1 = 0 XP.
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return (baseXp * math.pow(level - 1, exponent)).round();
  }

  /// Calculates current level from total XP.
  static int levelFromXp(int xp) {
    int level =
    math.max(1, math.pow(xp / baseXp, 1 / exponent).floor() + 1);

    while (xp >= xpForLevel(level + 1)) {
      level++;
    }

    while (level > 1 && xp < xpForLevel(level)) {
      level--;
    }

    return level;
  }

  /// Plant evolution stages.
  ///
  /// Levels 1-4   -> Stage 1
  /// Levels 5-9   -> Stage 2
  /// Levels 10-14 -> Stage 3
  /// Levels 15-19 -> Stage 4
  /// Levels 20+   -> Stage 5
  static int stageFromLevel(int level) {
    if (level >= 20) return 5;
    if (level >= 15) return 4;
    if (level >= 10) return 3;
    if (level >= 5) return 2;
    return 1;
  }

  static int streakXp(int streak) {
    return math.min(streak * streakMultiplier, streakCap);
  }

  static int waterXp(int ml) {
    return (ml ~/ 250) * xpPer250ml;
  }

  static int calculateDailyXp({
    required int waterMl,
    required bool reachedGoal,
    required int streak,
  }) {
    int xp = 0;

    xp += waterXp(waterMl);

    if (reachedGoal) {
      xp += dailyGoalBonus;
    }

    xp += streakXp(streak);

    return math.min(xp, dailyXpCap);
  }

  static LevelInfo fromXp(int totalXp) {
    final level = levelFromXp(totalXp);

    final currentLevelXp = xpForLevel(level);
    final nextLevelXp = xpForLevel(level + 1);

    final xpIntoLevel = totalXp - currentLevelXp;
    final xpNeeded = nextLevelXp - currentLevelXp;

    return LevelInfo(
      level: level,
      stage: stageFromLevel(level),
      totalXp: totalXp,
      currentLevelXp: currentLevelXp,
      nextLevelXp: nextLevelXp,
      xpIntoLevel: xpIntoLevel,
      xpNeeded: xpNeeded,
      progress: xpIntoLevel / xpNeeded,
    );
  }
}