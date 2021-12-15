import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/models/receipt.dart';
import 'dart:convert';

getAllReceipts() async {
  print(userToken);
  var response = await http.get(
    Uri.https(
      "profile.services.strykepay.co.uk",
      '/merchant/allReceipts',
    ),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    List<Receipt> receipts = [];
    print(response.body);
    var decodedData = jsonDecode(response.body);
    print("DATA IS " + decodedData.toString());
    print(decodedData.length);
    userInfo.userReceipts.clear();
    print(response.body);
    // print("The id is " + receipt["payer"]);
    if (decodedData["Receipts"] != null) {
      for (var payment in decodedData["Receipts"]) {
        receipts.add(Receipt(
            // BUSINESSNAME: payment['payee']['businessName'],
            ID: payment["_id"],
            PAYER: payment["payer"],
            PAYEE: payment["payee"],
            AMOUNT: payment['amount'],
            DESCRIPTION: payment["description"],
            TIP: double.parse(payment["tip"].toString()),
            TRANSACTIONNUMBER: payment["transactionNumber"],
            TRANSACTION: payment["transaction"],
            DATE: payment["date"],
            TOTALAMOUNT: payment["totalAmount"],
            //payerSortCode: receipt["payerBank"]["sortCode"],
            //payerAccountNumber: receipt["payerBank"]["accountNumber"],
            // payeeSortCode: receipt["payeeBank"]["sortCode"],
            //payeeAccountNumber: receipt["payeeBank"]["accountNumber"],
            CREATEDAT: payment["createdAt"],
            UPDATEDAT: payment["updatedAt"],
            REFUND: false,
            V: 0));
        print("payer is " + payment["payer"].toString());
      }
    }
    if (decodedData["Refunds"] != null) {
      for (var refund in decodedData["Refunds"]) {
        receipts.add(Receipt(
            // BUSINESSNAME: "",
            ID: refund["_id"],
            PAYER: "",
            PAYEE: refund["payee"],
            AMOUNT: refund['amount'],
            DESCRIPTION: refund["description"],
            TIP: double.parse(refund["tip"].toString()),
            TRANSACTIONNUMBER: refund["transactionNumber"],
            TRANSACTION: refund["transaction"],
            DATE: refund["date"],
            TOTALAMOUNT: refund["totalAmount"],
            //payerSortCode: receipt["payerBank"]["sortCode"],
            //payerAccountNumber: receipt["payerBank"]["accountNumber"],
            // payeeSortCode: receipt["payeeBank"]["sortCode"],
            //payeeAccountNumber: receipt["payeeBank"]["accountNumber"],
            CREATEDAT: refund["createdAt"],
            UPDATEDAT: refund["updatedAt"],
            REFUND: true,
            V: 0));
        print("payer is " + refund["payer"].toString());
      }
    }
    if (decodedData["Fees"] != null) {
      for (var refund in decodedData["Fees"]) {
        receipts.add(Receipt(
            // BUSINESSNAME: "",
            ID: refund["_id"],
            PAYER: "",
            PAYEE: refund["payee"],
            AMOUNT: refund['amount'],
            DESCRIPTION: refund["description"],
            //TIP: double.parse(refund["tip"].toString()),
            TRANSACTIONNUMBER: refund["transactionNumber"],
            TRANSACTION: refund["transaction"],
            DATE: refund["date"],
            TOTALAMOUNT: refund["totalAmount"],
            //payerSortCode: receipt["payerBank"]["sortCode"],
            //payerAccountNumber: receipt["payerBank"]["accountNumber"],
            // payeeSortCode: receipt["payeeBank"]["sortCode"],
            //payeeAccountNumber: receipt["payeeBank"]["accountNumber"],
            CREATEDAT: refund["createdAt"],
            UPDATEDAT: refund["updatedAt"],
            REFUND: false,
            V: 0));
        // print("payer is " + refund["payer"].toString());
      }
    }

    return receipts;
  } else {
    print("The error is " + response.body);
    List<Receipt> receipts = [];
    return receipts;
  }
}
