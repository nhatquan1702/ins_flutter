import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBarFailure(
      context: context,
      title: ConstantStrings.reload,
      message: e.toString(),
    );
  }
  return image;
}

Future<File?> pickImageFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBarFailure(
      context: context,
      title: ConstantStrings.reload,
      message: e.toString(),
    );
  }
  return image;
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No Image Selected');
}
