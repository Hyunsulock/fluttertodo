import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  cursorColor: Colors.black,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none),
                )),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
