import 'package:camera/camera.dart';
import 'package:file_picker/src/file_picker.dart';
import 'package:kids_republik/screens/activities/bi_monthly.dart';

class CameraService {
  CameraController? _controller;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    await _controller!.initialize();
  }

  CameraController? get cameraController => _controller;

  Future<void> captureAndSaveImage() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final XFile image = await _controller!.takePicture();
        // Process or save the captured image as needed
        imagefile = image as FilePicker?;
        imagefilepath = image.path;
        print('Image path: ${image.path}');
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
