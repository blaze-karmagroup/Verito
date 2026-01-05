import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  LocalDB._privateConstructor();

  static final LocalDB instance = LocalDB._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS attendance_report (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee_id TEXT NOT NULL,
        employee_name TEXT NOT NULL,
        checkMethod TEXT NOT NULL,
        location_name TEXT NOT NULL,
        date_time TEXT NOT NULL)
        ''');
  }

  Future<int> insertLog(Map<String, dynamic> log) async {
    Database db = await instance.database;
    return await db.insert('attendance_report', log);
  }

  Future<List<Map<String, dynamic>>> getLogs() async {
    Database db = await instance.database;
    return await db.query('attendance_report');
  }
}
