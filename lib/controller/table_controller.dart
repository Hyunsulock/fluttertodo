import 'package:fluttertodo/db/db_helper.dart';
import 'package:fluttertodo/models/timeTableModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TableController extends GetxController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  var timetableList = <TimeTableModel>[].obs;
  var currentTimeTable =
      new TimeTableModel(title: '시간표', year: 2022, semester: 2, id: 0).obs;

  Future<void> addTimeTable({TimeTableModel? timeTableModel}) async {
    return await DBHelper.insertTimeTable(timeTableModel);
  }

  void deleteByTimeTableId(int? id) {
    DBHelper.deleteTimeTableById(id);
    getData();
  }

  void updateByTimeTableId(int? id, data) {
    DBHelper.updateTimeTableById(id, data);
    getData();
  }

  Future<void> getData() async {
    var tableData = await DBHelper.queryTables();
    timetableList.assignAll(
        tableData.map((e) => new TimeTableModel.fromJson(e)).toList());
    await getCurrentTableData();
  }

  Future<void> getCurrentTableData() async {
    final getStorage = GetStorage();
    var table = getStorage.read('table');
    int tableInt = int.parse(table);
    var currenttableData = await DBHelper.queryTableById(tableInt);
    if (currenttableData.isNotEmpty) {
      var tableChange = TimeTableModel.fromJson(currenttableData[0]);
      currentTimeTable(tableChange);
    }
  }

  Future<void> changeCurrentTable(String id) async {
    final getStorage = GetStorage();
    getStorage.write('table', id);
    await getCurrentTableData();
  }
}
