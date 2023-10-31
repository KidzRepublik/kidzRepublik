import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import '../../utils/const.dart';
import '../../utils/getdatefunction.dart';
import '../../utils/image_slide_show.dart';
import '../consent/parent_consent_screen.dart';
import '../dailysheet/biweekly_report_shape.dart';
import '../dailysheet/parent_report/parent_report_shape.dart';
import '../kids/widgets/empty_background.dart';
import '../reminder/reminderstoparent.dart';
import '../widgets/base_drawer.dart';

int _cartBadgeAmount = 0;
late bool _showCartBadge;
Color color = Colors.red;
class ParentHomeScreen extends StatefulWidget {
  ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');
  final collectionReferenceActivity = FirebaseFirestore.instance.collection('Activity');
  User? user = FirebaseAuth.instance.currentUser;
  // final collectionReferenceActivity = FirebaseFirestore.instance.collection('Activity');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[50],
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
        // padding: EdgeInsetsDirectional.all(16),
        child: Column(children: [
          ImageSlideShowfunction(context),
          SingleChildScrollView(
              child: Column(children: [
            SizedBox(height: 10,),
            Text('My Kidz', textAlign: TextAlign.center),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 010),
              child: StreamBuilder<QuerySnapshot>(
                stream: collectionReference
                    .where('fathersEmail', isEqualTo: useremail)
                    // 'Todlers' )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: CircularProgressIndicator(),
                      ),
                    ); // Show loading indicator
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return EmptyBackground(
                      title: 'No data to show',
                    ); // No data
                  }

                  // Data is available, build the list
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 1.0, top: 1),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      );
                    },
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final childData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Picture, Name and fathers name of child
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  (childData['picture'] == '')
                                      ? Image.asset(
                                          'assets/staff.jpg',
                                          //color: kprimary,
                                          width: mQ.width * 0.12,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          childData['picture'],
                                          //color: kprimary,
                                          width: mQ.width * 0.12,
                                          fit: BoxFit.scaleDown,
                                        ),
                                  Text(
                                    "${childData['childFullName']}  ${childData['fathersName']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87.withOpacity(0.7),
                                        fontSize: 10),
                                  ),
                                ]),
                              ),
                              Expanded(
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Status',style: TextStyle(fontSize: 12),),
                                    (childData['checkin'] == 'Checked In')
                                        ? Icon(Icons.output,
                                        size: 20, color: Colors.green[900])
                                        : (childData['checkin'] == 'Checked Out')
                                        ? Icon(Icons.output,
                                        size: 20, color: Colors.red)
                                        : (childData['checkin'] == 'Absent')
                                        ? Icon(Icons.person_off,
                                        size: 20, color: Colors.red)
                                        : Text(''),
                                    Text('${childData['checkin']}',style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              SizedBox(width: mQ.width*0.08,)
                            ],
                          ),
                          // Reports and consents
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: mQ.width*0.23,
                                  height: mQ.height*0.025,
                                  child:
                                  checkforwardedreportsandshowbadge(mQ,(role_ == "Teacher")?"New":(role_ == "Principal")?"Forwarded":(role_ == "Parent")?"Approved":(role_ == "Director")?"Approved":"",snapshot.data!.docs[index].id,
                                    ElevatedButton(
                                    onPressed: () {
                                      Get.to(ParentReportShape(
                                          babyID_:
                                              snapshot.data!.docs[index].id,
                                          name_: childData['childFullName'],
                                          date_: getCurrentDate(),
                                          class_: childData['class_'],
                                          childPicture_: childData['picture'],
                                          reportType_: 'Approved'));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .brown.shade50, // Button background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                      ),
                                    ),
                                    child:
                                    Container(width: mQ.width*0.12,
                                      child: Text('    Daily    ',
                      style: TextStyle(fontSize: mQ.height*0.012)),
                                    ),
                                  )),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // width: mQ.width*0.1,
                                  height: mQ.height*0.025,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(BiWeeklyReportShapeScreen(babyID_: snapshot.data!.docs[index].id, name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'], babypicture_:  childData['picture']));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .brown.shade50, // Button background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                      ),
                                    ),
                                    child:
                                    Container(width: mQ.width*0.3,
                                      child: Text('Bi Weekly',
                                          style: TextStyle(fontSize: mQ.height*0.012)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: mQ.width*0.23,
                                      height: mQ.height*0.025,
                                      child:
                                      consentbadges(mQ,"Waiting",snapshot.data!.docs[index].id,"Reminder",
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.to(ParentReminderScreen(babyid_: snapshot.data!.docs[index].id,));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .brown.shade50, // Button background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                              ),
                                            ),
                                            child:
                                            Container(width: mQ.width*0.12,
                                              child: Text('Reminder',
                      style: TextStyle(fontSize: mQ.height*0.012)),
                                            ),
                                          )),
                                    ),
                              ),
                              Expanded(
                                child: Container(
                                  width: mQ.width*0.1,
                                      height: mQ.height*0.025,
                                      child:
                                      consentbadges(mQ,"Waiting",snapshot.data!.docs[index].id,"Consent",
                                          ElevatedButton(
                                            onPressed: () {
                                              print( snapshot.data!.docs[index].id,);
                                              Get.to(ParentConsentScreen(babyid:
                                              snapshot.data!.docs[index].id,
                                                ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .brown.shade50, // Button background color
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                                              ),
                                            ),
                                            child:
                                            Container(width: mQ.width*0.12,
                                              child: Text('Consent',
                                                  style: TextStyle(fontSize: mQ.height*0.012)),
                                            ),
                                          )),
                                    ),
                              ),
                            ],
                          ),
                          // status
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ]))
        ]),
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
              _showCartBadge = false;
            }
// setState(() {
            _cartBadgeAmount=
                snapshot.data!.docs.length;
            _showCartBadge = (snapshot.data!.docs.length > 0);
// });
            return
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 1, end: 0),
                badgeAnimation: badges.BadgeAnimation.slide(
                  disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                  curve: Curves.easeInCubic,
                ),
                showBadge: (snapshot.data!.docs.length > 0),
                badgeStyle: badges.BadgeStyle(badgeColor: color,),
                badgeContent: Text(snapshot.data!.docs.length.toString(),
                  style: TextStyle(fontSize: 8,color: Colors.white),
                ),
                child: pppasa,

              )
            ;
          },
        ),
      );
  }
  Widget consentbadges(mQ,status,babyid_,category,Widget pppasa) {
    return
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionReferenceActivity
              .where('child_',isEqualTo:babyid_)
              .where('category_', isEqualTo: category)
              .where('parentid_', isEqualTo: useremail)
              .where('result_',isEqualTo:status)
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
              // _showCartBadge = false;
            }
// setState(() {
//             _cartBadgeAmount=
//                 snapshot.data!.docs.length;
            // _showCartBadge = (snapshot.data!.docs.length > 0);
// });
            return
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 1, end: 0),
                badgeAnimation: badges.BadgeAnimation.slide(
                  disappearanceFadeAnimationDuration: Duration(milliseconds: 100),
                  curve: Curves.easeInCubic,
                ),
                showBadge: (snapshot.data!.docs.length > 0),
                badgeStyle: badges.BadgeStyle(badgeColor: color,),
                badgeContent: Text(snapshot.data!.docs.length.toString(),
                  style: TextStyle(fontSize: 8,color: Colors.white),
                ),
                child: pppasa,

              )
            ;
          },
        ),
      );
  }

}
