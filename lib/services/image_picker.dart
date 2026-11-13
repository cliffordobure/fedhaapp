import 'dart:io';

import 'package:fedha/features/common_widgets/toast_messages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final picker = ImagePicker();

  Future<File?> pickImage(BuildContext context, {ImageSource? source}) async {
    final pickedFile =
        await picker.pickImage(source: source ?? ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      showMessage(message: "No image selected");
      return null;
    }
  }
}
