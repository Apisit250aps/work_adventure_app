class UserStatistics {
  final int totalExp;
  final int totalCoin;
  final int totalQuests;
  final int totalAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserStatistics({
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

  UserStatistics copyWith({
    int? totalExp,
    int? totalCoin,
    int? totalQuests,
    int? totalAchievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserStatistics(
      totalExp: totalExp ?? this.totalExp,
      totalCoin: totalCoin ?? this.totalCoin,
      totalQuests: totalQuests ?? this.totalQuests,
      totalAchievements: totalAchievements ?? this.totalAchievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserStatistics{totalExp: $totalExp, totalCoin: $totalCoin, totalQuests: $totalQuests, totalAchievements: $totalAchievements}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatistics &&
          runtimeType == other.runtimeType &&
          totalExp == other.totalExp &&
          totalCoin == other.totalCoin &&
          totalQuests == other.totalQuests &&
          totalAchievements == other.totalAchievements &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      totalExp.hashCode ^
      totalCoin.hashCode ^
      totalQuests.hashCode ^
      totalAchievements.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
