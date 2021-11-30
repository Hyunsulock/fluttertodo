import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/controller/add_course_online_controller.dart';
import 'package:fluttertodo/controller/class_controller.dart';
import 'package:fluttertodo/view/pages/add_course_manual.dart';
import 'package:fluttertodo/view/widget/behav.dart';
import 'package:fluttertodo/view/widget/lectureTile.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constant.dart';

class AddCourseOnlinePage extends StatefulWidget {
  final notifyHelper;

  const AddCourseOnlinePage({Key? key, required this.notifyHelper})
      : super(key: key);

  @override
  _AddCourseOnlinePageState createState() => _AddCourseOnlinePageState();
}

class _AddCourseOnlinePageState extends State<AddCourseOnlinePage> {
  final _classController = Get.put(ClassController());
  final panelController = PanelController();
  final _bottomController = Get.put(BottomController());
  int _selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomController.getCourseData();
  }

  @override
  Widget build(BuildContext context) {
    final MaxHeight = MediaQuery.of(context).size.height * 0.5;
    final MinHeight = MediaQuery.of(context).size.height * 0.1;
    final panalMaxScrollExtent = MaxHeight - MinHeight;
    _bottomController.position.value = panalMaxScrollExtent + MinHeight;
    return Scaffold(
      body: SlidingUpPanel(
        boxShadow: [
          BoxShadow(blurRadius: 3.0, color: Color.fromRGBO(0, 0, 0, 0.25))
        ],
        minHeight: MinHeight,
        maxHeight: MaxHeight,
        controller: panelController,
        defaultPanelState: PanelState.OPEN,
        parallaxEnabled: false,
        parallaxOffset: 1.0,
        onPanelSlide: (position) {
          _bottomController.position.value =
              position * panalMaxScrollExtent + MinHeight;
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        panel: Container(
          child: Column(
            children: [
              _dragHandle(),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '검색',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(10),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: Obx(() {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _bottomController.Courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex != index
                                ? _selectedIndex = index
                                : _selectedIndex = -1;
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _bottomController
                                    .Courses[index].classModel!.title!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _bottomController
                                    .Courses[index].classModel!.prof!,
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                _lectureConvertString(
                                    _bottomController.Courses[index].lectures!),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                _bottomController
                                    .Courses[index].classModel!.room!,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                _bottomController
                                    .Courses[index].classModel!.id!,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '3학점',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              if (index == _selectedIndex)
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        List<Future> futures = [];

                                        futures.add(_classController.addClass(
                                            courseModel: _bottomController
                                                .Courses[index].classModel));
                                        futures.addAll(_bottomController
                                            .Courses[index].lectures!
                                            .map((data) =>
                                                _classController.addLectures(
                                                    lecturesModel: data)));

                                        await Future.wait(futures);
                                        await _classController.getData();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Text('시간표 등록'),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 10),
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                          color: index == _selectedIndex
                              ? Colors.blue[200]
                              : Colors.white,
                        ),
                      );
                    });
              }))
            ],
          ),
        ),
        body: Column(children: [
          _appBar(),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Obx(() {
                      var asd = constraints.maxHeight -
                          _bottomController.position.value;
                      print('onchange' + asd.toString());
                      return Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Column(
                          children: [
                            Container(
                              height: asd - 20,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      width: 1.0, color: Colors.grey[200]!)),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Column(
                                  children: [
                                    Obx(() => _daysIndex()),
                                    Obx(() => _showTable(
                                        _classController.lastLecture.value,
                                        asd - 6)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  _lectureConvertString(List lectures) {
    String lectureString = '';
    List date = ['월', '화', '수', '목', '금', '토', '일'];
    for (var lecture in lectures) {
      lectureString = lectureString +
          "${date[lecture.date]} ${classTime[lecture.start][0]}-${classTime[lecture.end][1]}, ";
    }
    return lectureString;
  }

  _returnShow(lastLecture, height) {
    return _scrollableTable(_classController.TableLayoutMax.value - 10);
  }

  _showTable(lastLecture, height) {
    return Expanded(child: _returnShow(lastLecture, height));
  }

  Container _daysIndex() {
    print('call 2 obx');
    List<Widget> daysList = [];
    for (int i = 0; i < _classController.lastday.value; i++) {
      daysList.add(_dayIndexTile(days[i]));
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey[200]!),
        ),
        //Color(0xFF95C0FF),
        color: Colors.white,
      ),
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

  _drawtable() {
    List<Widget> widgetList = [];
    for (int i = 0; i < _classController.lastLecture.value; i++) {
      widgetList.add(Expanded(
        flex: 1,
        child: Container(
          decoration: i == 0
              ? BoxDecoration(
                  color: Colors.white,
                )
              : BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey[200]!))),
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
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Container(
              height: height,
              child: Obx(() {
                return _drawtable();
              }),
            ),
            Container(
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
            )
          ],
        ),
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
                    ))
                : BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.grey[200]!),
                        top: BorderSide(width: 1.0, color: Colors.grey[200]!))),
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

  _dragHandle() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 18, bottom: 10),
        child: GestureDetector(
          onTap: () {
            if (panelController.isPanelOpen) {
              panelController.close();
            } else {
              panelController.open();
            }
          },
          child: Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Row(
        children: [
          Text(
            '시간표 데이터 추가 ',
            style: TextStyle(color: Colors.black),
          ),
          Expanded(child: SizedBox())
        ],
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await Get.to(
                  AddCourseManualPage(notifyHelper: widget.notifyHelper));
              _classController.getData();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ))
      ],
      elevation: 0.0,
    );
  }
}
