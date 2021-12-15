import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:strykepay_merchant/data/user_data.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

verifyMerchant(String email, String otp) async {
  var response = await http.put(
      Uri.parse(
          "https://profile.services.strykepay.co.uk/merchant/verifyMerchant/$email"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "pin": otp,
      }));
  if (response.statusCode == 200) {
    print(response.headers);
    print(response.body);
    var decodedData = jsonDecode(response.body);
    userToken = decodedData['token'];
    verifiedUser = VerifiedUser.fromJson(decodedData);
    return true;
  } else {
    print(response.reasonPhrase);
    print(response.body);
    // print(await response.stream.bytesToString());
    return false;
  }
}

checkOtp(String email, String otp) async {
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request(
      'GET',
      Uri.parse(
          'https://profile.services.strykepay.co.uk/merchant/checkOTP/$email'));
  request.body = json.encode({"otp": otp});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(response.reasonPhrase);
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    print(await response.stream.bytesToString());
    return false;
  }
}
