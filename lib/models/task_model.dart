class Task {
  final String id;
  final String name;
  final String? description;
  final int difficulty; // ต้องเป็น 1, 2, หรือ 3
  final DateTime? startDate;
  final DateTime? dueDate;
  final bool? isDone;
  final String? workId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.name,
    this.description,
    required this.difficulty,
    this.startDate,
    this.dueDate,
    this.isDone,
    this.workId,
    required this.createdAt,
    required this.updatedAt,
  });

  // ฟังก์ชันสำหรับการสร้าง instance จาก JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as int,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      isDone: json['isDone'] as bool?,
      workId: json['workId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // ฟังก์ชันสำหรับการแปลง instance เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'isDone': isDone,
      'workId': workId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
