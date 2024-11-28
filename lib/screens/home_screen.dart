import 'package:flutter/material.dart';
import 'add_edit_screen.dart'; // Import the Add/Edit screen
import 'task_details_screen.dart'; // Import the Task details screen

// Home screen that displays the list of tasks
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> tasks = []; // List of tasks, initially empty

  // Function to add or edit tasks
  void addOrEditTask(Map<String, String> task, [int? index]) {
    setState(() {
      if (index == null) {
        tasks.add(task); // Add new task to the list
      } else {
        tasks[index] = task; // Update an existing task at index
      }
    });
  }

  // Function to delete a task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index); // Remove task at the given index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Manager'), // Title of the app bar
        centerTitle: true, // Center the title
      ),
      body: ListView.builder(
        itemCount: tasks.length, // Number of tasks to display
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.task_alt), // Icon for each task
            title: Text(tasks[index]['name']!), // Task name
            subtitle: Text(tasks[index]['description']!), // Task description
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // Navigate to Add/Edit screen and get the updated task
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
                // Delete button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteTask(index); // Delete the task
                  },
                ),
              ],
            ),
            // On tapping the task, navigate to task details screen
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
          // Navigate to Add/Edit screen to add a new task
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(),
            ),
          );
          if (newTask != null) {
            addOrEditTask(newTask as Map<String, String>); // Add the new task
          }
        },
        child: Icon(Icons.add), // Add button icon
      ),
    );
  }
}
