import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/controller/table_controller.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:fluttertodo/view/widget/input_field.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

import 'add_table_page.dart';

class TimeTableListPage extends StatelessWidget {
  const TimeTableListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    var uuid = Uuid();
    final _tableController = Get.put(TableController());

    _tableController.getData();
    print("table count numberr" +
        _tableController.timetableList.length.toString());

    return Scaffold(
      appBar: _appBar(_tableController),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '대표 시간표',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.grey[800]),
              ),
            ),
            GestureDetector(
              onTap: () async {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                margin: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_tableController.currentTimeTable.value.title!),
                          Text(
                              "${_tableController.currentTimeTable.value.year}년 ${_tableController.currentTimeTable.value.semester}학기")
                        ],
                      );
                    })
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                '내 시간표',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.grey[800]),
              ),
            ),
            Obx(() {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _tableController.timetableList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await _tableController.changeCurrentTable(
                            _tableController.timetableList[index].id
                                .toString());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_tableController
                                    .timetableList[index].title!),
                                Text(
                                    "${_tableController.timetableList[index].year}년 ${_tableController.timetableList[index].semester}학기")
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            _option_button(
                                                '이름 변경',
                                                _tableController
                                                    .timetableList[index].id!,
                                                0,
                                                mWidth),
                                            _option_button(
                                                '시간표 삭제',
                                                _tableController
                                                    .timetableList[index].id!,
                                                1,
                                                mWidth),
                                            _option_button(
                                                '대표 시간표로 설정',
                                                _tableController
                                                    .timetableList[index].id!,
                                                2,
                                                mWidth),
                                          ],
                                        )),
                                    enterBottomSheetDuration: const Duration(
                                        minutes: 0,
                                        seconds: 0,
                                        milliseconds: 200));
                              },
                              child: Icon(
                                Icons.more_vert,
                                size: 27,
                                color: Colors.grey[300],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }),
          ],
        ),
      ),
    );
  }

  GestureDetector _option_button(String title, int id, int functionId, mWidth) {
    final TextEditingController _titleController = TextEditingController();
    final _tableController = Get.put(TableController());
    return GestureDetector(
      onTap: () {
        if (functionId == 0) {
          Get.defaultDialog(
            title: '',
            titleStyle: TextStyle(fontSize: 0),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('이름을 설정해주세요'),
                MyInputField(
                  title: '시간표 이름',
                  hint: 'tableTitle',
                  controller: _titleController,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 35),
                          child: Center(
                            child: Text('취소'),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Map<String, dynamic> updateValue = {
                            'title': _titleController.text
                          };
                          _tableController.updateByTimeTableId(id, updateValue);
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 35),
                          child: Center(
                            child: Text(
                              '확인',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else if (functionId == 1) {
          Get.defaultDialog(
              title: '',
              titleStyle: TextStyle(fontSize: 0),
              textCancel: '취소',
              textConfirm: '확인',
              content: Text('시간표를 삭제하시겠나요?'),
              onConfirm: () {
                _tableController.deleteByTimeTableId(id);
                Get.back();
              }

              // content: Column(
              //   children: [
              //     Text('시간표를 삭제하시겠나요?'),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         TextButton(onPressed: () {}, child: Text('취소')),
              //         TextButton(onPressed: () {}, child: Text('확인'))
              //       ],
              //     )
              //   ],
              // ));
              );
        }
      },
      child: Container(
        width: mWidth,
        child: Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  _appBar(_tableController) {
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
            '시간표 리스트 ',
            style: TextStyle(color: Colors.black),
          ),
          Expanded(child: SizedBox())
        ],
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await Get.to(AddTablePage());
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
