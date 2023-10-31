import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:kids_republik/controllers/bi_monthly_reports/bi_monthly_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import '../../main.dart';
import '../../utils/const.dart';
import '../../utils/getdatefunction.dart';
import '../../utils/image_slide_show.dart';
import '../kids/widgets/custom_textfield.dart';

CameraDescription? firstCamera;
List<String> list = <String>[];
String? dropdownValue;

String descriptionplus = "";
double? progress;
bool timeupdated = false;
bool imageloading = false;
bool takepicture = false;
FilePicker? imagefile;
String imagefilepath = '';
var selectedTime = TimeOfDay.now();

class BiMonthlyScreen extends StatefulWidget {
  final selectedbabyid_;
  final selectedsubject_;
final babypicture_;
final name_;
  BiMonthlyScreen({this.selectedbabyid_, super.key, this.selectedsubject_, required this.babypicture_,required this.name_});

  @override
  State<BiMonthlyScreen> createState() => _BiMonthlyScreenState();
}

class _BiMonthlyScreenState extends State<BiMonthlyScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  BiMonthlyController biMonthlyController = Get.put(BiMonthlyController());
  String? babyid;
  String? subject;
  String? class_variable;
  bool imagedownloading = false;
  late File limagefile;
camerainitialize() async {
  final cameras = await availableCameras();
  firstCamera = cameras.first;
}
  @override
  void initState()  {

    super.initState();
  descriptionplus = '';
    subject = widget.selectedsubject_;
    babyid = widget.selectedbabyid_;
    biMonthlyController.currentDate.value =
        biMonthlyController.getCurrentDate();
    selectedTime = TimeOfDay.now();
    selectlist();
    (subject != 'BiWeekly')?( subject != 'Mood')? dropdownValue = list.first: null: null;
    // (subject == 'BiWeekly')? () {
      biMonthlyController.subject_.text = '';
      biMonthlyController.activity_.text = '';
    // }

  }

  @override
  void dispose() {
    takepicture = false;
    progress = 0;
    imagefilepath = '';

    biMonthlyController.description_.text = '';
    super.dispose();
    imageUrl = "";
    descriptionplus = "";
    imageloading = false;
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kWhite),
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              ' Enter ${widget.selectedsubject_} data of ${widget.name_}',
              style: TextStyle(
                  fontSize: 14, color: Colors.amberAccent),
            ),
            Container(
              width: mQ.width * 0.12,
              height: mQ.height * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      widget.babypicture_,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            ],
          ),

          backgroundColor: kprimary,
        ),
        bottomNavigationBar: Obx(
              () =>
          biMonthlyController.isLoading.value
              ? Center(child: const CircularProgressIndicator())
              : ElevatedButton(style:
                  ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: kprimary, // Set the text color
                    elevation: 3, // Set the elevation (shadow) of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), // Set the button's border radius
                    ),
                    padding: EdgeInsets.all(16),
              ),
                onPressed: () async {
                  var description = '${biMonthlyController.description_.text} ${descriptionplus}';
                (imageUrl == null)?Center(child: CircularProgressIndicator()):
                  (widget.selectedsubject_ != 'BiWeekly') ? await biMonthlyController.addActivityfunction(
                      context,
                      widget.selectedbabyid_,
                      widget.selectedsubject_,
                      dropdownValue,
                      description,
                      imageUrl,
                      sleeptime_,
                      'DailySheet'
                  ): await biMonthlyController.addActivityfunction(
                      context,
                      widget.selectedbabyid_,
                      biMonthlyController.subject_.text,
                      biMonthlyController.activity_.text,
                      description,
                      imageUrl,
                      sleeptime_,
                      'BiWeekly'
                  );
                  // Navigator.pop(context);
                },
                child: Text('Create Activity', style: TextStyle(
                    color: Colors.white,

                ),
                )),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageSlideShowfunction(context),
              Container(
                height: mQ.height * 0.03,
                color: Colors.grey[50],
                width: mQ.width * 0.9,
                // padding:mQ ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Expanded(child: SizedBox(width: mQ.width * 0.5,)),
                    Expanded(
                      child: Text(
                        '  ${subject}',
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
              ),// Activity name and date
              SizedBox(
                height: mQ.height * 0.002,
              ),

              Obx(
                    () =>
                biMonthlyController.isLoadingInitial.value
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                          ],
                        ),
                        (subject == 'Mood' || subject == 'Activity' || subject == 'Notes') ?
                        Container():
                        Container(
                          width: mQ.width * 0.9,
                          alignment: Alignment.centerLeft,
                          color: Colors.grey[50],
                          child:
                          TextButton(
                            onPressed: () async {
                              timeupdated = true;
                              final TimeOfDay? time =
                              await showTimePicker(
                                  context: context,
                                  initialTime:
                                  selectedTime ?? TimeOfDay.now(),
                                  initialEntryMode:
                                  TimePickerEntryMode.
                                  dial,
                                  orientation: Orientation.portrait,
                                  builder: (BuildContext context,
                                      Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  }
                              );
                              selectedTime = time!;
                              sleeptime_ = selectedTime as String?;
                            },
                            child: (timeupdated)
                                ? Text(textAlign: TextAlign.left,
                              'Select Time ${selectedTime.format(context)}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Comic Sans MS',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            )
                                : Text(
                              'Select Time ${selectedTime.format(context)}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Comic Sans MS',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(height: mQ.height * 0.006,),

                        (widget.selectedsubject_ == 'BiWeekly'  )?
                            Container(width: mQ.width*0.9,child: BiWeeklyDropDown(widget.selectedbabyid_,mQ)):
                        (widget.selectedsubject_ != 'Mood'  )?
                        Container(width: mQ.width * 0.9,
                            alignment: Alignment.centerLeft,
                            color: Colors.grey[50],
                            child:
                            DropdownButtonFormField(
                              padding: EdgeInsets.only(left: mQ.width * 0.02),
                              value: dropdownValue,
                              icon: const Icon(
                                  Icons.arrow_downward, color: Colors.blue),
                              elevation: 10,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Comic Sans MS',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            )): Container(),
                        SizedBox(height: mQ.height * 0.006,
                            child: Container(color: Colors.white,)),
                        Container(width: mQ.width * 0.9,
                          alignment: Alignment.centerLeft,
                          color: Colors.grey[50],
                          child:
                          CustomTextField(
                            enabled: true,
                            controller: biMonthlyController.description_,
                            inputType: TextInputType.text,
                            labelText: "Type Remarks (optional)",
                            validators: (String? value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      (subject == 'Health')
                            ? checkboxfunction(
                            context, 'Recommended to consult the Dr.')
                            : (subject == 'Toilet')
                            ? checkboxfunction(context, 'Diaper Changed.')
                            : (subject == 'Sleep')
                            ? sleepFuntion(context)
                            : (subject == 'Fluids')
                            ? fluidsfunction(context)
                            : (subject == 'Mood') ? moodfunction(context) : Container(),
                        SizedBox(
                          height: mQ.height * 0.01,
                        ),
                        SizedBox(height: mQ.height * 0.004,
                            child: Container(color: Colors.white,)),
                        takepicture
                            ? imageloading
                            ? Container(
                            width: mQ.width * 0.4,
                            height: mQ.height * 0.2,
                            child: Center(
                                child:
                                CircularProgressIndicator()))
                            : Container(
                            width: mQ.width * 0.4,
                            height: mQ.height * 0.2,
                            child: Image.file(
                              File(imagefilepath),
                              fit: BoxFit.fill,
                            ))
                            : Container(),
                        takepicture
                            ?
                        IconButton(
                          icon: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text('Upload Image'),
                                Icon(Icons.camera_alt_outlined,
                                    size: 30),
                              ]),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          onPressed: () async {
                            _imageActionSheet(context, subject!,mQ);
                            // _imageActionSheet(context, subject!);
                          },
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _imageActionSheet2(BuildContext context,
      String title,) async {
    final status = await Permission.camera.request();
  if (status.isPermanentlyDenied) {
  openAppSettings();
  } else if (status.isGranted) {
    camerainitialize();

    _controller = CameraController(
      firstCamera!,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop:() async {
          _controller.dispose();
          return true;
        },
        child:
         Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child:
          Container(padding: EdgeInsets.all(0),
            width: double.infinity,
            // height: mQ.height*0.45,
              height: double.infinity,
            // color: grey100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent
            ),
        child:  Column(children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
                  FloatingActionButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image =
                        await _controller.takePicture();
                        if (!mounted) return;
                        imagefilepath = image.path;
                        imageloading = true;
                        await GallerySaver.saveImage(imagefilepath);
                        await loadimagefunction(imagefilepath);
                        await uploadimagetocloudstorage(image);
                        _controller.dispose();
                        Navigator.pop(context);
                      } catch (e) {
                        print(e);
                      }
                    },

          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.purple,
                            size: 20,
                          ),
                 ),
          ])
        ))
        );
      },
    );
  }
}

  Future<void> _imageActionSheet(BuildContext context, String title,mQ) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return
        Column(
    mainAxisSize: MainAxisSize.min,      children: [
            Text("Take ${title} Picture"),
            Row(children: [
              // Image.asset('assets/staff.jpg',width: mQ.width*0.9,height: mQ.height*0.7,),
            Expanded(
              child: ListTile(
                    title:
                Text('Camera',style: TextStyle(fontSize: mQ.height*0.016),),
               leading:  Icon(Icons.camera_alt_outlined, color: Colors.purple,size: 28,),
                    onTap: () async {_imageActionSheet2(context, title);Navigator.pop(context);},
                  contentPadding: EdgeInsets.symmetric(horizontal: 50)
              ),
            ),
            Expanded(
              child: ListTile(
                    title:
                    Text('Gallery',style: TextStyle(fontSize: mQ.height*0.016),),
               leading:  Icon(Icons.image, color: Colors.cyan, size: 28),
                    onTap: () async {_pickFile();Navigator.pop(context);},
        contentPadding: EdgeInsets.symmetric(horizontal: 50)
                  ),
            ),
            ]),
          ]);
      },
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      imageloading = true;
    });

    if (result == null) return;

    final file = result.files.first;
    imagefilepath = result.files.first.path!;
    uploadimagetocloudstorage(file);

    // _openFile(file);
    setState(() {
      imageloading = false;
    });
  }

  loadimagefunction(result) async {
    setState(() {
      imageloading = true;
    });
    if (result == null) return;
    imagefilepath = result;
    setState(() {
      imageloading = false;
    });
  }


  uploadimagetocloudstorage(imagefile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final file = File(imagefile.path);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final filename = "images/ ${babyid}${DateTime.now()}";
    final uploadTask = storageRef.child(filename).putFile(file, metadata);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
        // ...
          setState(() async {
            imageUrl = await storageRef.child(filename).getDownloadURL();
            imageloading = false;
            imagedownloading = true;
            ToastContext().init(context);
            Toast.show(
              'Photo Uploaded Successfully',
              // Get.context,
              duration: 5,  backgroundRadius: 5,
              //gravity: Toast.top,
            );  });

          break;
      }
      ToastContext().init(context);
      Toast.show(
        'Wait: Photo is uploading',
        // Get.context,
        duration: 2,  backgroundRadius: 2,
        //gravity: Toast.top,
      );
    });
  }

  int _groupValue = -1;

  Widget _myRadioButton({title, value, onChanged}) {
    return RadioListTile(
      contentPadding: EdgeInsets.all(0),
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  Widget _myRadioButtonMood({title, value, onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  sleepFuntion(context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
          ),
    InkWell(
    onTap: () {
    descriptionplus = biMonthlyController.description_.text;
    biMonthlyController.description_.text = dropdownValue!;
    dropdownValue = "Nap Start";
    }
    , // Handle the click event
    child: Wrap(
      children: [
    Text('Nap Start'),
    Icon(
    Icons.bedtime,
    color: Colors.green[600],
    size: 26,
    )
    ],),
    ),
    InkWell(
    onTap: () {
      descriptionplus = biMonthlyController.description_.text;
      biMonthlyController.description_.text = dropdownValue!;
      dropdownValue = "Wake up";
    }
    , // Handle the click event
    child: Wrap(
      children: [
    Text('Wake up'),
    Icon(
    Icons.sunny_snowing,
    color: Colors.red[600],
    size: 26,
    )

    ],),
    ),
          SizedBox(
            width: 20,
          ),
        ]);
  }


  bool isChecked = false;
  checkboxfunction(context, title) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }
    return Row(children: [
      Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            (isChecked) ? descriptionplus = title : descriptionplus = "";
          });
        },
      ),
      Text(title)
    ]);
  }

  fluidsfunction(context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('   Select Quantitity', style: TextStyle(
              color: Colors.blue
          ),),
          Row(
            children: [
              Expanded(
                child: _myRadioButton(
                  title: "All.",
                  value: 0,
                  onChanged: (newValue) =>
                      setState(() =>
                      (_groupValue = newValue,
                      descriptionplus = "Quantity: All")),
                ),
              ),
              Expanded(
                child: _myRadioButton(
                  title: "Most.",
                  value: 1,
                  onChanged: (newValue) =>
                      setState(() =>
                      (_groupValue = newValue,
                      descriptionplus = "Quantity: Most")),
                ),
              ),
              Expanded(
                child: _myRadioButton(
                  title: "Some.",
                  value: 2,
                  onChanged: (newValue) =>
                      setState(() =>
                      (_groupValue = newValue,
                      descriptionplus = "Quantity: Some")),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _myRadioButton(
                  title: "None.",
                  value: 3,
                  onChanged: (newValue) =>
                      setState(() =>
                      (_groupValue = newValue,
                      descriptionplus = "Quantity: None")),
                ),
              ),
              Expanded(
                child: _myRadioButton(
                  title: "NA.",
                  value: 4,
                  onChanged: (newValue) =>
                      setState(() => (_groupValue = newValue)),
                ),
              ),
              Expanded(
                  child: Text('')
              ),
            ],
          ),
        ]);
  }

  moodfunction(context) {
  dropdownValue = '';// descriptionplus = '';
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // textBaseline: TextBaseline.ideographic,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              children: [
                Expanded(
                  child: _myRadioButtonMood(
                    title: "Happy 😁",
                    value: 0,
                    onChanged: (newValue) =>
                        setState(
                                () =>
                            (_groupValue = newValue,
                            descriptionplus = "Happy 😁")),
                  ),
                ),
                Expanded(
                  child: _myRadioButtonMood(
                    title: "Sleep 😴",
                    value: 1,
                    onChanged: (newValue) =>
                        setState(
                                () =>
                            (_groupValue = newValue,
                            descriptionplus = "Sleep 😴")),
                  ),
                ),
              ]), Row(children: [
            Expanded(
              child: _myRadioButtonMood(
                title: "Grupmy 😣",
                value: 2,
                onChanged: (newValue) =>
                    setState(
                            () =>
                        (_groupValue = newValue, descriptionplus = "Grupmy 😣")),
              ),
            ),
            Expanded(
              child: _myRadioButtonMood(
                title: "Sick 🤢",
                value: 3,
                onChanged: (newValue) =>
                    setState(
                            () =>
                        (_groupValue = newValue, descriptionplus = "Sick 🤢")),
              ),
            ),
          ]), Row(children: [
            Expanded(
              child: _myRadioButtonMood(
                title: "Sad 🥺",
                value: 4,
                onChanged: (newValue) =>
                    setState(
                            () =>
                        (_groupValue = newValue, descriptionplus = "Sad 🥺")),
              ),
            ),
            Expanded(
              child: _myRadioButtonMood(
                title: "Shy 😊",
                value: 5,
                onChanged: (newValue) =>
                    setState(
                            () =>
                        (_groupValue = newValue, descriptionplus = "Shy 😊")),
              ),
            ),
          ]), Row(children: [
            Expanded(
              child: _myRadioButtonMood(
                title: "Playful 😂",
                value: 6,
                onChanged: (newValue) =>
                    setState(() =>
                    (_groupValue = newValue, descriptionplus = "Playfull 😂")),
              ),
            ),
          ],
          ),
        ]);
  }

  selectlist() {
    switch (widget.selectedsubject_) {
      case 'Activity':
        takepicture = true;
        list = [
          'Select ${widget.selectedsubject_}',
          'Fun Time',
          'Play Time',
          'Study Time',
          'Games',
          'Observation',
          'Other'
        ];
        break;
      case 'Health':
        takepicture = true;
        list = [
          'Select ${widget.selectedsubject_} remarks',
          'Baby was little disturbed today.',
          'Baby is having nappy rashes.',
          'Baby is having Fever.',
          'Baby is having Flu.',
          'Baby is having Cough.',
          'Baby is having Colic Pain.',
          'Baby is having stomach disturbance.',
          'Medicine.',
          'Other'
        ];
        break;
      case 'Fluids':
        takepicture = true;
        list = [
          'Select ${widget.selectedsubject_}',
          'Water',
          'Milk',
          'Juice',
          'Other'
        ];
        break;
      case 'Food':
        takepicture = true;
        list = [
          'Select ${widget.selectedsubject_}',
          'Break Fast',
          'Lunch',
          'Dinner',
          'Other'
        ];
        break;
      case 'Sleep':
        takepicture = false;
        list = [
          'Select ${widget.selectedsubject_} remarks',
          'Baby was having sound sleep',
          'Baby was having a short Nap',
          'Baby was having distributed',
          'Nap Start',
          'Wake up',
          'Other'
        ];
        break;
      case 'Toilet':
        takepicture = false;
        list = [
          'Select ${widget.selectedsubject_} remarks',
          'Used Toilet',
          'Pee',
          'Potty',
          'Other'
        ];
        break;
    // case 'Biweekly':
    // list = BiWeekly['subject_'];
    // list = [
    //   'Type note in remarks ',
    // 'Phonics - Literacy',
    // 'Numeracy',
    // 'Creative Learning',
    // 'Reading - Story Telling',
    // 'Movie - Music',
    // 'Physical Activity',
    // 'Other'
    // ];
    // break;
      case 'Supplies':
        takepicture = false;
        list = [
          'Select ${widget.selectedsubject_}',
          'Cloths',
          'Diapers',
          'Socks',
          'Towel',
          'Soap',
          'Shampoo',
          'Toys',
          'Anti Rashing Cream',
          'Feeder (Bottle)',
          'Stroller',
          'Baby Bib',
          'Feeding Cup',
          'Baby Spoon with Bowl',
          'Other'
        ];
        break;
      case 'Notes':
        takepicture = false;
        list = [
          'Select ${widget.selectedsubject_} remarks',
          'Baby enjoyed his day.',
          "Baby's day was full of smiles.",
          'Had tons of fun with toys.',
          'Quite Comfortable.',
          'Baby was relaxed.',
          'Other'
        ];
        break;
    }
  }
  BiWeeklyDropDown(selectedbabyid_,mQ) {
    CollectionReference collectionReferenceBiweekly = FirebaseFirestore.instance.collection('Consent');
    return SizedBox(width: mQ.width*0.9,
      child: StreamBuilder<QuerySnapshot>(
          stream: collectionReferenceBiweekly
              .where('category_', isEqualTo: 'BiWeekly')
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

            List<DropdownMenuItem> biweekltitems = [];


            final biweeklys = snapshot.data!.docs.reversed.toList();

            for (var biweekly in biweeklys)
              biweekltitems.add(DropdownMenuItem(
                value: biweekly.id,
                child: Text('${biweekly['subject_']} - ${biweekly['title_']} - ${biweekly['description_']}',
                  textAlign:TextAlign.left ,
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Comic Sans MS',
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
              );
            return
              Column(children: [
              DropdownButtonFormField(iconSize: mQ.height*0.028,
                  items: biweekltitems,
                  hint: biweekltitems.first,
                  onChanged: (biWeeklyvalue) async {
                    isloadingBiweekly = false;
                    final DocumentSnapshot _dataStream = await FirebaseFirestore.instance
                        .collection('Consent').doc(biWeeklyvalue).get();
                    biMonthlyController.description_.text = _dataStream.get('description_');
                    biMonthlyController.subject_.text = _dataStream.get('subject_');
                    biMonthlyController.activity_.text = _dataStream.get('title_');

                    // showBiWeeklyDialog(biWeeklyvalue,context,selectedbabyid_);
                  }),
                CustomTextField(
                  enabled: true,
                  controller: biMonthlyController.subject_,
                  inputType: TextInputType.text,
                  labelText: "Subject",
                  validators: (String? value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  enabled: true,
                  controller: biMonthlyController.activity_,
                  inputType: TextInputType.text,
                  labelText: "Topic / Title",
                  validators: (String? value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
            ]);
          }),
    );
  }

  showBiWeeklyDialog(documentId, selectedbabyid_, context) async {
    final DocumentSnapshot _dataStream = await FirebaseFirestore.instance
        .collection('Consent').doc(documentId).get();

    bool _isEnable = false;
    biMonthlyController.description_.text = _dataStream.get('description_');
    biMonthlyController.subject_.text = _dataStream.get('subject_');
    biMonthlyController.activity_.text = _dataStream.get('title_');
     // = _dataStream.get('title_');

    TextEditingController description_text_controller =
    TextEditingController(text: _dataStream.get('description_'));
    TextEditingController subject_text_controller =
    TextEditingController(text: _dataStream.get('subject_'));
    TextEditingController activity_text_controller =
    TextEditingController(text: _dataStream.get('title_'));
    return
    Column(
      children: [
        Text('Add Notes'),

        Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: TextField(
                controller: subject_text_controller,
                enabled: _isEnable,
              ),
            ),
            // Image.network(image),
            TextField(
              controller: activity_text_controller,
              enabled: _isEnable,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  child: TextField(
                    controller: description_text_controller,
                    enabled: _isEnable,
                  ),
                ),
                _isEnable ? IconButton(
                    onPressed: () {
                      biMonthlyController.addActivityfunction(
                          context,
                          selectedbabyid_,
                          subject_text_controller.text,
                          activity_text_controller.text,
                          description_text_controller.text,
                          imageUrl,
                          sleeptime_,
                          'BiWeekly');
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.orange,
                    )) :
                IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blue[600],
                    onPressed: () {
                      setState(() {
                        _isEnable = true;
                      });
                    }),
              ],
            ),
          ],


    );
  }
  Future requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // Permission granted, you can now use the camera.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, take the user to app settings.
      openAppSettings();
    } else {
      // Permission denied. You can handle this case as needed.
    }
    return status;
  }

}
