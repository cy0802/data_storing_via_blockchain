import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  File file;

  UserModel({required this.file});

  void updateUserInfo(File newfile) {
    file = newfile;
    notifyListeners();
  }
}

class UserProvider extends ChangeNotifier {
  late UserModel _userModel;

  UserModel get userModel => _userModel;

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}