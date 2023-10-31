import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids_republik/utils/parent_photos_slideshow.dart';

import '../../main.dart';
bool ApprovedOnly = false;
class PhotoSharingWithParents extends StatefulWidget {
  final baby;
  final reportdate_;
  final biweeklystatus_;
  final subject;
  final category;
  final Color subjectcolor_;
  final fathersEmail_;

  PhotoSharingWithParents({
    super.key,
    this.baby,
    this.reportdate_,
    this.subject,
    required this.subjectcolor_,
    this.category, this.fathersEmail_, this.biweeklystatus_,
  });
  String activitybabyid_ = '';

  @override
  State<PhotoSharingWithParents> createState() =>
      _PhotoSharingWithParentsState();
}

class _PhotoSharingWithParentsState extends State<PhotoSharingWithParents> {
  final collectionReference = FirebaseFirestore.instance.collection('Activity');
  bool deleteionLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    var condition;
    (widget.category == 'DailySheet')?
    (ApprovedOnly)
        ? condition = collectionReference
        .where('id', isEqualTo: widget.baby)
        .where('photostatus_', isEqualTo: 'Approved')
        :(role_ == "Teacher")?   condition = collectionReference
        .where('id', isEqualTo: widget.baby)
        .where('date_', isEqualTo: widget.reportdate_)
        .where('photostatus_',isEqualTo: 'New'):
    (role_ == "Principal")?   condition = collectionReference
        .where('id', isEqualTo: widget.baby)
        .where('date_', isEqualTo: widget.reportdate_)
        .where('photostatus_',isEqualTo: 'Forwarded')
        :condition = collectionReference
        .where('id', isEqualTo: widget.baby)
    // .where('date_', isEqualTo: widget.reportdate_)
        .where('photostatus_', whereIn: ['New','Forwarded'])

        : condition = collectionReference
        .where('id', isEqualTo: widget.baby)
        .where('date_', isEqualTo: widget.reportdate_)
        .where('category_', isEqualTo: widget.category)
        .where('biweeklystatus_', isEqualTo: widget.biweeklystatus_);

    return Column(
      children: [
        ParentPhotoSlideshow(fatherEmail: widget.fathersEmail_,babyId: widget.baby,
          // ActivityId: snapshot.data!.docs[index].id,
          // activity_: activityData['Activity'],
          // description_: activityData['description'],
          // subject_: activityData['Subject'],
          // image_: activityData['image_']
        ),
        (role_ == 'Principal' || role_ == 'Director'   )?
        Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded(child: Text('View:')),
            Expanded(child: Text('View:')),
            Expanded(
              child: TextButton(onPressed: () {
                setState(() {
                  ApprovedOnly = true;
                });
              }, child:  Text('Approved Only')),
            ),
            Expanded(
              child:   TextButton(onPressed: () {
                setState(() {
                  ApprovedOnly = false;
                });
              }, child:  Text('New Activities')),
            )
          ],
        )
            :Container()
        ,
        Padding(

          padding: const EdgeInsets.symmetric( horizontal: 14),
          child:
          StreamBuilder<QuerySnapshot>(
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
                return Text(
                    '${widget.subject} - record will be displayed here');
              } //EmptyBackground(title: 'Wait for activities to be updated',); }

              // Data is available, build the list
              return Container(
                width: mQ.width*0.82,
                color: Colors.blueGrey,      height: mQ.height,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final activityData = snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;

                    return
                      GestureDetector(
                        onTap: () {
                          (role_ == 'Teacher'|| role_ == 'Principal'|| role_ == 'Director')?showEditingDialog(
                              snapshot.data!.docs[index].id,
                              activityData['Activity'],
                              activityData['description'],
                              activityData['Subject'],
                              activityData['image_']):null;
                        },
                        child:
                        Container(
                          padding: EdgeInsetsDirectional.all(4),
                          width: mQ.width*0.7,
                          decoration: BoxDecoration(
                            color:
                            (activityData["photostatus_"]== "Approved")?Colors.red[50]:(activityData["photostatus_"]== "Forwarded")?Colors.blue[50]:Colors.blue[100],
                            borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 0.2,
                                blurRadius: 0.5,
                                offset: Offset(0, 3), // Add a shadow effect
                              ),
                            ],
                          ),
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color:
                                  (activityData["photostatus_"]== "Approved")?Colors.green[900]:(activityData["photostatus_"]== "Forwarded")?Colors.blue[50]:Colors.blue[900],
                                  borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 0.2,
                                      blurRadius: 0.5,
                                      offset: Offset(0, 3), // Add a shadow effect
                                    ),
                                  ],
                                ),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${activityData['Subject']} ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text('${activityData['date_']} ${activityData['time_']} ',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[200])),
                                      ),
                                    ]),
                              ),
                              Image.network(
                                  activityData['image_'],
                                  height: mQ.height * 0.28),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color:
                                  (activityData["photostatus_"]== "Approved")?Colors.green[50]:(activityData["photostatus_"]== "Forwarded")?Colors.grey[50]:Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      spreadRadius: 0.2,
                                      blurRadius: 0.5,
                                      offset: Offset(0, 3), // Add a shadow effect
                                    ),
                                  ],
                                ),

                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${activityData['Activity']} ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black)),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${activityData['photostatus_']} ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.cyan)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  '${activityData['description']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                      );},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  showEditingDialog(documentId, activity_, description, subject, image) {
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
                          Image.network(image),
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
                              Expanded(
                                child: IconButton(
                                    onPressed: () async {
                                      await confirm(
                                          title: Text("Update"),
                                          textOK: Text('Yes'),
                                          textCancel: Text('No'),
                                          context)
                                          ?
                                      await collectionReference
                                          .doc(documentId)
                                          .update({
                                        "photostatus_": 'rejected',
                                      })
                                          :null;
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(
                                      Icons.delete_outline_sharp,
                                      size: 18,
                                      // mQ.height*0.028,
                                      color: Colors.red,
                                    )),
                              ),

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

}
