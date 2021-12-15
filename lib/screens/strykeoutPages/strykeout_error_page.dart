import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_page.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:strykepay_merchant/handlers/payment_handler.dart';

class StrykeOutErrorPage extends StatefulWidget {
  const StrykeOutErrorPage({Key key}) : super(key: key);
  static String id = "strykeout_error_page";

  @override
  State<StrykeOutErrorPage> createState() => _StrykeOutErrorPageState();
}

void _launchURL(String _url) async {
  print("launching url");
  await canLaunch(_url)
      ? await launch(_url, forceSafariVC: false, forceWebView: false)
      : print("Could not launch $_url");
}

class _StrykeOutErrorPageState extends State<StrykeOutErrorPage>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  Animation animation;
  AnimationController controller;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
        upperBound: 1,
        lowerBound: 0.4);
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Navigator.popAndPushNamed(context, LoginPage.id);
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(),
                Column(
                  children: [
                    Image.asset(
                      "assets/images/sad-face.png",
                      scale: 0.9,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                      child: Text(
                        "Sorry",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Something went wrong"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  WideRoundedButton(
                    title: "Close",
                    onPressed: () {
                      Provider.of<PaymentHandler>(context, listen: false)
                          .setPaymentUrl("");
                      Navigator.popAndPushNamed(context, HomePage.id);
                    },
                    isEnabled: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
