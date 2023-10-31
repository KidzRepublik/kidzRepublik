import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/screens/main_tabs.dart';
import 'package:toast/toast.dart';

    // Obx(
    //                             () => DropdownButton<String>(
    //                               value:
    //                                   signUpController.selectedLandUnit.value,
    //                               onChanged: (newValue) {
    //                                 signUpController.selectedLandUnit.value =
    //                                     newValue!;
    //                               },
    //                               underline: Container(), // Hide the underline
    //                               items: signUpController.landUnitOptions
    //                                   .map((option) {
    //                                 return DropdownMenuItem<String>(
    //                                   value: option,
    //                                   child: Text(option),
    //                                 );
    //                               }).toList(),
    //                               style: TextStyle(color: Colors.black54),
    //                             ),
    //                           ),

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('users');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // TextEditingController LandInPlotControllerAcre = TextEditingController();

  // TextEditingController LandInPlotControllerKanal = TextEditingController();
  // TextEditingController LandInPlotControllerMarla = TextEditingController();

  // RxString selectedLandUnit = 'Acre'.obs;
  // List<String> landUnitOptions = ['Acre', 'kanal', 'Marla'];

  void signupUser(BuildContext context) {
    if (formKey.currentState!.validate()) {
        firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((result) {
          List<String> splitList = nameController.text.split(' ');
          List<String> indexList = [];

          for (int i = 0; i < splitList.length; i++) {
            for (int j = 1; j < splitList[i].length + 1; j++) {
              print(splitList);
              indexList.add(splitList[i].substring(0, j).toLowerCase());
              print(indexList);
            }
          }

          // collectionReferenceUser.doc(result.user!.uid).set({
          collectionReferenceUser.doc(result.user!.email).set({
            "id": emailController.text,
            "status": '',
            "role": '',
            "email": emailController.text,
            "password": passwordController.text,
            "full_name": nameController.text,
            "contact_number": phoneController.text,
            "userImage":
          "https://firebasestorage.googleapis.com/v0/b/kids-republik-e8265.appspot.com/o/images%2Fnullpicturenew.png?alt=media&token=a723ae08-0bd8-45a1-9b44-e5b51f7d647e",
            "searchIndex": indexList,
          }).then((res) async {
            isLoading.value = false;

            ToastContext().init(context);

            Toast.show(
              'Account Created Successfully',
              // Get.context,
              backgroundRadius: 5,
              //gravity: Toast.top,
            );

            Get.to(MainTabs());
          });
        }).catchError((err) {
          isLoading.value = false;

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('Oops'),
                  ),
                  content: Text(err.message),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: false,
                      child: const Column(
                        children: <Widget>[
                          Text('Cancel'),
                        ],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
        });
      }
    }
  }

