import 'package:flutter/material.dart';
import 'package:ins_flutter/data/model/post.dart';
import 'package:ins_flutter/data/repository/post_repository_new.dart';

class PostNotifier with ChangeNotifier {
  Post? _post;
  Post? get post => _post;

  List<Post>? _list;
  List<Post>? get getListPost => _list;

  List<Post>? _listByUserId;
  List<Post>? get getListPostByUserId => _listByUserId;

  List<Post>? _listBySearch;
  List<Post>? get getListPostBySearch => _listBySearch;

  Future<void> fetchListPost() async {
    List<Post>? listPost = await PostRepositoryNew().getPostList();
    _list = listPost;
    notifyListeners();
  }

  Future<void> fetchListPostByUser(String uId) async {
    List<Post>? listPost = await PostRepositoryNew().getPostListByUserId(uId);
    _listByUserId = listPost;
    notifyListeners();
  }

  Future<void> searchPost(String key) async {
    List<Post>? listPost = await PostRepositoryNew().searchPost(key);
    _listBySearch = listPost;
    notifyListeners();
  }

  Future<void> fetchPost(String postId) async {
    Post? post = await PostRepositoryNew().getPost(postId);
    _post = post;
    notifyListeners();
  }

  void setListPost(List<Post> listPost) {
    _list = listPost;
    notifyListeners();
  }

  Map<String, bool> _isLikeAnimating = {};
  Map<String, bool> get isLikeAnimating => _isLikeAnimating;

  void setLikeAnimating(String postId, bool like) {
    _isLikeAnimating[postId] = like;
    notifyListeners();
  }
}
