import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PickerImageProvider extends ChangeNotifier {
  File? _fileImage;
  File? get fileImage => _fileImage;

  Uint8List? _uInt8list;
  Uint8List? get uInt8list => _uInt8list;

  void pickerImageFile(File? file) {
    _fileImage = file;
    notifyListeners();
  }

  void pickerImageUInt8list(Uint8List? uInt8list) {
    _uInt8list = uInt8list;
    notifyListeners();
  }
}
