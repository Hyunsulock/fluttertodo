import 'package:flutter/material.dart';
import 'package:fluttertodo/db/db_helper.dart';
import 'package:fluttertodo/models/courseModel.dart';
import 'package:fluttertodo/models/lecturesModel.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClassController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var timeTableName = ''.obs;
  var timeTableYear = 2020.obs;
  var timeTableSemester = 1.obs;
  var courseList = <CourseModel>[].obs;
  var lectureList = <List<LecturesModel>>[[], [], [], [], [], [], []].obs;
  var lastday = 5.obs;
  var lastLecture = 6.obs;
  var changeTable = true.obs;
  var TableLayoutMax = 0.0.obs;

  Future<void> addClass({CourseModel? courseModel}) async {
    return await DBHelper.insertCourse(courseModel);
  }

  Future<void> addLectures({LecturesModel? lecturesModel}) async {
    return await DBHelper.insertLectures(lecturesModel);
  }

  Future<void> addTimeTable({TimeTableModel? timeTableModel}) async {
    return await DBHelper.insertTimeTable(timeTableModel);
  }

  Future<void> getData() async {
    final getStorage = GetStorage();
    var table = await getStorage.read('table');
    if (table == null) {
      print('added Timetable at Init');
      await getStorage.write('table', '1');
      await addTimeTable(
          timeTableModel: TimeTableModel(
        title: '시간표1',
        year: 2022,
        semester: 1,
      ));
      timeTableName('시간표1');
      timeTableYear(2022);
      timeTableSemester(1);
      return;
    }
    var lastHour = 6;
    int tableInt = int.parse(table);
    var tableData = await DBHelper.queryTableById(tableInt);
    timeTableName(tableData[0]['title']);
    timeTableYear(tableData[0]['year']);
    timeTableSemester(tableData[0]['semester']);
    int tableId = tableData[0]['id'];
    var result = await Future.wait([
      DBHelper.queryCourseByTableId(tableId),
      DBHelper.queryLecturesByTableId(tableId)
    ]);
    List<Map<String, dynamic>> courses = result[0];
    List<Map<String, dynamic>> lectures = result[1];

    print("lec " + lectures.length.toString());
    courseList.assignAll(
        courses.map((e) => new CourseModel.coursefromJson(e)).toList());
    for (int i = 0; i < 7; i++) {
      var datelectureList =
          lectures.where((element) => element['date'] == i).toList();
      datelectureList.sort((a, b) => a['start']!.compareTo(b['start']!));
      if (datelectureList.isNotEmpty) {
        int lastTime = datelectureList.last['end'];
        if (lastTime + 1 > lastHour) {
          lastHour = lastTime + 1;
          print(lastHour);
        }
      }

      lectureList[i].assignAll(
          datelectureList.map((e) => new LecturesModel.fromJson(e)).toList());
    }
    if (lastHour > 6) {
      lastLecture.value = lastHour;
    } else {
      lastLecture.value = 6;
    }
    if (lectureList[6].length != 0) {
      lastday.value = 7;
    } else {
      if (lectureList[5].length != 0) {
        lastday.value = 6;
      } else {
        lastday.value = 5;
      }
    }
  }

  void deleteByCourseId(String? id) {
    DBHelper.deleteByCourseId(id);
    getData();
  }
}
