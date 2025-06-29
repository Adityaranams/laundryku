import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('laundry.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        serviceType TEXT NOT NULL,
        weight REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertOrder(Order order) async {
    final db = await instance.database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<Order>> getOrders() async {
    final db = await instance.database;
    final result = await db.query('orders');
    return result.map((map) => Order.fromMap(map)).toList();
  }

  // Fungsi update pesanan
  Future<int> updateOrder(Order order) async {
    final db = await instance.database;
    return await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  // Fungsi delete pesanan
  Future<int> deleteOrder(int id) async {
    final db = await instance.database;
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
