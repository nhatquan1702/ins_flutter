import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_flutter/data/model/comment.dart';

class CommentRepository {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<Comment?> getComment(String postId) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      final commentData = snapshot.docs.map((e) => Comment.fromSnap(e)).single;
      return commentData;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<int?> getCommentLength(String postId) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      final commentData =
          snapshot.docs.map((e) => Comment.fromSnap(e)).toList().length;
      return commentData;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List<Comment>?> getCommentList(String postId) async {
    try {
      final snapshot = await _fireStore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy(
            'datePublished',
            descending: true,
          )
          .get();
      final commentData =
          snapshot.docs.map((e) => Comment.fromSnap(e)).toList();
      return commentData;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
