import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database.dart';
import 'models/task.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
          dispose: (_, dbService) => dbService.disconnect(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODO',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskListScreen(),
      ),
    );
  }
}
