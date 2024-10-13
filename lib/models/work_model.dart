import 'package:work_adventure/models/task_model.dart';

class Work {
  final String? id;
  final String? characterId;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? status; // "todo", "inprogress", หรือ "done"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<dynamic>? tasks;

  const Work({
    this.id,
    this.characterId,
    this.name,
    this.description,
    this.startDate,
    this.dueDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.tasks,
  }) : assert(
          status == null ||
              status == 'todo' ||
              status == 'inprogress' ||
              status == 'done',
          'Status must be null, "todo", "inprogress", or "done"',
        );

  factory Work.fromJson(Map<String, dynamic> json) {
    final task = json['tasks']?.map((task) => Task.fromJson(task)).toList();
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
      tasks: task,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'name': name,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tasks': tasks,
    };
  }

  Work copyWith({
    String? id,
    String? characterId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? dueDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Task>? tasks,
  }) {
    return Work(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tasks: tasks?? this.tasks,
    );
  }

  @override
  String toString() {
    return 'Work{id: $id, name: $name, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Work &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          characterId == other.characterId &&
          name == other.name &&
          description == other.description &&
          startDate == other.startDate &&
          dueDate == other.dueDate &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      characterId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      startDate.hashCode ^
      dueDate.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
