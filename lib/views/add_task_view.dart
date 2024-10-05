import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_todo_app/controllers/controller.dart';
import 'package:getx_todo_app/models/task_model.dart';

class AddTaskView extends StatefulWidget {
  final Task? task;
  final int? index;
  const AddTaskView({super.key, this.index, this.task});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TaskController controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      controller.titleController.text = widget.task!.title;
      controller.descriptionController.text = widget.task!.description;
      controller.selectedDate = widget.task!.dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.task != null ? 'Edit Task' : 'Add New Task',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(
              label: 'Title',
              hint: 'Enter Title...',
              controller: controller.titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            AppInput(
              label: 'Description',
              hint: 'Enter Description...',
              controller: controller.descriptionController,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select Date",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton.icon(
              onPressed: () async {
                controller.selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(3000),
                );
                setState(() {});
              },
              label: Text(
                controller.selectedDate == null
                    ? 'Pick Date'
                    : '${controller.selectedDate!.toLocal()}'.split(' ')[0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrange,
                ),
              ),
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: Colors.deepOrange,
                size: 25,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (controller.titleController.text.isEmpty ||
                      controller.descriptionController.text.isEmpty ||
                      controller.selectedDate == null) {
                    Get.snackbar(
                      colorText: Colors.white,
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.BOTTOM,
                      'Error',
                      'All fields are required',
                    );
                    return;
                  }
                  if (widget.task != null) {
                    var updatedTask = Task(
                      title: controller.titleController.text,
                      description: controller.descriptionController.text,
                      dateTime: controller.selectedDate!,
                      isDone: widget.task!.isDone,
                    );
                    controller.editTask(widget.index!, updatedTask);
                    Get.back();
                    Get.snackbar(
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                      snackPosition: SnackPosition.BOTTOM,
                      'Updated',
                      'Task updated successfully',
                    );
                  } else {
                    var newTask = Task(
                      title: controller.titleController.text,
                      description: controller.descriptionController.text,
                      dateTime: controller.selectedDate!,
                    );
                    controller.addTask(newTask);
                    Get.back();
                    Get.snackbar(
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                      snackPosition: SnackPosition.BOTTOM,
                      'Added',
                      'Task added successfully',
                    );
                  }
                },
                child: Text(
                  widget.task != null ? 'Edit Task' : 'Add Task',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.label,
    required this.hint,
    this.subLabel,
    this.controller,
    this.focusNode,
    this.inputFormatters,
    // this.prefixIcon,
    // this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    // this.isPassword = false,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.fillColor,
    this.maxLines = 1,
    // this.enableSuffixPadding = true,
    this.labelSpace,
  });

  final String label, hint;
  final String? subLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  // final Widget? prefixIcon, suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  // final bool isPassword;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool readOnly, enabled;
  final Color? fillColor;
  final int maxLines;
  // final bool enableSuffixPadding;
  final double? labelSpace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: labelSpace ?? 8),
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          inputFormatters: inputFormatters,
          cursorColor: Theme.of(context).primaryColor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
          readOnly: readOnly,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? Colors.white,
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
            errorMaxLines: 2,
            // prefixIcon: prefixIcon,
            // suffixIcon: Padding(
            //   padding: enableSuffixPadding
            //       ? const EdgeInsetsDirectional.only(end: 5)
            //       : EdgeInsets.zero,
            //   child: suffixIcon,
            // ),
            // suffixIconConstraints: const BoxConstraints(),
            // prefixIconConstraints: const BoxConstraints(),
            border: _border(context),
            enabledBorder: _border(context),
            focusedBorder: _border(context),
            errorBorder: _border(context),
            focusedErrorBorder: _border(context),
            disabledBorder: _border(context),
          ),
        ),
        if (subLabel != null) const SizedBox(height: 5),
        if (subLabel != null)
          Text(
            subLabel!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  OutlineInputBorder _border(context) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      );
}
