import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../kids/widgets/empty_background.dart';



class SelectChildForActivity extends StatefulWidget {
  final activityclass_;
  SelectChildForActivity({ this.activityclass_, super.key});
String activitybabyid_ = '';

  @override
  State<SelectChildForActivity> createState() => _SelectChildForActivityState();
}
class _SelectChildForActivityState extends State<SelectChildForActivity> {
  final collectionReference = FirebaseFirestore.instance.collection('BabyData');


  @override
  Widget build(BuildContext context) {
    // BiMonthlyScreen biMonthlyScreen = BiMonthlyScreen();
SelectChildForActivity selectChildForActivity = SelectChildForActivity();
    final mQ = MediaQuery.of(context).size;
    return Column(mainAxisSize: MainAxisSize.max, children: [
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
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, top: 2),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                );
              },
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final childData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return
                  SingleChildScrollView(
                    child: InkWell(
                    onTap: () {
                      // Get.to(BiMonthlyScreen(selectedbabyid_: snapshot.data!.docs[index].id));
                      // Get.to(SelectActivityScreen(selectedchild_: snapshot.data!.docs[index].id));
                      // biMonthlyScreen.selectedbabyid_ =
                      setState(() {
                      selectChildForActivity.activitybabyid_ = snapshot.data!.docs[index].id;

                      });
                      // return activitybabyid_;
                    },
                    child:
                    Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/staff.jpg',
                            //color: kprimary,
                            width: mQ.width * 0.09,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            "${childData['childFullName']} - ${childData['fathersName']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87.withOpacity(0.7),
                                fontSize: 12),
                          ),
                        ]
                    )                ),
                  );
              },
            );
          },
        ),
      ),
    ]);
  }
}
