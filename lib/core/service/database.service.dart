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
    String uploadTable = AppConstants.uploadTable;
    await db.execute(
      'CREATE TABLE $networkTable ('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'num INTEGER, '
      'domain INTEGER,'
      'preDef INTEGER,'
      'macAddr TEXT,'
      'ipAddr TEXT,'
      'port TEXT,'
      'ssid TEXT,'
      'key TEXT,'
      'rSSID TEXT,' // router SSID
      'rKey TEXT' // router pass key
      'rLIP TEXT,' // router local IP
      'rEIP TEXT,' // router External IP
      'rPort TEXT,' // router port
      'maxNodes INTEGER,'
      'numOfNodes INTEGER,'
      'nRT INTEGER,' // num of RTs in networks
      'nRTCh TEXT,' // num of children per RT (max 10 RT)
      'nEDs INTEGER,' // num of EDs in network
      'netT INTEGER,' // network type
      'netId INTEGER,' // network Id
      'netPId INTEGER,'
      'netPT INTEGER,'
      'nTim INTEGER,' // total of timers defined in a network
      'nThr INTEGER,' // total of thresholds defined in a network
      'nCl INTEGER,' // number of clusters
      'nMCl INTEGER,'
      'nAso INTEGER,' // number of associations
      'nMAso INTEGER,' // number of multi network associations
      'date INTEGER,'
      ')',
    );
    await db.execute(
      'CREATE TABLE $uploadTable ('
      'id INTEGER PRIMARY KEY, '
      'dName  TEXT,'
      'dNetNum INTEGER,'
      'dNum INTEGER,'
      'dType INTEGER,'
      'dSubType INTEGER,'
      'dStackType INTEGER,'
      'dLocation TEXT,'
      'dParNum INTEGER,' // Parent Node Num
      'dNumChild INTEGER,'
      'dAssociation INTEGER,'
      'dMacAddr TEXT ,'
      'dStatus INTEGER,'
      'dDim INTEGER,'
      'nAct INTEGER,'
      'actStatus TEXT,' // actuation status
      'numOfSen INTEGER,' // num of sensors
      'numOfAssocSen INTEGER,'
      'sensorVal TEXT,'
      'clTbl TEXT,  ' // table which holds if a given device is part of a cluster (0-9)
      'aITbl TEXT,  ' // assoc Initiator table
      'aLTbl TEXT,'
      'timI INTEGER,  ' //timerInd: 0,
      'thI INTEGER,    ' //threshInd: 0,

      'thP1 TEXT,'
      'thP2 TEXT,'
      'thTY TEXT, ' // threshold type
      'thSN TEXT,  ' // threshold sensor
      'thAT TEXT,  ' // Action Type
      'thSA TEXT, ' // Status
      'thST TEXT,  ' // Start Time
      'thET TEXT, ' // End Time
      'thWK TEXT,  ' // Weekday
      'thEM TEXT,'
      'thSM TEXT,'
      'ST TEXT,  ' // start time
      'ET TEXT,  ' // end time
      'TT TEXT,  ' // timer type
      'WK TEXT,  ' // Weekday
      'AT TEXT,  ' // action type
      'SA TEXT,  ' // status
      'EM TEXT,'
      'SM TEXT,'
      'senD TEXT,'
      ')',
    );
    await db.execute(
      '''CREATE TABLE $deviceTable(
        nodeNumber TEXT PRIMARY KEY, nodeType TEXT, nodeSubType TEXT,
        Location TEXT, stackType TEXT, numChild TEXT, status TEXT,
        parentNodeNum TEXT, macAddress TEXT, name TEXT, networkTableMAC TEXT)
    ''',
    );
  }

  Future<void> insertNetwork(RpeNetwork breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.networkTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RpeNetwork>> getAllNetworks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.networkTable);
    return List.generate(maps.length, (index) => RpeNetwork.fromMap(maps[index]));
  }

  Future<void> insertDevice(Device breed) async {
    final db = await _databaseService.database;
    await db.insert(
      AppConstants.deviceTable,
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RpeNetwork>> getNetworksByType(List<String> types) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db
        .query(AppConstants.networkTable, where: 'type = ?', whereArgs: types);
    return List.generate(maps.length, (index) => RpeNetwork.fromMap(maps[index]));
  }

  Future<List<RpeNetwork>> getNetworksById(List<String> ids) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db
        .query(AppConstants.networkTable, where: 'id = ?', whereArgs: ids);
    return List.generate(maps.length, (index) => RpeNetwork.fromMap(maps[index]));
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

  Future<void> insertUpload(RpeUpload breed) async {
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

  Future<List<RpeUpload>> getAllUploads() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query(AppConstants.uploadTable);
    return List.generate(maps.length, (index) => RpeUpload.fromMap(maps[index]));
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
