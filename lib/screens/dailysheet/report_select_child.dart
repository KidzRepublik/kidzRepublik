import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/screens/dailysheet/report_shape.dart';
import '../../utils/const.dart';
import '../../utils/getdatefunction.dart';
import '../../utils/image_slide_show.dart';
import '../kids/widgets/empty_background.dart';
class ReportSelectChild extends StatefulWidget {
  final reportstatus_;
  ReportSelectChild({super.key, this.reportstatus_});

  @override
  State<ReportSelectChild> createState() => _ReportSelectChildState();
}

class _ReportSelectChildState extends State<ReportSelectChild> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');
  ScrollController scrollController = ScrollController();

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
      backgroundColor: Colors.blue[50],
      // bottomNavigationBar: MainTabsBottomNavigation(),
      body:
      Column(children: [
        ImageSlideShowfunction(context),
        Container(
          height: mQ.height * 0.03,
          color: Colors.grey[50],
          width: mQ.width,
          child: Text(
            'Select from ${teachersClass_} class',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
          child: StreamBuilder<QuerySnapshot>(
            stream: collectionReference
                .where('class_', isEqualTo: teachersClass_)
                .where('checkin', isEqualTo: 'Checked In')
            // 'Todlers' )
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
                return EmptyBackground(
                  title: 'Curently, No student is present in this class',
                ); // No data
              }

              // Data is available, build the list
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: mQ.width * 0.45,
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
                            Get.to(ReportShapeScreen(babyID_:  snapshot.data!.docs[position].id ,name_:  childData['childFullName'], date_: getCurrentDate(), class_:  childData['class_'],babypicture_: childData['picture'], fathersEmail_: childData['fathersEmail'],));
                            // Get.to(BiMonthlyScreen(
                            //     selectedsubject_: widget.selectedsubject_,
                            //     selectedbabyid_:
                            //     snapshot.data!.docs[position].id));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              child: Container(
                                width: mQ.width * 0.25,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: mQ.width * 0.25,
                                          height: mQ.height * 0.15,
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
                                        Text(" ${childData['childFullName']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Comic Sans MS',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue)),
                                        Text(
                                            '${childData['fathersName']}',
                                            style: TextStyle(
                                                color: Colors.black)),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ]));

    //   Column(children: [
    //     ImageSlideShowfunction(context),
    //     SingleChildScrollView(
    //         child: Column(children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
    //             child: StreamBuilder<QuerySnapshot>(
    //               stream: collectionReference
    //                   .where('class_', isEqualTo: teachersClass_)
    //                   // .where('report', isEqualTo: widget.reportstatus_)
    //                   .where('checkin', isEqualTo: 'Checked In')
    //                   .snapshots(),
    //               builder: (context, snapshot) {
    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return Center(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 25.0),
    //                       child: CircularProgressIndicator(),
    //                     ),
    //                   ); // Show loading indicator
    //                 }
    //
    //                 if (snapshot.hasError) {
    //                   return Center(child: Text('Error: ${snapshot.error}'));
    //                 }
    //
    //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //                   return EmptyBackground(
    //                     title: 'Curently, No report is prepared in this class',
    //                   ); // No data
    //                 }
    //
    //                 // Data is available, build the list
    //                 return ListView.separated(
    //                   separatorBuilder: (context, index) {
    //                     return Padding(
    //                       padding: const EdgeInsets.only(bottom: 5.0, top: 5),
    //                       // child: Divider(
    //                       //   color: Colors.grey.withOpacity(0.2),
    //                       // ),
    //                     );
    //                   },
    //                   primary: false,
    //                   shrinkWrap: true,
    //                   itemCount: snapshot.data!.docs.length,
    //                   itemBuilder: (context, index) {
    //                     final childData = snapshot.data!.docs[index].data()
    //                     as Map<String, dynamic>;
    //
    //                     return InkWell(
    //                       onTap: () {
    //                         // Get.to(BiMonthlyScreen(selectedbabyid_: snapshot.data!.docs[index].id, selectedsubject_: 'Sleep',));
    //                         // Get.to(MoodScreen());
    //                         //   (babyID_: snapshot.data!.docs[index].id ,name_: childData['childFullName'], date_: getCurrentDate(), class_: childData['class_'],));
    //                         Get.to(ReportShapeScreen(babyID_:  snapshot.data!.docs[index].id ,name_:  childData['childFullName'], date_: getCurrentDate(), class_:  childData['class_'],babypicture_: childData['picture'],));
    //                         // Get.to(TodlersReport(babyID_: snapshot.data!.docs[index].id ,name_: childData['childFullName'], date_: '18-09-2023', class_: childData['class_'],));
    //                             // selectedchild_: snapshot.data!.docs[index].id));
    //                       },
    //                       child: Wrap(
    //                         // crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //
    //                           Image.network(childData['picture'],width: mQ.width * 0.09,
    //                             fit: BoxFit.contain,
    //                           ),
    //                           SizedBox(
    //                             width: mQ.width * 0.004,
    //                           ),
    //                           // Expanded(
    //                           //   child: Column(
    //                           //     mainAxisAlignment: MainAxisAlignment.start,
    //                           //     crossAxisAlignment: CrossAxisAlignment.start,
    //                           //     children: [
    //                           //       Row(
    //                           //         crossAxisAlignment: CrossAxisAlignment.start,
    //                           //         children: [
    //                                     Text(
    //                                       "${childData['childFullName']} - ${childData['fathersName']}",
    //                                       style: TextStyle(
    //                                           fontWeight: FontWeight.bold,
    //                                           color:
    //                                           Colors.black87.withOpacity(0.7),
    //                                           fontSize: 12),
    //                                     ),
    //                                   ],
    //                                 ),
    //
    //                               // ],
    //                             // ),
    //                           // ),
    //                         // ],
    //                       // ),
    //                     );
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //         ]))
    //   ]),
    // );
  }
}


  // final collectionReference = FirebaseFirestore.instance.collection('BabyData');
  //
  // @override
  // Widget build(BuildContext context) {
  //   final mQ = MediaQuery.of(context).size;
  //   return Scaffold(
  //       body:
  //       Column(children: [
  //         ImageSlideShowfunction(context),
  //         Container(
  //           height: mQ.height * 0.03,
  //           color: Colors.grey[50],
  //           width: mQ.width,
  //           child: Text(
  //             'Select from ${teachersClass_} class',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream: collectionReference
  //                 .where('class_', isEqualTo: teachersClass_)
  //                 .where('checkin', isEqualTo: 'Checked In')
  //             // 'Todlers' )
  //                 .snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(top: 2.0),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 ); // Show loading indicator
  //               }
  //
  //               if (snapshot.hasError) {
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               }
  //
  //               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                 return EmptyBackground(
  //                   title: 'Curently, No student is present in this class',
  //                 ); // No data
  //               }
  //
  //               // Data is available, build the list
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Container(
  //                     height: mQ.width * 0.45,
  //                     child: ListView.builder(
  //                       physics: AlwaysScrollableScrollPhysics(),
  //                       itemCount: snapshot.data!.docs.length,
  //                       controller: scrollController,
  //                       scrollDirection: Axis.horizontal,
  //                       itemBuilder: (context, position) {
  //                         final childData = snapshot.data!.docs[position].data()
  //                         as Map<String, dynamic>;
  //
  //                         return GestureDetector(
  //                           onTap: () {
  //                             // Get.to(BiMonthlyScreen(
  //                             //     selectedsubject_: widget.selectedsubject_,
  //                             //     selectedbabyid_:
  //                             //     snapshot.data!.docs[position].id));
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(1.0),
  //                             child: Card(
  //                               child: Container(
  //                                 width: mQ.width * 0.25,
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                   CrossAxisAlignment.start,
  //                                   mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Column(
  //                                       children: [
  //                                         Container(
  //                                           width: mQ.width * 0.25,
  //                                           height: mQ.height * 0.15,
  //                                           decoration: BoxDecoration(
  //                                             shape: BoxShape.circle,
  //                                             image: DecorationImage(
  //                                                 image: NetworkImage(
  //                                                   childData['picture'],
  //                                                 ),
  //                                                 // Image.network(babypicture_ , width: mQ.width * 0.07),
  //                                                 fit: BoxFit.fill),
  //                                           ),
  //                                         ),
  //                                         Text(" ${childData['childFullName']}",
  //                                             style: TextStyle(
  //                                                 fontSize: 14,
  //                                                 fontFamily: 'Comic Sans MS',
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: Colors.blue)),
  //                                         Text(
  //                                             '${childData['fathersName']}',
  //                                             style: TextStyle(
  //                                                 color: Colors.black)),
  //
  //                                         //     Padding(
  //                                         //   padding: const EdgeInsets.all(3.0),
  //                                         //   child: Column(
  //                                         //     crossAxisAlignment:
  //                                         //         CrossAxisAlignment.start,
  //                                         //     children: <Widget>[
  //                                         //       // Image.network(
  //                                         //       //   childData['picture'],
  //                                         //       //   //color: kprimary,
  //                                         //       //   width: mQ.width * 0.25,
  //                                         //       //   height: mQ.height * 0.15,
  //                                         //       //   fit: BoxFit.contain,
  //                                         //       // ),
  //                                         //       Padding(
  //                                         //         padding:
  //                                         //             const EdgeInsets.symmetric(
  //                                         //                 horizontal: 2.0,
  //                                         //                 vertical: 2.0),
  //                                         //         child: Text(
  //                                         //             '${childData['childFullName']}',
  //                                         //             style: TextStyle(
  //                                         //                 color: Colors.black)),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(10.0)),
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   )
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ]));
  // }

