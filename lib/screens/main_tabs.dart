import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_republik/screens/activities/select_activity.dart';
import 'package:kids_republik/screens/home/principal_home.dart';
import 'package:kids_republik/screens/kids/assign_class_to_child_screen.dart';
import 'package:kids_republik/utils/const.dart';
import 'package:kids_republik/utils/parent_photos_slideshow.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../main.dart';
import 'dailysheet/manager_report/manager_report_select_child.dart';
import 'dailysheet/widgets/empty_background.dart';
import 'home/manager_home.dart';
import 'home/parent_home_screen.dart';
import 'home/teacher_activity_child.dart';

class MainTabs extends StatefulWidget {
  MainTabs();

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  var _currentIndex = 0;

  buildScreen() {
    switch (role_) {
      case 'Director':
        switch (_currentIndex) {
          case 0:
            return PrincipalHomeScreen();
          case 1:
            return AssignClassToChildren(selectedclass_: 'All Classes');
            // return TeacherHomeChild(activityclass_: teachersClass_);
          case 2:
            return ManagerReportSelectChild(reportstatus_: 'Approved');
        }
      case 'Principal':
        switch (_currentIndex) {
          case 0:
            return PrincipalHomeScreen();
            case 1:
            return AssignClassToChildren(selectedclass_: 'All Classes');
            case 2:
            return ManagerReportSelectChild(reportstatus_: 'Approved');
        }
      case 'Manager':
        switch (_currentIndex) {
          case 0:
            return ManagerHomeScreen();
          case 1:
            return AssignClassToChildren(selectedclass_: 'All Classes');
          case 2:
            return EmptyBackground(title: "");
        }
      case 'Teacher':
        switch (_currentIndex) {
          case 0:
            return SelectActivityScreen(teachersclass: teachersClass_);
          case 1:
            return TeacherHomeChild(activityclass_: teachersClass_);
          case 2:
            return ManagerReportSelectChild(reportstatus_: 'Forwarded');
        }
      case 'Parent':
        switch (_currentIndex) {
          case 0:
            return ParentHomeScreen();
          case 1:
            return ParentPhotoSlideshow(fatherEmail: useremail!,babyId: null,);
          case 2:
            return ManagerReportSelectChild(reportstatus_: 'Approved');
        }
      default:
        switch (_currentIndex) {
          case 0:
            // return PrincipalHomeScreen();
            return EmptyBackground(title: '');
          case 1:
            return EmptyBackground(title: '');
          case 2:
            return EmptyBackground(title: '');
        }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildScreen(),
      bottomNavigationBar: SalomonBottomBar(
        // backgroundColor: Color(0xFFD4E7E9),
        // backgroundColor: Color(0xC4E8E9),
        backgroundColor: kprimary,
        // Colors.teal[100],
        currentIndex: _currentIndex,
        margin: EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8),
        unselectedItemColor: Colors.white60,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text("Home"),
            selectedColor: Colors.white,
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.school_outlined),
            title: Text("Class"),
            selectedColor: Colors.white,
          ),

          SalomonBottomBarItem(
            icon: Icon(Icons.article_outlined),
            title: Text("Report"),
            selectedColor: Colors.white,
          ),

        ],
      ),
    );
  }
}
