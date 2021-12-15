import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/data/onboard_page_details.dart';
import 'package:strykepay_merchant/screens/onboarding/components/onboard_page.dart';
import 'package:strykepay_merchant/screens/onboarding/components/rounded_button.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';

class IntroScreen extends StatefulWidget {
  static String id = "intro_screen";
  int selectedPage = 0;

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Timer timer;
  void swipeScreen(bool next) {
    print("swiping");

    int minIndex = 0;
    int maxIndex = onboardData.length - 1;
    if (widget.selectedPage < maxIndex && next) {
      setState(() {
        widget.selectedPage++;
      });
    } else if (widget.selectedPage > minIndex && !next) {
      setState(() {
        widget.selectedPage--;
      });
    }
    print(widget.selectedPage);
  }

  @override
  void initState() {
    //timer = Timer.periodic(Duration(seconds: 3), (Timer t) => swipeScreen());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: appTheme(),
        home: SafeArea(
          child: GestureDetector(
            onPanUpdate: (details) {
              swipeScreen(details.delta.dx < 0);
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                      child: OnboardPage(
                    pageModel: onboardData[widget.selectedPage],
                  )),
                  widget.selectedPage == 1
                      ? Positioned(
                          bottom: 30,
                          //left: MediaQuery.of(context).size.width / 4,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CupertinoButton(
                                color: Color(0xFF007BFF),
                                child: Text("Start"),
                                onPressed: () {
                                  print("pressed button");
                                  Navigator.popAndPushNamed(
                                      context, Register.id);
                                },
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ));
  }
}
