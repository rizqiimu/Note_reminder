import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'catatan.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  final String tableCatatan = 'catatan_tb';
  final String columId = 'id';
  final String columJudul = 'judul';
  final String columCatatan = 'catatan';
  final String columDate = 'date';
  final String columTime = 'time';
  final String columIdDevice = 'idDevice';

  static Database _db;

  DbHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'catatan.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableCatatan($columId INTEGER PRIMARY KEY, $columJudul TEXT, $columCatatan TEXT, $columDate TEXT, $columTime TEXT, $columIdDevice TEXT)");
  }

  Future<int> saveCatatan(Catatan catatan) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableCatatan, catatan.toMap());
    print(result);
    return result;
  }

  Future<List> getAllCatatan() async {
    var dbClient = await db;
    var result = await dbClient.query(tableCatatan, columns: [
      columId,
      columJudul,
      columCatatan,
      columDate,
      columTime,
      columIdDevice
    ]);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableCatatan"));
  }

  Future<Catatan> getCatatan(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableCatatan,
        columns: [
          columId,
          columJudul,
          columCatatan,
          columDate,
          columTime,
          columIdDevice
        ],
        where: '$columId = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return Catatan.fromMap(result.first);
    }
    return null;
  }

  // get by Id Device
  Future<Catatan> getCatatanByIdDevice(String id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableCatatan,
        columns: [
          columId,
          columJudul,
          columCatatan,
          columDate,
          columTime,
          columIdDevice
        ],
        where: '$columIdDevice = ?',
        whereArgs: [id]);
    if (result.length > 0) {
      return Catatan.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteCatatan(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableCatatan, where: '$columId = ?', whereArgs: [id]);
  }

  Future<int> updateCatatan(Catatan catatan) async {
    var dbClient = await db;
    return await dbClient.update(tableCatatan, catatan.toMap(),
        where: '$columId = ?', whereArgs: [catatan.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
