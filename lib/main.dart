
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple,
        accentColor: Colors.black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.purple,
      ),
      home: TodoListScreen(
        isDarkMode: isDarkMode,
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  TodoListScreen({required this.isDarkMode, required this.toggleTheme});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, dynamic>> _todos = [];
  List<Map<String, dynamic>> _trashedTodos = [];
  List<Map<String, dynamic>> _filteredTodos = [];
  String _searchQuery = "";

  get center => null;

  @override
  void initState() {
    super.initState();
    _filteredTodos = _todos;
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTodo = "";
        String? note;
        DateTime? selectedDate;
        TimeOfDay? selectedTime;

        return AlertDialog(
          title: Text("Add a new task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => newTodo = value,
                  decoration: InputDecoration(hintText: "Any plan?"),
                ),
                TextField(
                  onChanged: (value) => note = value,
                  decoration: InputDecoration(hintText: "Add a note (optional)"),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(selectedDate == null
                          ? "Set Date"
                          : DateFormat.yMMMd().format(selectedDate!)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(selectedTime == null
                          ? "Set Time"
                          : selectedTime!.format(context)),
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
                if (newTodo.isNotEmpty) {
                  setState(() {
                    _todos.add({
                      'title': newTodo,
                      'note': note,
                      'completed': false,
                      'reminderDate': selectedDate,
                      'reminderTime': selectedTime,
                      'pinned': false,
                    });
                    _filteredTodos = _todos;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editTodoAtIndex(int index) {
    final todo = _filteredTodos[index];
    String editedTitle = todo['title'];
    String? editedNote = todo['note'];
    DateTime? editedDate = todo['reminderDate'];
    TimeOfDay? editedTime = todo['reminderTime'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => editedTitle = value,
                  controller: TextEditingController(text: todo['title']),
                  decoration: InputDecoration(hintText: "Edit title"),
                ),
                TextField(
                  onChanged: (value) => editedNote = value,
                  controller: TextEditingController(text: todo['note']),
                  decoration: InputDecoration(hintText: "Edit note"),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: editedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            editedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(editedDate == null
                          ? "Set Date"
                          : DateFormat.yMMMd().format(editedDate!)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: editedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            editedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(editedTime == null
                          ? "Set Time"
                          : editedTime!.format(context)),
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
                setState(() {
                  _todos[index] = {
                    'title': editedTitle,
                    'note': editedNote,
                    'completed': todo['completed'],
                    'reminderDate': editedDate,
                    'reminderTime': editedTime,
                    'pinned': todo['pinned'],
                  };
                  _filteredTodos = _todos;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoAtIndex(int index) {
    setState(() {
      _trashedTodos.add(_filteredTodos[index]);
      _todos.remove(_filteredTodos[index]);
      _filteredTodos = _todos
          .where((todo) =>
              todo['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _togglePin(int index) {
    setState(() {
      _filteredTodos[index]['pinned'] = !_filteredTodos[index]['pinned'];
      _filteredTodos = _todos;
    });
  }

  void _searchTodoList(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTodos = _todos
          .where((todo) =>
              todo['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        backgroundColor: Colors.purple,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _searchTodoList,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: widget.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = _filteredTodos[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo['completed'],
                      onChanged: (bool? value) {
                        setState(() {
                          todo['completed'] = value!;
                        });
                      },
                    ),
                    title: Text(
                      todo['title'],
                      style: TextStyle(
                        fontWeight:
                            todo['pinned'] ? FontWeight.bold : FontWeight.normal,
                        decoration: todo['completed']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todo['note'] != null) Text("Note: ${todo['note']}"),
                        if (todo['reminderDate'] != null &&
                            todo['reminderTime'] != null)
                          Text(
                            "Reminder: ${DateFormat.yMMMd().format(todo['reminderDate'])}, ${todo['reminderTime'].format(context)}",
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (todo['reminderDate'] != null &&
                            todo['reminderTime'] != null)
                          Icon(
                            Icons.notifications,
                            color: Colors.purple,
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () => _editTodoAtIndex(index),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.push_pin,
                            color: todo['pinned'] ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _togglePin(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodoAtIndex(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _addTodo,
                backgroundColor: Colors.purple,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child:
                  Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Settings"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SwitchListTile(
                            title: Text("Dark Mode"),
                            value: widget.isDarkMode,
                            onChanged: (bool value) {
                              widget.toggleTheme();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text("About"),
              leading: Icon(Icons.info),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(      
                      title: Text("About"),
                      content: Text(
                          "Final Project of Group 8 \nMichael Angelo Hernanandez \nAngelle Salvadora\nAlexis Ilogon\nArnelieh Talaba \n\n\n'Don't be busy, BE PRODUCTIVE!'"                          ),
                   
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
             ListTile(
              title: Text("Trash Bin"),
              leading: Icon(Icons.delete),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrashBinScreen(
                      trashedTodos: _trashedTodos,
                      restoreTodo: (int index) {
                        setState(() {
                          _todos.add(_trashedTodos[index]);
                          _trashedTodos.removeAt(index);
                          _filteredTodos = _todos;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TrashBinScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trashedTodos;
  final Function(int) restoreTodo;

  TrashBinScreen({required this.trashedTodos, required this.restoreTodo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trash Bin"), backgroundColor: Colors.purple),
      body: trashedTodos.isEmpty
          ? Center(child: Text("No tasks in the trash bin."))
          : ListView.builder(
              itemCount: trashedTodos.length,
              itemBuilder: (context, index) {
                final todo = trashedTodos[index];
                return ListTile(
                  title: Text(todo['title']),
                  subtitle: todo['note'] != null ? Text("Note: ${todo['note']}") : null,
                  trailing: IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () => restoreTodo(index),
                  ),
                );
              },
            ),
    );
  }
}