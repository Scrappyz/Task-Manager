import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/task_details_screen.dart';

// Main entry point of the app
void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      initialRoute: '/', // Default route when app starts
      // Define the routes and navigation
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/addTask':
            return MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(),
            );
          case '/details':
            // Extract task data passed via settings.arguments
            final task = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: task),
            );
          default:
            // Unknown route handler
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
