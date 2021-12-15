import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

import '../../splash_screen.dart';

class EnterPinCheck extends StatefulWidget {
  const EnterPinCheck({Key key, this.nextPageId}) : super(key: key);
  final String nextPageId;
  @override
  _EnterPinCheckState createState() => _EnterPinCheckState();
}

class _EnterPinCheckState extends State<EnterPinCheck>
    with SingleTickerProviderStateMixin {
  void load() {
    setState(() {
      loading = true;
      controller.forward();
    });
  }

  void endLoad() {
    setState(() {
      loading = false;
      controller.stop();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 1,
    );
    errorController = StreamController<ErrorAnimationType>();
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    // controller.forward()
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
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Animation animation;
  AnimationController controller;
  bool loading = false;
  bool showSymbols = false;
  String pin = "";
  String errorMessage = "";
  TextEditingController textEditingController = TextEditingController();
  int segmentedControlGroupValue = 0;
  StreamController<ErrorAnimationType> errorController;
  bool restart = false;
  String tempPin = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: StrykeAppBar(
          canPop: true,
          hasButton: false,
          buttonText: "Register",
          popCallback: () {
            if (SplashScreen.loggedIn == true) {
              print("true");
              SplashScreen.loggedIn = false;
              Navigator.popAndPushNamed(context, LoginPage.id);
            } else {
              print("false");
              Navigator.pop(context);
            }
            //  Navigator.popAndPushNamed(context, HomePage.id);
          },
        ),
        body: LoadingOverlay(
          isLoading: loading,
          opacity: 0.8,
          progressIndicator: Container(
            child: Image.asset('assets/images/logo.png'),
            height: animation.value * 130,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 70, top: 22, right: 70),
                      child: Text(
                        "Please enter your PIN to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontFamily: "",
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 9),
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.accentElement,
                          fontFamily: "",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: PinCodeTextField(
                        backgroundColor: Colors.white,
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: AppColors.accentText,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: true,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 3) {
                            //return "I'm from validator";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          activeColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          errorBorderColor: Colors.redAccent,
                          disabledColor: AppColors.secondaryAccent,
                          inactiveColor: AppColors.secondaryAccent,
                          selectedColor: AppColors.accentElement,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 30,
                          activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) async {
                          load();
                          print(v + " complete");
                          if (await loginPin(v) == true) {
                            if (await myProfile()) {
                              Navigator.popAndPushNamed(
                                  context, widget.nextPageId);
                            } else {
                              textEditingController.clear();
                              setState(() {
                                textEditingController.clear();
                                endLoad();
                                errorMessage = "Please try again";
                              });
                            }
                          } else {
                            //FocusScope.of(context).unfocus();
                            //textEditingController.value =TextEditingValue.empty;
                            // textEditingController.clear();
                            if (Platform.isIOS) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterPinCheck(
                                          nextPageId: widget.nextPageId,
                                        )),
                              );
                            }
                            Future.delayed(Duration(microseconds: 1))
                                .then((value) => textEditingController.clear());
                            errorController.add(ErrorAnimationType.shake);
                            textEditingController.clear();
                            //endLoad();
                            //textEditingController.clear();
                            setState(() {
                              endLoad();
                              errorMessage = "Please try again";
                            });

                            //  pin="";
                            //textEditingController.text="";

                          }
                        },
                        onChanged: (v) {
                          setState(() {
                            pin = v;
                            tempPin = pin;
                          });
                          setState(() {
                            // pin = v;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 9),
                      child: TextButton(
                        child: Text(
                          "Forgot Pin?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.accentElement,
                            fontFamily: "",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          SplashScreen.loggedIn = false;
                          Navigator.popAndPushNamed(context, LoginPage.id);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
