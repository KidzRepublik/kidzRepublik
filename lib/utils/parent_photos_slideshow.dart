import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/utils/const.dart';
final collectionReference = FirebaseFirestore.instance.collection('BabyData');
final collectionReferenceActivity = FirebaseFirestore.instance.collection('BabyData');

class ParentPhotoSlideshow extends StatefulWidget {
  String? fatherEmail;
  String? babyId;
  String? ActivityId;
  String? activity_;
  String? description_;
  String? subject_;
  String? image_;
  ParentPhotoSlideshow({
    required this.fatherEmail,required this.babyId,
    this. ActivityId, this.activity_, this.description_, this.subject_, this.image_,
  });

  @override
  _ParentPhotoSlideshowState createState() => _ParentPhotoSlideshowState();
}

class _ParentPhotoSlideshowState extends State<ParentPhotoSlideshow> {
  List<Map<String, dynamic>>? activityPhotos;
  bool deleteionLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // fetchApprovedActivityPhotos(widget.fatherEmail).then((photos) {
if(role_ == "Parent")
  setState(() {
widget.fatherEmail = useremail;
fetchChildrenForUser().then((photos) {
  setState(() {
    activityPhotos = photos;
  });
});
  });
    if(role_ != "Parent")
fetchChildrenForSchool().then((photos) {
  setState(() {
    activityPhotos = photos;
  });
});
//   setState(() {
// widget.fatherEmail = useremail;
//   });
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return
      (role_ == 'Parent')?Scaffold(
        appBar: AppBar(title: Text('MyKidz',style: TextStyle(fontSize: 14,color: Colors.white),),backgroundColor: kprimary),
body:
(activityPhotos == null)?Column(
  children: [
    SizedBox(height: mQ.height*0.3,),
    Center(child: Text('No Approved Photos')),
    // Center(child: CircularProgressIndicator(),),
  ],
):
CarouselSlider(
  items: activityPhotos!
      .map((photo)
  {   return Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(height: mQ.height*0.003,),
      Container(
        width: mQ.width,
        height: mQ.height*0.035,
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 0.7,
              blurRadius: 0.9,
              offset: Offset(0, 3), // Add a shadow effect
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: Text(photo['Activity'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.indigo),)),
            (role_ != 'Parent')? Expanded(child: Text(photo['photostatus_'],style: TextStyle(
              color:
              (photo["photostatus_"]== "Approved")?Colors.green:(photo["photostatus_"]== "Forwarded")?Colors.blue[150]:Colors.blue[200],
            ),textAlign: TextAlign.right,)):Expanded(child: Text(photo['date_'],textAlign: TextAlign.right,style: TextStyle(color: Colors.grey,fontSize: 10),)),
          ],
        ),
      ),
      SizedBox(height: mQ.height*0.003,),
      Image.network(photo['image_'],width:mQ.width
        ,
        // width: mQ.width*0.9,
      ),
      SizedBox(height: mQ.height*0.003,),
      Container(
        width: mQ.width,
        height: mQ.height*0.04,
        decoration: BoxDecoration(
          color:
          Colors.grey.shade50,
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
        // Row(
        //   children: [
            // Expanded(child: Text(photo['Activity'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.indigo),)),
            // (role_ != 'Parent')? Expanded(child: Text(photo['photostatus_'],style: TextStyle(
            //   color:
            //   (photo["photostatus_"]== "Approved")?Colors.green:(photo["photostatus_"]== "Forwarded")?Colors.blue[150]:Colors.blue[200],
            // ),textAlign: TextAlign.right,)):Expanded(child: Text(photo['date_'],textAlign: TextAlign.right,style: TextStyle(color: Colors.grey,fontSize: 10),)),
      Text(photo['description'],textAlign: TextAlign.justify,style: TextStyle(color: Colors.grey,fontSize: 12)),
          // ],
        // ),
      ),
      SizedBox(height: mQ.height*0.003,),

    ],
  );}
  )
      .toList(),
  options: CarouselOptions(
    height:
    (role_ == 'Parent')?
    mQ.height*0.75:   mQ.height*0.3,
    // aspectRatio: 16 / 9,
    enlargeCenterPage: true,
    enableInfiniteScroll: false,
  ),
)

      ):
      (activityPhotos == null)?Column(
        children: [
          SizedBox(height: mQ.height*0.3,),
          Center(child: Text('No Approved Photos')),
          // Center(child: CircularProgressIndicator(),),
        ],
      ):
      CarouselSlider(
        items: activityPhotos!
            .map((photo)
        {   return Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: mQ.height*0.003,),
            Container(
              width: mQ.width,
              // height: mQ.height*0.035,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0.7,
                    blurRadius: 0.9,
                    offset: Offset(0, 3), // Add a shadow effect
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: Text(photo['Activity'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.indigo),)),
                  (role_ != 'Parent')? Expanded(child: Text(photo['photostatus_'],style: TextStyle(
                    color:
                    (photo["photostatus_"]== "Approved")?Colors.green:(photo["photostatus_"]== "Forwarded")?Colors.blue[150]:Colors.blue[200],
                  ),textAlign: TextAlign.right,)):Expanded(child: Text(photo['date_'],textAlign: TextAlign.right,style: TextStyle(color: Colors.grey,fontSize: 10),)),
                ],
              ),
            ),
            Container(
              width: mQ.width,
                decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(5), // Apply rounded corners if desired
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0.7,
                    blurRadius: 0.9,
                    offset: Offset(0, 3), // Add a shadow effect
                  ),
                ],
              ),
              child: Image.network(photo['image_'],
                // width: mQ.width,
                height: mQ.height*0.25
                ,
                // width: mQ.width*0.9,
              ),
            ),
            Container(
              width: mQ.width,
              // height: mQ.height*0.04,
              decoration: BoxDecoration(
                color:
                Colors.grey.shade50,
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
              Text(photo['description'],textAlign: TextAlign.justify,style: TextStyle(color: Colors.grey,fontSize: 12)),
            ),
          ],
        );}
        )
            .toList(),
        options: CarouselOptions(
          height: mQ.height*0.4,
          // aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
      );
/*
      Column(
          children: [
            role_=="Parent"?Column(
              children: [
                SizedBox(height: mQ.height*0.12),
                Center(child: Text('MyKidz'))
              ],
            ):Container(),
            Center(
              child:(activityPhotos == null)?Column(
                children: [
                  SizedBox(height: mQ.height*0.3,),
                  Text('No Approved Photos for today'),
                  // Center(child: CircularProgressIndicator(),),
                ],
              ):
              CarouselSlider(
                items: activityPhotos!
                    .map((photo)
                {   return Column(
                  children: [
                    Image.network(photo['image_'],height:(role_ == 'Parent')? mQ.height*0.60: mQ.height*0.20
                      ,
                      // width: mQ.width*0.9,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text(photo['Activity'])),
                        (role_ != 'Parent')? Expanded(child: Text(photo['photostatus_'],style: TextStyle(
                          color:
                            (photo["photostatus_"]== "Approved")?Colors.green:(photo["photostatus_"]== "Forwarded")?Colors.blue[150]:Colors.blue[200],
                            ),textAlign: TextAlign.right,)):Expanded(child: Text(photo['date_'],textAlign: TextAlign.right,style: TextStyle(color: Colors.grey),)),
                      ],
                    ),
                    Text(photo['description'],textAlign: TextAlign.right),
                  ],
                );}
                )
                    .toList(),
                options: CarouselOptions(
                  height:
                  (role_ == 'Parent')?
                  mQ.height*0.75:   mQ.height*0.3,
                  // aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
              )??
                  // :
                  Text('No approved activity photos found for this parent.'),
            ),
          ]
      );
*/

  }

  Future<List<Map<String, dynamic>>?> fetchChildrenForUser() async {
    try {
      // First, query the "babyData" collection to get the "babyId" for the user's children.
      final babyDataSnapshot = await FirebaseFirestore.instance
          .collection('BabyData')
          .where('fathersEmail', isEqualTo: widget.fatherEmail)
          .get();

      final babyIds = babyDataSnapshot.docs.map((doc) => doc.id).toList();

      // Now, query the "activity" collection using the babyIds to get the children's activities.
      final activitySnapshot = await FirebaseFirestore.instance
          .collection('Activity')
          .where('photostatus_', isEqualTo: 'Approved')
          .where('id', whereIn: babyIds)
          .get();

      if (activitySnapshot.docs.isNotEmpty) {
        return activitySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching children: $e');
      return null;
    }
  }
  Future<List<Map<String, dynamic>>?> fetchChildrenForSchool() async {
    try {
      final activitySnapshot = await FirebaseFirestore.instance
          .collection('Activity')
          .where('photostatus_', whereIn: ['New','Forwarded','Approved'])
          .where('id', isEqualTo: widget.babyId)
          .get();

      if (activitySnapshot.docs.isNotEmpty) {
        return activitySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching children: $e');
      return null;
    }
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

                              // IconButton(
                              //       onPressed: () {
                              //         setState(() {
                              //           deleteionLoading = true;
                              //         });
                              //         deleteDocumentFromFirestore(documentId);
                              //       },
                              //       icon: Icon(Icons.delete_outline_sharp,
                              //           size: 18, color: Colors.black)),
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
}


// Future<List<Map<String, dynamic>>?> fetchApprovedActivityPhotos(String babyid) async {
//   try {
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Activity')
//         // .where('id', isEqualTo: babyid)
//         .where('photostatus_', isEqualTo: 'Approved')
//         .get();
//
//     if (snapshot.docs.isNotEmpty) {
//       return await snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching approved activity photos: $e');
//     return null;
//   }
//
// }

