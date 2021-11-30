import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/controller/table_controller.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:fluttertodo/view/widget/input_field.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AddTablePage extends StatefulWidget {
  const AddTablePage({Key? key}) : super(key: key);

  @override
  _AddTablePageState createState() => _AddTablePageState();
}

class _AddTablePageState extends State<AddTablePage> {
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _tableController = Get.put(TableController());
    return Scaffold(
      appBar: _appBar(_tableController),
      body: Container(
        child: Column(
          children: [
            MyInputField(
              title: '시간표 이름',
              hint: 'tableTitle',
              controller: _titleController,
            ),
          ],
        ),
      ),
    );
  }

  _appBar(_tableController) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      title: Row(
        children: [
          Text(
            '시간표 생성 ',
            style: TextStyle(color: Colors.black),
          ),
          Expanded(child: SizedBox())
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await _tableController.addTimeTable(
                timeTableModel: TimeTableModel(
              title: _titleController.text,
              year: 2020,
              semester: 1,
            ));
            _tableController.getData();
            Get.back();
          },
          child: Text('완료'),
        )
      ],
      elevation: 0.0,
    );
  }
}
