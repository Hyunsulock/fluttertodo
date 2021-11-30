import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassSelector extends StatefulWidget {
  final List<Map<int, bool>> ClassCheckList;
  const ClassSelector(
      {Key? key, required List<Map<int, bool>> this.ClassCheckList})
      : super(key: key);

  @override
  _ClassSelectorState createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<ClassSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Column(
        children: [
          dateRow(),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: _TimeTable(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Container dateRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
          color: Color(0xFF95C0FF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '월',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '화',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '수',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '목',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '금',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Column _TimeTable() {
    List<Row> classRowList = [];
    for (var i = 0; i < 9; i++) {
      List<Expanded> classTileList = [];
      classTileList.add(Expanded(
        child: Container(
          height: 50,
          child: Center(
            child: Text(
              '${i + 1}교시',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
      for (var j = 0; j < 7; j++) {
        classTileList.add(Expanded(
          child: Checkbox(
            value: widget.ClassCheckList[j][i] == null ? false : true,
            onChanged: widget.ClassCheckList[j][i] == false
                ? null
                : (bool? value) {
                    setState(() {
                      if (value!) {
                        widget.ClassCheckList[j][i] = value;
                      } else {
                        widget.ClassCheckList[j].remove(i);
                      }
                    });
                  },
          ),
        ));
      }
      classRowList.add(Row(
        children: classTileList,
      ));
    }
    return Column(
      children: classRowList,
    );
  }
}
