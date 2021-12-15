import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/dialogs/add_institution_dialog.dart';

import '../data_handling.dart';

enum AccountType { Personal, Business, Corporate, Wealth }

class Institution {
  AccountType _character;
  String _id = "";
  String _sortCode = "";
  String _name = "";
  String _branch = "";
  String _city = "";
  String _institutionId = "";
  String _logo = "";
  String _accountNumber;
  bool _personal = false;
  bool _business = false;
  Image _logoImage;
  Institution(
      {String id,
      String sortCode,
      String name,
      String branch,
      String city,
      String accountNumber,
      String institutionID,
      String logo,
      bool personal,
      bool business,
      Image logoImage}) {
    _id = id;
    _sortCode = sortCode;
    _name = name;
    _branch = branch;
    _city = city;
    _institutionId = institutionID;
    _logo = logo;
    // print("new logo: " + _logo);
    _personal = personal;
    _business = business;
    _accountNumber = accountNumber;
    _logoImage = logoImage;
  }
  Institution.from({String id}) {
    _id = id;
  }
  String getName() {
    return _name;
  }

  String getLogoUrl() {
    return _logo;
  }

  String getInstitutionId() {
    return _institutionId;
  }

  String getId() {
    return _id;
  }

  String getSortCode() {
    return _sortCode;
  }

  String getAccountNumber() {
    return _accountNumber;
  }

  Image getLogo() {
    if (_logo == "") {
      getInstitutionLogo(
        _sortCode,
        (Image logo) {
          _logoImage = logo;
        },
      );
      return _logoImage;
    } else {
      return _logoImage;
    }
  }

  AccountType getAccountType() {
    if (_personal) {
      return AccountType.Personal;
    } else {
      return AccountType.Business;
    }
  }
}
