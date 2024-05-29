import 'package:mongo_dart/mongo_dart.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
    '_id': ObjectId.fromHexString(id),
    'title': title,
    'description': description,
    'dueDate': dueDate.toIso8601String(),
    'isCompleted': isCompleted,
  };

  static Task fromJson(Map<String, dynamic> json) => Task(

    id: (json['_id'] as ObjectId).toHexString(),
    title: json['title'],
    description: json['description'],
    dueDate: DateTime.parse(json['dueDate']),
    isCompleted: json['isCompleted'],
  );}