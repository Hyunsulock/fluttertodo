import 'package:flutter/material.dart';
import 'dart:math' as math;

class CourseModel {
  String? id;
  String? title;
  String? room;
  String? prof;
  int? remind;
  int? color;
  int? table_id;
  // List<Map<int, bool>>? classCheckList;

  CourseModel(
      {this.id,
      this.title,
      this.room,
      this.prof,
      this.remind,
      this.color,
      this.table_id
      // this.classCheckList,
      });

  CourseModel.coursefromJson(Map<String, dynamic> json, {int table = -1}) {
    id = json['id'];
    title = json['title'];
    room = json['room'];
    prof = json['prof'];
    remind = 5;
    color = json['color'] != null ? json['color'] : Colors.blueAccent.value;
    table_id = json['table_id'] != null ? json['table_id'] : table;
  }

  Map<String, dynamic> courseToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['room'] = this.room;
    data['prof'] = this.prof;
    data['remind'] = this.remind;
    data['color'] = this.color;
    data['table_id'] = this.table_id;
    return data;
  }

  // List<Map<String, dynamic>> timeList() {
  //   final List<Map<String, dynamic>> dataList = [];
  //   var j = 0;
  //   for (var dayMap in classCheckList!) {
  //     if (dayMap.isEmpty) {
  //       j++;
  //       continue;
  //     }
  //     if (dayMap.keys.length > 1) {
  //       List<List<int>> result = [];
  //       List<int> temp = [];
  //       List<int> daykeyList = dayMap.keys.toList();
  //       daykeyList.sort();
  //       print('keys' + dayMap.keys.toList().toString());
  //       temp.add(daykeyList[0]);
  //       for (var i = 0; i < dayMap.keys.length - 1; i++) {
  //         if (daykeyList[i + 1] == daykeyList[i] + 1) {
  //           temp.add(daykeyList[i + 1]);
  //           print('temp' + temp.toString());
  //         } else {
  //           result.add(temp);
  //           print('result' + result.toString());
  //           temp = [];
  //           temp.add(dayMap.keys.toList()[i + 1]);
  //         }
  //       }
  //       result.add(temp);
  //       print(result);
  //       for (var list in result) {
  //         Map<String, dynamic> data = new Map<String, dynamic>();
  //         data['course_id'] = this.id;
  //         data['hour'] = list[0];
  //         data['length'] = list.last - list[0];
  //         data['date'] = j;
  //         dataList.add(data);
  //       }
  //     } else {
  //       Map<String, dynamic> data = new Map<String, dynamic>();
  //       data['course_id'] = this.id;
  //       data['hour'] = dayMap.keys.toList()[0];
  //       data['length'] = 0;
  //       data['date'] = j;
  //       dataList.add(data);
  //     }
  //     j++;
  //   }
  //   print(dataList);
  //   return dataList;
  // }
}
