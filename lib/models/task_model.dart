import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  DateTime? dateTime;


  Task({
    required this.title, 
    required this.description, 
   this.isDone = false,
    required this.dateTime,
    });
}