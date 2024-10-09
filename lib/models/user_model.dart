import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/user_statistic_model.dart';

class User {
  final String? id;
  final String? username;
  final String? email;
  final bool? isAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.username,
    this.email,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isAdmin: json['isAdmin'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    bool? isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStatistics? userStatistics,
    List<Character>? characters,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, isAdmin: $isAdmin}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          isAdmin == other.isAdmin &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      isAdmin.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

// Helper function for list comparison
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
