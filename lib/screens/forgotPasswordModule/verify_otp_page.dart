import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/verification.dart';
import 'package:strykepay_merchant/screens/loginPages/enter_pin_page.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/new_password_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'dart:ui';
import 'dart:async';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({Key key, this.number, this.email}) : super(key: key);
  static String id = "verify_otp_page";
  final String number;
  final String email;

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  String errorMessage;
  Timer _timer;
  int _start = 1800;
  @override
  void initState() {
    errorMessage = "";
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    // TODO: implement dispose
    super.dispose();
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
                  margin: EdgeInsets.only(left: 134, top: 22, right: 134),
                  child: Text(
                    "One Time Passcode",
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
                      if (await checkOtp(widget.email, v)) {
                        print(widget.email);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewPasswordPage(email: widget.email)),
                        );
                      } else {
                        setState(() {
                          errorMessage = "Invalid OTP, please try again";
                        });
                      }
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70.0, vertical: 50),
                  child: WideRoundedButton(
                    title: "Resend",
                    onPressed: () async {
                      _timer.cancel();
                      _start = 1800;

                      setState(() {
                        _timer = new Timer.periodic(
                          Duration(seconds: 1),
                          (Timer timer) {
                            if (_start == 0) {
                              setState(() {
                                timer.cancel();
                              });
                            } else {
                              setState(() {
                                _start--;
                              });
                            }
                          },
                        );
                      });

                      var number =
                          (await requestResetPassword(widget.email)).toString();
                      print(number);
                      if (number != "false") {
                      } else {
                        setState(() {
                          errorMessage =
                              "Something went wrong while resending your OTP, please try again";
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    Duration(seconds: _start).inMinutes.toString() +
                        ":" +
                        Duration(seconds: _start % 60).inSeconds.toString(),
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                )
              ],
            ),
//Continue button may be unnecessary due to completion automatically being detected and action being made regardless of button press/
          ],
        ));
  }
}
