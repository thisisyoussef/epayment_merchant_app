import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/models/receipt.dart';
import 'dart:convert';

double tpv;
var amountDue;
var lastMonthVolume;
var currentVolume;
double takePercentage;
bool loading = true;
getRevenue() async {
  loading = true;
  String token = userToken;
  print(userToken);
  var response = await http.get(
    Uri.https(
      "profile.services.strykepay.co.uk",
      '/merchant/getRevenue',
    ),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    currentVolume = decodedData["CV"];
    amountDue = decodedData["CF"];
    takePercentage = decodedData["TP"];
    // print("percentage is " + takePercentage.toString());
    loading = false;
    return true;
  } else {
    loading = false;
    return false;
  }
}

bool getLoading() {
  return loading;
}

getCurrentVolume() {
  return currentVolume;
}

getAmountDue() {
  return amountDue;
}

double getPercentage() {
  return takePercentage;
}
