import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_republik/controllers/add_child_controller.dart';
import 'package:kids_republik/screens/kids/widgets/custom_textfield.dart';
import 'package:kids_republik/screens/widgets/primary_button.dart';
import 'package:kids_republik/utils/const.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  AddChildController addChildController = Get.put(AddChildController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addChildController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kWhite),
        title: Text(
          'Add Child',
          style: TextStyle(color: kWhite),
        ),
        backgroundColor: kprimary,
      ),
      body:
    // Obx(
    //     () => addChildController.isLoadingInitial.value
    //         ? Center(child: CircularProgressIndicator())
    //         : addChildController.dropdownItems.isEmpty
    //             ? EmptyBackground(
    //                 title: 'Nothing Found Go classes To Add class',
    //               )
    //             :
        SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 15),
                      child: Form(
                        key: addChildController.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: mQ.height * 0.03,
                            ),
                            CustomTextField(
                              controller: addChildController.childFullName,
                              inputType: TextInputType.text,
                              labelText: "Enter Name ",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Age",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: addChildController
                                        .ChildAgeYears,
                                    inputType: TextInputType.number,
                                    labelText: "Year",
                                  ),
                                ),
                                SizedBox(
                                  height: mQ.height * 0.028,
                                ),
                                Expanded(
                                  child: CustomTextField(
                                    controller: addChildController
                                        .ChildAgeMonths,
                                    inputType: TextInputType.number,
                                    labelText: "Month",
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: CustomTextField(
                                    controller: addChildController
                                        .ChildAgeDays,
                                    inputType: TextInputType.number,
                                    labelText: "Days",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    addChildController.selectDate(context);
                                  },
                                  child: Text(
                                    'Admission Date: ${addChildController.currentDate.value}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            // Obx(
                            //   () => Row(
                            //     children: [
                            //       DropdownButton<DocumentSnapshot>(
                            //         value: addChildController.selectedItem,
                            //         onChanged: (DocumentSnapshot? newValue) {
                            //           addChildController.selectedItem =
                            //               newValue!;
                            //           addChildController.seedName.value =
                            //               newValue['name'];
                            //           addChildController.seedVariety.value =
                            //               newValue['subtitle'];
                            //
                            //           addChildController.seedUnitPrice.value =
                            //               newValue['price_per_kg'];
                            //           addChildController.seedInStock.value =
                            //               int.parse(newValue['in_stock']);
                            //           addChildController
                            //                   .seedInStockOriginalValue.value =
                            //               int.parse(newValue['in_stock']);
                            //           addChildController.seedUnitValuePrice
                            //               .value = newValue['currency'];
                            //
                            //           setState(() {
                            //             addChildController
                            //                 .ChildGender.text = '';
                            //           });
                            //
                            //           addChildController.seedDocumentID.value =
                            //               newValue.id.toString();
                            //         },
                            //         underline:
                            //             Container(), // Hide the underline
                            //
                            //         items: addChildController.dropdownItems
                            //             .map((DocumentSnapshot item) {
                            //           return DropdownMenuItem<DocumentSnapshot>(
                            //             value: item,
                            //             child: Text(
                            //               item['name'],
                            //               style: TextStyle(
                            //                   color: Colors.black,
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 16),
                            //             ), // Replace 'name' with the field you want to display
                            //           );
                            //         }).toList(),
                            //       ),
                            //       SizedBox(
                            //         width: 16,
                            //       ),
                            //       Text(
                            //         addChildController.seedVariety.value,
                            //         style: TextStyle(
                            //             color: Colors.black54,
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 16),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Obx(
                            //   () => Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Text(
                            //         "Available In Stock: ${addChildController.seedInStock.value} Kg",
                            //         style: TextStyle(
                            //             color: Colors.black54,
                            //             fontWeight: FontWeight.w400,
                            //             fontSize: 14),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // CustomTextField(
                            //   onChanged: (value) {
                            //     if (value.isNotEmpty) {
                            //       print(addChildController.seedInStock.value);
                            //       print(int.parse(value));
                            //       addChildController.seedInStock.value =
                            //           addChildController
                            //                   .seedInStockOriginalValue.value -
                            //               int.parse(value);
                            //       if (addChildController.seedInStock.value < 1) {
                            //         setState(() {
                            //           addChildController
                            //               .ChildGender.text = '';
                            //         });
                            //         addChildController.seedInStock.value =
                            //             addChildController
                            //                 .seedInStockOriginalValue.value;
                            //
                            //         ToastContext().init(context);
                            //
                            //         Toast.show(
                            //           'Out of Stock',
                            //           // Get.context,
                            //           backgroundRadius: 5,
                            //           //gravity: Toast.top,
                            //         );
                            //       }
                            //     } else {
                            //       setState(() {
                            //         addChildController.seedInStock.value =
                            //             addChildController
                            //                 .seedInStockOriginalValue.value;
                            //       });
                            //     }
                            //   },
                            //   controller: addChildController.ChildGender,
                            //   inputType: TextInputType.number,
                            //   labelText: "Quantity Being Used/زىر استمال مقدأر",
                            //   validators: (String? value) {
                            //     if (value!.isEmpty) {
                            //       return 'Required';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Fathers Info",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.fathersName,
                              inputType: TextInputType.text,
                              labelText:
                                  "Fathers Name",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.065,
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.fMobileNo,
                              inputType: TextInputType.number,
                              labelText:
                                  "Father's Mobile No",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.fathersEmail,
                              inputType: TextInputType.emailAddress,
                              labelText:
                                  "Father Email",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            CustomTextField(
                              controller:
                              addChildController.fathersOccupation,
                              inputType: TextInputType.text,
                              labelText:
                              "Father Occupation",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            CustomTextField(
                              controller:
                              addChildController.workPhoneNo,
                              inputType: TextInputType.phone,
                              labelText:
                              "Work Phone No",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            CustomTextField(
                              controller:
                              addChildController.employer,
                              inputType: TextInputType.text,
                              labelText:
                              "Employer",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.028,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Contact Info",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.address1,
                              inputType: TextInputType.text,
                              labelText:
                                  "Address 1",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.065,
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.address2,
                              inputType: TextInputType.text,
                              labelText:
                                  "Address 2",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              controller:
                                  addChildController.picture,
                              inputType: TextInputType.text,
                              labelText:
                                  "Picture",
                              validators: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mQ.height * 0.065,
                            ),
                            Obx(
                              () => addChildController.isLoading.value
                                  ? Center(
                                      child: const CircularProgressIndicator())
                                  : SizedBox(
                                      width: mQ.width * 0.85,
                                      height: mQ.height * 0.065,
                                      child: PrimaryButton(
                                        onPressed: () {
                                          addChildController
                                              .addChildFunction(context);
                                        },
                                        label: "Save",
                                        elevation: 3,
                                        bgColor: kprimary,
                                        labelStyle: kTextPrimaryButton.copyWith(
                                            fontWeight: FontWeight.w500),
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      // ),
    );
  }
}
