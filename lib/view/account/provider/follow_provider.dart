import 'package:flutter/material.dart';

class FollowProvider with ChangeNotifier {
  bool _isFollow = false;
  bool get isFollow => _isFollow;

  int _follower = 0;
  int get follower => _follower;

  void changeFollow(bool fl) {
    _isFollow = fl;
    notifyListeners();
  }

  void setFollower(int fl) {
    _follower = fl;
    notifyListeners();
  }
}
