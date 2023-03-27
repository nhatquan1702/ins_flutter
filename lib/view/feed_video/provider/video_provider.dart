import 'package:flutter/material.dart';
import 'package:ins_flutter/data/model/video.dart';
import 'package:ins_flutter/data/repository/video_repository.dart';

class VideoProvider with ChangeNotifier {
  // Post? _video;
  // Post? get video => _video;

  List<Video>? _list;
  List<Video>? get getListVideo => _list;

  List<Video>? _videoSource;
  List<Video>? get videoSource => _videoSource;

  int _prevVideo = 0;
  int get prevVideo => _prevVideo;

  // List<Video>? _listByUserId;
  // List<Video>? get getListPostByUserId => _listByUserId;
  //
  // List<Video>? _listBySearch;
  // List<Video>? get getListPostBySearch => _listBySearch;

  Future<void> fetchListVideo() async {
    List<Video>? listPost = await VideoRepository().getVideoList();
    _list = listPost;
    notifyListeners();
  }

  Future<void> fetchVideoSource() async {
    List<Video>? list = await VideoRepository().getVideoList();
    _videoSource = list;
    notifyListeners();
  }

  // Future<void> fetchListPostByUser(String uId) async {
  //   List<Video>? list = await PostRepositoryNew().getPostListByUserId(uId);
  //   _listByUserId = list;
  //   notifyListeners();
  // }
  //
  // Future<void> searchPost(String key) async {
  //   List<Video>? list = await PostRepositoryNew().searchPost(key);
  //   _listBySearch = list;
  //   notifyListeners();
  // }
  //
  // Future<void> fetchPost(String videoId) async {
  //   Video? video = await PostRepositoryNew().getPost(videoId);
  //   _video = video;
  //   notifyListeners();
  // }
  //
  // void setListPost(List<Video> list) {
  //   _list = list;
  //   notifyListeners();
  // }
  //
  // Map<String, bool> _isLikeAnimating = {};
  // Map<String, bool> get isLikeAnimating => _isLikeAnimating;
  //
  // void setLikeAnimating(String videoId, bool like) {
  //   _isLikeAnimating[videoId] = like;
  //   notifyListeners();
  // }

  Future<void> loadVideo(int index) async {
    if (_videoSource!.length > index) {
      await _videoSource![index].loadVideoController();
      _videoSource![index].controller!.play();
      notifyListeners();
    }
  }

  Future<void> changeVideo(index) async {
    if (_videoSource![index].controller == null) {
      await _videoSource![index].loadVideoController();
    }
    _videoSource![index].controller!.play();
    //_videoSource![_prevVideo].controller.removeListener(() {});

    if (_videoSource![_prevVideo].controller != null)
      _videoSource![_prevVideo].controller!.pause();
    _prevVideo = index;
    notifyListeners();
  }
}
