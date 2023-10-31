import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/screens/activities/view_bi_weekly_activities.dart';
import 'package:kids_republik/screens/consent/parent_consent_screen.dart';
import 'package:kids_republik/screens/home/teacher_management.dart';
import 'package:kids_republik/screens/kids/assign_class_to_child_screen.dart';
import 'package:kids_republik/screens/kids/registration_form.dart';
import 'package:kids_republik/screens/reminder/reminderstoparent.dart';
import 'package:kids_republik/screens/widgets/base_drawer.dart';
import 'package:kids_republik/utils/const.dart';
import 'package:kids_republik/utils/image_slide_show.dart';

import '../../utils/camera_service.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
    final cameraService = CameraService();
  bool deleteionLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green[50],

        // backgroundColor: Colors.blue[50],
        drawer: BaseDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhite),
          title: Text(
            'Home',
            style: TextStyle(fontSize: 14,color: kWhite),
          ),
          backgroundColor: kprimary,
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          ImageSlideShowfunction(context),
          SizedBox(
            height: mQ.height * 0.12,
          ),
          Row(children: [
            IconButton(
              onPressed: () {
                Get.to(RegistrationForm());
              },
              icon: Image.asset('assets/manager/registration.png',
                  width: mQ.width * 0.29),
              // child: const Text('Consent Statements'),
            ),
            IconButton(
              onPressed: () {
                Get.to(AssignClassToChildren(selectedclass_: 'All Classes'));
              },
              icon: Image.asset('assets/manager/students.png',
                  width: mQ.width * 0.29),
              // child: const Text('Consent Statements'),
            ),
            IconButton(
              icon: Image.asset('assets/manager/staff.png',
                  width: mQ.width * 0.29),
              onPressed: () {
                Get.to(TeacherManagementScreen());
              },
            ),
          ]),
              Row(children: [
                IconButton(
                  onPressed: () {
                    Get.to(ViewBiweeklyActivities());
                  },
                  icon: Image.asset('assets/manager/biweekly1.png',
                      width: mQ.width * 0.29),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(ParentConsentScreen(babyid: 'null',));
                  },
                  icon: Image.asset('assets/manager/consent.png',
                      width: mQ.width * 0.29),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(ParentReminderScreen(babyid_: "All Reminders",));
                  },
                  icon: Image.asset('assets/manager/reminder1.png',
                      width: mQ.width * 0.29),
                ),
              ]),

            ])));
  }

  // UpdateClassController updateCropController = Get.put(UpdateClassController());

  Padding showDetailsRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ],
      ),
    );
  }

}
