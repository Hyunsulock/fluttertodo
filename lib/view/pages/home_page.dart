import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/constant.dart';
import 'package:fluttertodo/controller/class_controller.dart';
import 'package:fluttertodo/controller/notification_services.dart';
import 'package:fluttertodo/view/pages/add_class_online.dart';
import 'package:fluttertodo/view/pages/timetable_list_page.dart';
import 'package:fluttertodo/view/widget/behav.dart';
import 'package:fluttertodo/view/widget/lectureTile.dart';
import 'package:get/get.dart';
import 'add_course_manual.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  late NotifyHelper notifyHelper;
  final _classController = Get.put(ClassController());
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('restared ----');
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _classController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_classController.timeTableYear.value.toString()}년 ${_classController.timeTableSemester.value.toString()}학기',
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          Text(
                            _classController.timeTableName.value,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () async {
                            var result = await Get.to(AddCourseOnlinePage(
                                notifyHelper: notifyHelper));
                            if (result != null) {
                              _classController.getData();
                            }
                          },
                          iconSize: 24,
                          icon: Icon(Icons.add_box_outlined)),
                      IconButton(
                          iconSize: 24,
                          onPressed: () async {},
                          icon: Icon(Icons.settings_outlined)),
                      IconButton(
                          iconSize: 24,
                          onPressed: () async {
                            await Get.to(TimeTableListPage());
                            _classController.getData();
                          },
                          icon: Icon(Icons.format_list_bulleted)),
                    ],
                  ),
                ],
              ),
              Obx(() => _daysIndex()),
              Obx(() => _showTable(_classController.lastLecture.value)),
            ],
          ),
        ),
      ),
    );
  }

  Container _daysIndex() {
    print('call 2 obx');
    List<Widget> daysList = [];
    for (int i = 0; i < _classController.lastday.value; i++) {
      daysList.add(_dayIndexTile(days[i]));
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!, width: 1.0),
          //Color(0xFF95C0FF),
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.symmetric(
        vertical: 0,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.grey[200]!))),
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: Text(
              classTime[0][0],
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          ...daysList
        ],
      ),
    );
  }

  Expanded _dayIndexTile(String day) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  _showTable(lastLecture) {
    return Expanded(child: LayoutBuilder(
      builder: (context, constraints) {
        print('update of controll');
        if (constraints.maxHeight < lastLecture * 100) {
          return _scrollableTable(lastLecture.toDouble() * 100);
        } else {
          print('mmax');
          return _scrollableTable(constraints.maxHeight - 10);
        }
      },
    ));
  }

  _drawtable() {
    List<Widget> widgetList = [];
    for (int i = 0; i < _classController.lastLecture.value; i++) {
      widgetList.add(Expanded(
        flex: 1,
        child: Container(
          decoration: i == 0
              ? BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(width: 1.0, color: Colors.grey[200]!),
                  ))
              : i == _classController.lastLecture.value - 1
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      border: Border.all(width: 1.0, color: Colors.grey[200]!))
                  : BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          right:
                              BorderSide(width: 1.0, color: Colors.grey[200]!),
                          top: BorderSide(
                              width: 1.0, color: Colors.grey[200]!))),
        ),
      ));
    }
    return Column(
      children: widgetList,
    );
  }

  _dayOfWeek(int day) {
    List<Widget> widgetList = [];
    var datelectureList = _classController.lectureList[day];
    var listLen = datelectureList.length;
    var count = 0;
    for (int k = 0; k < _classController.lastLecture.value; k++) {
      if (count < listLen) {
        if (datelectureList[count].start != k) {
          widgetList.add(LectureTile(
            color: 3,
            isNotEmpty: false,
            flexLen: 1,
            key: UniqueKey(),
          ));
        } else {
          var TileData = _classController.courseList
              .where((e) => e.id == datelectureList[count].course_id)
              .first;
          widgetList.add(LectureTile(
            onTap: () async {
              Get.dialog(Dialog(
                // insetPadding:
                //     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Wrap(children: [
                    Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(TileData.color!),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                TileData.title!,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w500),
                              ),
                              Expanded(child: Container()),
                              GestureDetector(
                                child: Icon(Icons.delete),
                                onTap: () async {
                                  _classController
                                      .deleteByCourseId(TileData.id);
                                  await _classController.getData();
                                  Get.back();
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            children: [
                              Icon(Icons.face_rounded,
                                  size: 20, color: Colors.grey[700]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                TileData.prof!,
                                style: TextStyle(color: Colors.grey[700]),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                          child: Row(
                            children: [
                              Icon(Icons.fmd_good_rounded,
                                  size: 20, color: Colors.grey[700]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                TileData.room!,
                                style: TextStyle(color: Colors.grey[700]),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ));
              // _classController.deleteByCourseId(TileData.id);
              // await _classController.getData();
            },
            color: TileData.color!,
            title: TileData.title!,
            prof: TileData.prof!,
            room: TileData.room!,
            isNotEmpty: true,
            flexLen:
                datelectureList[count].end! - datelectureList[count].start! + 1,
            key: UniqueKey(),
          ));
          k = k + datelectureList[count].end! - datelectureList[count].start!;
          count++;
        }
      } else {
        widgetList.add(
          LectureTile(
            color: 3,
            flexLen: 1,
            key: UniqueKey(),
            isNotEmpty: false,
          ),
        );
      }
    }
    return Expanded(
      flex: 1,
      child: Column(
        children: widgetList,
      ),
    );
  }

  _scrollableTable(double height) {
    _classController.TableLayoutMax.value = height;
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: height,
                child: Obx(() {
                  return _drawtable();
                }),
              ),
              ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(10)),
                child: Container(
                  height: height,
                  child: Obx(() {
                    print('call obx');
                    List<Widget> tableList = [];

                    tableList.add(Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        child: timeIndex()));

                    for (int i = 0; i < _classController.lastday.value; i++) {
                      tableList.add(_dayOfWeek(i));
                    }
                    tableList.add(Container(
                      width: 1,
                    ));

                    return Row(children: tableList);
                  }),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }

  Column timeIndex() {
    List<Widget> TimeTiles = [];
    for (int i = 0; i < _classController.lastLecture.value; i++) {
      TimeTiles.add(Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            decoration: i == 0
                ? BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(width: 1.0, color: Colors.grey[200]!),
                      left: BorderSide(width: 1.0, color: Colors.grey[200]!),
                    ))
                : i == _classController.lastLecture.value - 1
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                        border:
                            Border.all(width: 1.0, color: Colors.grey[200]!))
                    : BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            right: BorderSide(
                                width: 1.0, color: Colors.grey[200]!),
                            left: BorderSide(
                                width: 1.0, color: Colors.grey[200]!),
                            top: BorderSide(
                                width: 1.0, color: Colors.grey[200]!))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${i + 1}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  classTime[i][0],
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
                Text(
                  'I',
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
                Text(
                  classTime[i][1],
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          )));
    }
    return Column(
      children: TimeTiles,
    );
  }
}
