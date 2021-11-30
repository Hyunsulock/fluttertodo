import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:fluttertodo/controller/class_controller.dart';
import 'package:fluttertodo/controller/notification_services.dart';
import 'package:fluttertodo/models/courseModel.dart';
import 'package:fluttertodo/models/lecturesModel.dart';
import 'package:fluttertodo/view/widget/class_table_selector.dart';
import 'package:fluttertodo/view/widget/input_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import '../../constant.dart';

class AddCourseManualPage extends StatefulWidget {
  final NotifyHelper notifyHelper;
  const AddCourseManualPage({Key? key, required this.notifyHelper})
      : super(key: key);

  @override
  State<AddCourseManualPage> createState() => _AddCourseManualPageState();
}

class _AddCourseManualPageState extends State<AddCourseManualPage> {
  ColorSwatch? _tempMainColor;
  Color? _tempShadeColor;
  ColorSwatch? _mainColor = Colors.blue;
  Color? _shadeColor = Colors.blue[800];
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  int _selectedColor = 0;
  var uuid = Uuid();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _profController = TextEditingController();
  final ClassController _classController = Get.put(ClassController());
  final List<Map<int, bool>> ClassCheckList = [{}, {}, {}, {}, {}, {}, {}];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 7; i++) {
      var datelectureList = _classController.lectureList[i];

      for (var lecture in datelectureList) {
        var length = lecture.end! - lecture.start!;
        if (length > 0) {
          for (int j = 0; j < length + 1; j++) {
            ClassCheckList[i][lecture.start! + j] = false;
          }
        } else {
          ClassCheckList[i][lecture.start!] = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text('Add Class'),
              MyInputField(
                title: 'title',
                hint: 'class',
                controller: _titleController,
              ),
              MyInputField(
                title: 'room',
                hint: 'room',
                controller: _roomController,
              ),
              MyInputField(
                title: 'Prof',
                hint: 'professor',
                controller: _profController,
              ),
              MyInputField(
                title: 'Alarm',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                    underline: Container(
                      height: 0,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: TextStyle(color: Colors.black),
                    onChanged: (String? newVal) {
                      setState(() {
                        _selectedRemind = int.parse(newVal!);
                      });
                    },
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem(
                        child: Text(value.toString()),
                        value: value.toString(),
                      );
                    }).toList()),
              ),
              Text('select Class'),
              ClassSelector(ClassCheckList: ClassCheckList),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorSelector(),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            validateData();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Create class'),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              primary: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _colorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color'),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: List<Widget>.generate(1, (int index) {
            return GestureDetector(
              onTap: () {
                _openColorPicker();
              },
              child: CircleAvatar(
                backgroundColor: _shadeColor,
                radius: 18.0,
              ),
            );
          }),
        )
      ],
    );
  }

  void validateData() {
    if (_titleController.text.isNotEmpty &&
        _roomController.text.isNotEmpty &&
        _profController.text.isNotEmpty) {
      _addClassToDB();
      Get.back(result: true);
    } else if (_titleController.text.isEmpty || _roomController.text.isEmpty) {
      Get.snackbar('Required', "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: Icon(Icons.warning_amber_rounded));
    }
  }

  List<LecturesModel> timeList(courseId, classCheckList, tableInt) {
    final List<LecturesModel> dataList = [];
    var j = 0;
    for (Map<int, bool> dayMap in classCheckList!) {
      if (dayMap.isEmpty) {
        j++;
        continue;
      }
      List<int> checked = [];
      for (MapEntry<int, bool> value in dayMap.entries) {
        if (value.value) {
          checked.add(value.key);
        }
      }
      if (checked.length > 1) {
        List<List<int>> result = [];
        List<int> temp = [];

        checked.sort();
        print('keys' + checked.toList().toString());
        temp.add(checked[0]);
        for (var i = 0; i < checked.length - 1; i++) {
          if (checked[i + 1] == checked[i] + 1) {
            temp.add(checked[i + 1]);
            print('temp' + temp.toString());
          } else {
            result.add(temp);
            print('result' + result.toString());
            temp = [];
            temp.add(checked.toList()[i + 1]);
          }
        }
        result.add(temp);
        print(result);
        for (var list in result) {
          print('timetable' + tableInt.toString());
          dataList.add(LecturesModel(
              course_id: courseId,
              start: list[0],
              end: list.last,
              date: j,
              table_id: tableInt));
        }
      } else if (checked.isNotEmpty) {
        dataList.add(LecturesModel(
            course_id: courseId,
            start: checked[0],
            end: checked[0],
            date: j,
            table_id: tableInt));
      }
      j++;
    }
    print(dataList);
    return dataList;
  }

  _addClassToDB() async {
    final getStorage = GetStorage();
    var table = await getStorage.read('table');
    print("tehlo--------------------|" + table + "|----------");
    int tableInt = int.parse(table);
    var courseId = uuid.v1();
    List<LecturesModel> lectures = timeList(courseId, ClassCheckList, tableInt);
    List<Future> futures = [];
    if (_selectedRemind != null) {
      //widget.notifyHelper.displayNotification(title: 'title', body: 'body');
      futures.addAll(lectures.map((e) => widget.notifyHelper
          .scheduleWeeklyNotification(
              e.date!,
              int.parse(classTime[e.start!][0].split(':')[0]),
              int.parse(classTime[e.start!][0].split(':')[1]),
              e.course_id!,
              _titleController.text,
              _roomController.text)));
    }

    futures.add(_classController.addClass(
        courseModel: CourseModel(
            id: courseId,
            title: _titleController.text,
            room: _roomController.text,
            prof: _profController.text,
            remind: _selectedRemind,
            color: _shadeColor!.value,
            table_id: tableInt
            // classCheckList: ClassCheckList
            )));
    futures.addAll(lectures
        .map((data) => _classController.addLectures(lecturesModel: data)));
    await Future.wait(futures);
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}
