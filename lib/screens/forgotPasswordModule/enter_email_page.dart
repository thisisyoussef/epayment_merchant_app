import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';
import 'package:strykepay_merchant/models.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/verify_otp_page.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

class EnterEmailPage extends StatefulWidget {
  static String id = "enter_email_page";
  const EnterEmailPage({Key key}) : super(key: key);

  @override
  State<EnterEmailPage> createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  String errorMessage = "";
  String email;
  BusinessInfoDetails userInfo = BusinessInfoDetails();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 33,
                ),
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Regular',
                    fontSize: 24,
                    color: const Color(0xff444444),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 38, top: 9, right: 50),
                child: Text(
                  "Enter your email and we'll send you a one time code to reset your password",
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Regular',
                    fontSize: 16,
                    color: const Color(0xff444444),
                  ),
                  textAlign: TextAlign.center,
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                  child: UserInputField(
                    showSymbols: false,
                    isValid: true,
                    initialValue: email,
                    title: "Email",
                    isPassword: false,
                    callback: (String input) {
                      setState(() {
                        email = input;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              WideRoundedButton(
                title: "Next",
                onPressed: () async {
                  var number = (await requestResetPassword(email)).toString();
                  print(number);
                  if (number != "false") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyOtpPage(
                                number: number,
                                email: email,
                              )),
                    );
                  } else {
                    print("X");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
