import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/dataHandling/payment.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import 'package:strykepay_merchant/screens/collection_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models.dart';

String newRefund;
String oldTransaction;
addRefund({String transactionNumber}) async {
  newRefund = "";
  oldTransaction = "";
  print("Token is " + userToken.toString());
  var response = await http.post(
    Uri.parse("https://refund.strykepay.co.uk/refund/addTransaction"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
    },
    body: jsonEncode(<String, dynamic>{
      "transactionNumber": transactionNumber,
    }),
  );
  if (response.statusCode == 200) {
    print("TN " + transactionNumber);
    print(userToken);
    var decodedData = jsonDecode(response.body);
    print("response is " + response.body);
    dynamic redirectLink = decodedData['authorisationUrl'];
    newRefund = decodedData["transaction"]["transactionNumber"];
    oldTransaction = transactionNumber;
    print("old transaction is " + transactionNumber);
    print("new refund is " + newRefund);
    print("link : " + redirectLink);
    print("the old transaction is " + transactionNumber + " " + oldTransaction);
    return await redirectLink;
  } else {
    print("Transaction Response is " + response.body);
    return false;
  }
}

transferConsentRefund(String consent, String auid) async {
  print("bookmark");
  print(oldTransaction);
  print(newRefund);
  print(consent);
  print(auid);
  print(userToken);
  var headers = {'Authorization': 'Bearer $userToken'};
  print("Token is " + userToken.toString());
  var response = await http.get(
    Uri.https(
      "refund.strykepay.co.uk",
      '/refund/transferConsent',
      {
        'application-user-id': auid,
        'oldTransactionNumber': oldTransaction,
        'consent': consent,
        'transactionNumber': newRefund,
      },
    ),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    if (decodedData["error"] != null) {
      print("Consent response internal error");
      print(response.body);
      return false;
    }
    print("Consent response true");
    print(response.body);
    return true;
  } else {
    print(response.statusCode);
    print("Consent response");
    print(oldTransaction);
    print(newRefund);
    print(consent);
    print(auid);
    print(response.body);
    return false;
  }
}
