import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/verify_email_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/data_handling.dart';

import 'account_updated.dart';
import 'mainScreens/home_page.dart';

class CreatePin extends StatefulWidget {
  const CreatePin({Key key, this.resetPin}) : super(key: key);
  static String id = "create_pin_page";
  final bool resetPin;
  @override
  _CreatePinState createState() => _CreatePinState();
}

class PinWrapper {
  PinWrapper();
}

class _CreatePinState extends State<CreatePin> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;
  String currentText = "";
  String pin = "";
  String verifiedPin = "";
  String tempPin = "";
  PinWrapper pinWrapper = PinWrapper();
  String errorMessage = "";
  bool verifying = false;
  bool verified = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: StrykeAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 134, top: 22, right: 134),
                  child: Text(
                    verifying
                        ? "Verify PIN"
                        : widget.resetPin == null
                            ? "Create PIN"
                            : "Create new PIN",
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
                  margin: EdgeInsets.only(left: 63, top: 9, right: 63),
                  child: Text(
                    verifying && widget.resetPin == null
                        ? "Verify your 4 digit Pin to access your account"
                        : verifying
                            ? "Verify your new 4 digit Pin"
                            : widget.resetPin == null
                                ? "Setup your 4 digit Pin to access your account"
                                : "Create your new 4 digit PIN to access your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontFamily: "",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
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
                    onCompleted: (v) {
                      setState(() {
                        if (verifying) {
                          print(v);
                          print(pin);
                          verifiedPin = v;
                          print(verifiedPin);
                          verified = pin == verifiedPin;
                          if (!verified) {
                            print("Not Verified");
                            verifying = false;
                            pin = "";
                            verifiedPin = "";
                            textEditingController.text = "";
                          } else {
                            print("Verified");
                            if (widget.resetPin == null) {
                              createPin(verifiedPin);
                            } else {
                              resetPin(verifiedPin);
                            }
                            widget.resetPin == null
                                ? Navigator.pop(context)
                                :
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => AccountUpdatedPage()),);
                          }
                        } else {
                          print(v);
                          print("Completed");
                          print(pin);
                          pin = textEditingController.value.text;
                          print("Pin is " + pin);
                          v = "";
                          //Copy pin data to tempPin variable to store data rather than textController.text reference, which becomes empty and deletes value
                          tempPin = pin;
                          textEditingController.text = "";
                          print("Pin is " + pin);
                          print("Pin is " + tempPin);
                          pin = tempPin;
                          print("Pin is " + pin);
                          verifying = true;
                        }
                      });
                    },
                    onChanged: (v) {
                      print(v);
                      setState(() {
                        if (verifying) {
                          verifiedPin = v;
                        } else {
                          pin = v;
                        }
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
              ],
            ),
            //Continue button may be unnecessary due to completion automatically being detected and action being made regardless of button press/
            WideRoundedButton(
              title: "Continue",
              isEnabled: true,
              onPressed: () {
                if (verified) {
                  if (widget.resetPin == null) {
                    createPin(pin);
                  } else {
                    resetPin(pin);
                  }
                }
              },
            ),
          ],
        ));
  }
}
