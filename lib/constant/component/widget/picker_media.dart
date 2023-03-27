import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/view/feed_video/widget/confirm_widget.dart';
import 'package:video_compress/video_compress.dart';

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

pickVideo(ImageSource src, BuildContext context) async {
  final video = await ImagePicker().pickVideo(source: src);
  if (video != null) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfirmScreen(
          videoFile: File(video.path),
          videoPath: video.path,
        ),
      ),
    );
  }
}

compressVideo(String videoPath) async {
  final compressedVideo = await VideoCompress.compressVideo(
    videoPath,
    quality: VideoQuality.MediumQuality,
  );
  return compressedVideo!.file;
}

getThumbnail(String videoPath) async {
  final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
  return thumbnail;
}
