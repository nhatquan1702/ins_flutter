import 'package:flutter/material.dart';

class ObscureNotifier with ChangeNotifier {
  bool _isObscure = true;
  bool _isObscureAgain = true;
  bool _changeStatusLoading = false;
  bool _loadingAddPostScreen = false;
  String _keySearchScreen = '';

  bool get isObscure => _isObscure;
  bool get isObscureAgain => _isObscureAgain;
  bool get loadingAddPostScreen => _loadingAddPostScreen;
  String get keySearchScreen => _keySearchScreen;
  bool get changeStatusLoading => _changeStatusLoading;

  void updateObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void updateObscureAgain() {
    _isObscureAgain = !_isObscureAgain;
    notifyListeners();
  }

  void setLoadingStatus(bool check) {
    _changeStatusLoading =  check;
    notifyListeners();
  }

  void setLoadingAddPostScreen(bool check) {
    _loadingAddPostScreen =  check;
    notifyListeners();
  }

  void setKeySearchScreen(String value) {
    _keySearchScreen =  value;
    notifyListeners();
  }
}