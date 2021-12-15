import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:strykepay_merchant/dataHandling/altered_endpoints.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/handlers/notifications_handler.dart';
import 'package:strykepay_merchant/handlers/qr_screen_handler.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import '../main.dart';
import 'package:encrypt/encrypt.dart' as EC;

class QRScreen extends StatefulWidget {
  const QRScreen({Key key, this.amount}) : super(key: key);
  final double amount;
  static bool paymentStatus;

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen>
    with SingleTickerProviderStateMixin {
  notifs() async {
    if (await getUserId() != "") {
      print("setting up background function");
//      prefs.setString("id", await getUserId());
      if (Platform.isIOS) {
        NotificationsHandler.callback();
      } else {
        await AndroidAlarmManager.periodic(
          const Duration(minutes: 1),
          // Ensure we have a unique alarm ID.
          Random().nextInt(pow(2, 31)),
          NotificationsHandler.callback,
          exact: true,
          wakeup: true,
        );
      }
    }
  }

  @override
  void initState() {
    QRScreen.paymentStatus = null;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    QRScreen.paymentStatus = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    notifs();
    print("Payee is " + userInfo.id);
    return Scaffold(
      appBar: StrykeAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      MediaQuery.of(context).size.height * 0.35),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      "£" + widget.amount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: QrImage(
                        eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square, color: Colors.black),
                        data: jsonEncode({
                          "payee": userInfo.id,
                          "amount": widget.amount,
                          "description": "new DB test",
                          "tip": 0,
                          "logo": userInfo.logoUrl.toString(),
                          "businessName": userInfo.name,
                        }).toString()
                        /*  EC.Encrypter(EC.AES(
                              EC.Key.fromUtf8(
                                  'put32charactershereeeeeeeeeeeee!'),
                              mode: EC.AESMode.cbc))
                          .encrypt(
                              jsonEncode({
                                "payee": userInfo.id,
                                "amount": widget.amount,
                                "description": "new DB test",
                                "tip": 0,
                                "logo": userInfo.logoUrl,
                                "businessName": userInfo.name,
                              }),
                              iv: EC.IV.fromUtf8('put16characters!'))
                          .base64,*/
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withOpacity(0.5),
        child: Center(
          child: Text(Provider.of<QRScreenHandler>(context, listen: true)
                      .getComplete() ==
                  null
              ? "Pending Payment..."
              : Provider.of<QRScreenHandler>(context, listen: true)
                          .getComplete() ==
                      true
                  ? "Payment Success"
                  : "Payment Failure"),
        ),
      ),
    );
  }
}
