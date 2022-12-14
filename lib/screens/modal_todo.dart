import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc23_project_cgjimenez/models/todo_model.dart';
import 'package:cmsc23_project_cgjimenez/providers/todo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoModal extends StatelessWidget {
  String type;
  final TextEditingController _formFieldController = TextEditingController();
  static final FirebaseAuth auth = FirebaseAuth.instance;

  TodoModal({
    super.key,
    required this.type,
  });
  DateTime now = DateTime.now();

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add New Todo");
      case 'Edit':
        return const Text("Edit Todo");
      case 'Delete':
        return const Text("Delete Todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              Todo temp = Todo(
                  userId: auth.currentUser!.uid,
                  completed: false,
                  title: _formFieldController.text,
                  sharedWith: []);

              context.read<TodoListProvider>().addTodo(temp);

              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              context.read<TodoListProvider>().editTodo(
                  "${_formFieldController.text} (Edited ${now.toString()})");

              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
