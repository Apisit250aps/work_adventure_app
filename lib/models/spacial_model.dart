
class Special {
  final String? id;
  final String? charId;
  final int? strength;
  final int? perception;
  final int? endurance;
  final int? charisma;
  final int? intelligence;
  final int? agility;
  final int? luck;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Special({
    this.id,
    this.charId,
    this.strength,
    this.perception,
    this.endurance,
    this.charisma,
    this.intelligence,
    this.agility,
    this.luck,
    this.createdAt,
    this.updatedAt,
  });

  factory Special.fromJson(Map<String, dynamic> json) {
    return Special(
      id: json['_id'] as String,
      charId: json['charId'] as String,
      strength: json['strength'] as int,
      perception: json['perception'] as int,
      endurance: json['endurance'] as int,
      charisma: json['charisma'] as int,
      intelligence: json['intelligence'] as int,
      agility: json['agility'] as int,
      luck: json['luck'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'charId': charId,
      'strength': strength,
      'perception': perception,
      'endurance': endurance,
      'charisma': charisma,
      'intelligence': intelligence,
      'agility': agility,
      'luck': luck,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Special copyWith({
    String? id,
    String? charId,
    int? strength,
    int? perception,
    int? endurance,
    int? charisma,
    int? intelligence,
    int? agility,
    int? luck,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Special(
      id: id ?? this.id,
      charId: charId ?? this.charId,
      strength: strength ?? this.strength,
      perception: perception ?? this.perception,
      endurance: endurance ?? this.endurance,
      charisma: charisma ?? this.charisma,
      intelligence: intelligence ?? this.intelligence,
      agility: agility ?? this.agility,
      luck: luck ?? this.luck,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Special{id: $id, charId: $charId, strength: $strength, perception: $perception, endurance: $endurance, charisma: $charisma, intelligence: $intelligence, agility: $agility, luck: $luck}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Special &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          charId == other.charId &&
          strength == other.strength &&
          perception == other.perception &&
          endurance == other.endurance &&
          charisma == other.charisma &&
          intelligence == other.intelligence &&
          agility == other.agility &&
          luck == other.luck &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      charId.hashCode ^
      strength.hashCode ^
      perception.hashCode ^
      endurance.hashCode ^
      charisma.hashCode ^
      intelligence.hashCode ^
      agility.hashCode ^
      luck.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
