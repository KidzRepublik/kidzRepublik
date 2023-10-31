import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../utils/const.dart';
import '../../utils/image_slide_show.dart';
import '../kids/widgets/empty_background.dart';
// import 'bi_monthly.dart';

class SelectChildForReminder extends StatefulWidget {
  final activityclass_;
  final selectedsubject_;
  SelectChildForReminder(
      {this.activityclass_, super.key, required this.selectedsubject_});
  String activitybabyid_ = '';

  @override
  State<SelectChildForReminder> createState() => _SelectChildForReminderState();
}

class _SelectChildForReminderState extends State<SelectChildForReminder> {
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
        body: Column(children: [
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
                  .where('class_', isEqualTo: widget.activityclass_)
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
                              // Get.to(BiMonthlyScreen(name_: childData['childFullName'],babypicture_: childData['picture'],
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
  }
}
