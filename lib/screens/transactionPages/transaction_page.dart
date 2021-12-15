import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:strykepay_merchant/dataHandling/institution_endpoints.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/handlers/receipts_handler.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_error_page.dart';
import 'package:strykepay_merchant/screens/transactionPages/transaction_success_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../mainScreens/home_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:strykepay_merchant/handlers/payment_handler.dart';
import 'package:strykepay_merchant/dataHandling/refund.dart';
import 'package:strykepay_merchant/models/institution.dart';

class TransactionPage extends StatefulWidget {
  static bool isTrying = false;
  static bool paymentSuccess = false;
  static bool paymentFailure = false;

  TransactionPage(
      {Key key,
      this.transactionName,
      this.transactionNumber,
      this.totalPrice,
      this.payee,
      this.description,
      this.tip,
      this.businessLogoUrl,
      this.businessName})
      : super(key: key);
  final String payee;
  final String description;
  final double tip;
  final String transactionName;
  final String transactionNumber;
  final double totalPrice;
  final String businessLogoUrl;
  final String businessName;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

void _launchURL(String _url) async {
  print("launching url");
  await canLaunch(_url)
      ? await launch(_url, forceSafariVC: false, forceWebView: false)
      : print("Could not launch $_url");
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  void load() {
    setState(() {
      loading = true;
      TransactionPage.isTrying = true;
      controller.forward();
    });
  }

  void endLoad() {
    setState(() {
      loading = false;
      TransactionPage.isTrying = false;

      controller.stop();
    });
  }

  StreamSubscription _sub;
  bool loading = false;
  Animation animation;
  AnimationController controller;
  bool disableButton = false;
  int _index = 0;
  Institution _selectedInstitution = Institution();

  initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      print("Initial uni link is: " + initialLink.toString());
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      print("Exception");
      // Handle exception by warning the user their action did not succeed
      // return?
    }
    String consent;
    String auid;
    _sub = linkStream.listen((String link) async {
      setState(() {
        disableButton = true;
      });
      print("New uni link is: " + link);
      var uri = Uri.parse(link);
      print(uri.toString());
      print("Uri is " + uri.queryParameters.toString());
      uri.queryParameters.forEach((key, value) {
        if (key == "consent") {
          consent = value;
          print("consent is" + consent);
        } else if (key == "application-user-id") {
          auid = value;
          print("auid is " + auid);
          if (auid.isNotEmpty) {
            load();
          }
        }
      });
      if (await transferConsentRefund(
        consent,
        auid,
      )) {
        setState(() {
          print("payment success");
          endLoad();
          TransactionPage.paymentSuccess = true;
        });
        return true;
      } else {
        TransactionPage.paymentFailure = true;

        endLoad();
      }
      endLoad();
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      print("Error");
      return false;
      // Handle exception by warning the user their action did not succeed
    });
    return false;
    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  String _url;
  void _urlInit() async {
    /*_url = await addTransaction(
        payee: widget.payee,
        description: widget.description,
        amount: widget.totalPrice,
        tip: 0);*/
    print(_url);
  }

  @override
  void initState() {
    // _urlInit();
    TransactionPage.paymentFailure = false;
    TransactionPage.isTrying = false;
    TransactionPage.paymentSuccess = false;
    initUniLinks();
    print("Price is: " + widget.totalPrice.toString());

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
      //print(animation.value);
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Navigator.popAndPushNamed(context, LoginPage.id);
        controller.forward();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    TransactionPage.paymentFailure = false;
    TransactionPage.isTrying = false;
    TransactionPage.paymentSuccess = false;
    // TODO: implement dispose
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TransactionPage.paymentSuccess) {
/*      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransactionSuccessPage()),
      );*/
      //Navigator.popAndPushNamed(context, HomePage.id);
      //Navigator.popAndPushNamed(context, HomePage.id);
    }
    return Scaffold(
      appBar: StrykeAppBar(
        popCallback: () {
          Provider.of<PaymentHandler>(context, listen: false).setPaymentUrl("");
          Navigator.pop(context, HomePage.id);
        },
      ),
      body: LoadingOverlay(
        opacity: 0.9,
        progressIndicator: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/images/logo.png'),
                  height: animation.value * 130,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
            loading
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: AppColors.accentElement.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 40),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 20, right: 20),
                          child: Text(
                            "Processing your payment. Please don't leave this page until payment is complete",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        isLoading: Provider.of<PaymentHandler>(context, listen: true)
                    .getPaymentUrl() ==
                "" ||
            TransactionPage.isTrying,
        child: SafeArea(
          child: TransactionPage.paymentSuccess
              ? TransactionSuccessPage()
              : TransactionPage.paymentFailure &&
                      TransactionPage.isTrying == false
                  ? TransactionErrorPage()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Column(
                          children: [
                            Text(
                              "TN # " + widget.transactionNumber,
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0),
                                child: Text(
                                  "To easily set up payment from your bank to the above-mentioned account details, we are about to securely redirect you to your bank where you will be asked to confirm the payment via SafeConnect, an FCA regulated payment initiation provider for StrykePay.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      "£" + widget.totalPrice.toString(),
                                      style: TextStyle(fontSize: 25),
                                    )
                                  ],
                                ),
                              ),
                              WideRoundedButton(
                                title: "Refund",
                                onPressed: !disableButton &&
                                        Provider.of<PaymentHandler>(context,
                                                    listen: true)
                                                .getPaymentUrl() !=
                                            ""
                                    ? () async {
                                        //load();
                                        load();
                                        setState(() {
                                          TransactionPage.isTrying = true;
                                        });
                                        String encodeQueryParameters(
                                            Map<String, String> params) {
                                          return params.entries
                                              .map((e) =>
                                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                              .join('&');
                                        }

                                        final Uri customLaunch = Uri(
                                          scheme: 'https',
                                          path: 'flutterbooksample.com',
                                          /*   query: encodeQueryParameters(<String, String>{
                            'subject': 'Example Subject & Symbols are allowed!'
                          }),
                       */
                                        );
                                        // await _launchURL("https://4rxfo.app.link");
                                        controller.stop();
                                        setState(() {
                                          controller.forward();
                                        });
                                        try {
                                          _launchURL(
                                              Provider.of<PaymentHandler>(
                                                      context,
                                                      listen: false)
                                                  .getPaymentUrl());
                                        } catch (e) {
                                          Navigator.pushNamed(
                                              context, TransactionErrorPage.id);
                                        }
                                        setState(() {
                                          controller.stop();
                                        });
                                      }
                                    : null,
                                isEnabled: !disableButton &&
                                    Provider.of<PaymentHandler>(context,
                                                listen: true)
                                            .getPaymentUrl() !=
                                        "",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
