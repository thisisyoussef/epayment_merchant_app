import 'package:flutter/cupertino.dart';

class UserInfo extends ChangeNotifier {
  String token = "";
  String email = "";
  String fName = "";
  String lName = "";

  void setToken(String _token) {
    token = _token;
  }

  void setEmail(String _email) {
    this.email = _email;
  }

  void setFName(String _fName) {
    this.fName = _fName;
  }

  String getFName() {
    return fName;
  }

  void setLName(String _lName) {
    this.lName = _lName;
  }

  String getLName() {
    return lName;
  }

  String getToken() {
    return token;
  }

  String getEmail() {
    return email;
  }

  UserInfo();
}
