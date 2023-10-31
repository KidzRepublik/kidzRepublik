import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/screens/activities/bi_monthly.dart';
import '../../utils/const.dart';
import '../../utils/image_slide_show.dart';
import '../kids/widgets/empty_background.dart';
int present_ = 0;
int absent_ = 0;
class ActivityHomeChild extends StatefulWidget {
  final activityclass_;
  final selectedsubject_;
  ActivityHomeChild({this.activityclass_, super.key, this.selectedsubject_});

  @override
  State<ActivityHomeChild> createState() => _ActivityHomeChildState();
}

class _ActivityHomeChildState extends State<ActivityHomeChild> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');

setattendance() async {
  await collectionReference
      .where('class', isEqualTo : widget.activityclass_)
      .where('checkin', isEqualTo : 'Checked In')
      .count().get().then(
        (res) => present_ = res.count ,
    onError: (e) => print("Error completing: $e"),
  );
  await collectionReference.where('checkin', isNotEqualTo : 'Checked In' ).count().get().then(
        (res) => absent_ = res.count ,
    onError: (e) => print("Error completing: $e"),
  );
}

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    final subject_ = widget.selectedsubject_;
    setattendance();
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
      body: Column(children: [
        ImageSlideShowfunction(context),
        SingleChildScrollView(
            child: Column(children: [
              Container(height: mQ.height*0.03,color: Colors.grey[50],width: mQ.width,child: Text('Select ${teachersClass_}',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference
                  .where('class_', isEqualTo: widget.activityclass_)
                  // .where('checkin', isEqualTo: 'Checked In')
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
                    title: 'Curently, No student is assigned this class',
                  ); // No data
                }

                // Data is available, build the list
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 1.0, top: 1.0),
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

                    return InkWell(
                      onTap: () {
                        // Get.to(BiMonthlyScreen(selectedbabyid_: snapshot.data!.docs[index].id));
                        Get.to(BiMonthlyScreen(
                            selectedsubject_: subject_,selectedbabyid_: snapshot.data!.docs[index].id, babypicture_: childData['picture'], name_: childData['childFullName'],));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            childData['picture'],
                            //color: kprimary,
                            width: mQ.width * 0.09,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: mQ.width * 0.004,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${childData['childFullName']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black87.withOpacity(0.7),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${childData['fathersName']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 0.3,
                                    color: Colors.black87.withOpacity(0.7),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]))
      ]),
    );
  }
}
