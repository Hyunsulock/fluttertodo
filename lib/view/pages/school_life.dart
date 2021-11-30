import 'dart:ui';

import 'package:flutter/material.dart';

class SchoolLife extends StatefulWidget {
  const SchoolLife({Key? key}) : super(key: key);

  @override
  _SchoolLifeState createState() => _SchoolLifeState();
}

class _SchoolLifeState extends State<SchoolLife> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          '학교생활',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_bag, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '중고나라',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.calculate, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '학점계산기',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.food_bank, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '식단표',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chat_rounded, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '랜덤채팅',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.house_siding, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '자취방 리뷰',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.restaurant, size: 35),
                      onPressed: () {},
                    ),
                    Text(
                      '맛집 추천',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.dashboard_customize_outlined,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      '족보',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 34),
                      onPressed: () {},
                    ),
                    Text(
                      '행사일정',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    )
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
