import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_icons/solar_icons.dart';

class TasksScreen extends StatefulWidget {
  final VoidCallback onBack;

  const TasksScreen({super.key, required this.onBack});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("smart_toolkit_tasks");

    if (saved != null) {
      final List decoded = jsonDecode(saved);

      if (!mounted) return;

      setState(() {
        tasks = decoded.map((e) => Task.fromJson(e)).toList();
      });
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "smart_toolkit_tasks",
      jsonEncode(tasks.map((e) => e.toJson()).toList()),
    );
  }

  void addTask() {
    if (taskController.text.trim().isEmpty) return;

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: taskController.text.trim(),
      completed: false,
    );

    setState(() {
      tasks.insert(0, task);
    });

    taskController.clear();
    saveTasks();
  }

  void toggleTask(String id) {
    setState(() {
      final task = tasks.firstWhere((t) => t.id == id);
      task.completed = !task.completed;
    });

    saveTasks();
  }

  void deleteTask(String id) {
    setState(() {
      tasks.removeWhere((t) => t.id == id);
    });

    saveTasks();
  }

  void editTask(Task task) {
    taskController.text = task.title;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: "Update task...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                      ),
                      onPressed: () {
                        setState(() {
                          task.title = taskController.text.trim();
                        });

                        saveTasks();
                        taskController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void openAddDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "New Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: "Enter task...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                      ),
                      onPressed: () {
                        addTask();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: openAddDialog,
        child: const Icon(SolarIconsOutline.addCircle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Task Manager",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          "No tasks yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => toggleTask(task.id),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: task.completed
                                          ? const Color(0xFF4F46E5)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFF4F46E5),
                                        width: 2,
                                      ),
                                    ),
                                    child: task.completed
                                        ? const Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: task.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.completed
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(SolarIconsOutline.pen),
                                  onPressed: () => editTask(task),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      SolarIconsOutline.trashBinTrash),
                                  onPressed: () => deleteTask(task.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String id;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "completed": completed,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );
}
