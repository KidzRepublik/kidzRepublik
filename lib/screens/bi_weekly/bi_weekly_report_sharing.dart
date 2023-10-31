import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../utils/const.dart';

class BiWeeklySharingWithParents extends StatefulWidget {
  final baby;
  final reportdate_;
  final biweeklystatus_;
  final subject;
  final babyname;
  final babypicture;
  final category;
  final Color subjectcolor_;
  final fathersEmail_;

  BiWeeklySharingWithParents({
    super.key,
    this.baby,
    this.reportdate_,
    this.subject,
    this.babyname,
    this.babypicture,
    required this.subjectcolor_,
    this.category, this.fathersEmail_, this.biweeklystatus_,
  });
  String activitybabyid_ = '';

  @override
  State<BiWeeklySharingWithParents> createState() =>
      _BiWeeklySharingWithParentsState();
}

class _BiWeeklySharingWithParentsState extends State<BiWeeklySharingWithParents> {
  final collectionReference = FirebaseFirestore.instance.collection('Activity');
  bool deleteionLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var condition;
    var startDate;
    var endDate;
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime.now();
    DateTime fifteenDaysAgo = currentDate.subtract(Duration(days: 15));


currentDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
fifteenDaysAgo = DateTime(fifteenDaysAgo.year,fifteenDaysAgo.month,fifteenDaysAgo.day);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kprimary, // Change this to the desired color
    ));
    if (now.day >= 1 && now.day <= 15) {
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month, 15);
    } else{
      startDate = DateTime(now.year, now.month, 16);
      endDate = DateTime(now.year, now.month, 31);
    }
    final mQ = MediaQuery.of(context).size;
    var biweeklystatus_;
    if(role_ == "Teacher"){biweeklystatus_ = '"biweeklystatus_", isEqualTo: "New"';}
    if(role_ == "Principal"){biweeklystatus_ = '"biweeklystatus_", WhereIn: ["Forwarded","Approved"]';}
    if(role_ == "Director"){biweeklystatus_ = '"biweeklystatus_", WhereIn: ["New","Forwarded","Approved"]';}
    if(role_ == "Parent"){biweeklystatus_ = '"biweeklystatus_", isEqualTo: "Approved"';}
    condition = collectionReference
        .where('category_', isEqualTo: 'BiWeekly')
        .where('id', isEqualTo: widget.baby)
        .where('date_', isGreaterThanOrEqualTo: DateFormat('dd-MM-yyyy').format(startDate), isLessThanOrEqualTo: DateFormat('dd-MM-yyyy').format(endDate))
        .where(biweeklystatus_);

    return Column(
      children: [
        // InkWell(onTap:
        // Get.to(
            // BiWeeklyReportShapePDFPreviewPage(babyID_: widget.baby, name_: widget.babyname, date_: widget.reportdate_, class_: '', babypicture_: widget.babypicture,))
        //   ,
        //   child:
        // Text('PDF')

        // ),
        countdays(startDate,endDate,mQ),
        // IconButton(
        //     padding: EdgeInsets.zero,
        //     onPressed: () {
        //       Future<pw.Document> generatePdf() async {
        //         final pdf = pw.Document();
        //
        //         // Fetch data from Firestore
        //         // Replace this with your Firestore logic
        //         final QuerySnapshot snapshot = await FirebaseFirestore.instance
        //             .collection('Activity')
        //             .where('category_', isEqualTo: 'Biweekly')
        //             .where('Status_', isEqualTo: 'Approved')
        //             .get();
        //
        //         // Add data to PDF
        //         for (final doc in snapshot.docs) {
        //           pdf.addPage(
        //             pw.Page(
        //               build: (pw.Context context) {
        //                 return pw.Center(
        //                   child: pw.Text('${doc.data()}'),
        //                 );
        //               },
        //             ),
        //           );
        //         }
        //
        //         return pdf;
        //       }
        //       Get.to(
        //           BiWeeklyReportShapePDFPreviewPage(babyID_: widget.baby, name_: widget.babyname, date_: widget.reportdate_, class_: '', babypicture_: widget.babypicture,));
        //
        //         //     PdfPreviewPage(
        //         //   totalLand:
        //         //   recordData['land_in_plot'],
        //         //   currency: recordData['currency'],
        //         //   farmerName: controller.name.value,
        //         //   cropName:
        //         //   "${recordData['seed_name']}/${recordData['seed_variety']}",
        //         //   plot_no: recordData['plot_no'],
        //         //   Sowing_date:
        //         //   recordData['sowing_date'],
        //         //   harvestingDate:
        //         //   recordData['harvesting_date'],
        //         //   seed_used: recordData[
        //         //   'seed_quantity_used'] +
        //         //       ' Kg',
        //         //   seed_expenses:
        //         //   recordData['seed_expenses']
        //         //       .toString(),
        //         //   land_prep_expenses: recordData[
        //         //   'land_preparation_expenses']
        //         //       .toString(),
        //         //   irrigation_expenses: recordData[
        //         //   'irrigation_expenses']
        //         //       .toString(),
        //         //   ferrtilizer:
        //         //   "${recordData['fertilizer_name']}/${recordData['fertilizer_variety']}",
        //         //   ferrtilizer_expenses: recordData[
        //         //   'fertilizer_expenses']
        //         //       .toString(),
        //         //   ferrtilizer_used: recordData[
        //         //   'fertilizer_quantity_used'] +
        //         //       ' Kg',
        //         //   Pesticides:
        //         //   "${recordData['pesticide_name']}/${recordData['pesticide_variety']}",
        //         //   Pesticides_expenses: recordData[
        //         //   'pesticides_expenses']
        //         //       .toString(),
        //         //   Pesticides_used: recordData[
        //         //   'pesticide_quantity_used']
        //         //       .toString(),
        //         //   other:
        //         //   "${recordData['other_name']}/${recordData['other_variety']}",
        //         //   other_expenses:
        //         //   recordData['other_expenses']
        //         //       .toString(),
        //         //   other_used: recordData[
        //         //   'other_quantity_used']
        //         //       .toString(),
        //         //   total_expenditure: recordData[
        //         //   'total_expenditure']
        //         //       .toString(),
        //         //   productivity:
        //         //   recordData['productivity']
        //         //       .toString(),
        //         //   total_income:
        //         //   recordData['sold_in']
        //         //       .toString(),
        //         //   result: recordData[
        //         //   'total_expenditure'] >
        //         //       recordData['sold_in']
        //         //       ? "Beard loss of: ${recordData['total_expenditure'] - recordData['sold_in']}"
        //         //       : "Earned Profit of: ${recordData['sold_in'] - recordData['total_expenditure']}",
        //         //   labor_expenses:
        //         //   recordData['labor_expenses']
        //         //       .toString(),
        //         // )
        //
        //     },
        //     icon: Icon(
        //       Icons.picture_as_pdf,
        //       color: Colors.red[50],
        //
        //     )),

        Padding(
          padding:EdgeInsets.symmetric(horizontal: 18.0),
          child: StreamBuilder<QuerySnapshot>(
            stream:
            condition.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return
                  Text(
                    '${widget.subject} - record will be displayed here');
              }
              //EmptyBackground(title: 'Wait for activities to be updated',); }
              // Map<String, List<QueryDocumentSnapshot>> groupedActivities = {};
              Map<String, List<Map<String, dynamic>>> groupedActivities = {};
              snapshot.data!.docs.forEach((activity) {
                String subject = activity['Subject'];
                // Text (activity['Subject']);
                if (groupedActivities.containsKey(subject)) {
                  groupedActivities[subject]!.add({
                      'id': activity.id,
                      'Activity': activity['Activity'],
                      'description': activity['description'],
                      'date_': activity['date_'],
                      'time_': activity['time_'],
                      });
                      Text( activity['Activity']);
                } else {
                  groupedActivities[subject] = [{
                    'id': activity.id,
                    'Activity': activity['Activity'],
                    'description': activity['description'],
                    'date_': activity['date_'],
                    'time_': activity['time_'],
                  }];
                }
              });

              return
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: groupedActivities.entries.map((entry) {
                    return Column(
                      children: [
                        Container(width: mQ.width*0.9,color: Colors.grey[50],
                          child: Text(
                            '${entry.key}',
                            style: TextStyle(fontWeight: FontWeight.bold,),
                          ),
                        ),
                    Container(width: mQ.width*0.9,color: Colors.green[50],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entry.value.map((activity) {
                              return InkWell(
                                onTap: (){
                                  showEditingDialog(activity['id'], activity['Activity'], activity['description'], entry.key);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text('${activity['Activity']}',style: TextStyle(fontWeight: FontWeight.bold),)),
                                        (role_ == "Parent")?Expanded(child: Container()):Expanded(child: Text('${activity['date_']}',textAlign: TextAlign.right,style: TextStyle(color: Colors.grey[500]),)),
                                      ],
                                    ),
                                        Text('${activity['description']}'),
                                        // Text('Time: ${activity['time_']}'),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                                      SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                );
            },
          ),
        ),
      ],
    );
  }

  showEditingDialog(documentId, activity_, description, subject) {
    bool _isEnable = false;
    TextEditingController description_text_controller =
    TextEditingController(text: description);
    TextEditingController subject_text_controller =
    TextEditingController(text: subject);
    TextEditingController activity_text_controller =
    TextEditingController(text: activity_);
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Material(
                    child: CupertinoAlertDialog(
                      title:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: subject_text_controller,
                              enabled: _isEnable,
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                                alignment: AlignmentDirectional.topEnd,onPressed: () {
                              Navigator.of(context).pop();
                            },
                                icon: Icon(Icons.cancel,
                                    size: 12, color: Colors.black)),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          TextField(
                            controller: activity_text_controller,
                            enabled: _isEnable,
                          ),
                          TextField(
                            controller: description_text_controller,
                            maxLines: 3,
                            enabled: _isEnable,
                          ),
                          (_isEnable)
                              ? IconButton(
                              onPressed: () {
                                collectionReference.doc(documentId).update({
                                  "Subject": subject_text_controller.text,
                                  "Activity": activity_text_controller.text,
                                  "description": description_text_controller.text,
                                });
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.save,
                                color: Colors.orange,
                              ))
                              : Container(),
                        ],
                      ),
                      actions: [
                        deleteionLoading
                            ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: CircularProgressIndicator(),
                            ))
                            : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  iconSize: 18,
                                  color: Colors.blue[600],
                                  onPressed: () {
                                    setState(() {
                                      _isEnable = true;
                                    });
                                  }),
                              (role_ == 'Teacher')?
                              IconButton(
                                  onPressed: () async {
                                    await collectionReference
                                        .doc(documentId)
                                        .update({"photostatus_": 'Forwarded'});
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.arrow_circle_right_outlined,
                                      size: 18, color: Colors.green[600])):Container(),
                              (role_ == 'Manager' )?
                              IconButton(
                                  onPressed: () async {
                                    await collectionReference
                                        .doc(documentId)
                                        .update({"photostatus_": "Recommended"});
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.verified_outlined,
                                      size: 18, color: Colors.green[600])):Container(),
                              (role_ == 'Principal' || role_ == 'Director' )?
                              IconButton(
                                  onPressed: () async {
                                    await collectionReference
                                        .doc(documentId)
                                        .update({"photostatus_": "Approved"});
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.approval,
                                      size: 18, color: Colors.green[600])):Container(),
                              (role_ == 'Principal' || role_ == 'Director' )?
                              IconButton(
                                  onPressed: () async {
                                    await collectionReference
                                        .doc(documentId)
                                        .update({"photostatus_": "Share"});
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.share,
                                      size: 18, color: Colors.green[600])):Container(),
                              (role_ == 'Manager' ||role_ == 'Principal' )?
                              IconButton(
                                  onPressed: () async {
                                    await collectionReference
                                        .doc(documentId)
                                        .update({'photostatus_': "Returned"});
                                  },
                                  icon: Icon(Icons.assignment_return_outlined,
                                      size: 18, color: Colors.orangeAccent)): Container(),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteionLoading = true;
                                    });
                                    deleteDocumentFromFirestore(documentId);
                                  },
                                  icon: Icon(Icons.delete_outline_sharp,
                                      size: 18, color: Colors.black)),
                            ]),

                        // actionbuttonsfunction(context, MediaQuery.of(context).size,documentId),

                        // CupertinoDialogAction(
                        //     isDefaultAction: false,
                        //     child: const Column(
                        //       children: <Widget>[
                        //         Text('Forward'),
                        //       ],
                        //     ),
                        //     onPressed: () {
                        //       collectionReference.doc(documentId).update({'status':"Forward"});
                        //     }),
                        // CupertinoDialogAction(
                        //     isDefaultAction: false,
                        //     child: const Column(
                        //       children: <Widget>[
                        //         Text('Update'),
                        //       ],
                        //     ),
                        //     onPressed: () {
                        //       // collectionRefrenceActivity.doc(documentId).update({'status':"Returned"});
                        //     }),
                        // CupertinoDialogAction(
                        //     isDefaultAction: false,
                        //     child: const Column(
                        //       children: <Widget>[
                        //         Text('Delete'),
                        //       ],
                        //     ),
                        //     onPressed: () {
                        //       setState(() {
                        //         deleteionLoading = true;
                        //       });
                        //       deleteDocumentFromFirestore(documentId);
                        //     }),
                        // CupertinoDialogAction(
                        //     isDefaultAction: false,
                        //     child: const Column(
                        //       children: <Widget>[
                        //         Text('Cancel'),
                        //       ],
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     }),
                      ],
                    ));
              });
        });
  }

  Future<void> deleteDocumentFromFirestore(String documentId) async {
    // Reference to the Firestore collection and document

    try {
      // Delete the document with the specified document ID
      setState(() {
        deleteionLoading = false;
      });
      Navigator.of(context).pop();

      await collectionReference.doc(documentId).delete();
    } catch (e) {
      Navigator.of(context).pop();
      print('Error deleting document: $e');
    }
  }



countdays(startDate,endDate,mQ){
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Activity')
          .where('id', isEqualTo: widget.baby)
          .where('date_', isGreaterThanOrEqualTo: DateFormat('dd-MM-yyyy').format(startDate), isLessThanOrEqualTo: DateFormat('dd-MM-yyyy').format(endDate))
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        int checkedInCount = 0;
        int absentCount = 0;

        snapshot.data!.docs.forEach((activity) {
          if (activity['Activity'] == 'Checked In') {
            checkedInCount++;
          }
          if (activity['Activity'] == 'Absent') {
            absentCount++;
          }
        });

        return Container(color: Colors.brown[50],
          child:
          Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: mQ.width * 0.1,
                        height: mQ.height * 0.05,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.babypicture,
                              ),
                              // Image.network(babypicture_ , width: mQ.width * 0.07),
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                        Container(alignment: Alignment.center,
                          width: mQ.width * 0.45,
                          height: mQ.height * 0.05,
                          child:
                    Column(
                      children: [
        // (Academic Session 2023-2024),
                          Text('BI-WEEKLY ACTIVITIES',
                        style: TextStyle(fontSize: mQ.height*0.018,fontWeight: FontWeight.bold)),
                        Text('(Academic Session 2023-2024)',
                            style: TextStyle(fontSize: mQ.height*0.013,fontWeight: FontWeight.bold)),
                      ],
                    ),
                        ),
                    Container(alignment: Alignment.centerRight,
                      width: mQ.width * 0.1,
                      height: mQ.height * 0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/logo.png',
                            // width: mQ.width * 0.07),
                            ),
                            // Image.network(babypicture_ ,
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date:',textAlign: TextAlign.left,
                        style: TextStyle(fontSize: mQ.height*0.013)),
                        Text('${DateFormat('dd MMM').format(startDate)} to ${DateFormat('dd MMM yy').format(endDate)}',textAlign: TextAlign.left,
                            style: TextStyle(fontSize: mQ.height*0.013)),
                      ],
                    ),
                  ),
                  Expanded(child:
                  Text(" ${(widget.babyname)}",
                      textAlign: TextAlign.center,
        style: TextStyle(fontSize: mQ.height*0.02,
                          fontFamily: 'Comic Sans MS',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue))),
                  // Expanded(child: Text(,textAlign: TextAlign.center,)),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Days Present: $checkedInCount',textAlign: TextAlign.right,
                      style: TextStyle(fontSize: mQ.height*0.013)),
                        // style: TextStyle(fontSize: 10),),
                      Text('Absent: $absentCount',textAlign: TextAlign.right,
                          style: TextStyle(fontSize: mQ.height*0.013)),
                        // style: TextStyle(fontSize: 10),),
                    ],
                  )),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
}
