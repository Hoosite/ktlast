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
    print('Connected to MongoDB');
  }

  Future<void> disconect() async {
    await _db.close();
    _isConnected = false;
    print('Disconect to MongoDB');
  }
  