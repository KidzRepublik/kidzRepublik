import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:whatsapp_sender_flutter/whatsapp_sender_flutter.dart';
import '../../utils/const.dart';
import '../../utils/getdatefunction.dart';
import '../../utils/image_slide_show.dart';
import '../../utils/updateclassstrength.dart';
import '../activities/bi_monthly.dart';
import '../kids/widgets/empty_background.dart';

bool saveCheckIn = false;
var classData;

class TeacherHomeChild extends StatefulWidget {
  final activityclass_;
  TeacherHomeChild({required this.activityclass_, super.key});

  @override
  State<TeacherHomeChild> createState() => _TeacherHomeChildState();
}

class _TeacherHomeChildState extends State<TeacherHomeChild> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');
  Widget setattendance(mQ, attendanceclass_) {
    return
      Padding(
        padding:EdgeInsets.all(mQ.width*0.018),
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionReferenceClass
              .where("class_", isEqualTo: attendanceclass_)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top:mQ.height*0.02),
                  child: CircularProgressIndicator(),
                ),
              ); // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return EmptyBackground(
                title: 'Curently, No student is present in this class',
              ); // No data
            }

            // Data is available, build the list
            return Container(
              height: mQ.height * 0.025,
              width: mQ.width*0.99,
              color: Colors.grey[50],
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                // controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, position) {
                  final attendanceData = snapshot.data!.docs[position].data()
                  as Map<String, dynamic>;
                  UpdateClassRoomStrength(teachersClass_!,context);

                  return GestureDetector(
                    onTap: () {
                      Get.to (TeacherHomeChild(activityclass_: attendanceData['class_']));
                    },
                    child:
                    Container(
                        padding: EdgeInsets.only(left: mQ.width*0.01, right: mQ.width*0.04),
                        height: mQ.height * 0.025,
                        width: mQ.width*0.99,
                        color: Colors.grey[50],
                        alignment: Alignment.center,
                        child:
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text('Babies ', //${attendanceData['strength_']}
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Comic Sans MS',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.blue[900])),
                                    Wrap(children: [
                                      Icon(Icons.person,
                                          color: Colors.green[900], size: 18),
                                      Text('${attendanceData['present_']} ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Comic Sans MS',
                                              fontWeight: FontWeight.normal,
                                              color: Colors.green[900])),
                                    ]),
                                    SizedBox(
                                      width: mQ.width * 0.01,
                                    ),
                                    Wrap(children: [
                                      Icon(Icons.person, color: Colors.red, size: 18),
                                      Text('${attendanceData['absent_']} ',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Comic Sans MS',
                                              fontWeight: FontWeight.normal,
                                              color: Colors.red)),
                                    ]),
                                    ])),
                                    Expanded(
                                      child: Text(getCurrentDateforattendance(),textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Comic Sans MS',
                                              fontWeight: FontWeight.normal,
                                              color: Colors.blue[900])),
                                    ),
                                  ],
                                ),
                              ), //class attendance Summery
                  );
                },
              ),
            );
          },
        ),
      );
  }
  final collectionReferenceActivity =
      FirebaseFirestore.instance.collection('Activity');

  final collectionReferenceClass =
      FirebaseFirestore.instance.collection('ClassRoom');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhite),
          title: Text(
            'Class ${teachersClass_}',
            style: TextStyle(color: kWhite),
          ),
          backgroundColor: kprimary,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
        ImageSlideShowfunction(context),
        setattendance(mQ,widget.activityclass_),
            SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical:mQ.height*0.01, horizontal: mQ.width*0.01),
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionReference
                      .where('class_', isEqualTo: widget.activityclass_)
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
                      // return EmptyBackground(
                      //   title: 'Curently, No student is assigned this class',
                      // ); // No data
                    }

                    // Data is available, build the list
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left:mQ.width*0.01, right: mQ.width*0.01),
                          // padding: const EdgeInsets.only(left: 1.0, right: 1),
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

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left:mQ.width*0.01),
                                  width: mQ.width * 0.30,
                                  child: Text(
                                      " ${childData['childFullName']}  ${childData['fathersName']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Comic Sans MS',
                                        fontWeight: FontWeight.normal,
                                        color:Colors.blue[900],
                                      )),
                                ),
                                Container(
                                  width: mQ.width * 0.10,
                                  height: mQ.height * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          childData['picture'],
                                        ),
                                        // Image.network(babypicture_ , width: mQ.width * 0.07),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child:
                              // saveCheckIn?Center(child: CircularProgressIndicator(),):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: mQ.width * 0.05),
                                  Container(
                                    width: mQ.width * 0.2,
                                    alignment: FractionalOffset.centerLeft,
                                    child: Text("${childData['checkin']}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Comic Sans MS',
                                          fontWeight: FontWeight.normal,
                                          color: (childData['checkin'] ==
                                                  "Checked In")
                                              ? Colors.green
                                              : Colors.red,
                                        )),
                                  ),
                                  SizedBox(width: mQ.width * 0.05),
                                  (childData['checkin'] != 'Checked In')
                                      ? IconButton(
                                          onPressed: () async {
                                            _showConfirmationDialog(snapshot,index,childData,"Checked In",context);
                                        },
                                          icon: Icon(Icons.output,
                                              size: 22,
                                              color: Colors.green[900]))
                                      : (childData['checkin'] == 'Checked In')
                                      ? IconButton(
                                          onPressed: () {
                                            _showConfirmationDialog(snapshot,index,childData,"Checked Out",context);
                                          },
                                          icon: Icon(Icons.output,
                                              size: 22, color: Colors.red))
                                      : Container(),
                                  (childData['checkin'] != 'Checked In')
                                      ? IconButton(
                                          onPressed: () async {
                                            _showConfirmationDialog(snapshot,index,childData,"Absent",context);

                                          },
                                          icon: Icon(Icons.person_off,
                                              size: 22, color: Colors.red))
                                      : SizedBox(
                                          width: mQ.width * 0.001,
                                        ),
                                ],
                              ),

                              // ],
                              // ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ]))
          ]),
        ));
  }
  void _showConfirmationDialog(snapshot, index, childData,status_,BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
          title: Text('Confirmation'),
          content: Text('Do you want to proceed with this action?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Proceed'),
              onPressed: () {
                checkinsavefunction(snapshot,index,childData,status_);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  checkinsavefunction(snapshot, index, childData,status_) async {
var date_ = getCurrentDate();
    await collectionReferenceActivity.add({
      "id": snapshot
          .data!.docs[index].id,
      "Subject": "Attendance",
      "Activity": status_,
      "date_": date_,
      "time_":
      selectedTime.format(context),
      "image_": imageUrl,
      "description":

      (status_ == 'Absent') ?
      "${childData['childFullName']} is absent today"
          : "${childData['childFullName']} has just ${status_}",
      "status_": "New",
      "category_": "DailySheet"
    });
    await collectionReference
        .doc(snapshot
        .data!.docs[index].id)
        .update({
      "checkin": status_
    });
    (status_ == 'Checked In') ?
    await collectionReferenceClass.doc(childData['class_']).update({
      'present_': FieldValue.increment(1),
      'absent_': FieldValue.increment(-1)
    }) :
    await collectionReferenceClass.doc(childData['class_']).update({
      'present_': FieldValue.increment(-1),
      'absent_': FieldValue.increment(1)
    });
    await WhatsAppSenderFlutter.send(
        phones: [ childData['whatsapp']],
        message:
        (status_ == "Absent") ?
        "${childData['childFullName']} is absent today" :
        "${childData['childFullName']} has just ${status_}"
    );
  }
  }


