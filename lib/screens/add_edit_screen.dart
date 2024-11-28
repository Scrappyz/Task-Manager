import 'package:flutter/material.dart';

// Add/Edit task screen for adding a new task or editing an existing one
class AddEditTaskScreen extends StatefulWidget {
  final Map<String, String>? task; // Task data (null if adding)
  final int? index; // Index of the task being edited (null if adding)

  AddEditTaskScreen({this.task, this.index});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key to validate input fields
  final _nameController = TextEditingController(); // Controller for task name
  final _descriptionController = TextEditingController(); // Controller for task description

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Pre-fill data if editing an existing task
      _nameController.text = widget.task!['name']!;
      _descriptionController.text = widget.task!['description']!;
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the screen is disposed
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
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              // Task name input field
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
              // Task description input field
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
              // Button to submit the form
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If form is valid, pass back task data to previous screen
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
