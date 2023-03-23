import 'package:flutter/widgets.dart';
import 'package:ins_flutter/data/model/user.dart';
import 'package:ins_flutter/data/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get getUser => _user;

  UserModel? _userById;
  UserModel? get userById => _userById;

  List<UserModel>? _listUserBySearch;
  List<UserModel>? get getListUserBySearch => _listUserBySearch;

  Future<void> refreshUser() async {
    UserModel? getUser = await UserRepository().getUser();
    _user = getUser;
    notifyListeners();
  }

  Future<void> refreshUserById(String userId) async {
    UserModel? getUser = await UserRepository().getUserById(userId);
    _userById = getUser;
    notifyListeners();
  }

  Future<void> searchUser(String key) async {
    List<UserModel>? list = await UserRepository().searchUser(key);
    _listUserBySearch = list;
    notifyListeners();
  }
}
