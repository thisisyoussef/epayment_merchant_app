import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:strykepay_merchant/dataHandling/refund.dart';

QRScreenHandler qrHandler = QRScreenHandler();

class QRScreenHandler extends ChangeNotifier {
  bool paymentComplete = null;
  setComplete(bool complete) {
    paymentComplete = complete;
    notifyListeners();
  }

  getComplete() {
    return paymentComplete;
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
