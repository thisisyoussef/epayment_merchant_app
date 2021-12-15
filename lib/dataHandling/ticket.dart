import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

addTicket(String subject, String body) async {
  var headers = {
    'Authorization': 'Bearer $userToken',
    'Content-Type': 'application/json'
  };
  var request = http.Request(
      'POST', Uri.parse('https://ticket.strykepay.co.uk/ticket/addTicket'));
  request.body = json.encode({"subject": subject, "text": body});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}
