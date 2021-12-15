import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/my_profile_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/userModels/new_user.dart';

checkPin(String pin, String email) async {
  var response = await http.get(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/checkPin/$email.toLowerCase()"),
    /*   body: jsonEncode(
      <String, String>{"pin": pin},
    ),*/
  );
  if (response.statusCode == 200) {
    print(response.body);

    return true;
  } else {
    print(response.reasonPhrase);
    print(response.body);
    return false;
  }
}
