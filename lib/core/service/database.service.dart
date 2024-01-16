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

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    String networkTable = AppConstants.networkTable;
    String deviceTable = AppConstants.deviceTable;
    String clusterTable = AppConstants.clusterTable;
    await db.execute(
      'CREATE TABLE $networkTable ('
      'url TEXT NOT NULL UNIQUE PRIMARY KEY,'
      'macAddr TEXT ,'
      'name TEXT, '
      'num INTEGER, '
      'domain INTEGER,'
      'preDef INTEGER,'
      'ipAddr TEXT,'
      'key TEXT,'
      'numOfNodes INTEGER,'
      'nRT INTEGER,'
      'nRTCh INTEGER,'
      'nEDs INTEGER,'
      'netT INTEGER,'
      'netId INTEGER,'
      'netPId INTEGER,'
      'netPT INTEGER,'
      'nTim INTEGER,'
      'nThr INTEGER,'
      'nCl INTEGER,'
      'nMCl INTEGER,'
      'nAso INTEGER,'
      'nMAso INTEGER,'
      'date INTEGER'
      ')',
    );
    await db.execute('CREATE TABLE $deviceTable('
        'nodeNumber TEXT PRIMARY KEY, nodeType TEXT, nodeSubType TEXT,'
        'location TEXT, stackType TEXT, numChild TEXT, status TEXT,'
        'parentNodeNum TEXT, macAddress TEXT, name TEXT, networkTableMAC TEXT, image TEXT,'
        'dName  TEXT,'
        'dNetNum TEXT,'
        'dNum INTEGER,'
        'dType INTEGER,'
        'dSubType INTEGER,'
        'dStackType INTEGER,'
        'dLocation INTEGER,'
        'dParNum INTEGER,'
        'dNumChild INTEGER,'
        'dAssociation INTEGER,'
        'dMacAddr TEXT ,'
        'dStatus INTEGER,'
        'dDim INTEGER,'
        'nAct INTEGER,'
        'actStatus TEXT,'
        'numOfSen INTEGER,'
        'numOfAssocSen INTEGER,'
        'sensorVal TEXT,'
        'clTbl TEXT,'
        'aITbl TEXT,'
        'aLTbl TEXT,'
        'timI INTEGER,'
        'thI INTEGER,'
        'thP1 TEXT,'
        'thP2 TEXT,'
        'thTY TEXT, '
        'thSN TEXT,'
        'thAT TEXT,'
        'thSA TEXT, '
        'thST TEXT,'
        'thET TEXT, '
        'thWK TEXT,'
        'thEM TEXT,'
        'thSM TEXT,'
        'ST TEXT,'
        'ET TEXT,'
        'TT TEXT,'
        'WK TEXT,'
        'AT TEXT,'
        'SA TEXT,'
        'EM TEXT,'
        'SM TEXT,'
        'senD TEXT'
        ')');

    await db.execute(
      '''CREATE TABLE $clusterTable(
        clusterName TEXT PRIMARY KEY, type TEXT, devices TEXT, description TEXT)
    ''',
    );
  }

  Future<void> insertCluster(Cluster breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.clusterTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cluster>> getAllClusters() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.clusterTable);
    return List.generate(maps.length, (index) => Cluster.fromMap(maps[index]));
  }

  Future<List<Cluster>> getClusterByName(List<String> clusterName) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.clusterTable,
        where: 'clusterName = ?',
        whereArgs: clusterName);
    return List.generate(maps.length, (index) => Cluster.fromMap(maps[index]));
  }

  Future<void> insertNetwork(RpeNetwork breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.networkTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<RpeNetwork>> getAllNetworks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.networkTable);
    return List.generate(
        maps.length, (index) => RpeNetwork.fromMap(maps[index]));
  }

  Future<void> insertDevice(RpeDevice breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.deviceTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<RpeNetwork>> getNetworksByPreDef(List<int> types) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.networkTable,
        where: 'preDef = ?',
        whereArgs: types);
    return List.generate(
        maps.length, (index) => RpeNetwork.fromMap(maps[index]));
  }

  Future<List<RpeNetwork>> getNetworksById(List<String> ids) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db
        .query(AppConstants.networkTable, where: 'id = ?', whereArgs: ids);
    return List.generate(
        maps.length, (index) => RpeNetwork.fromMap(maps[index]));
  }

  Future clearAllDevice() async {
    final db = await _databaseService.database;
    String tableName = AppConstants.deviceTable;
    return await db.rawDelete("DELETE FROM $tableName");
  }

  Future<List<RpeDevice>> getAllDevices() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.deviceTable);
    return List.generate(
        maps.length, (index) => RpeDevice.fromMap(maps[index]));
  }

  Future<List<RpeDevice>> getDevices(List<String> mac) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.deviceTable,
        where: 'networkTableMAC = ?',
        whereArgs: mac);
    return List.generate(
        maps.length, (index) => RpeDevice.fromMap(maps[index]));
  }

  Future<List<RpeDevice>> getDevicesByMac(List<String> mac) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.deviceTable,
        where: 'macAddress = ?',
        whereArgs: mac);
    return List.generate(
        maps.length, (index) => RpeDevice.fromMap(maps[index]));
  }

  Future<RpeDevice> getDevicesByNodeNumType(
      nodeType, nodeSubType, nodeNumber) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.deviceTable,
        where: 'nodeType = ? and nodeSubtype = ? and nodeNumber = ? ',
        whereArgs: [nodeType, nodeSubType, nodeNumber]);
    return RpeDevice.fromMap(maps[0]);
  }

  Future updateDevice(RpeDevice device) async {
    final db = await _databaseService.database;
    await db.update(AppConstants.deviceTable, device.toMap(),
        where: 'macAddress = ?', whereArgs: [device.macAddress]);
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
