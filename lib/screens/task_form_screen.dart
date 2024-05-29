import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Новая задача' : 'Редактировать задачу', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Описание'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final task = Task(
                      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      isCompleted: _isCompleted,
                    );
                    if (widget.task == null) {
                      await Provider.of<DatabaseService>(context, listen: false).insertTask(task);
                    } else {
                      await Provider.of<DatabaseService>(context, listen: false).updateTask(task);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.task == null ? 'Добавить задачу' : 'Обновить задачу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
