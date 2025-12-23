import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/travel_plan.dart'; // Pastikan import ini benar

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // GANTI NAMA DATABASE DI SINI AGAR TIDAK KONFLIK DENGAN YANG LAMA
    String path = join(await getDatabasesPath(), 'culture_explorer_final.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE travel_plans(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            heritageName TEXT,
            heritageCountry TEXT,
            heritageImage TEXT,
            planDate TEXT,
            notes TEXT,
            status TEXT,
            budget REAL,
            rating INTEGER
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertTravelPlan(TravelPlan plan) async {
    final db = await database;
    try {
      return await db.insert('travel_plans', plan.toMap());
    } catch (e) {
      print("Database Insert Error: $e");
      return 0;
    }
  }

  // READ ALL
  Future<List<TravelPlan>> getAllTravelPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('travel_plans', orderBy: "id DESC");
    return List.generate(maps.length, (i) {
      return TravelPlan.fromMap(maps[i]);
    });
  }

  // UPDATE
  Future<int> updateTravelPlan(TravelPlan plan) async {
    final db = await database;
    return await db.update(
      'travel_plans',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  // DELETE
  Future<int> deleteTravelPlan(int id) async {
    final db = await database;
    return await db.delete(
      'travel_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}