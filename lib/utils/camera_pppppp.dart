import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

CameraDescription? firstCamera;
Future<File?> capturePicture(CameraController controller) async {
  try {
    XFile image = await controller.takePicture();
    return File(image.path);
  } catch (e) {
    print('Error capturing picture: $e');
    return null;
  }
}
Future<File?> pickPicture() async {
  final imagePicker = ImagePicker();
  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedImage == null) {
    return null;
  }
  return File(pickedImage.path);
}
Future<String?> uploadPictureToFirebaseStorage(File imageFile) async {
  try {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('images/${DateTime.now()}.jpg');
    final uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() {});
    final url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    print('Error uploading picture: $e');
    return null;
  }
}
class PictureUploadScreen extends StatefulWidget {
  @override
  _PictureUploadScreenState createState() => _PictureUploadScreenState();

}

class _PictureUploadScreenState extends State<PictureUploadScreen> {
  File? _selectedImage;
@override
  Future<void> initState() async {
    // TODO: implement initState
    super.initState();
    final cameras = await availableCameras();
    firstCamera = cameras.first;

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picture Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : Placeholder(),
            ElevatedButton(
              onPressed: () async {
                final image = await capturePicture(CameraController(firstCamera!, ResolutionPreset.medium));
                setState(() {
                  _selectedImage = image;
                });
              },
              child: Text('Capture Picture'),
            ),
            ElevatedButton(
              onPressed: () async {
                final image = await pickPicture();
                setState(() {
                  _selectedImage = image;
                });
              },
              child: Text('Pick Picture from Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedImage != null) {
                  final url = await uploadPictureToFirebaseStorage(_selectedImage!);
                  if (url != null) {
                    print('Uploaded picture URL: $url');
                    // You can use the URL for further processing or display.
                  }
                }
              },
              child: Text('Upload Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
