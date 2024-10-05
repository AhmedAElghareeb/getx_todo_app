import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/controllers/controller.dart';
import 'package:getx_todo_app/models/task_model.dart';
import 'package:getx_todo_app/views/add_task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Tasks',
          style: style24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Obx(() {
          return controller.taskList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        size: 100,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Tasks Founded',
                        style: style24,
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.taskList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Slidable(
                        key: ValueKey(index),
                        startActionPane: startActionPaneWid(
                          controller.taskList[index],
                          index,
                        ),
                        endActionPane: endActionPaneWid(index),
                        child: CardItem(
                          task: controller.taskList[index],
                          index: index,
                          controller: controller,
                        ).animate().fade().slide(duration: 500.ms),
                      ),
                    );
                  });
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTaskView());
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ActionPane endActionPaneWid(int index) {
    return ActionPane(
      motion: const DrawerMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          borderRadius: BorderRadius.circular(15),
          autoClose: true,
          onPressed: (ctx) {
            controller.deleteTask(index);
            Get.snackbar(
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                      snackPosition: SnackPosition.BOTTOM,
                      'Done',
                      'Task Deleted Succefully...!',
                    );
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    );
  }

  ActionPane startActionPaneWid(Task task, int index) {
    return ActionPane(
      motion: const DrawerMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          borderRadius: BorderRadius.circular(15),
          autoClose: true,
          onPressed: (context) => Get.to(
            () => AddTaskView(
              task: task,
              index: index,
            ),
          ),
          backgroundColor: const Color(0xff493AD5),
          icon: Icons.edit,
          label: 'Edit',
        ),
      ],
    );
  }

  dynamic get style24 => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      );
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.task,
    required this.index,
    required this.controller,
  });

  final Task task;
  final int index;
  final TaskController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(
          task.isDone ? Icons.check_circle_outline : Icons.check_circle_outline,
          color: task.isDone ? Colors.green : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            const Divider(),
            Text(
              '${task.dateTime!.toLocal()}'.split(' ')[0],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.deepOrange,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => controller.toggleTaskCopmplete(index),
          icon: Icon(
            task.isDone ? Icons.check_circle : Icons.circle_outlined,
            color: task.isDone ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
