import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? commentId;
  final DateTime datePublished;
  final String? name;
  final String? profilePic;
  final String? text;
  final String? uid;

  const Comment({
    required this.commentId,
    required this.datePublished,
    required this.name,
    required this.profilePic,
    required this.text,
    required this.uid,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      commentId: snapshot["commentId"] ?? null,
      datePublished: snapshot["datePublished"].toDate() ?? null,
      name: snapshot["name"] ?? null,
      profilePic: snapshot["profilePic"] ?? null,
      text: snapshot["text"] ?? null,
      uid: snapshot["uid"] ?? null,
    );
  }

  static Comment fromJson(Map<String, dynamic> data) {

    return Comment(
      commentId: data["commentId"] ?? null,
      datePublished: data["datePublished"] ?? null,
      name: data["name"] ?? null,
      profilePic: data["profilePic"] ?? null,
      text: data["text"] ?? null,
      uid: data["uid"] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        "commentId": commentId,
        "datePublished": datePublished,
        "name": name,
        "profilePic": profilePic,
        "text": text,
        "uid": uid,
      };
}
