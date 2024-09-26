class UserStatistics {
  final String id;
  final String userId;
  final int? totalExp;
  final int? totalCoin;
  final int? totalQuests;
  final int? totalAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserStatistics({
    required this.id,
    required this.userId,
    this.totalExp,
    this.totalCoin,
    this.totalQuests,
    this.totalAchievements,
    required this.createdAt,
    required this.updatedAt,
  });

  // ฟังก์ชันสำหรับการสร้าง instance จาก JSON
  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      totalExp: json['totalExp'] as int?,
      totalCoin: json['totalCoin'] as int?,
      totalQuests: json['totalQuests'] as int?,
      totalAchievements: json['totalAchievements'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // ฟังก์ชันสำหรับการแปลง instance เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalExp': totalExp,
      'totalCoin': totalCoin,
      'totalQuests': totalQuests,
      'totalAchievements': totalAchievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
