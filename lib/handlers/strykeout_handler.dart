import 'package:flutter/material.dart';
import 'package:strykepay_merchant/dataHandling/payment.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:strykepay_merchant/dataHandling/refund.dart';

class StrykeOutHandler extends ChangeNotifier {
  String paymentUrl;
  String transactionNumber;
  setPaymentUrl(String url) {
    paymentUrl = url;
    notifyListeners();
  }

  getPaymentUrl() {
    print("woo url is" + paymentUrl);
    if (paymentUrl == "") {
      //TransactionPage.paymentFailure = true;
      //TransactionPage.isTrying = true;
    } else {
      //TransactionPage.paymentFailure = false;
      //TransactionPage.isTrying = false;
    }
    return paymentUrl;
  }

  getTransactionNumber() {
    return transactionNumber;
  }

  void registerPayment(double amount) async {
    dynamic response = await addTransaction();
    notifyListeners();
    if (response != false) {
      paymentUrl = response;
      //TransactionPage.paymentSuccess = true;
      //TransactionPage.paymentFailure = false;
    } else {
      print("addTransaction error");
      print(response);
      // TransactionPage.paymentFailure = true;
    }
  }
}
/*

class paymentHandler extends ChangeNotifier {
  String paymentUrl;
  setPaymentUrl(String url) {
    paymentUrl = url;
    notifyListeners();
  }

  getPaymentUrl(String url) {
    return paymentUrl;
  }
}
*/
