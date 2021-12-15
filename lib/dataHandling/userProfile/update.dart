import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import '../../models.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/models.dart';
import 'package:http_parser/http_parser.dart';

resetPassword(String password, String email) async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/resetPassword/$email"),
    headers: <String, String>{
      //HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": password,
      "confirmPassword": password,
    }),
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return true;
  } else {
    print(response.statusCode);
    print(response.body);
    return false;
  }
}

generatePin(String email) async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/generatePin/$email"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{}),
  );
  print(response.body);
}

updatePassword(String oldPassword, String password) async {
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/updatePassword/${userInfo.email}"),
    headers: <String, String>{
      //HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": password,
      "confirmPassword": password,
      "oldPassword": oldPassword,
    }),
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    return true;
  } else {
    return false;
  }
}

updateInfo(BusinessInfoDetails currentUser) async {
  var headers = {
    'Authorization': 'Bearer ${userToken}',
    'Content-Type': 'application/json'
  };
  var request = http.Request(
      'PUT',
      Uri.parse(
          'https://profile.services.strykepay.co.uk/merchant/updateInfo'));
  request.body = json.encode({
    'businessName': userInfo.name,
    'email': currentUser.email,
    "phone": currentUser.number,
    "addressLine": currentUser.addressLine,
    "streetName": "streetName",
    "buildingNumber": "buildingNumber",
    "postCode": currentUser.postcode,
    "county": "county",
    "country": "country",
    "department": "department",
    "supDepartment": "subDepartment",
    "addressType": "addressType",
    "VATNumber": currentUser.VATNumber
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    print(await response.stream.bytesToString());

    return false;
  }
}

addLogo(String image) async {
  print(image);
  var headers = {
    'Authorization': 'Bearer ${userToken}',
    'Content-Type': 'application/json'
  };
  //TODO FINISH IMAGE
  var putUri =
      Uri.parse('https://profile.services.strykepay.co.uk/merchant/addLogo');
  var request = new http.MultipartRequest("PUT", putUri);
  request.files.add(await http.MultipartFile.fromPath(
    'upload',
    image,
  ));
  request.headers.addAll(headers);
  request.send().then((response) async {
    if (response.statusCode == 200) {
      print("Uploaded!");
      return true;
    } else {
      print(await response.stream.bytesToString());
      return false;
    }
  });
}

requestResetPassword(String email) async {
  var response = await http.post(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/requestResetPassword/$email"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    var decodedData;
    decodedData = jsonDecode(response.body);
    return decodedData['Merchant'];
  } else {
    print(response.reasonPhrase);
    return false;
  }
}
