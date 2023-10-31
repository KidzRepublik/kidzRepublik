import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

class UpdateCropController extends GetxController {
  RxString currentDate = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingInitial = true.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  TextEditingController plotNoController = TextEditingController();
  TextEditingController LandInPlotController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController landPreparationController = TextEditingController();
  TextEditingController irrigationController = TextEditingController();
  TextEditingController fertilizerQuantityController = TextEditingController();
  TextEditingController pesticidesQuantityController = TextEditingController();
  TextEditingController otherQuantityController = TextEditingController();
  TextEditingController laborExpensesController = TextEditingController();
  TextEditingController incomeProductController = TextEditingController();
  TextEditingController soldInController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  RxString priceUnitValue = ''.obs;

  RxInt seedExpenses = 0.obs;

  RxInt landPreparationPreviousExpenses = 0.obs;
  RxInt irrigationPreviousExpenses = 0.obs;
  RxInt laborPreviousExpenses = 0.obs;
  RxInt productivityPrevious = 0.obs;
  RxInt soldInPreviousExpenses = 0.obs;

  //fertilizers
  RxList<DocumentSnapshot> dropdownItemsFertilizers = <DocumentSnapshot>[].obs;
  DocumentSnapshot? selectedItemFertilizers;
  RxString fertilizerName = ''.obs;
  RxString fertilizerVariety = ''.obs;
  RxString fertilizerUnitPrice = ''.obs;
  RxString fertilizerPreviousExpenses = ''.obs;
  RxInt fertilizerInStock = 0.obs;
  RxInt fertilizerInStockOriginalValue = 0.obs;
  RxString fertilizerDocumentID = ''.obs;

  //pesticide
  RxList<DocumentSnapshot> dropdownItemsPesticide = <DocumentSnapshot>[].obs;
  DocumentSnapshot? selectedItemPesticide;
  RxString pesticideName = ''.obs;
  RxString pesticideVariety = ''.obs;
  RxString pesticideUnitPrice = ''.obs;
  RxString pesticidePreviousExpenses = ''.obs;
  RxInt pesticideInStock = 0.obs;
  RxInt pesticideOriginalValue = 0.obs;
  RxString pesticideDocumentID = ''.obs;
  RxString pesticideMeasurmentUnit = ''.obs;

  //Others
  RxList<DocumentSnapshot> dropdownItemsOthers = <DocumentSnapshot>[].obs;
  DocumentSnapshot? selectedItemOthers;
  RxString othersName = ''.obs;
  RxString othersVariety = ''.obs;
  RxString otherUnitPrice = ''.obs;
  RxString othersPreviousExpenses = ''.obs;
  RxInt othersInStock = 0.obs;
  RxInt othersOriginalValue = 0.obs;
  RxString othersDocumentID = ''.obs;
  RxString otherMeasurmentUnit = ''.obs;

  Future<void> fetchInitialCrops(String documentId) async {
    isLoadingInitial.value = true;
    try {
      DocumentSnapshot documentSnapshot = await collectionReference
          .doc(user!.uid)
          .collection('crops')
          .doc(documentId)
          .get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      currentDate.value = data['sowing_date'];
      fertilizerName.value = data['seed_name'];
      fertilizerVariety.value = data['seed_variety'];
      seedExpenses.value = data['seed_expenses'];

      plotNoController.text = data['plot_no'];
      LandInPlotController.text = data['land_in_plot'];
      quantityController.text = data['seed_quantity_used'];
      landPreparationPreviousExpenses.value = data['land_preparation_expenses'];
      irrigationPreviousExpenses.value = data['irrigation_expenses'];
      laborPreviousExpenses.value = data['labor_expenses'];
      productivityPrevious.value = data['productivity'];
      soldInPreviousExpenses.value = data['sold_in'];
      priceUnitValue.value = data['currency'];
    } catch (error) {
      print('Error fetching data: $error');
    }
    isLoadingInitial.value = false;
  }

  void updateCropFunction(BuildContext context, String documentId) {
    isLoading.value = true;

    String fertilizerSafety = fertilizerQuantityController.text.isEmpty
        ? '0'
        : fertilizerQuantityController.text;
    String pestSafety = pesticidesQuantityController.text.isEmpty
        ? '0'
        : pesticidesQuantityController.text;
    String otherSafety = otherQuantityController.text.isEmpty
        ? '0'
        : otherQuantityController.text;

    String unitfertilizerSafety =
        fertilizerUnitPrice.value.isEmpty ? '0' : fertilizerUnitPrice.value;
    String unitpestSafety =
        pesticideUnitPrice.value.isEmpty ? '0' : pesticideUnitPrice.value;
    String unitotherSafety =
        otherUnitPrice.value.isEmpty ? '0' : otherUnitPrice.value;

    int fertilizerExpenses =
        int.parse(unitfertilizerSafety) * int.parse(fertilizerSafety);

    int pesticideExpenses = int.parse(unitpestSafety) * int.parse(pestSafety);
    int otherExpenses = int.parse(unitotherSafety) * int.parse(otherSafety);

    int laborExpenses = laborExpensesController.text == ''
        ? laborPreviousExpenses.value
        : int.parse(laborExpensesController.text) + laborPreviousExpenses.value;

    int irrigationExpenses = irrigationController.text == ''
        ? irrigationPreviousExpenses.value
        : int.parse(irrigationController.text) +
            irrigationPreviousExpenses.value;

    int landExpenses = landPreparationController.text == ''
        ? landPreparationPreviousExpenses.value
        : int.parse(landPreparationController.text) +
            landPreparationPreviousExpenses.value;

    collectionReference.doc(user!.uid).collection('crops').doc(documentId).set({
      "land_preparation_expenses": landExpenses,
      "irrigation_expenses": irrigationExpenses,
      "fertilizer_name": fertilizerName.value,
      "fertilizer_variety": fertilizerVariety.value,
      "fertilizer_quantity_used": fertilizerQuantityController.text,
      "fertilizer_documentId": fertilizerDocumentID.value,
      "pesticide_name": pesticideName.value,
      "pesticide_variety": pesticideVariety.value,
      "pesticide_quantity_used": pesticidesQuantityController.text,
      "pesticide_selected_unit": pesticideMeasurmentUnit.value,
      "pesticide_documentId": pesticideDocumentID.value,
      "other_name": othersName.value,
      "other_variety": othersVariety.value,
      "other_quantity_used": otherQuantityController.text,
      "other_selected_unit": otherMeasurmentUnit.value,
      "other_documentId": othersDocumentID.value,
      "labor_expenses": laborExpenses,
      "productivity": incomeProductController.text == ''
          ? productivityPrevious.value
          : int.parse(incomeProductController.text) +
              productivityPrevious.value,
      "sold_in": soldInController.text == ''
          ? soldInPreviousExpenses.value
          : int.parse(soldInController.text) + soldInPreviousExpenses.value,
      "total_expenditure": seedExpenses.value +
          fertilizerExpenses +
          pesticideExpenses +
          otherExpenses +
          landExpenses +
          laborExpenses +
          irrigationExpenses,
      "earn_lose_value": 0,
      "fertilizer_expenses": fertilizerExpenses,
      "pesticides_expenses": pesticideExpenses,
      "other_expenses": otherExpenses,
    }, SetOptions(merge: true)).then((res) async {
      if (dropdownItemsFertilizers.isNotEmpty ||
          fertilizerName.value.isNotEmpty) {
        collectionReference
            .doc(user!.uid)
            .collection('stored_crops')
            .doc(fertilizerDocumentID.value)
            .set({
          "in_stock": fertilizerInStock.value.toString(),
        }, SetOptions(merge: true));
      }

      if (dropdownItemsPesticide.isNotEmpty || pesticideName.value.isNotEmpty) {
        collectionReference
            .doc(user!.uid)
            .collection('stored_crops')
            .doc(pesticideDocumentID.value)
            .set({
          "in_stock": pesticideInStock.value.toString(),
        }, SetOptions(merge: true));
      }

      if (dropdownItemsOthers.isNotEmpty || othersName.value.isNotEmpty) {
        collectionReference
            .doc(user!.uid)
            .collection('stored_crops')
            .doc(pesticideDocumentID.value)
            .set({
          "in_stock": othersInStock.value.toString(),
        }, SetOptions(merge: true));
      }

      isLoading.value = false;

      ToastContext().init(context);

      Toast.show(
        'Crop updated Successfully',
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

  String getCurrentDate() {
    final now = DateTime.now();
    final day =
        now.day.toString().padLeft(2, '0'); // Add leading zero if needed
    final month =
        now.month.toString().padLeft(2, '0'); // Add leading zero if needed
    final year = now.year.toString();

    return '$day/$month/$year';
  }

  void moveToRecords(BuildContext context, String documentId) {
    isLoading.value = true;

    collectionReference.doc(user!.uid).collection('crops').doc(documentId).set({
      "type": 'record',
      "harvesting_date": getCurrentDate(),
    }, SetOptions(merge: true)).then((res) async {
      isLoading.value = false;

      // ToastContext().init(Get.context!);

      // Toast.show(
      //   'updated to record Successfully',
      //   // Get.context,
      //   backgroundRadius: 5,
      //   //gravity: Toast.top,
      // );

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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //fetchData();
  }

  Future<void> fetchfertilizer() async {
    List<DocumentSnapshot> data = await getfertilizers();
    print(data);

    dropdownItemsFertilizers.value = data;
    print(dropdownItemsFertilizers.length);

    print(dropdownItemsFertilizers);
    // Set the initial selected item to the first item in the list, if it's not empty
    if (dropdownItemsFertilizers.isNotEmpty) {
      selectedItemFertilizers = dropdownItemsFertilizers[0];
      fertilizerVariety.value = dropdownItemsFertilizers[0]['subtitle'];
      fertilizerUnitPrice.value = dropdownItemsFertilizers[0]['price_per_kg'];

      fertilizerName.value = dropdownItemsFertilizers[0]['name'];
      fertilizerInStock.value =
          int.parse(dropdownItemsFertilizers[0]['in_stock']);
      fertilizerInStockOriginalValue.value =
          int.parse(dropdownItemsFertilizers[0]['in_stock']);

      fertilizerDocumentID.value = dropdownItemsFertilizers[0].id.toString();
    }
    isLoadingInitial.value = false;
  }

  Future<List<DocumentSnapshot>> getfertilizers() async {
    QuerySnapshot querySnapshot = await collectionReference
        .doc(user!.uid)
        .collection('stored_crops')
        .where('type', isEqualTo: 'fertilizer')
        .get();
    return querySnapshot.docs;
  }

  //pesticides
  Future<void> fetchpesticides() async {
    List<DocumentSnapshot> data = await getpesticides();
    print(data);

    dropdownItemsPesticide.value = data;
    print(dropdownItemsPesticide.length);

    // Set the initial selected item to the first item in the list, if it's not empty
    if (dropdownItemsPesticide.isNotEmpty) {
      selectedItemPesticide = dropdownItemsPesticide[0];
      pesticideVariety.value = dropdownItemsPesticide[0]['subtitle'];
      pesticideUnitPrice.value = dropdownItemsPesticide[0]['price_per_kg'];

      pesticideName.value = dropdownItemsPesticide[0]['name'];
      pesticideInStock.value = int.parse(dropdownItemsPesticide[0]['in_stock']);
      pesticideOriginalValue.value =
          int.parse(dropdownItemsPesticide[0]['in_stock']);

      pesticideMeasurmentUnit.value =
          dropdownItemsPesticide[0]['selected_unit'];

      pesticideDocumentID.value = dropdownItemsPesticide[0].id.toString();
    }
    isLoadingInitial.value = false;
  }

  Future<List<DocumentSnapshot>> getpesticides() async {
    QuerySnapshot querySnapshot = await collectionReference
        .doc(user!.uid)
        .collection('stored_crops')
        .where('type', isEqualTo: 'pesticide')
        .get();
    return querySnapshot.docs;
  }

  //Others
  Future<void> fetchOthers() async {
    List<DocumentSnapshot> data = await getOthers();
    print(data);

    dropdownItemsOthers.value = data;
    print(dropdownItemsOthers.length);

    // Set the initial selected item to the first item in the list, if it's not empty
    if (dropdownItemsOthers.isNotEmpty) {
      selectedItemOthers = dropdownItemsOthers[0];
      othersVariety.value = dropdownItemsOthers[0]['subtitle'];
      otherUnitPrice.value = dropdownItemsOthers[0]['price_per_kg'];

      othersName.value = dropdownItemsOthers[0]['name'];
      othersInStock.value = int.parse(dropdownItemsOthers[0]['in_stock']);
      othersOriginalValue.value = int.parse(dropdownItemsOthers[0]['in_stock']);

      othersDocumentID.value = dropdownItemsOthers[0].id.toString();
      otherMeasurmentUnit.value = dropdownItemsOthers[0]['selected_unit'];
    }
    isLoadingInitial.value = false;
  }

  Future<List<DocumentSnapshot>> getOthers() async {
    QuerySnapshot querySnapshot = await collectionReference
        .doc(user!.uid)
        .collection('stored_crops')
        .where('type', isEqualTo: 'others')
        .get();
    return querySnapshot.docs;
  }
}
