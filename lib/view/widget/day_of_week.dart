// import 'package:flutter/cupertino.dart';
//
// class DayOfWeek extends StatelessWidget {
//   const DayOfWeek({Key? key}) : super(key: key);
//
//
//   List<Widget> widgetList = [];
//   var datelectureList = _classController.lectureList[i];
//   var listLen = datelectureList.length;
//   var count = 0;
//   for (int k = 0; k < 6; k++) {
//   if (count < listLen) {
//   if (datelectureList[count].start != k) {
//   widgetList.add(LectureTile(
//   color: 3,
//   isNotEmpty: false,
//   flexLen: 1,
//   key: UniqueKey(),
//   ));
//   } else {
//   var TileData = _classController.courseList
//       .where(
//   (e) => e.id == datelectureList[count].course_id)
//       .first;
//   widgetList.add(LectureTile(
//   onTap: () async {
//   _classController.deleteByCourseId(TileData.id);
//   await _classController.getData();
//   },
//   color: TileData.color!,
//   title: TileData.title!,
//   prof: TileData.prof!,
//   room: TileData.room!,
//   isNotEmpty: true,
//   flexLen: datelectureList[count].end! -
//   datelectureList[count].start! +
//   1,
//   key: UniqueKey(),
//   ));
//   k = k +
//   datelectureList[count].end! -
//   datelectureList[count].start!;
//   count++;
//   }
//   } else {
//   widgetList.add(
//   LectureTile(
//   color: 3,
//   flexLen: 1,
//   key: UniqueKey(),
//   isNotEmpty: false,
//   ),
//   );
//   }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
