import 'package:flutter/material.dart';
import 'add_edit_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> tasks = []; // List of tasks

  void addOrEditTask(Map<String, String> task, [int? index]) {
    setState(() {
      if (index == null) {
        tasks.add(task); // Add new task
      } else {
        tasks[index] = task; // Update existing task
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Delete task
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Manager'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.task_alt),
            title: Text(tasks[index]['name']!),
            subtitle: Text(tasks[index]['description']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditTaskScreen(
                          task: tasks[index],
                          index: index,
                        ),
                      ),
                    );
                    if (updatedTask != null) {
                      addOrEditTask(updatedTask as Map<String, String>, index);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteTask(index);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: tasks[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(),
            ),
          );
          if (newTask != null) {
            addOrEditTask(newTask as Map<String, String>);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
