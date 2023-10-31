import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_republik/utils/const.dart';
import 'package:kids_republik/utils/getdatefunction.dart';
import 'package:toast/toast.dart';

import '../../../main.dart';
import 'parent_report_recomendations.dart';
RxBool isLoading = true.obs;
class ParentReportShape extends StatelessWidget {
  final String babyID_;
  final String name_;
  final String date_;
  final String class_;
  final String childPicture_;
  final String reportType_;

  ParentReportShape({
    Key? key,
    required this.babyID_,
    required this.name_,
    required this.date_,
    required this.class_, required this.childPicture_, required this.reportType_,
  }) : super(key: key);
  final collectionReference = FirebaseFirestore.instance.collection('Activity');
  final collectionReferencebabydata = FirebaseFirestore.instance.collection('BabyData');


  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery
        .of(context)
        .size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kprimary, // Change this to the desired color
    ));
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar:

        (role_ == "Principal" ) ?
        Container(
          color: kprimary,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Approve'
                  ,style: TextStyle(color: Colors.white)
              ),
              IconButton(icon: Icon(Icons.done_all,size: 24,color: Colors.white,),onPressed: () async => {
                await confirm(context)?updateDocumentsWithStatusForwarded(babyID_,"Forwarded","Approved",context):null,

              },),
            ],
          ),
        ):
        (role_ == "Teacher") ?
        Container(
          color: kprimary,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forward',style: TextStyle(color: Colors.white)),
              IconButton(icon: Icon(color:Colors.white, Icons.send,size: 24),onPressed: () async => {
                await confirm(context)?updateDocumentsWithStatusForwarded(babyID_,"New","Forwarded",context):null,
              }),
            ],
          ),
        )
            :
        (role_ == "Parent") ?
        Container(color: kprimary,
          child: IconButton(
              onPressed: () async {
                await collectionReferencebabydata
                    .doc(babyID_)
                    .update({'parentfeedback_': "Seen"});
                Navigator.pop(context);
              },
              icon: Icon(Icons.done,
                  size: 18, color: Colors.white,)),
        )
        :
        (role_ == "Director") ?
        Container(color: kprimary,
          child: IconButton(
              onPressed: () async {
                await collectionReferencebabydata
                    .doc(babyID_)
                    .update({'directorremarks_': "Seen"});
                Navigator.pop(context);
              },
              icon: Icon(Icons.done,
                  size: 18, color: Colors.white)),
        ):Container(),

        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: mQ.height*0.04,left: mQ.width*0.03,right: mQ.width*0.03,bottom: mQ.height*0.03),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white], // Define your gradient colors
              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 7),
                                height: mQ.height*0.03,alignment: AlignmentDirectional.bottomStart,
                                child:  Text(" ${(name_)}'s Report",
                                    style: TextStyle(
                                        fontSize: mQ.height*0.022,
                                        fontFamily: 'Comic Sans MS',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                              Container(height: 20,
                                padding: EdgeInsets.only(left: 7),
                                child: Text(getCurrentDateforattendance(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Comic Sans MS',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue[900])),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: mQ.width*0.45),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 7),
                                  alignment: AlignmentDirectional.bottomEnd,
                                  width: mQ.width * 0.08,
                                  height: mQ.height * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(image:NetworkImage(childPicture_),fit: BoxFit.scaleDown),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 7),
                                  alignment: AlignmentDirectional.bottomEnd,
                                  width: mQ.width * 0.08,
                                  height: mQ.height * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // image: DecorationImage(image:NetworkImage(childPicture_),fit: BoxFit.scaleDown),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(right: 7),
                                  alignment: AlignmentDirectional.bottomEnd,
                                  width: mQ.width * 0.08,
                                  height: mQ.height * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image:NetworkImage(childPicture_),fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                Row(
                      children: [
                        Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.green, boxcolor_: Colors.transparent,category: 'DailySheet',boxheading: "Checked In", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.02,reportType_: reportType_)),
                        // Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.teal.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: 'DailySheet',boxheading: "Absent", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.04,reportType_: reportType_)),
                        Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.red, boxcolor_: Colors.transparent,category: 'DailySheet',boxheading: "Checked Out", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.02,reportType_: reportType_)),
                        // Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.teal.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: 'DailySheet',boxheading: "Absent", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.04,reportType_: reportType_)),
                      //   Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.teal.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: 'DailySheet',boxheading: "Checked Out", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.04,reportType_: reportType_)),
                      //   Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Attendance', reportdate_: getCurrentDate(), subjectcolor_: Colors.teal.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: 'DailySheet',boxheading: "Absent", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.04,reportType_: reportType_)),
                      ],
                    ),
                Row(
                  children: [
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Food', reportdate_: getCurrentDate(), subjectcolor_: Colors.brown.withOpacity(0.8), boxcolor_: Colors.deepOrange.shade50,category: 'DailySheet',boxheading: "Feeding", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Toilet', reportdate_: getCurrentDate(), subjectcolor_: Colors.deepPurple.withOpacity(0.8), boxcolor_:Colors.orange.shade50,category: "DailySheet",boxheading: "Diapers / Potty", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Fluids', reportdate_: getCurrentDate(), subjectcolor_: Colors.cyan.withOpacity(0.8), boxcolor_: Colors.blue.shade50,category: "DailySheet",boxheading: "Water / Juice", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Sleep', reportdate_: getCurrentDate(), subjectcolor_: Colors.black.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: "DailySheet",boxheading: "Napping", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                  ],
                ),
                SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: collectionReference
                            .where('id', isEqualTo: babyID_)
                            .where('date_', isEqualTo: getCurrentDate())
                            .where('photostatus_', isEqualTo: 'Forwarded')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Row(
                              children:
                             [
                               Padding(
                                  padding: EdgeInsets.all(mQ.width*0.01),
                                  child: Image.asset('assets/dailyimage1.jpg', width: mQ.width*0.2, height: mQ.height*0.08),
                                ),
                               Padding(
                                  padding: EdgeInsets.all(mQ.width*0.01),
                                  child: Image.asset('assets/dailyimage2.jpg', width: mQ.width*0.2, height: mQ.height*0.08),
                                ),
                               Padding(
                                  padding: EdgeInsets.all(mQ.width*0.01),
                                  child: Image.asset('assets/dailyimage31.png', width: mQ.width*0.2, height: mQ.height*0.08),
                                ),
                               Padding(
                                  padding: EdgeInsets.all(mQ.width*0.01),
                                  child: Image.asset('assets/dailyimage4.jpg', width: mQ.width*0.2, height: mQ.height*0.08),
                                ),
                            ]);
                          }

                          return
                            Row(
                            children: snapshot.data!.docs.map((doc) {
                              final imageUrl = doc['image_'] as String;
                              return Padding(
                                padding: EdgeInsets.all(mQ.width*0.01),
                                child: Image.network(imageUrl, width: mQ.width*0.2, height: 100),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Mood', reportdate_: getCurrentDate(), subjectcolor_: Colors.purple.withOpacity(0.8), boxcolor_: Colors.green.shade50,category: "DailySheet",boxheading: "Mood", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                    Expanded(child: ParentDailySheetScreen(baby: babyID_, subject: 'Health', reportdate_: getCurrentDate(), subjectcolor_: Colors.green.withOpacity(0.8), boxcolor_: CupertinoColors.quaternaryLabel,category: "DailySheet",boxheading: "Medicine", boxwidth_: mQ.width*0.45,reportType_: reportType_)),
                  ],
                ),
                     ParentDailySheetScreen(baby: babyID_, subject: 'Activity', reportdate_: getCurrentDate(), subjectcolor_: Colors.pink.withOpacity(0.8), boxcolor_: CupertinoColors.extraLightBackgroundGray,category: "DailySheet",boxheading: "Today's Activities", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.07,reportType_: reportType_),
                    ParentDailySheetScreen(baby: babyID_, subject: 'Notes', reportdate_: getCurrentDate(), subjectcolor_: Colors.brown.withOpacity(0.8), boxcolor_: Colors.brown.shade50,category: "DailySheet",boxheading: "Notes", boxwidth_: mQ.width*0.9, boxheight_: mQ.height*0.07,reportType_: reportType_),
              SizedBox(height: mQ.height*0.01,)
              ],
            ),
          ),
        ));
  }



}

void updateDocumentsWithStatusForwarded(babyid_,existingstatus_, update_,context) async {
  final CollectionReference collection = FirebaseFirestore.instance.collection('Activity');
  final QuerySnapshot snapshot = await collection
      .where('status_', isEqualTo: existingstatus_)
      .where('date_',isEqualTo: getCurrentDate())
      // .where('Subject',isEqualTo: getCurrentDate())
      .where('id', isEqualTo: babyid_).get();

  for (QueryDocumentSnapshot doc in snapshot.docs) {
    // Update the status to a new value, e.g., 'UpdatedStatus'
    await collection.doc(doc.id).update({'status_': update_});
  }
  ToastContext().init(context);
  Toast.show(
    'Report ${update_} successfully',
    // Get.context,
    duration: 10,  backgroundRadius: 5,
    //gravity: Toast.top,
  );
}
