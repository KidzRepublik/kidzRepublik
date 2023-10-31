import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
class Activities {
   void checkIn2() {
    final collectionofBabyID = FirebaseFirestore.instance.collection(
        'BabyData');
    final data = collectionofBabyID
// .where(id = BabyID)
        .doc().get();
        // .doc(BabyID).get();
// BabyID = "${doc.id}";
    print("${collectionofBabyID.id} => ${data}");
    return ;
  }

  Future checkIn() async {
    final collectionofBabyID = FirebaseFirestore.instance.collection('BabyData');
    final data = await collectionofBabyID
    // .where(id = BabyID)
        .doc().get();
        // .doc(BabyID).get();
    // BabyID = "${doc.id}";
    print("${collectionofBabyID.id} => ${data}");
  }


  Future<void> showbabydata() async {
    // FirebaseFirestore db = FirebaseFirestore.instance;
    if (role_ == 'Teacher')
      {
        switch (teachersClass_) {
          case 'Infant':
            AlertDialog(title: Text('Infant'),);
            // Get.to(InfantClassScreen());
          case 'Todlers':
            // Get.to(TodlerClassScreen());
          case 'Play Group - I':
            // Get.to(PlayGroupIClassScreen());
          case 'Kinder Garten - I':
            // Get.to(KinderGartenIClassScreen());
          case 'Kinder Garten - II':
            // Get.to(KinderGartenIIClassScreen());
          default:
            // Text(teachersClass_!);
            // Text(role!);
            // Text(role as String);
            // Text(teachersClass_ as String);
            // await db.collection("users").get().then((event) {
            //   for (var doc in event.docs) {
            //     print("${doc.id} => ${doc.data()}");
            //   }
            // });
        }
      }
    }
  }

