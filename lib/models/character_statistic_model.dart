class Character {
  final String id;
  final String name;
  final int exp;
  final int level;
  final String className;
  final int coin;
  final int health;
  final int stamina;
  final int focusPoint;
  final DateTime createdAt;
  final DateTime updatedAt;

  Character({
    required this.id,
    required this.name,
    required this.exp,
    required this.level,
    required this.className,
    required this.coin,
    required this.health,
    required this.stamina,
    required this.focusPoint,
    required this.createdAt,
    required this.updatedAt,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
