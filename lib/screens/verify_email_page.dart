import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/add_information_page.dart';
import 'package:strykepay_merchant/screens/dialogs/add_institution_dialog.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

import 'mainScreens/home_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key key}) : super(key: key);
  static String id = "verify_email_page";

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  String errorMessage;
  @override
  void initState() {
    errorMessage = "";
    // generatePin();
    // TODO: implement initState
    super.initState();
  }

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
                  margin: EdgeInsets.only(left: 0, top: 22, right: 0),
                  child: Text(
                    "Code",
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
                    "Please enter the code sent to " +
                        userInfo.email +
                        " to validate your account",
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
                  height: MediaQuery.of(context).size.height * 0.02,
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
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: PinCodeTextField(
                    backgroundColor: Colors.white,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: AppColors.accentText,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v.length < 3) {
                        return null;
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
                      if (await verifyPin(v, (String _errorMessage) {
                        setState(() {
                          errorMessage = _errorMessage;
                        });
                      })) {
                        Navigator.popAndPushNamed(
                            context, AddInformationPage.id);
                      } else {}
                      if (errorMessage == "") {
                        Navigator.popAndPushNamed(
                            context, AddInformationPage.id);
                      }
                      setState(() {});
                    },
                    onChanged: (v) {
                      print(v);
                      setState(() {});
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
              onPressed: () {},
            ),
          ],
        ));
  }
}
