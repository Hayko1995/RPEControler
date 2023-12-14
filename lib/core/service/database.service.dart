import 'package:path/path.dart';
import 'package:rpe_c/app/constants/app.constants.dart';
import 'package:rpe_c/core/api/mesh.api.dart';
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
    print("db path =" + path);

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE networkTable (id INTEGER PRIMARY KEY, mac TEXT, val INTEGER)',
    );
    await db.execute(
      'CREATE TABLE location (id INTEGER PRIMARY KEY, name TEXT, val INTEGER)',
    );
    await db.execute(
      '''CREATE TABLE uploadTable (
        nodeNumber TEXT  PRIMARY KEY, nodeType TEXT, nodeSubType TEXT,
        nodeStatus TEXT, nodeMessageLen TEXT, timeStamp TEXT, uploadMessageType TEXT, 
        messageSubType TEXT, sensorType TEXT, sensorValue TEXT)''',
    );
    await db.execute(
      '''CREATE TABLE deviceTable (
        nodeNumber TEXT PRIMARY KEY, nodeType TEXT, nodeSubType TEXT,
        Location TEXT, stackType TEXT, numChild TEXT, status TEXT,
        parentNodeNum TEXT, macAddress TEXT, name TEXT, networkTableMAC TEXT)''',
    );
  }

  Future<void> insertNetwork(Network breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.networkTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Network>> getAllNetworks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.networkTable);
    return List.generate(maps.length, (index) => Network.fromMap(maps[index]));
  }

  Future<void> insertDevice(Device breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.deviceTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future clearAllDevice() async {
    final db = await _databaseService.database;
    String tableName = AppConstants.deviceTable;
    return await db.rawDelete("DELETE FROM $tableName");
  }

  Future<List<Device>> getAllDevices() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.deviceTable);
    return List.generate(maps.length, (index) => Device.fromMap(maps[index]));
  }

  Future<List<Device>> getDevices(List<String> mac) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.deviceTable,
        where: 'networkTableMAC = ?',
        whereArgs: mac);
    return List.generate(maps.length, (index) => Device.fromMap(maps[index]));
  }

  // Future<CR> getCR(int id) async {
  //   final db = await _databaseService.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(AppConstants.crTable, where: 'id = ?', whereArgs: [id]);
  //   return CR.fromMap(maps[0]);
  // }

  // Future<void> updateCR(CR breed) async { TODO
  //   final db = await _databaseService.database;
  //
  //   await db.update(
  //     AppConstants.crTable,
  //     breed.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [breed.id],
  //   );
  // }

  Future<void> deleteDevice(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      AppConstants.deviceTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertUpload(Upload breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.uploadTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future clearAllUploads() async {
    final db = await _databaseService.database;
    String tableName = AppConstants.uploadTable;
    return await db.rawDelete("DELETE FROM $tableName");
  }

  Future<List<Upload>> getAllUploads() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.uploadTable);
    return List.generate(maps.length, (index) => Upload.fromMap(maps[index]));
  }

  // Future<CR> getCR(int id) async {
  //   final db = await _databaseService.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(AppConstants.crTable, where: 'id = ?', whereArgs: [id]);
  //   return CR.fromMap(maps[0]);
  // }

  // Future<void> updateCR(CR breed) async { TODO
  //   final db = await _databaseService.database;
  //
  //   await db.update(aaaa
  //     AppConstants.crTable,
  //     breed.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [breed.id],
  //   );
  // }

  Future<void> deleteUpload(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      AppConstants.uploadTable,
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
