class Character {
  final String? id;
  final String? name;
  final int? exp;
  final int? level;
  final String? className;
  final int? coin;
  final int? health;
  final int? stamina;
  final int? focusPoint;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Character({
    this.id,
    this.name,
    this.exp,
    this.level,
    this.className,
    this.coin,
    this.health,
    this.stamina,
    this.focusPoint,
    this.createdAt,
    this.updatedAt,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'] as String,
      name: json['name'] as String,
      exp: json['exp'] as int,
      level: json['level'] as int,
      className: json['className'] as String,
      coin: json['coin'] as int,
      health: json['health'] as int,
      stamina: json['stamina'] as int,
      focusPoint: json['focus_point'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'exp': exp,
      'level': level,
      'className': className,
      'coin': coin,
      'health': health,
      'stamina': stamina,
      'focus_point': focusPoint,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Character copyWith({
    String? id,
    String? name,
    int? exp,
    int? level,
    String? className,
    int? coin,
    int? health,
    int? stamina,
    int? focusPoint,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      exp: exp ?? this.exp,
      level: level ?? this.level,
      className: className ?? this.className,
      coin: coin ?? this.coin,
      health: health ?? this.health,
      stamina: stamina ?? this.stamina,
      focusPoint: focusPoint ?? this.focusPoint,
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
          exp == other.exp &&
          level == other.level &&
          className == other.className &&
          coin == other.coin &&
          health == other.health &&
          stamina == other.stamina &&
          focusPoint == other.focusPoint &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      exp.hashCode ^
      level.hashCode ^
      className.hashCode ^
      coin.hashCode ^
      health.hashCode ^
      stamina.hashCode ^
      focusPoint.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}