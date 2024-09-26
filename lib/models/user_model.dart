import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/models/user_statistic_model.dart';



class User {
  final String id;
  final String username;
  final String email;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserStatistics userStatistics;
  final List<Character> characters;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.userStatistics,
    required this.characters,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var characterList = json['characters'] as List;
    List<Character> characters = characterList.map((i) => Character.fromJson(i)).toList();

    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      isAdmin: json['isAdmin'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      userStatistics: UserStatistics.fromJson(json['userStatistics']),
      characters: characters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userStatistics': userStatistics.toJson(),
      'characters': characters.map((character) => character.toJson()).toList(),
    };
  }
}
