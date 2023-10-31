import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/controllers/consent_controllers/add_new_consent_controller.dart';
import 'package:kids_republik/utils/getdatefunction.dart';
import 'package:toast/toast.dart';
import '../../main.dart';
import '../../utils/const.dart';
import '../../utils/image_slide_show.dart';
import '../kids/widgets/custom_textfield.dart';
import '../widgets/primary_button.dart';

var dropdownValueClasses = classes_.first;
class SendReminderToParent extends StatefulWidget {
  String consent_heading;
  String consent_statement;
  SendReminderToParent(this.consent_heading, this.consent_statement, { super.key});

  @override
  State<SendReminderToParent> createState() => _SendReminderToParentState();

}

class _SendReminderToParentState extends State<SendReminderToParent> {

  AddNewConsentController addNewConsentController = Get.put(AddNewConsentController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController heading_text_controller =
    TextEditingController(text: widget.consent_heading);
    TextEditingController statement_text_controller =
    TextEditingController(text: widget.consent_statement);
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhite),
        title: Text(
          'Consent Statements',
          style: TextStyle(color: kWhite),
        ),
        backgroundColor: kprimary,
      ),
      // bottomNavigationBar: MainTabsBottomNavigation(),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageSlideShowfunction(context),
          Padding(
            padding: const EdgeInsets.only(right: 8.0,left: 8),
            child: Column(
              children: [
                SizedBox(height: 3,),
                Container(
                  height: mQ.height * 0.03,
                  color: Colors.grey[50],
                  width: mQ.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          'Require parents consent',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      Expanded(
                        child: Text(textAlign: TextAlign.right,
                          ' ${addNewConsentController.currentDate.value}',
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

                SizedBox(height: 3,),
                // Obx(
                //       () => addNewConsentController.isLoadingInitial.value
                //       ? Center(child: CircularProgressIndicator())
                //       :
                SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButtonFormField(
                            value: dropdownValueClasses,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValueClasses = value!;
                              });
                            },
                            items: classes_.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          PopupMenuButton<String>(
                            // Generate the menu items from the list
                            itemBuilder: (BuildContext context) {
                              return classes_.map((String item) {
                                return PopupMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList();
                            },
                            onSelected: (String selectedItem) {
                              // Handle the selected item
                              print('Selected: $selectedItem');
                            },
                          ),
                          CustomTextField(
                            enabled: true,
                            controller: heading_text_controller,
                            inputType: TextInputType.text,
                            labelText: "Heading",
                            validators: (String? value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: mQ.height * 0.02,
                          ),
                          CustomTextField(
                            enabled: true,
                            controller: statement_text_controller,
                            inputType: TextInputType.text,
                            labelText: "Consent Statement",
                            validators: (String? value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: mQ.height * 0.005,
                          ),
                          Obx(
                                () => addNewConsentController.isLoading.value
                                ? Center(child: const CircularProgressIndicator())
                                : SizedBox(
                              width: mQ.width * 0.85,
                              height: mQ.height * 0.065,
                              child: PrimaryButton(
                                onPressed: () {
                                  // addNewConsentController.isLoading.value = true;
                                  addConsentStatementToClass(dropdownValueClasses, heading_text_controller, statement_text_controller);
                                   // getStudentsByClass(dropdownValueClasses);
                                  // try {
                                  //   collectionRefrenceActivity.add(
                                  //       {'child_': ' ',
                                  //         'title_': activity_text_controller.text,
                                  //         'description_': description_text_controller.text,
                                  //         'date_': getCurrentDate(),
                                  //         'result_': 'Waiting',
                                  //         'category_': 'Consent',
                                  //         'parentid_': ''
                                  //       });
                                  // } catch (error) {
                                  //   print('Error fetching data: $error');
                                  // }
                                  // addNewConsentController.isLoading.value = false;
                                  Toast.show('Record added successfully',backgroundColor: Colors.black12,duration: 10 );
                                  Get.back();

                                  // addNewConsentController.addActivityfunction(
                                  //     context);
                                },
                                label: "Save",
                                elevation: 3,
                                bgColor: kprimary,
                                labelStyle: kTextPrimaryButton.copyWith(
                                    fontWeight: FontWeight.w500),
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<List<DocumentSnapshot>> getStudentsByClass(String className) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('BabyData')
        .where('class_', isEqualTo: className)
        .get();
    return querySnapshot.docs;
  }
  Future<void> addConsentStatementToClass(className,heading,statement) async {
    List<DocumentSnapshot> students = await getStudentsByClass(className);
    CollectionReference consentCollection = FirebaseFirestore.instance.collection('Activity');

    students.forEach((student) async {
      String studentid = student.id;
      String fathersEmail = student['fathersEmail'];

      // Create a new document for each student in the class collection
      await consentCollection.add({
        'child_': studentid,
        'parentid_': fathersEmail,
        'title_': heading,
        'description_': statement,
        'date_': getCurrentDate(),
        'result_': 'Waiting',
        'category_': 'Consent'
      });
    });   // List<DocumentSnapshot> parents = await getStudentsByClass(className);
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('BabyData')
    //     .where('class_', isEqualTo: className)
    //     .get();
        // .doc(className).collection('students');

    // querySnapshot.forEach((parents) async {
    //   await consentCollection.add({
    //   });
    // });
  }

}
