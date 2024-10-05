import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/models/task_model.dart';
import 'package:hive/hive.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  void openBox() async {
    var box = await Hive.openBox<Task>('todoTasks');
    taskList.addAll(box.values);
  }


  void addTask(Task task) async {
    var box = Hive.box<Task>('todoTasks');
    box.add(task);
    taskList.add(task);
  }

  void deleteTask(int index) {
    var box = Hive.box<Task>('todoTasks');
    box.deleteAt(index);
    taskList.removeAt(index);
  }

  void editTask(int index, Task newTask) {
    var box = Hive.box<Task>('todoTasks');
    box.putAt(index, newTask);
    taskList[index] = newTask;
  }

  void toggleTaskCopmplete(int index) {
    taskList[index].isDone = !taskList[index].isDone;
    taskList.refresh();
  }
}