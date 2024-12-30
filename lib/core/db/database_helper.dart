import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = 'tasks.db';
  static const String _tableName = 'tasks';

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _dbName),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isComplete INTEGER,
            priority TEXT,
            completionAt TEXT,
            createdAt TEXT,
            updatedAt TEXT            
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await initDB();

    return db.insert(_tableName, task);
  }

  static Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await initDB();
    return db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task["id"]],
    );
  }

  static Future<List<Map<String, dynamic>>> getSingleTaskById(int? id) async {
    final db = await initDB();
    return db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteTask(int? id) async {
    final db = await initDB();
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> fetchTasks() async {
    final db = await initDB();
    return db.query(_tableName);
  }
}
