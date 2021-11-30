import 'package:flutter/material.dart';
import 'package:fluttertodo/controller/app_controller.dart';
import 'package:fluttertodo/view/pages/community.dart';
import 'package:fluttertodo/view/pages/dashboard.dart';
import 'package:fluttertodo/view/pages/home_page.dart';
import 'package:fluttertodo/view/pages/school_life.dart';
import 'package:fluttertodo/view/pages/user_page.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedPageIndex = 0;
    _pages = [DashBoard(), Community(), HomePage(), SchoolLife(), UserPage()];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        //The following parameter is just to prevent
        //the user from swiping to the next page.
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _bottomNavigationBarItem(Icons.home_outlined, '홈', Icons.home_filled),
          _bottomNavigationBarItem(Icons.group_outlined, '커뮤니티', Icons.group),
          _bottomNavigationBarItem(
              Icons.schedule_outlined, '시간표', Icons.schedule),
          _bottomNavigationBarItem(Icons.school_outlined, '학교생활', Icons.school),
          _bottomNavigationBarItem(Icons.person_outline, '내정보', Icons.person),
        ],
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        currentIndex: _selectedPageIndex,
        onTap: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;
            _pageController.jumpToPage(selectedPageIndex);
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      IconData icon, String label, IconData iconActive) {
    return BottomNavigationBarItem(
      activeIcon: Icon(
        iconActive,
        color: Colors.black,
      ),
      icon: Icon(icon, color: Colors.grey),
      label: label,
    );
  }
}

// class App extends GetView<AppController> {
//   const App({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //appBar: _appBar(),
//         body: IndexedStack(
//           index: controller.currentIndex.value,
//           children: [
//             DashBoard(),
//             Community(),
//             HomePage(),
//             SchoolLife(),
//             UserPage()
//           ],
//         ),
//         // Obx(() {
//         //   switch (RouteName.values[controller.currentIndex.value]) {
//         //     case RouteName.Home:
//         //       return DashBoard();
//         //       break;
//         //     case RouteName.Community:
//         //       return Community();
//         //       break;
//         //     case RouteName.TimeTable:
//         //       return HomePage();
//         //       break;
//         //     case RouteName.SchoolLife:
//         //       return SchoolLife();
//         //       break;
//         //     case RouteName.UserInfo:
//         //       return UserPage();
//         //       break;
//         //   }
//         // }),
//         bottomNavigationBar: Obx(
//           () => BottomNavigationBar(
//               selectedFontSize: 13.0,
//               unselectedFontSize: 13.0,
//               selectedItemColor: Colors.black,
//               unselectedLabelStyle: TextStyle(color: Colors.grey),
//               unselectedItemColor: Colors.grey,
//               type: BottomNavigationBarType.fixed,
//               currentIndex: controller.currentIndex.value,
//               showSelectedLabels: true,
//               onTap: (index) {
//                 controller.changePageIndex(index);
//               },
//               items: [
//                 _bottomNavigationBarItem(
//                     Icons.home_outlined, '홈', Icons.home_filled),
//                 _bottomNavigationBarItem(
//                     Icons.group_outlined, '커뮤니티', Icons.group),
//                 _bottomNavigationBarItem(
//                     Icons.schedule_outlined, '시간표', Icons.schedule),
//                 _bottomNavigationBarItem(
//                     Icons.school_outlined, '학교생활', Icons.school),
//                 _bottomNavigationBarItem(
//                     Icons.person_outline, '내정보', Icons.person),
//               ]),
//         ));
//   }
//
//   BottomNavigationBarItem _bottomNavigationBarItem(
//       IconData icon, String label, IconData iconActive) {
//     return BottomNavigationBarItem(
//       activeIcon: Icon(
//         iconActive,
//         color: Colors.black,
//       ),
//       icon: Icon(icon, color: Colors.grey),
//       label: label,
//     );
//   }
// }
