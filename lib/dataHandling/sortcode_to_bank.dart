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

sortCodeToBank(String sortCode) async {
  var response = await http.get(
    Uri.http(
      "institutionfilter.strykepay.co.uk",
      '/institution/institutionFilter',
      {'sortCode': sortCode},
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${userToken}',
    },
  );
  // print(userInfo.token);
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    print(response.body);
    print("Data check" + sortCode);
    decodedData = jsonDecode(response.body);
    return decodedData[0]['_id'];
  } else {
    print(response.reasonPhrase);
    // print(await response.stream.bytesToString());
    return response.reasonPhrase;
  }
}
