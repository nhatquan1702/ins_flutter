import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/data/model/user.dart';
import 'package:ins_flutter/constant/provider/image_storage_provider.dart';
import 'package:provider/provider.dart';

class UserRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user info
  Future<UserModel?> getUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  Future<UserModel?> getUserById(String userId) async {
    DocumentSnapshot documentSnapshot =
        await _fireStore.collection('users').doc(userId).get();
    return UserModel.fromSnap(documentSnapshot);
  }

  Future<List<UserModel>?> searchUser(String key) async {
    try {
      final snapshot = await _fireStore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: key)
          .get();
      final userDataList =
          snapshot.docs.map((e) => UserModel.fromSnap(e)).toList();
      return userDataList;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // Signing Up User

  Future<String> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String? bio,
    required File? imageAvatar,
  }) async {
    String res = ConstantStrings.someError;
    try {
      String photoAvatarUrl = '';

      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio!.isNotEmpty ||
          imageAvatar != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = _auth.currentUser!.uid;
        if (imageAvatar != null) {
          photoAvatarUrl = await context
              .read<FirebaseStorageProvider>()
              .storeFileToFirebase(
                'pickerImageAvatar/$uid',
                imageAvatar,
              );
        }

        UserModel userModel = UserModel(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoAvatarUrl,
          email: email,
          bio: bio ?? ConstantStrings.notBio,
          followers: [],
          following: [],
        );

        await _fireStore
            .collection("users")
            .doc(cred.user!.uid)
            .set(userModel.toJson());

        res = ConstantStrings.success;
      } else {
        res = ConstantStrings.pleaseEnterFields;
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = ConstantStrings.someError;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = ConstantStrings.success;
      } else {
        res = ConstantStrings.pleaseEnterFields;
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
