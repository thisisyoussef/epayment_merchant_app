import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models.dart';
import '../main.dart';

String transactionNumber;

addTransaction() async {
  prefs = await SharedPreferences.getInstance();
  print("Token is " + userToken.toString());
  var response = await http.post(
    Uri.parse("https://cashout.strykepay.co.uk/payment/addTransaction"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
    },
    body: jsonEncode(<String, dynamic>{}),
  );
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    print(response.body);
    dynamic redirectLink = decodedData['authorisationUrl'];
    dynamic _transactionNumber =
        decodedData['transaction']['transactionNumber'];
    transactionNumber = _transactionNumber;
    print("Trans number is " + transactionNumber);
    return await redirectLink;
  } else {
    print(response.statusCode);
    print("Transaction Response is " + response.body);
    return false;
  }
}

transferConsent(String consent, String auid) async {
  print("tn" + transactionNumber);
  print("consent" + consent);
  print("auid" + auid);

  TransactionPage.isTrying = true;
  var headers = {'Authorization': 'Bearer $userToken'};
  print("Token is " + userToken.toString());
  var response = await http.get(
    Uri.https(
      "cashout.strykepay.co.uk",
      '/payment/transferConsent',
      {
        'application-user-id': auid,
        "consent": consent,
        "transactionNumber": transactionNumber
      },
    ),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 500) {
    TransactionPage.isTrying = false;
    print(response.statusCode);
    print(response.body);

    return;
  } else if (response.statusCode == 200) {
    TransactionPage.isTrying = false;

    print("Consent response true");
    print(response.body);
    var decodedData = jsonDecode(response.body);
    if (decodedData["message"] != null) {
      TransactionPage.paymentFailure = true;
      TransactionPage.paymentSuccess = false;
      return false;
    } else if (decodedData["error"] != null) {
      return false;
    } else if (decodedData["transaction"]["status"] != null &&
        decodedData["transaction"]["status"] != "COMPLETED") {
      print("consent false");
      TransactionPage.paymentFailure = true;
      TransactionPage.paymentSuccess = false;
      return false;
    }
    TransactionPage.paymentSuccess = true;
    TransactionPage.paymentFailure = false;

    return true;
  } else {
    TransactionPage.isTrying = false;
    print("Consent response false");
    print(transactionNumber);
    print(response.statusCode);
    print(response.body);
    TransactionPage.paymentFailure = true;
    TransactionPage.paymentSuccess = false;
    return false;
  }
}
