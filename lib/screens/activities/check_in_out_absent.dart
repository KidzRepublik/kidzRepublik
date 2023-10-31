import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final collectionRefrenceActivity = FirebaseFirestore.instance.collection('Activity');
final collectionRefrence = FirebaseFirestore.instance.collection('BabyData');

checkInOutAbsent (checkinstatus,
collectionRefrence, snapshot, index, id, mQ){
Column(
children: [
Container(
child: (checkinstatus != 'Checked In')
?
IconButton(
onPressed: () {
// collectionRefrenceActivity
    // .add({
// "id": collectionRefrence.doc(snapshot.data!.docs[index].id,
// "Activity": "Checked In",
// "date_": DateTime.now(),
// "description": "Daily Sheet will be displayed in App, please check"
// });
// collectionRefrence.doc(BabyID_).update(
// {"checkin": "Checked In"});
},
icon: Icon(
Icons.output, size: 22,
color: Colors.green[900])
)
    : SizedBox(width: mQ.width * 0.05,)
),
],
);

}