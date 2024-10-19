class Character {
  final String? id;
  final String? name;
  final int? avatarIndex;
  final int? exp;
  final int? level;
  final String? className;
  final int? coin;
  final int? health;
  final int? stamina;
  final int? focusPoint;
  final int? statusPoint;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Character({
    this.id,
    this.name,
    this.avatarIndex,
    this.exp,
    this.level,
    this.className,
    this.coin,
    this.health,
    this.stamina,
    this.focusPoint,
    this.statusPoint,
    this.createdAt,
    this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'] as String,
      name: json['name'] as String,
      avatarIndex: json['avatarIndex'] as int,
      exp: json['exp'] as int,
      level: json['level'] as int,
      className: json['className'] as String,
      coin: json['coin'] as int,
      health: json['health'] as int,
      stamina: json['stamina'] as int,
      focusPoint: json['focus_point'] as int,
      statusPoint: json['status_point'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'avatarIndex': avatarIndex,
      'exp': exp,
      'level': level,
      'className': className,
      'coin': coin,
      'health': health,
      'stamina': stamina,
      'focus_point': focusPoint,
      "status_Point": statusPoint,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Character copyWith({
    String? id,
    String? name,
    int? avatarIndex,
    int? exp,
    int? level,
    String? className,
    int? coin,
    int? health,
    int? stamina,
    int? focusPoint,
    int? statusPoint,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      exp: exp ?? this.exp,
      level: level ?? this.level,
      className: className ?? this.className,
      coin: coin ?? this.coin,
      health: health ?? this.health,
      stamina: stamina ?? this.stamina,
      focusPoint: focusPoint ?? this.focusPoint,
      statusPoint: statusPoint ?? this.statusPoint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Character{id: $id, name: $name, level: $level, className: $className}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatarIndex == other.avatarIndex &&
          exp == other.exp &&
          level == other.level &&
          className == other.className &&
          coin == other.coin &&
          health == other.health &&
          stamina == other.stamina &&
          focusPoint == other.focusPoint &&
          statusPoint == other.statusPoint &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      avatarIndex.hashCode ^
      exp.hashCode ^
      level.hashCode ^
      className.hashCode ^
      coin.hashCode ^
      health.hashCode ^
      stamina.hashCode ^
      focusPoint.hashCode ^
      statusPoint.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
