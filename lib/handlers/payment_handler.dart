import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:strykepay_merchant/dataHandling/refund.dart';

class PaymentHandler extends ChangeNotifier {
  String paymentUrl = "";
  String transactionNumber = "";
  setPaymentUrl(String url) {
    paymentUrl = url;
    notifyListeners();
  }

  getPaymentUrl() {
    print("pay url is" + paymentUrl);
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

  void registerPayment(String transactionNumber) async {
    dynamic response = await addRefund(transactionNumber: transactionNumber);
    notifyListeners();
    if (response != false) {
      setPaymentUrl(response);
      notifyListeners();
      //TransactionPage.paymentSuccess = true;
      //TransactionPage.paymentFailure = false;
    } else {
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
