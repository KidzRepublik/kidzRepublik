import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/screens/dailysheet/biweekly_report_shape.dart';
import 'package:kids_republik/screens/dailysheet/parent_report/parent_report_shape.dart';
import 'package:kids_republik/screens/dailysheet/report_shape.dart';
import 'package:kids_republik/screens/widgets/base_drawer.dart';
import 'package:kids_republik/utils/const.dart';
import 'package:kids_republik/utils/getdatefunction.dart';
import 'package:kids_republik/utils/image_slide_show.dart';
var reports_ = <String>[];
// = <String> [ 'Daily' , 'BiWeekly', 'Activities'];
class ManagerReportSelectChild extends StatefulWidget {
  final reportstatus_;
  ManagerReportSelectChild({super.key, this.reportstatus_});

  @override
  State<ManagerReportSelectChild> createState() => _ManagerReportSelectChildState();
}
Color color = Colors.red;

class _ManagerReportSelectChildState extends State<ManagerReportSelectChild> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');
  final collectionReferenceActivity = FirebaseFirestore.instance.collection('Activity');
  ScrollController scrollController = ScrollController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (role_ == "Teacher") reports_ = <String> [ 'Daily' , 'BiWeekly', 'Activities'];
    if (role_ == "Parent") reports_ = <String> [ 'Daily' , 'BiWeekly'];
    if (role_ == 'Principal')  setState(() {
      reports_ =  [  'Daily' ,'Approved', 'BiWeekly', 'Activities'];
    });
    if (role_ == 'Director')
      setState(() {
        reports_ = [  'Daily','Approved','New', 'BiWeekly', 'Activities'] ;
      });
}

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
// reports_ = [] ;
}
  @override
  Widget build(BuildContext context) {

    final mQ = MediaQuery.of(context).size;
    return Scaffold(
        // drawer: BaseDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhite),
          title: Text(
            'Daily & Bi Weekly Reports ',
            style: TextStyle(color: kWhite,fontSize: 14),
          ),
          backgroundColor: kprimary,
        ),
        backgroundColor: Colors.blue[50],
        body:
        SingleChildScrollView(
          child: Column(children: [
            ImageSlideShowfunction(context),
            Container(
              padding: EdgeInsets.only(left: mQ.width*0.01, right: mQ.width*0.04),
              // padding: EdgeInsets.only(right: 8, left: 8),
              height: mQ.height * 0.03,
              color: Colors.grey[50],
              width: mQ.width,
              // padding:mQ ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'View reports',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.right,
                      ' ${getCurrentDateforattendance()}',
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Comic Sans MS',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
              (role_=="Teacher")?classwisestudents(teachersClass_) :  Container(),
    (role_=="Teacher")?  Container():
    classwisestudents('Infant'),
    (role_=="Teacher")?  Container():
classwisestudents('Todler'),
    (role_=="Teacher")?  Container():
classwisestudents('Play Group - I'),
    (role_=="Teacher")?  Container():
classwisestudents('Kinder Garten - I'),
(role_=="Teacher")?  Container():
classwisestudents('Kinder Garten - II')
           ]),
        ));

     }
     // showchildrens(){
     //
     //   if(role_=="Teacher")
     //     classwisestudents(teachersClass_); else {
     //     classwisestudents('Infant');
     //     classwisestudents('Todler');
     //     classwisestudents('Play Group - I');
     //     classwisestudents('Kinder Garten - I');
     //     classwisestudents('Kinder Garten - II');}
     // }
  Widget classwisestudents(classname){
    final mQ = MediaQuery.of(context).size;
    return
      Padding(
        padding:
        EdgeInsets.symmetric(vertical: 0.0, horizontal: mQ.width*0.02),
        child: StreamBuilder<QuerySnapshot>(
          stream: (role_ == 'Parent') ? collectionReference.where('class_', isEqualTo: classname).where('fathersEmail', isEqualTo: useremail).snapshots():collectionReference.where('class_', isEqualTo: classname).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {return Center(child: Padding(padding: EdgeInsets.only(top: mQ.height*0.01),child: CircularProgressIndicator(),),); }
            if (snapshot.hasError) {return Center(child: Text('Error: ${snapshot.error}'));}
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {return Center(child: Text('',style: TextStyle(color: Colors.grey),));}
            return Column(
              children: <Widget>[
                Container(width: mQ.width,color: Colors.green[50] ,height: mQ.height*0.022,child: Text(classname,textAlign: TextAlign.center,style: TextStyle(color: Colors.teal),)),
                Container(alignment: Alignment.center,
                  color: Colors.transparent,
                  height: mQ.height * 0.098,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      final childData = snapshot.data!.docs[position].data()
                      as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          // Get.to(BiMonthlyScreen(name_: childData['childFullName'],babypicture_: childData['picture'],
                          //     selectedsubject_: widget.selectedsubject_,
                          //     selectedbabyid_:
                          //     snapshot.data!.docs[position].id));
                        },
                        child:
                        checkforwardedreportsandshowbadge(mQ,(role_ == "Teacher")?"New":(role_ == "Principal")?"Forwarded":(role_ == "Parent")?"Approved":(role_ == "Director")?"Approved":"",snapshot.data!.docs[position].id,
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<String>(
                              icon: Container(
                                width: mQ.width * 0.1,
                                height: mQ.height * 0.042,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(alignment: FractionalOffset.topCenter,
                                      image: NetworkImage(
                                        childData['picture'],
                                      ),
                                      // Image.network(babypicture_ , width: mQ.width * 0.07),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              surfaceTintColor: Colors.green,shadowColor: Colors.limeAccent,
                              color: Colors.purple[50], // Generate the menu items from the list
                              itemBuilder:
                                  (BuildContext
                              context) {
                                return reports_.map(
                                        (String item) {
                                      return PopupMenuItem<
                                          String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList();
                              },
                              onSelected: (String
                              selectedItem) async {

                                await confirm(title: Text("View Report"), textOK: Text('Yes'),textCancel: Text('No'),context)?
                              (selectedItem == 'Daily')? Get.to(ParentReportShape(babyID_: snapshot.data!.docs[position].id , name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], childPicture_:  childData['picture'],reportType_: 'Forwarded'))
                                    : (selectedItem == 'Approved')? Get.to(ParentReportShape(babyID_: snapshot.data!.docs[position].id , name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], childPicture_:  childData['picture'],reportType_: 'Approved'))
                                : (selectedItem == 'New')? Get.to(ParentReportShape(babyID_: snapshot.data!.docs[position].id , name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], childPicture_:  childData['picture'],reportType_: 'New'))
                                :(selectedItem == 'Activities')? Get.to(ReportShapeScreen(babyID_:  snapshot.data!.docs[position].id ,name_:  childData['childFullName'], date_: getCurrentDate(), class_:  childData['class_'],babypicture_: childData['picture'], fathersEmail_: childData['fathersEmail'],)):
                                // Get.to(BiWeeklyReportShapeScreen(babyID_: snapshot.data!.docs[position].id, name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], babypicture_:  childData['picture'])):
                                Get.to(BiWeeklyReportShapeScreen(babyID_: snapshot.data!.docs[position].id, name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], babypicture_:  childData['picture']))
                                // Get.to(ReportShapeScreen(babyID_:  snapshot.data!.docs[position].id ,name_:  childData['childFullName'], date_: getCurrentDate(), class_:  childData['class_'],babypicture_: childData['picture'],))
                                    :Null;
                                // collectionReference.doc(snapshot.data!.docs[position].id).update({"class_": selectedItem});
                              },
                            ),
                            Text(" ${childData['childFullName']} ",
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Comic Sans MS',
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                          ],
                        ),),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      );

  }
  Widget checkforwardedreportsandshowbadge(mQ,status,babyid_,Widget pppasa) {
    return
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionReferenceActivity
              .where('id',isEqualTo:babyid_)
              .where('date_',isEqualTo:getCurrentDate().toString())
              .where('status_',isEqualTo:status)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: CircularProgressIndicator(),
                ),
              ); // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            }

            return
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: -2, end: -3),
                badgeAnimation: badges.BadgeAnimation.slide(
                  disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                  curve: Curves.easeInCubic,
                ),
                showBadge: (snapshot.data!.docs.length > 0),
                badgeStyle: badges.BadgeStyle(badgeColor: color,),
                badgeContent: Text(snapshot.data!.docs.length.toString(),
                  style: TextStyle(color: Colors.white,fontSize: 10),
                ),
                child: pppasa,

              )
            ;
          },
        ),
      );
  }


}
