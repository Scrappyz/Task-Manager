import 'package:flutter/material.dart';

// Task details screen that displays detailed information about the task
class TaskDetailsScreen extends StatelessWidget {
  final Map<String, String> task; // Task data to display

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task['name']!)), // Display task name in the app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task['name']!, // Task name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                task['description']!, // Task description
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
