import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/grid': (context) => CategoryScreen(),
        '/details': (context) => TaskDetailsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> tasks = List.generate(10, (index) => 'Task $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Manager'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('View Categories'),
              onTap: () {
                Navigator.pushNamed(context, '/grid');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text(tasks[index]),
            onTap: () {
              Navigator.pushNamed(context, '/details',
                  arguments: tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add new tasks feature coming soon!')),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'Work',
    'Personal',
    'Health',
    'Shopping',
    'Learning',
    'Hobbies',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${categories[index]} selected')),
              );
            },
            child: Card(
              color: Colors.blue[100],
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TaskDetailsScreen extends StatefulWidget {
  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final String taskName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _completed = !_completed;
            });
          },
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            padding: EdgeInsets.all(20),
            width: _completed ? 250 : 200,
            height: _completed ? 100 : 150,
            decoration: BoxDecoration(
              color: _completed ? Colors.green[200] : Colors.red[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                _completed
                    ? '$taskName Completed!'
                    : 'Mark $taskName as Complete',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
