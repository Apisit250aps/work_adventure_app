class Work {
  final String id;
  final String characterId;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? status; // สามารถกำหนดเป็น "todo", "inprogress", หรือ "done"
  final DateTime createdAt;
  final DateTime updatedAt;

  Work({
    required this.id,
    required this.characterId,
    required this.name,
    this.description,
    this.startDate,
    this.dueDate,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // ฟังก์ชันสำหรับสร้าง instance จาก JSON
  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['_id'] as String,
      characterId: json['characterId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      status: json['status'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // ฟังก์ชันสำหรับแปลง instance เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'name': name,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
