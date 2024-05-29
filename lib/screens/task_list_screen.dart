import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../models/task.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<void> _connectFuture;
  late StreamSubscription<List<Task>> _tasksSubscription;

  @override
  void initState() {
    super.initState();
    _connectFuture = Provider.of<DatabaseService>(context, listen: false).connect();

    // подписка на поток
    _tasksSubscription = Provider.of<DatabaseService>(context, listen: false).taskStream.listen((tasks) {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _tasksSubscription.cancel(); // отмена подписмки
    Provider.of<DatabaseService>(context, listen: false).disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        shadowColor: Color.fromARGB(255, 75, 88, 132),
        backgroundColor: Color.fromARGB(255, 186, 195, 242),
        
      ),
      body: FutureBuilder<void>(
        future: _connectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            if (Provider.of<DatabaseService>(context, listen: false).isConnected) {
              return FutureBuilder<List<Task>>(
                future: Provider.of<DatabaseService>(context, listen: false).getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else {
                    final tasks = snapshot.data ?? [];
                    if (tasks.isEmpty) {
                      return Center(child: Text('Нет задач'));
                    } else {
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  task.isCompleted = value ?? false;
                                });
                                Provider.of<DatabaseService>(context, listen: false).updateTask(task);
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TaskFormScreen(task: task),
                              ));
                            },
                            onLongPress: () {
                              Provider.of<DatabaseService>(context, listen: false).deleteTask(task.id);
                            },
                          );
                        },
                      );
                    }
                  }
                },
              );
            } else {
              return Center(child: Text('ошибка MongoDB'));
            }
          }
        },
      ),
      backgroundColor: Color.fromARGB(255, 133, 105, 245),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskFormScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
