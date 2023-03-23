import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ins_flutter/constant/string.dart';
import 'package:ins_flutter/data/model/comment.dart';
import 'package:ins_flutter/data/model/post.dart';
import 'package:uuid/uuid.dart';

import 'storage_method.dart';

class PostRepositoryNew {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = ConstantStrings.someError;
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _fireStore.collection('posts').doc(postId).set(post.toJson());
      res = ConstantStrings.success;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = ConstantStrings.someError;
    try {
      if (likes.contains(uid)) {
        _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _fireStore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = ConstantStrings.success;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(
      String postId, String text, Comment comment) async {
    String res = ConstantStrings.someError;
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
        res = ConstantStrings.success;
      } else {
        res = ConstantStrings.pleaseEnterFields;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = ConstantStrings.someError;
    try {
      await _fireStore.collection('posts').doc(postId).delete();
      res = ConstantStrings.success;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _fireStore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _fireStore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _fireStore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _fireStore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _fireStore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<Post>?> getPostList() async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .orderBy(
            'datePublished',
            descending: true,
          )
          .get();

      final postDataList = snapshot.docs.map((e) => Post.fromSnap(e)).toList();

      return postDataList;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List<Post>?> getPostListByUserId(String userId) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .where('uid', isEqualTo: userId)
          .orderBy(
            'datePublished',
            descending: true,
          )
          .get();

      final postDataList = snapshot.docs.map((e) => Post.fromSnap(e)).toList();

      return postDataList;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List<Post>?> searchPost(String key) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .where('description', isEqualTo: key)
          .get();

      final postDataList = snapshot.docs.map((e) => Post.fromSnap(e)).toList();

      return postDataList;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Post?> getPost(String postId) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .where('postId', isEqualTo: postId)
          .get();
      final postData = snapshot.docs.map((e) => Post.fromSnap(e)).single;
      return postData;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
