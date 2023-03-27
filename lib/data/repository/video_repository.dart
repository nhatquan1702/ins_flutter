import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ins_flutter/constant/component/widget/snackbar.dart';
import 'package:ins_flutter/data/model/video.dart';
import 'package:ins_flutter/data/repository/storage_method.dart';

class VideoRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  uploadVideo(
    BuildContext context,
    String songName,
    String caption,
    String videoPath,
  ) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _fireStore.collection('users').doc(uid).get();
      // get id
      var allDocs = await _fireStore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl =
          await StorageMethods().uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await StorageMethods()
          .uploadThumbnailsToStorage("Video $len", videoPath);

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['username'],
        uid: uid,
        id: "Video $len",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['photoUrl'],
        thumbnail: thumbnail,
        datePublished: DateTime.now(),
      );

      await _fireStore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      showSnackBarFailure(
        context: context,
        title: '',
        message: 'thanh cong',
      );
    } catch (e) {
      showSnackBarFailure(
        context: context,
        title: '',
        message: e.toString(),
      );
    }
  }

  Future<List<Video>?> getVideoList() async {
    try {
      final snapshot = await _fireStore
          .collection('videos')
          .orderBy(
        'datePublished',
        descending: true,
      )
          .get();

      final videoDataList = snapshot.docs.map((e) => Video.fromSnap(e)).toList();

      return videoDataList;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
