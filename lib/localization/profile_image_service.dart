// File: lib/services/profile_image_picker_service.dart

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileImagePickerService {
  static final ProfileImagePickerService _instance =
      ProfileImagePickerService._internal();

  factory ProfileImagePickerService() => _instance;

  ProfileImagePickerService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({required ImageSource source}) async {
    print(
        "Picking image from ${source == ImageSource.camera ? 'camera' : 'gallery'}");
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) {
      return null;
    }

    final appDir = await getApplicationDocumentsDirectory();
    const fileName = 'profile_image.png';
    final file = File('${appDir.path}/$fileName');

    await file.writeAsBytes(await pickedFile.readAsBytes());

    return file;
  }

  Future<File?> getSavedImage() async {
    print("Getting saved image");
    final appDir = await getApplicationDocumentsDirectory();
    const fileName = 'profile_image.png';
    final file = File('${appDir.path}/$fileName');

    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  }

  Future<void> removeSavedImage() async {
    print("Removing saved image");
    const fileName = 'profile_image.png';
    final appDir = await getApplicationDocumentsDirectory();

    final localPath = '${appDir.path}/$fileName';
    final imageFile = File(localPath);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }
}
