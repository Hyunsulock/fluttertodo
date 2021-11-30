import 'package:fluttertodo/models/courseModel.dart';
import 'package:fluttertodo/models/lecturesModel.dart';
import 'dart:math' as math;

import 'package:get_storage/get_storage.dart';

class CourseDataModel {
  CourseModel? classModel;
  List<dynamic>? lectures;

  CourseDataModel({this.classModel, this.lectures});

  CourseDataModel.fromJson(Map<String, dynamic> json, tableInt) {
    // json['course']['color'] = (math.Random().nextDouble() * 0xFFFFFF).toInt();
    // print(json);

    classModel = CourseModel.coursefromJson(json['course'], table: tableInt);

    lectures = json['lectures']
        .map((e) => LecturesModel.fromJson(e, table: tableInt))
        .toList();
  }
}
