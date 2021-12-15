import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/qr_screen.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'dart:convert';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  double amount;
  @override
  void initState() {
    myProfile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Collect",
              style: TextStyle(fontSize: 50),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "How much are you collecting?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
              child: TextFormField(
                style: TextStyle(fontSize: 100),
                textAlign: TextAlign.center,
                decoration: new InputDecoration(),
                onChanged: (String input) {
                  amount = double.parse(input);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: WideRoundedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRScreen(amount: amount)),
                  );
                },
                title: "Generate Code",
                isEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
