import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/task_details_screen.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/addTask':
            return MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(),
            );
          case '/details':
            final task = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(task: task),
            );
          default:
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
