class Task {
  final String id;
  final String name;
  final String? description;
  final int difficulty;
  final DateTime? startDate;
  final DateTime? dueDate;
  final bool isDone;
  final String? workId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.name,
    this.description,
    required this.difficulty,
    this.startDate,
    this.dueDate,
    required this.isDone,
    this.workId,
    required this.createdAt,
    required this.updatedAt,
  }) : assert(difficulty >= 1 && difficulty <= 3,
            'Difficulty must be 1, 2, or 3');

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
      isDone: json['isDone'] as bool,
      workId: json['workId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

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

  Task copyWith({
    String? id,
    String? name,
    String? description,
    int? difficulty,
    DateTime? startDate,
    DateTime? dueDate,
    bool? isDone,
    String? workId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
      workId: workId ?? this.workId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, difficulty: $difficulty, isDone: $isDone}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          difficulty == other.difficulty &&
          startDate == other.startDate &&
          dueDate == other.dueDate &&
          isDone == other.isDone &&
          workId == other.workId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      difficulty.hashCode ^
      startDate.hashCode ^
      dueDate.hashCode ^
      isDone.hashCode ^
      workId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}