import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/verification.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

class RemoteLogoutPinPage extends StatefulWidget {
  const RemoteLogoutPinPage({Key key, this.email, this.password})
      : super(key: key);
  final String email;
  final String password;
  @override
  _RemoteLogoutPinPageState createState() => _RemoteLogoutPinPageState();
}

class _RemoteLogoutPinPageState extends State<RemoteLogoutPinPage>
    with SingleTickerProviderStateMixin {
  String pin = "";
  String errorMessage = "";
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
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    // controller.forward();
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
  TextEditingController textEditingController = TextEditingController();
  int segmentedControlGroupValue = 0;
  Map<int, Widget> myTabs = {};
  StreamController<ErrorAnimationType> errorController;
  @override
  Widget build(BuildContext context) {
    myTabs = <int, Widget>{
      0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          "Don't Remember This Device",
          style: TextStyle(
            fontFamily: 'Hussar',
            fontSize: 16,
            color: segmentedControlGroupValue != 0
                ? AppColors.accentElement
                : Color(0xffffffff),
            letterSpacing: 0.96,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      1: Text(
        'Remember This Device',
        style: TextStyle(
          fontFamily: 'Hussar',
          fontSize: 16,
          color: segmentedControlGroupValue != 1
              ? AppColors.accentElement
              : Color(0xffffffff),
          letterSpacing: 0.96,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
/*

*/
    };
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: StrykeAppBar(
          popCallback: () {
            Navigator.pop(context);
          },
          canPop: true,
          hasButton: false,
          buttonText: "Register",
          buttonCallback: () {
            Navigator.pop(context);
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
                      margin: EdgeInsets.only(left: 5, top: 22, right: 5),
                      child: Text(
                        "Please enter your PIN to logout from your other device and proceed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontFamily: "",
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
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
                          if (await remoteLogout(widget.email, v)) {
                            print("Allowing");
                            if (segmentedControlGroupValue == 0) {
                              if (await allowDevice(widget.email, v)) {
                                print("Allowing");
                                var response =
                                await login(widget.email, widget.password);
                                if (response == true) {
                                  print(response);
                                  Navigator.popAndPushNamed(
                                      context, HomePage.id);
                                } else {
                                  print(response);
                                }
                              } else {
                                setState(() {
                                  errorMessage =
                                  "Something went wrong, please try again";
                                });
                                print("Error");
                              }
                            } else {
                              if (await addDevice(widget.email, v)) {
                                var response =
                                await login(widget.email, widget.password);
                                if (response == true) {
                                  if (await myProfile()) {
                                    print(response);
                                    Navigator.popAndPushNamed(
                                        context, HomePage.id);
                                  }
                                } else {
                                  setState(() {
                                    errorMessage =
                                    "Something went wrong, please try again";
                                  });
                                  print(response);
                                }
                              } else {
                                print("error");
                                // Navigator.popAndPushNamed(context, HomePage.id);
                              }
                            }
                          } else {
                            textEditingController.clear();
                            print("errors");
                          }
                          setState(() {
                            errorMessage = "Incorrect PIN, please try again";
                          });
                          endLoad();
                        },
                        onChanged: (v) {
                          pin = v;
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 24, right: 24),
                        child: Container(
                          width: 400,
                          child: CupertinoSlidingSegmentedControl(
                              thumbColor: AppColors.accentElement,
                              groupValue: segmentedControlGroupValue,
                              children: myTabs,
                              onValueChanged: (i) {
                                setState(() {
                                  segmentedControlGroupValue = i;
                                });
                              }),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
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
