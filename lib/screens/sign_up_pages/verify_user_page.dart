import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/verification.dart';
import 'add_information_page.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/set_login_pin_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';

class VerifyUserPage extends StatefulWidget {
  const VerifyUserPage({Key key, this.userNumber, this.email})
      : super(key: key);
  static String id = "verify_user_page";
  final String userNumber;
  final String email;
  @override
  _VerifyUserPageState createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  String errorMessage;

  _VerifyUserPageState();

  @override
  void initState() {
    errorMessage = "";
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
                    "Verify Your Account",
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
                    "Please enter the 6 digit code sent to " + widget.email,
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
                      if (await verifyMerchant(widget.email, v)) {
                        myProfile();
                        Navigator.pushNamed(context, AddInformationPage.id);
                      } else {
                        setState(() {
                          textEditingController.clear();
                        });
                      }
                      /*           verifyPin(v, (String _errorMessage) {
                        setState(() {
                          errorMessage = _errorMessage;
                        });
                      });
                      if (errorMessage == "") {
                        Navigator.popAndPushNamed(context, HomePage.id);
                      }

                      setState(() {});*/
                    },
                    onChanged: (v) {},
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
          ],
        ));
  }
}
