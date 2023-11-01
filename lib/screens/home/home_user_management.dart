import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/main.dart';
import 'package:kids_republik/screens/auth/signup.dart';
import 'package:kids_republik/screens/kids/widgets/empty_background.dart';
import 'package:kids_republik/screens/widgets/base_drawer.dart';
import 'package:kids_republik/utils/const.dart';
import 'package:kids_republik/utils/getdatefunction.dart';
import 'package:kids_republik/utils/image_slide_show.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final collectionRefrence = FirebaseFirestore.instance.collection('users');
  bool deleteionLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  // UpdateClassController updateCropController = Get.put(UpdateClassController());

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: Colors.blue[50],
      // drawer: BaseDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhite),
        title: Text(
          'User Management',
          style: TextStyle(color: kWhite,fontSize: 14),
        ),
        backgroundColor: kprimary,
      ),
      floatingActionButton:FloatingActionButton(onPressed: () {
        Get.to(SignUpScreen());
      },
      // backgroundColor: Colors.transparent,
          child:
      Container(
        width: mQ.width*0.13,decoration: BoxDecoration(

        ),
        child: Center(
          child:
            Icon(
              Icons.add,
              size: 22,
              color: kprimary,
            ),
          ),
        // ),
      )),

      body: SingleChildScrollView(
          child: Column(
        children: [
        ImageSlideShowfunction(context),
          Container(
            height: mQ.height * 0.03,
            color: Colors.grey[50],
            width: mQ.width * 0.95,
            // padding:mQ ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'List of Users',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    ' ${getCurrentDateforattendance()}',
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Comic Sans MS',
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 14),
            child: StreamBuilder<QuerySnapshot>(
              stream: (role_ == 'Director')?collectionRefrence
                  .snapshots()
                  :collectionRefrence
                  .where('role', whereIn: ['Manager','Teacher','Parent'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: CircularProgressIndicator(),
                    ),
                  ); // Show loading indicator
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));

                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return EmptyBackground(
                    title: 'Click on + button to Add User',
                  ); // No data
                }

                // Data is available, build the list
                return ListView.builder(
                  // separatorBuilder: (context, index) {
                  //   return Divider(
                  //     color: Colors.grey.withOpacity(0.2),
                  //   );
                  // },
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final userData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: mQ.width*0.0051),
                      child: Container(
                        height: mQ.height*0.1,
                        decoration: BoxDecoration(
                          color:
                          Colors.grey[50],
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

                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (userData['userImage'] == Null)?
                                Image.asset(
                                  'assets/staff.jpg',
                                  //color: kprimary,
                                  width: mQ.width * 0.1,
                                  fit: BoxFit.contain,
                                )
                                    :
                                Image.network(userData['userImage'],
                                  width: mQ.width * 0.1,
                                  fit: BoxFit.contain,
                                ),

                                SizedBox(
                                  width: mQ.width*0.0005,
                                ),
                                Expanded(
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${userData['full_name']}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87.withOpacity(0.7),
                                              fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 6.0),
                                        child: Container(
                                          height: 6,
                                          width: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (userData['status'] == 'Activate')?Colors.green[300]:Colors.red[300],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${userData['role']}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.7,
                                            color: Colors.black87.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${userData['email']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color:
                                                    Colors.grey,
                                                fontSize: 10),
                                          ),
                                          Text(
                                            "${userData['contact_number']}",
                                            style: TextStyle(
                                              fontSize: 10,
                                              letterSpacing: 0.7,
                                              color:Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        Container(color: Colors.blueGrey[50],height: mQ.height*0.051,
                          child: Column(
                            children: [
                        Text('Tap on Role to Assign',style: TextStyle(fontSize: 10),),
                          Container(height: mQ.height*0.0345,child:
                          (role_!="Principal")?
                          _showActionSheet(
                                context,
                                "${userData['full_name']} - ${userData['email']}",
                                snapshot.data!.docs[index].id,
                                userData['role'],mQ
                                // title1:
                                //       "${userData['full_name']} / ${userData['email']}",
                              ):null,)
                            ],
                          ),
                        ),

                        ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: mQ.height * 0.08,
          ),
        ],
      )),
    );
  }

  Widget _showActionSheet(
    BuildContext context,
    String title,
    String documentId,
  var title1,mQ

  ) {
    return Row(
          children: [
            (role_=="Director")?
            Expanded(child: TextButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"role": "Principal" }):null;},   child: Text('Principal',style: TextStyle(fontSize: mQ.height*0.012),),)):Container(),
            Expanded(child: TextButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"role": "Manager" }):null;;},   child: Text('Manager',style: TextStyle(fontSize: mQ.height*0.012)),      )),
            Expanded(child: TextButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"role": "Teacher" }):null;;},   child: Text('Teacher',style: TextStyle(fontSize: mQ.height*0.012)),      )),
            Expanded(child: TextButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"role": "Parent" }):null;;},   child: Text('Parent',style: TextStyle(fontSize: mQ.height*0.012)),      )),
            IconButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"status": "Activate" }):null;;},   icon: Icon(Icons.verified_user_outlined,size: 18,color: CupertinoColors.systemGreen,), tooltip: 'Activate'),
            IconButton(onPressed: () async {await confirm(context)?collectionRefrence.doc(documentId).update({"status": "Block" }):null; ;},   icon: Icon(Icons.app_blocking_sharp,size: 18,color: Colors.red),tooltip: 'Block'     ),

          ],
        );

  }


}
