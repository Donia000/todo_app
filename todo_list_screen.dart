import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class TodoListScreen extends StatefulWidget {
  final String userName;
  final String category;

  TodoListScreen({required this.userName, required this.category});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('${widget.userName}_${widget.category}');
    if (data != null) {
      List decoded = jsonDecode(data);
      setState(() {
        tasks = decoded.map((e) => Task.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString('${widget.userName}_${widget.category}', data);
  }

  void _addOrEditTask({Task? task, int? index}) {
    String title = task?.title ?? "";
    String priority = task?.priority ?? "Medium";
    DateTime? deadline = task?.deadline;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task == null ? "Add New Task" : "Edit Task"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Task title"),
                onChanged: (val) => title = val,
                controller: TextEditingController(text: task?.title ?? ""),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: priority,
                items: ["High", "Medium", "Low"]
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) priority = val;
                },
                decoration: InputDecoration(labelText: "Priority"),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      deadline != null
                          ? "Deadline: ${deadline?.day}/${deadline?.month}/${deadline?.year}"
                          : "No deadline selected",
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: deadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => deadline = picked);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty) {
                if (task == null) {
                  setState(() {
                    tasks.add(
                      Task(
                        title: title,
                        priority: priority,
                        deadline: deadline,
                      ),
                    );
                  });
                } else {
                  setState(() {
                    tasks[index!] = Task(
                      title: title,
                      isDone: task.isDone,
                      priority: priority,
                      deadline: deadline,
                    );
                  });
                }
                _saveTasks();
                Navigator.pop(context);
              }
            },
            child: Text(task == null ? "Add" : "Save"),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _toggleDone(int index, bool? value) {
    setState(() {
      tasks[index].isDone = value ?? false;
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} List 📝"),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                "No tasks yet, ${widget.userName}! 🌟",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => TaskTile(
                task: tasks[index],
                onChanged: (val) => _toggleDone(index, val),
                onDelete: () => _deleteTask(index),
                onEdit: () => _addOrEditTask(task: tasks[index], index: index),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: Icon(Icons.add),
      ),
    );
  }
}
