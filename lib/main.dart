import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/models/task_model.dart';
import 'package:getx_todo_app/views/home_view.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<Task>('todoTasks');
  runApp(const ToDoAppWithGetX());
}

class ToDoAppWithGetX extends StatelessWidget {
  const ToDoAppWithGetX({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do Tasks',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeView(),
    );
  }
}
