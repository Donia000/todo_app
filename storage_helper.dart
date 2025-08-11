import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageHelper {
  static const String taskKey = "tasks_list";

  // حفظ المهام
  static Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = tasks
        .map((task) => jsonEncode(task.toMap()))
        .toList();
    await prefs.setStringList(taskKey, taskStrings);
  }

  // تحميل المهام
  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList(taskKey);

    if (taskStrings == null) return [];
    return taskStrings
        .map((taskString) => Task.fromMap(jsonDecode(taskString)))
        .toList();
  }
}
