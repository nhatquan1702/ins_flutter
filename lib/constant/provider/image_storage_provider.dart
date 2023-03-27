import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageProvider with ChangeNotifier {
  final FirebaseStorage firebaseStorage;
  FirebaseStorageProvider({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String path, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    notifyListeners();
    return downloadUrl;
  }
}
