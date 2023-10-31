import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/screens/auth/login.dart';
import 'package:kids_republik/screens/main_tabs.dart';

class SplashController extends GetxController {
  final isLogged = false.obs;
  RxString name = ''.obs;
  RxString email = ''.obs;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void onInit() {
    Future.delayed(Duration(seconds: 2)).then((val) {
      pickInitialdata();
    });
    super.onInit();
  }

  Future pickInitialdata() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.delayed(Duration(seconds: 2)).then((val) {
        Get.off(LoginScreen());
      });
      // Get.offAndToNamed(AppRoutes.home);
    } else {
      try {
        DocumentSnapshot userSnapshot =
            await usersCollection.doc(user.email).get();
        if (userSnapshot.exists) {
          name.value = userSnapshot['full_name'] ?? '';
          email.value = userSnapshot['email'] ?? '';
          useremail = userSnapshot['email'] ?? '';
         role_ = userSnapshot['role'];
          userImage_ = userSnapshot['userImage'];
          teachersClass_ = userSnapshot['class'];
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }

      Get.off(MainTabs());
    }
  }
}
