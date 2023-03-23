import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ins_flutter/data/model/comment.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final List<Comment>? comments;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    this.comments,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  Post copyWith({
    String? description,
    String? uid,
    String? username,
    int? likes,
    List<Comment>? comments,
    String? postId,
    DateTime? datePublished,
    String? postUrl,
    String? profImage,
  }) =>
      Post(
        description: description ?? this.description,
        uid: uid ?? this.uid,
        username: username ?? this.username,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        postId: postId ?? this.postId,
        datePublished: datePublished ?? this.datePublished,
        postUrl: postUrl ?? this.postUrl,
        profImage: profImage ?? this.profImage,
      );

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"].toDate(),
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage
      };
}
