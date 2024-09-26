
class User {
  final String userId;
  final String username;
  final String email;
  final String? fname;
  final String? lname;

  final bool? isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.username,
    required this.email,
    this.fname,
    this.lname,
    this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      username: json['username'],
      email: json['email'],
      fname: json['fname'],
      lname: json['lname'],
      isAdmin: json['isAdmin'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'username': username,
      'email': email,
      'fname': fname,
      'lname': lname,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
