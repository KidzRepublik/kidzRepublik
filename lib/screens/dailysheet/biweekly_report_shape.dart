import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_republik/screens/bi_weekly/bi_weekly_report_sharing.dart';
import 'package:kids_republik/utils/getdatefunction.dart';

import '../../utils/const.dart';

RxBool isLoading = true.obs;

class BiWeeklyReportShapeScreen extends StatelessWidget {
  final String babyID_;
  final String babypicture_;
  final String name_;
  final String date_;
  final String class_;

  BiWeeklyReportShapeScreen({
    Key? key,
    required this.babyID_,
    required this.name_,
    required this.date_,
    required this.class_,
    required this.babypicture_,
  }) : super(key: key);
  final collectionReference = FirebaseFirestore.instance.collection('Activity');


  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kprimary, // Change this to the desired color
    ));
    return Scaffold(
        body: SingleChildScrollView(
        padding: EdgeInsets.only(top: mQ.height*0.05,left: mQ.width*0.03,right: mQ.width*0.03,bottom: mQ.height*0.03),
    child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
    // gradient: LinearGradient(
    // begin: Alignment.topCenter,
    // end: Alignment.bottomCenter,
    // colors: [Colors.white!, Colors.white!], // Define your gradient colors
    // ),
    borderRadius: BorderRadius.circular(10), // Apply rounded corners if desired
    border: Border.all(color: Colors.grey,width: 1),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.6),
    spreadRadius: 2,
    blurRadius: 5,
    offset: Offset(0, 2), // Add a shadow effect
    ),
    ],
    ),
      child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(' ${(date_)}',
                //           style: TextStyle(
                //               fontSize: 14,
                //               fontFamily: 'Comic Sans MS',
                //               fontWeight: FontWeight.bold,
                //               color: Colors.blue)),
                //       Column(
                //         children: [
                //           Container(
                //             width: mQ.width * 0.07,
                //             height: mQ.width * 0.07,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               image: DecorationImage(
                //                   image: NetworkImage(
                //                     babypicture_,
                //                   ),
                //                   // Image.network(babypicture_ , width: mQ.width * 0.07),
                //                   fit: BoxFit.fill),
                //             ),
                //           ),
                //           Text(" ${(name_)}",
                //               style: TextStyle(
                //                   fontSize: 14,
                //                   fontFamily: 'Comic Sans MS',
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.blue)),
                //         ],
                //       ),
                //     ]),
                BiWeeklySharingWithParents(
                    baby: babyID_,babypicture: babypicture_,babyname: name_,
                    // MoodScreen(baby: babyID_,
subject: "Approved Biweekly",                  category: 'BiWeekly',
                    reportdate_: getCurrentDate(),
                    subjectcolor_: Colors.brown.withOpacity(0.8),biweeklystatus_: 'New',),
              ],
            ),
    ),
        ));
  }
}
