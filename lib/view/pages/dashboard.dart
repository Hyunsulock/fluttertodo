import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            SizedBox(
              width: 35,
            ),
            Text(
              'SchoolIT',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/tokyoIcon.png',
              width: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Tokyo University',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ]),
      backgroundColor: Colors.white,
      elevation: 0.2,
    );
  }
}
