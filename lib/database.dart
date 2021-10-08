import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model/breath_record.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "BreathRecord.db"),
      onCreate: (database, version) async {
        await database.execute("""
          CREATE TABLE BreathRecordTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          holdPeriod DOUBLE NOT NULL,
          timeStamp INT NOT NULL
          )
          """);
      },
      version: 1,
    );
  }

  Future<bool> insertData(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert("BreathRecordTable", dataModel.tomap());
    return true;
  }

  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String, Object>> datas = await db.query("BreathRecordTable");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final Database db = await initDB();
    return await db
        .delete("BreathRecordTable", where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final Database db = await initDB();
    await db.delete("BreathRecordTable");
  }
}
