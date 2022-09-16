// Import a package that makes it easy to start building a basic app
import 'package:flutter/material.dart';

// Define our todo element
class Todo {
  // Two fields:
  // String name representing task name
  // bool checked representing whether the task is checked off
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

// TodoItem is a class for each item in the list
// TodoItem is a widget
class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  // Change text appearance based on task status
  TextStyle? _getTextStyle(bool checked) {
    // If task is not checked do nothing
    if (!checked) return null;

    // If task is checked add strike through to cross it off
    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  // This widget actually displays the tasks
  @override
  Widget build(BuildContext context) {
    // ListTile widget lets us display the task
    return ListTile(
      // When the tile is tap, we call the onTodoChanged function
      onTap: () {
        onTodoChanged(todo);
      },
      // Add circle icon that holds the first letter of the task
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      // Title is the task text
      // with the style defined in the previous function based on task status
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

// Calls a state to determine what to do and render
class TodoList extends StatefulWidget {
  @override
  // Calls _TodoListState, which is defined below
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // Initialize a text controller (allows user to enter text)
  final TextEditingController _textFieldController = TextEditingController();
  // Define our list/array of todo items (tasks)
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar holds the app title
      appBar: AppBar(
        // Specify the app title
        title: Text('To-Do List App'),
      ),
      // Body of the app is a ListView widget where the todos are the children
      body: ReorderableListView(
        // Specify padding for the body of the app
        padding: EdgeInsets.symmetric(vertical: 8.0),
        // Enable reordering of the list
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if(newIndex > oldIndex){
              newIndex = newIndex-1;
            }
          });
          // Reorder all tasks based on old/new indices
          final task = _todos.removeAt(oldIndex);
          _todos.insert(newIndex, task);
        },
        // Children of the list view are each of the todo items in our list
        children: _todos.map((Todo todo) {
          // map all the todos and return a todoItem for each one
          return TodoItem(
            // the todo itself
            todo: todo,
            // change handler function
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      // Button that will create a dialog when pressed
      floatingActionButton: FloatingActionButton(
          // Create dialog box when pressed
          onPressed: () => _displayDialog(),
          // Add tooltip indicating purpose of button
          tooltip: 'Add Item',
          // Plus sign icon on the button
          child: Icon(Icons.add)),
    );
  }

  // Called when todo is clicked
  void _handleTodoChange(Todo todo) {
    // State change rebuilds the whole widget
    setState(() {
      // Flip checked boolean
      todo.checked = !todo.checked;
    });
  }

  // Adds a new todo item to our master list
  void _addTodoItem(String name) {
    if (name.isNotEmpty) {
      setState(() {
        // Add a new todo with the specified name
        // Defaults to not checked off
        _todos.add(Todo(name: name, checked: false));
      });
      // Empty the text controller
      _textFieldController.clear();
    }
  }

  Future<void> _displayDialog() async {
    // Show a dialog box with the following contents
    return showDialog<void>(
      context: context,
      // Force user to tap button
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // Prompt user to add a new item
          title: const Text('Add a new todo item'),
          content: TextField(
                  // Provide text controller for adding text
                  controller: _textFieldController,
                  // Add guide text inside the text box
                  decoration: const InputDecoration(hintText: 'Type your new todo'),
          ),
          // Has an action that holds the add button
          actions: <Widget>[
            TextButton(
              // Button says Add on it
              child: const Text('Add'),
              // When pressed, add the todo item with the text in the box
              // Close the dialog box as well
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

// TodoApp is the widget with the skeleton of the list
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Give app a title
      title: 'To-Do List App',
      // Home calls the todolist function that actually has the items
      home: TodoList(),
    );
  }
}

// Main returns an instance of the TodoApp, which runs all our code
void main() => runApp(TodoApp());