import 'dart:convert';

import 'package:fluttertodo/db/db_helper.dart';
import 'package:fluttertodo/models/courseModel.dart';
import 'package:fluttertodo/models/courseDataModel.dart';
import 'package:fluttertodo/models/lecturesModel.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BottomController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var position = 0.0.obs;
  var Courses = <CourseDataModel>[].obs;

  Future<void> getCourseData() async {
    final Uri uri = Uri.parse(
        'https://timetable-36ce9-default-rtdb.asia-southeast1.firebasedatabase.app/TestUni.json');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> list = jsonDecode(response.body);
      print(list);
      final getStorage = GetStorage();
      var table = await getStorage.read('table');
      int tableInt = int.parse(table);
      for (var k in list.keys) {
        Courses.add(CourseDataModel.fromJson(list[k], tableInt));
      }
    }
  }
}
