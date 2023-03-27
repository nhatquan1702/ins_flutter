import 'package:flutter/foundation.dart';
import 'package:ins_flutter/data/model/comment.dart';
import 'package:ins_flutter/data/repository/comment_repository.dart';

class CommentProvider with ChangeNotifier {
  List<Comment>? _listCmt;
  List<Comment>? get getListComment => _listCmt;

  Future<void> fetchListComment(String postId) async {
    List<Comment>? listCmt = await CommentRepository().getCommentList(postId);
    _listCmt = listCmt;
    notifyListeners();
  }

  Map<String, int> _commentLength = {};
  Map<String, int> get commentLength => _commentLength;

  void setCommentLength(String id) async {
    _commentLength[id] = (await CommentRepository().getCommentLength(id))!;
    notifyListeners();
  }
}
