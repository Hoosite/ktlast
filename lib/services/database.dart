import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/task.dart';

class DatabaseService {
  static const String MONGO_CONN_URL = "mongodb://localhost:27017/todo_app";
  static const String DB_NAME = "todo_app";
  static const String TASKS_COLLECTION = "tasks";

  late Db _db;
  late DbCollection _tasksCollection;
  bool _isConnected = false;

  late StreamController<List<Task>> _tasksController;

  Stream<List<Task>> get taskStream => _tasksController.stream;

  DatabaseService() {
    _tasksController = StreamController<List<Task>>.broadcast();
  }

  Future<void> connect() async {
    _db = await Db.create(MONGO_CONN_URL);
    await _db.open();
    _tasksCollection = _db.collection(TASKS_COLLECTION);
    _isConnected = true;
    print('Connected MongoDB');
  }

  Future<void> disconnect() async {
    await _db.close();
    _isConnected = false;
    print('Disconect MongoDB');
  }
  bool get isConnected => _isConnected;


   Future<List<Task>> getTasks() async {
          if (!_isConnected) {
      throw StateError('Database is not connected');
    }

    final tasks = await _tasksCollection.find().toList();
    return tasks.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> insertTask(Task task) async {
          if (!_isConnected) {
      throw StateError('Database is not connected');
    }

    task.id = ObjectId().toHexString();
    await _tasksCollection.insert(task.toJson());
    _updateTaskStream();
  }

  Future<void> updateTask(Task task) async {
          if (!_isConnected) {
      throw StateError('Database is not connected');
    }

    await _tasksCollection.update(
      where.id(ObjectId.fromHexString(task.id)),
      task.toJson(),
    );
    _updateTaskStream();
  }

  Future<void> deleteTask(String taskId) async {
          if (!_isConnected) {
      throw StateError('Database is not connected');
    }

    await _tasksCollection.remove(where.id(ObjectId.fromHexString(taskId)));
    _updateTaskStream();
  }

  void _updateTaskStream() async {
          if (!_isConnected) {
      throw StateError('Database is not connected');
    }

    final tasks = await _tasksCollection.find().toList();
    _tasksController.add(tasks.map((task) => Task.fromJson(task)).toList());
  }
}
