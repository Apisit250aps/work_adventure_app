class CharacterStatistics {
  final String id;
  final String characterId;
  final int? totalExp;
  final int? totalCoin;
  final int? totalQuests;
  final int? totalAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  CharacterStatistics({
    required this.id,
    required this.characterId,
    this.totalExp,
    this.totalCoin,
    this.totalQuests,
    this.totalAchievements,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor สำหรับสร้าง instance จาก JSON
  factory CharacterStatistics.fromJson(Map<String, dynamic> json) {
    return CharacterStatistics(
      id: json['_id'] as String,
      characterId: json['characterId'] as String,
      totalExp: json['totalExp'] as int?,
      totalCoin: json['totalCoin'] as int?,
      totalQuests: json['totalQuests'] as int?,
      totalAchievements: json['totalAchievements'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // ฟังก์ชันสำหรับแปลง instance เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'totalExp': totalExp,
      'totalCoin': totalCoin,
      'totalQuests': totalQuests,
      'totalAchievements': totalAchievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
