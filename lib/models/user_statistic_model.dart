class UserStatistics {
  final int totalExp;
  final int totalCoin;
  final int totalQuests;
  final int totalAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserStatistics({
    required this.totalExp,
    required this.totalCoin,
    required this.totalQuests,
    required this.totalAchievements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalExp: json['totalExp'] as int,
      totalCoin: json['totalCoin'] as int,
      totalQuests: json['totalQuests'] as int,
      totalAchievements: json['totalAchievements'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExp': totalExp,
      'totalCoin': totalCoin,
      'totalQuests': totalQuests,
      'totalAchievements': totalAchievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
