import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import '../../models.dart';

addInstitution(String institutionId, String accountNumber) async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/addInstitution/"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "institution_id": institutionId,
      "accountNumber": accountNumber,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    print(response.body);
    return false;
  }
}

changeInstitutionIndex(String institutionId) async {
  String token = userToken;
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/changeInstitutionIndex/"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "institutionId": institutionId,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    return false;
  }
}

removeAccount(String accountNumber, String institutionId) async {
  String token = userInfo.token;
  final queryParameters = {
    'accountNumber': accountNumber,
    'institution': institutionId,
  };
  var response = await http.put(
    Uri.https('profile.services.strykepay.co.uk',
        '/merchant/removeInstitutionAccount/', queryParameters),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

//  userInfo.userInstitutions.removeAt(userInfo.userInstitutions
  //    .indexWhere((element) => element.getId() == institutionId));
  if (response.statusCode == 200) {
    print("Response from removing account: " + response.body);
    return true;
  } else {
    print("error removing account");
    return false;
  }
}
