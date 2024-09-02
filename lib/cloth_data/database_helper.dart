import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Create a singleton instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor to return the same instance each time
  factory DatabaseHelper() {
    return _instance;
  }

  // Private internal constructor
  DatabaseHelper._internal();

  // Getter to access the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Method to initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'laundry.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE laundry(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
    );
  }
}
