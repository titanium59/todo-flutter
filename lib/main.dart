import 'package:flutter/material.dart';
import 'package:to_do/my_todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final todoName = TextEditingController();
  TodoPriority taskPriority = TodoPriority.medium;

  void _showEmptyTodoNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Required'),
          content: const Text('Please enter a task name.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My ToDo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: MyTodo.todos.isEmpty
          ? const Center(
        child: Text(
          "No ToDo's",
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      )
          : ListView(
        children: MyTodo.todos.map((todo) {
          return ListTile(
            title: Text(todo.name.toString()),
            subtitle: Text("Priority: ${todo.priority.toString().split('.').last}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo.completed,
                  onChanged: (bool? newValue) {
                    setState(() {
                      todo.completed = newValue ?? false;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      MyTodo.todos.remove(todo);
                    });
                  },),
              ],
            )

          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              // StatefulBuilder allows managing the state inside the BottomSheet
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 20,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: todoName,
                          decoration: const InputDecoration(
                            labelText: "Enter Task",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text("Select Priority"),
                        Row(
                          children: [
                            Radio<TodoPriority>(
                              value: TodoPriority.low,
                              groupValue: taskPriority,
                              onChanged: (value) {
                                setModalState(() {
                                  taskPriority = value!;
                                });
                              },
                            ),
                            const Text("Low"),
                            Radio<TodoPriority>(
                              value: TodoPriority.medium,
                              groupValue: taskPriority,
                              onChanged: (value) {
                                setModalState(() {
                                  taskPriority = value!;
                                });
                              },
                            ),
                            const Text("Medium"),
                            Radio<TodoPriority>(
                              value: TodoPriority.high,
                              groupValue: taskPriority,
                              onChanged: (value) {
                                setModalState(() {
                                  taskPriority = value!;
                                });
                              },
                            ),
                            const Text("High"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Perform any necessary actions, like saving the task
                            setState(() {
                              if(todoName.text.isEmpty){
                                _showEmptyTodoNameDialog();
                              }
                              else{
                                MyTodo currentTodo = MyTodo(id: DateTime.now().millisecondsSinceEpoch , name: todoName.text, priority: taskPriority);
                                MyTodo.todos.add(currentTodo);
                                todoName.clear();
                                Navigator.pop(context);
                              }
                            });
                          },
                          child: const Text('Save Task'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}