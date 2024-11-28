import 'package:flutter/material.dart';

// Main function to run the app
void main() {
  runApp(TaskManagerApp());
}

// Root widget of the application
class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      initialRoute: '/', // Default route is the HomeScreen
      onGenerateRoute: (settings) { // Dynamically handle route navigation
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/addTask':
            return MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(), // Screen for adding/editing tasks
            );
          case '/details':
            // Retrieve the task data passed via arguments
            final task = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: task), // View task details
            );
          default:
            // Handle unknown routes
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(child: Text('Unknown Route')),
              ),
            );
        }
      },
    );
  }
}

// Home screen displaying the list of tasks
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> tasks = []; // List of tasks (each task is a map with name and description)

  // Add or edit a task
  void addOrEditTask(Map<String, String> task, [int? index]) {
    setState(() {
      if (index == null) {
        tasks.add(task); // Add new task
      } else {
        tasks[index] = task; // Update existing task
      }
    });
  }

  // Delete a task by index
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
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
        itemCount: tasks.length, // Number of tasks
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.task_alt), // Icon for each task
            title: Text(tasks[index]['name']!), // Display task name
            subtitle: Text(tasks[index]['description']!), // Display task description
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditTaskScreen(
                          task: tasks[index], // Pass the task to be edited
                          index: index,
                        ),
                      ),
                    );
                    if (updatedTask != null) {
                      addOrEditTask(updatedTask as Map<String, String>, index); // Update task
                    }
                  },
                ),
                // Delete button
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteTask(index); // Remove task
                  },
                ),
              ],
            ),
            // Tap to view task details
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
              builder: (context) => AddEditTaskScreen(), // Navigate to Add Task screen
            ),
          );
          if (newTask != null) {
            addOrEditTask(newTask as Map<String, String>); // Add new task
          }
        },
        child: Icon(Icons.add), // Floating action button to add a task
      ),
    );
  }
}

// Screen for adding or editing a task
class AddEditTaskScreen extends StatefulWidget {
  final Map<String, String>? task; // Task data (null if adding a new task)
  final int? index; // Index of the task being edited (null if adding)

  AddEditTaskScreen({this.task, this.index});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _nameController = TextEditingController(); // Controller for task name
  final _descriptionController = TextEditingController(); // Controller for task description

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Pre-fill fields if editing a task
      _nameController.text = widget.task!['name']!;
      _descriptionController.text = widget.task!['description']!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Task name input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              // Task description input
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Save button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                    });
                  }
                },
                child: Text(widget.index == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen to display task details
class TaskDetailsScreen extends StatelessWidget {
  final Map<String, String> task; // Task data to display

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task['name']!)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                task['name']!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                task['description']!,
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
