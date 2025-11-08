import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget {
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }
}