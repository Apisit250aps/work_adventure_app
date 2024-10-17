import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'quest_hive_model.g.dart';

@HiveType(typeId: 0)
class Quest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String details;

  Quest({
    String? id,
    required this.title,
    this.isCompleted = false,
    required this.date,
    this.details = '',
  }) : id = id ?? const Uuid().v4();
}
