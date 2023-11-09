import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserData {
  final String? email;
  final String? displayName;

  UserData(this.email, this.displayName);

  @override
  String toString() {
    return 'UserData(email: $email, displayName: $displayName)';
  }
}

class UserDataProvider extends ChangeNotifier {
  UserData? userData;

  void updateUserData(UserData newData) {
    userData = newData;
    notifyListeners();
  }
}
