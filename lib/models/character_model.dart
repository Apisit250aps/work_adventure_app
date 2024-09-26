// class Character {
//   final String id;
//   final String userId;
//   final String name;
//   final String className;
//   final int? exp;
//   final int? level;
//   final int? coin;
//   final int? health;
//   final int? stamina;
//   final int? focusPoint;  // เปลี่ยนชื่อจาก focus_point เป็น camelCase ตามมาตรฐาน Dart
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Character({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.className,
//     this.exp,
//     this.level,
//     this.coin,
//     this.health,
//     this.stamina,
//     this.focusPoint,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // ฟังก์ชันสำหรับการสร้าง instance จาก JSON
//   factory Character.fromJson(Map<String, dynamic> json) {
//     return Character(
//       id: json['_id'] as String,
//       userId: json['userId'] as String,
//       name: json['name'] as String,
//       className: json['className'] as String,
//       exp: json['exp'] as int?,
//       level: json['level'] as int?,
//       coin: json['coin'] as int?,
//       health: json['health'] as int?,
//       stamina: json['stamina'] as int?,
//       focusPoint: json['focus_point'] as int?,  // แปลงเป็น focusPoint ในคลาส
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//     );
//   }

//   // ฟังก์ชันสำหรับการแปลง instance เป็น JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'name': name,
//       'className': className,
//       'exp': exp,
//       'level': level,
//       'coin': coin,
//       'health': health,
//       'stamina': stamina,
//       'focus_point': focusPoint,  // แปลงเป็น focus_point ใน JSON
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
