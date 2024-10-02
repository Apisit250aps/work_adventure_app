class CharacterStatistics {
  final String? id; // ใช้แทน Document._id
  final String characterId;
  final int? totalExp;
  final int? totalCoin;
  final int? totalQuests;
  final int? totalAchievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CharacterStatistics({
    this.id,
    required this.characterId,
    this.totalExp,
    this.totalCoin,
    this.totalQuests,
    this.totalAchievements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CharacterStatistics.fromJson(Map<String, dynamic> json) {
    return CharacterStatistics(
      id: json['_id'] as String?,
      characterId: json['characterId'] as String,
      totalExp: json['totalExp'] as int?,
      totalCoin: json['totalCoin'] as int?,
      totalQuests: json['totalQuests'] as int?,
      totalAchievements: json['totalAchievements'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'characterId': characterId,
      'totalExp': totalExp,
      'totalCoin': totalCoin,
      'totalQuests': totalQuests,
      'totalAchievements': totalAchievements,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CharacterStatistics copyWith({
    String? id,
    String? characterId,
    int? totalExp,
    int? totalCoin,
    int? totalQuests,
    int? totalAchievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CharacterStatistics(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
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
    return 'CharacterStatistics{id: $id, characterId: $characterId, totalExp: $totalExp, totalCoin: $totalCoin, totalQuests: $totalQuests, totalAchievements: $totalAchievements}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterStatistics &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          characterId == other.characterId &&
          totalExp == other.totalExp &&
          totalCoin == other.totalCoin &&
          totalQuests == other.totalQuests &&
          totalAchievements == other.totalAchievements &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      characterId.hashCode ^
      totalExp.hashCode ^
      totalCoin.hashCode ^
      totalQuests.hashCode ^
      totalAchievements.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}