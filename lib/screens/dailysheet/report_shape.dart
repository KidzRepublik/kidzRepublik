import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/screens/dailysheet/photo_sharing_with_parents.dart';
import 'package:kids_republik/utils/getdatefunction.dart';


RxBool isLoading = true.obs;
final subjects_ = <String> ['Food','Fluids','Health','Activity'];
class ReportShapeScreen extends StatelessWidget {
  final String babyID_;
  final String babypicture_;
  final String name_;
  final String date_;
  final String class_;
  final String fathersEmail_;

  ReportShapeScreen({
    Key? key,
    required this.babyID_,
    required this.name_,
    required this.date_,
    required this.class_,
    required this.babypicture_, required this.fathersEmail_,
  }) : super(key: key);
  final collectionReference = FirebaseFirestore.instance.collection('Activity');


  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                // Image.asset('assets/todlerlog.png', width: mQ.width * 0.3),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: mQ.width * 0.14,
                          height: mQ.height * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  babypicture_,
                                ),
                                // Image.network(babypicture_ , width: mQ.width * 0.07),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: mQ.width * 0.14,
                          height: mQ.height * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(" ${(name_)}",textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Comic Sans MS',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
                Expanded(
                  child: Text(' ${(getCurrentDateforattendance())}',textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Comic Sans MS',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey)),
                ),
              ]),

        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              PhotoSharingWithParents(
                      baby: babyID_,
                      // MoodScreen(baby: babyID_,
                      subject: 'Activity',
                      category: 'DailySheet',
                      reportdate_: getCurrentDate(),
                      subjectcolor_: Colors.teal.withOpacity(0.8)),
              ],
    ),
          )
        );
  }



}
