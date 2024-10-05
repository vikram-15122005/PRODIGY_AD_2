import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _todoItems = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoList(); // Load saved tasks when app starts
  }

  // Load to-do items from shared_preferences
  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTodos = prefs.getStringList('todoItems');
    if (savedTodos != null) {
      setState(() {
        _todoItems.addAll(savedTodos);
      });
    }
  }

  // Save to-do items to shared_preferences
  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoItems', _todoItems);
  }

  // Add a new task to the list and save it
  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _todoItems.add(task);
      });
      _textController.clear();
      _saveTodoList(); // Save the updated list
    }
  }

  // Remove a task from the list and save the change
  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
    _saveTodoList(); // Save the updated list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          _buildInputField(),
          Expanded(child: _buildTodoList()),
        ],
      ),
    );
  }

  // Input field to add a new task
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter a task',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addTodoItem(_textController.text),
          ),
        ],
      ),
    );
  }

  // Build the list of to-do items
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(index);
      },
    );
  }

  // Build each individual to-do item
  Widget _buildTodoItem(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(_todoItems[index]),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeTodoItem(index),
        ),
      ),
    );
  }
}
