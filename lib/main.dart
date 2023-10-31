import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/firebase_options.dart';
import 'package:kids_republik/screens/splash.dart';
String? role_ = '';
String? useremail ;
String? userImage_ ;
String? teachersClass_ = '';
bool isloadingDate = false;
bool isloadingBiweekly = true;
RxBool isloadingPage = true.obs;
String? imageUrl ;
// "https://firebasestorage.googleapis.com/v0/b/kids-republik-e8265.appspot.com/o/images%2Fnullpicturenew.png?alt=media&token=a723ae08-0bd8-45a1-9b44-e5b51f7d647e";
final classes_  =<String> [ 'Select class', 'Infant', 'Todler', 'Kinder Garten - I', 'Kinder Garten - II', 'Play Group - I', 'Delete', 'Update'];
String? sleeptime_ = '${TimeOfDay.now().hour} : ${TimeOfDay.now().minute}';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kidz Republik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent).copyWith(background: Colors.blue[50]),
      ),
      home:  SplashScreen (),
    );
  }
}
