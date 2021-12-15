import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/dataHandling/verification.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';

class AddDevicePinPage extends StatefulWidget {
  const AddDevicePinPage({Key key, this.email, this.password})
      : super(key: key);
  final String email;
  final String password;
  @override
  _AddDevicePinPageState createState() => _AddDevicePinPageState();
}

class _AddDevicePinPageState extends State<AddDevicePinPage> {
  String pin = "";
  String errorMessage = "";
  int segmentedControlGroupValue = 0;
  TextEditingController textEditingController = TextEditingController();
  Map<int, Widget> myTabs = {};
  StreamController<ErrorAnimationType> errorController;
  @override
  void initState() {
    // TODO: implement initState
    myTabs = <int, Widget>{
      0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          "Don't Remember",
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
        'Remember Device',
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
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    myTabs = <int, Widget>{
      0: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Text(
          "Don't Remember",
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
        'Remember Device',
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 22, right: 10),
                    child: Text(
                      "Please enter your PIN",
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
                        if (segmentedControlGroupValue == 0) {
                          if (await allowDevice(widget.email, v)) {
                            print("Allowing");
                            var response =
                                await login(widget.email, widget.password);
                            if (response == true) {
                              print(response);
                              Navigator.popAndPushNamed(context, HomePage.id);
                            } else {
                              print(response);
                            }
                          } else {
                            print("Error");
                          }
                        } else {
                          if (await addDevice(widget.email, v)) {
                            var response =
                                await login(widget.email, widget.password);
                            if (response == true) {
                              print(response);
                              Navigator.popAndPushNamed(context, HomePage.id);
                            } else {
                              print(response);
                            }
                          } else {
                            print("error");
                            // Navigator.popAndPushNamed(context, HomePage.id);
                          }
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
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 24.0, left: 24, right: 24),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
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
        ));
  }
}
