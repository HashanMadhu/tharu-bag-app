import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Database එක ලබා ගැනීම (නැතිනම් අලුතින් සාදයි)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tharu_bags.db');
    return _database!;
  }

  // Database එක පෝන් එකේ නිර්මාණය කිරීම
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // orders නමින් Table එකක් සෑදීම
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        bagName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');
  }

  // ඇණවුමක් සේව් කිරීම (Insert)
  Future<int> insertOrder(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('orders', row);
  }

  // සියලුම ඇණවුම් ලබා ගැනීම (Query)
  Future<List<Map<String, dynamic>>> queryAllOrders() async {
    final db = await instance.database;
    return await db.query('orders');
  }

  // ඇණවුමක් මැකීම (Delete)
  Future<int> deleteOrder(int id) async {
    final db = await instance.database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
