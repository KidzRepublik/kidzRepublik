// import 'dart:html';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kids_republik/screens/kids/widgets/custom_textfield.dart';
// import 'package:kids_republik/screens/widgets/primary_button.dart';
// import 'package:kids_republik/utils/const.dart';
// import 'package:toast/toast.dart';
//
// class UpdateClassScreen extends StatefulWidget {
//   final String documentId;
//   UpdateClassScreen({super.key, required this.documentId});
//
//   @override
//   State<UpdateClassScreen> createState() => _UpdateClassScreenState();
// }
//
// class _UpdateClassScreenState extends State<UpdateClassScreen> {
//   UpdateClassController updateClassController =
//       Get.put(UpdateClassController());
//   // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   // CollectionReference collectionReference = FirebaseFirestore.instance.collection('BabyData');
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //this.childId = widget.documentId;
//
//     // updateClassController.fetchInitialCrops(widget.documentId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mQ = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: kWhite),
//         title: Text(
//           'Update Class',
//           style: TextStyle(color: kWhite),
//         ),
//         backgroundColor: kprimary,
//         actions: [
//           TextButton(
//             onPressed: () {
//               updateClassController.isLoading.value = false;
//             },
//             child: Text(
//               'abc',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       body: Obx(
//         () => updateClassController.isLoadingInitial.value
//             ? Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 14.0, horizontal: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: mQ.height * 0.03,
//                       ),
//                       ClassDropDown(),
//                       SizedBox(
//                         height: mQ.height * 0.065,
//                       ),
//                       Obx(
//                         () =>// updateClassController.isLoading.value ?
//                              // Center(child: const CircularProgressIndicator())
//                             // :
//                         SizedBox(
//                                 width: mQ.width * 0.85,
//                                 height: mQ.height * 0.065,
//                                 child: PrimaryButton(
//                                   onPressed: () {
//                                     // CollectionReference collectionReference = CollectionReference("BabyData");
//                                     // collectionReference.doc(documentId).set({
//                                       // collectionReference.doc(user!.uid).collection('crops').doc(documentId).set({
//                                       // "class_": updateClassController.fetchInitialClass(documentId),
//                                     // }, SetOptions(merge: true));
//
//                                     // updateClassController.updateCropFunction(
//                                     //     context, widget.documentId);
//                                   },
//                                   label: "Save",
//                                   elevation: 3,
//                                   bgColor: kprimary,
//                                   labelStyle: kTextPrimaryButton.copyWith(
//                                       fontWeight: FontWeight.w500),
//                                   borderRadius: BorderRadius.circular(22.0),
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//
//     Get.delete<UpdateClassController>();
//   }
// }
