import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class AddCropController extends GetxController {
  RxString selectedLandUnit = 'Acre'.obs;
  List<String> landUnitOptions = ['Acre', 'kanal', 'Marla'];
  RxString currentDate = ''.obs;
  RxString seedName = ''.obs;
  RxString seedVariety = ''.obs;
  RxString seedUnitPrice = ''.obs;
  RxInt seedInStock = 0.obs;
  RxInt seedInStockOriginalValue = 0.obs;
  RxString seedUnitValuePrice = ''.obs;
  RxString seedDocumentID = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingInitial = true.obs;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  TextEditingController plotNoController = TextEditingController();
  TextEditingController LandInPlotControllerAcre = TextEditingController();
  TextEditingController LandInPlotControllerKanal = TextEditingController();
  TextEditingController LandInPlotControllerMarla = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController landPreparationController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  RxList<DocumentSnapshot> dropdownItems = <DocumentSnapshot>[].obs;
  DocumentSnapshot? selectedItem;

  void addCropFunction(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (LandInPlotControllerAcre.text.isEmpty &&
          LandInPlotControllerKanal.text.isEmpty &&
          LandInPlotControllerMarla.text.isEmpty) {
        ToastContext().init(context);

        Toast.show(
          'In Land In Plot/پلاٹ کا رقبہ atleast one field must be filled ',
          // Get.context,
          backgroundRadius: 5,
          duration: 3,
          //gravity: Toast.top,
        );
      } else {
        isLoading.value = true;
        var landValue = '';
        if (LandInPlotControllerAcre.text.isNotEmpty &&
            LandInPlotControllerKanal.text.isNotEmpty &&
            LandInPlotControllerMarla.text.isNotEmpty) {
          landValue =
              "${LandInPlotControllerAcre.text} Acre, ${LandInPlotControllerKanal.text} Kanal, ${LandInPlotControllerMarla.text} Marla";
        } else if (LandInPlotControllerAcre.text.isEmpty &&
            LandInPlotControllerKanal.text.isNotEmpty &&
            LandInPlotControllerMarla.text.isNotEmpty) {
          landValue =
              "${LandInPlotControllerKanal.text} Kanal, ${LandInPlotControllerMarla.text} Marla";
        } else if (LandInPlotControllerAcre.text.isEmpty &&
            LandInPlotControllerKanal.text.isEmpty &&
            LandInPlotControllerMarla.text.isNotEmpty) {
          landValue = "${LandInPlotControllerMarla.text} Marla";
        } else if (LandInPlotControllerAcre.text.isNotEmpty &&
            LandInPlotControllerKanal.text.isEmpty &&
            LandInPlotControllerMarla.text.isEmpty) {
          landValue = "${LandInPlotControllerAcre.text} Acre";
        } else if (LandInPlotControllerAcre.text.isNotEmpty &&
            LandInPlotControllerKanal.text.isEmpty &&
            LandInPlotControllerMarla.text.isNotEmpty) {
          landValue =
              "${LandInPlotControllerAcre.text} Acre, ${LandInPlotControllerMarla.text} Marla";
        } else if (LandInPlotControllerAcre.text.isEmpty &&
            LandInPlotControllerKanal.text.isNotEmpty &&
            LandInPlotControllerMarla.text.isEmpty) {
          landValue = "${LandInPlotControllerKanal.text} Kanal";
        } else if (LandInPlotControllerAcre.text.isNotEmpty &&
            LandInPlotControllerKanal.text.isNotEmpty &&
            LandInPlotControllerMarla.text.isEmpty) {
          landValue =
              "${LandInPlotControllerAcre.text} Acre, ${LandInPlotControllerKanal.text} Kanal";
        }

        collectionReference.doc(user!.uid).collection('crops').add({
          "type": 'crop',
          "plot_no": plotNoController.text,
          "land_in_plot": landValue,
          "currency": seedUnitValuePrice.value,
          "sowing_date": currentDate.value,
          "seed_name": seedName.value,
          "seed_variety": seedVariety.value,
          "seed_documentId": seedDocumentID.value,
          "seed_quantity_used": quantityController.text,
          "land_preparation_expenses":
              int.parse(landPreparationController.text),
          "seed_expenses": int.parse(quantityController.text) *
              int.parse(seedUnitPrice.value),
          "irrigation_expenses": 0,
          "fertilizer_name": "",
          "fertilizer_variety": "",
          "fertilizer_quantity_used": "",
          "fertilizer_documentId": "",
          "pesticide_name": "",
          "pesticide_variety": "",
          "pesticide_quantity_used": "",
          "pesticide_documentId": "",
          "other_name": "",
          "other_variety": "",
          "other_quantity_used": "",
          "other_documentId": "",
          "labor_expenses": 0,
          "productivity": 0,
          "sold_in": 0,
          "harvesting_date": "",
          "total_expenditure": 0,
          "earn_lose_value": 0,
          "fertilizer_expenses": 0,
          "pesticides_expenses": 0,
          "other_expenses": 0,
        }).then((res) async {
          collectionReference
              .doc(user!.uid)
              .collection('stored_crops')
              .doc(seedDocumentID.value)
              .set({
            "in_stock": seedInStock.value.toString(),
          }, SetOptions(merge: true));

          isLoading.value = false;

          ToastContext().init(context);

          Toast.show(
            'Crop added Successfully',
            // Get.context,
            backgroundRadius: 5,
            //gravity: Toast.top,
          );

          Get.back();
        }).catchError((err) {
          print(err.toString());
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    currentDate.value = getCurrentDate();
    //fetchData();
  }

  Future<void> fetchData() async {
    List<DocumentSnapshot> data = await getCollectionData();
    print(data);

    dropdownItems.value = data;
    print(dropdownItems.length);

    print(dropdownItems);
    // Set the initial selected item to the first item in the list, if it's not empty
    if (dropdownItems.isNotEmpty) {
      selectedItem = dropdownItems[0];
      seedVariety.value = dropdownItems[0]['subtitle'];
      seedUnitPrice.value = dropdownItems[0]['price_per_kg'];
      seedName.value = dropdownItems[0]['name'];
      seedInStock.value = int.parse(dropdownItems[0]['in_stock']);
      seedInStockOriginalValue.value = int.parse(dropdownItems[0]['in_stock']);
      seedDocumentID.value = dropdownItems[0].id.toString();
      seedUnitValuePrice.value = dropdownItems[0]['currency'];
    }
    isLoadingInitial.value = false;
  }

  Future<List<DocumentSnapshot>> getCollectionData() async {
    QuerySnapshot querySnapshot = await collectionReference
        .doc(user!.uid)
        .collection('stored_crops')
        .where('type', isEqualTo: 'seed')
        .get();
    return querySnapshot.docs;
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final day =
        now.day.toString().padLeft(2, '0'); // Add leading zero if needed
    final month =
        now.month.toString().padLeft(2, '0'); // Add leading zero if needed
    final year = now.year.toString();

    return '$day/$month/$year';
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month,
          now.day), // Set lastDate to the end of the current year
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      currentDate.value = '$day/$month/$year';
    }
  }
}
