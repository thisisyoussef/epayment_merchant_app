import 'dart:convert';
import 'dart:io';

import '../dataHandling/userProfile/onboarding_user_credentials.dart';

import 'package:flutter/material.dart';
import '../dataHandling/receipt.dart';
import '../models/receipt.dart';
import 'package:http/http.dart' as http;

class ReceiptsHandler extends ChangeNotifier {
  bool loadingReceipts = true;
  List<Receipt> selectedReceipts = [];
  setReceipts() async {
    setLoadingReceipts(true);
    selectedReceipts = await getAllReceipts();
    setLoadingReceipts(false);
    notifyListeners();
  }

  setLoadingReceipts(bool on) {
    loadingReceipts = on;
    notifyListeners();
  }

  List<Receipt> getReceipts() {
    return selectedReceipts;
  }

  bool getLoadingReceipts() {
    return loadingReceipts;
  }
}
