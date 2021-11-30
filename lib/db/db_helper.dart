import 'package:fluttertodo/models/courseModel.dart';
import 'package:fluttertodo/models/lecturesModel.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _courseDBTable = 'courses';
  static final String _lectureDBTable = 'lectures';
  static final String _timeTableDB = 'timeTables';

  static Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE $_timeTableDB(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              year INTEGER NOT NULL,
              semester INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE $_courseDBTable(
              id TEXT PRIMARY KEY, 
              title TEXT NOT NULL,
              room TEXT NOT NULL,
              prof TEXT NOT NULL,
              color INTEGER NOT NULL,
              remind INTEGER,
              table_id INTEGER NOT NULL,
              FOREIGN KEY (table_id) REFERENCES $_timeTableDB (id) 
                ON DELETE CASCADE ON UPDATE CASCADE
              )""");

    await db.execute("""
            CREATE TABLE $_lectureDBTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              course_id TEXT,
              start INTEGER NOT NULL,
              end INTEGER NOT NULL,
              date INTEGER NOT NULL,
              table_id INTEGER NOT NULL,
              FOREIGN KEY (course_id) REFERENCES $_courseDBTable (id) 
                ON DELETE CASCADE ON UPDATE CASCADE
            )""");
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'classes.db';
      _db = await openDatabase(_path,
          version: _version, onCreate: _create, onConfigure: _onConfigure);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> insertCourse(CourseModel? courseModel) async {
    print('insert');
    await _db!.insert(_courseDBTable, courseModel!.courseToJson());
    // for (var data in classModel.timeList()) {
    //   await _db!.insert(_lectureTable, data);
    // }
  }

  static Future<void> insertLectures(LecturesModel? lectureModel) async {
    print('insertLec');
    await _db!.insert(_lectureDBTable, lectureModel!.ToJson());
  }

  static Future<void> insertTimeTable(TimeTableModel? timeTableModel) async {
    print('insertTable');
    await _db!.insert(_timeTableDB, timeTableModel!.ToJson());
  }

  static Future<List<Map<String, dynamic>>> queryCourse() async {
    return await _db!.query(_courseDBTable);
  }

  static Future<List<Map<String, dynamic>>> queryLectures() async {
    return await _db!.query(_lectureDBTable);
  }

  static Future<List<Map<String, dynamic>>> queryTables() async {
    return await _db!.query(_timeTableDB);
  }

  static Future<List<Map<String, dynamic>>> queryTableById(int? id) async {
    return await _db!.query(_timeTableDB, where: 'id=?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> queryCourseByTableId(
      int? id) async {
    return await _db!
        .query(_courseDBTable, where: 'table_id=?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> queryLecturesByTableId(
      int? id) async {
    return await _db!
        .query(_lectureDBTable, where: 'table_id=?', whereArgs: [id]);
  }

  static Future<void> deleteByCourseId(String? id) async {
    print('clicked');
    await _db!.delete(_courseDBTable, where: 'id=?', whereArgs: [id]);
  }

  static Future<void> deleteTimeTableById(int? id) async {
    await _db!.delete(_timeTableDB, where: 'id=?', whereArgs: [id]);
  }

  static Future<void> updateTimeTableById(int? id, data) async {
    await _db!.update(_timeTableDB, data, where: 'id=?', whereArgs: [id]);
  }
}
