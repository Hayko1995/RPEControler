import 'package:path/path.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rpe_c/core/models/db.models.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.dbName);

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {lightSensors} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE crTable (id INTEGER PRIMARY KEY, nodeNumber INTEGER, nodeType INTEGER, nodeSubType INTEGER, Location TEXT, stackType INTEGER, numChild INTEGER, status INTEGER, parentNodeNum INTEGER, macAddress TEXT )',
    );
  }

  Future<void> insertCR(CR breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.crTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CR>> getAllCRs() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.crTable);
    return List.generate(maps.length, (index) => CR.fromMap(maps[index]));
  }

  Future<CR> getCR(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.crTable, where: 'id = ?', whereArgs: [id]);
    return CR.fromMap(maps[0]);
  }

  Future<void> updateCR(CR breed) async {
    final db = await _databaseService.database;

    await db.update(
      AppConstants.light,
      breed.toMap(),
      where: 'id = ?',
      whereArgs: [breed.id],
    );
  }

  Future<void> deleteCR(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      AppConstants.light,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getAllTableNames() async {
    final db = await _databaseService.database;
    List<Map> maps =
        await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');

    List<String> tableNameList = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        try {
          tableNameList.add(maps[i]['name'].toString());
        } catch (e) {
          print('Exeption : Cant get from db all names ');
        }
      }
    }
    return tableNameList;
  }
}
