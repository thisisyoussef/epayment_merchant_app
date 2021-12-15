import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';

class EnterPinPage extends StatefulWidget {
  static String id = "enter_pin_page";
  const EnterPinPage({Key key, this.statusCode}) : super(key: key);
  final int statusCode;
  @override
  _EnterPinPageState createState() => _EnterPinPageState();
}

class _EnterPinPageState extends State<EnterPinPage>
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
  String pin = "";
  String errorMessage = "";
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
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
                            if (await loginPin(v)) {
                              setState(() {
                                //widget.remoteLogin == null ?
                                Navigator.popAndPushNamed(context, HomePage.id);
                              });
                            } else {
                              endLoad();
                              textEditingController.clear();
                              pin = "";
                            }
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
                            Navigator.popAndPushNamed(context, LoginPage.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
