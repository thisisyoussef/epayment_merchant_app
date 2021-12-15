import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/enter_email_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';

import '../../account_updated.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key key}) : super(key: key);
  static String id = "update_password_page";
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  bool showSymbols = false;
  String verifiedPassword = "";
  String oldPassword = "";
  String password = "";
  String errorMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StrykeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 33,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 33,
                  ),
                  child: Text(
                    'Reset Password',
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
                    "Update your password",
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
                UserInputField(
                    showSymbols: false,
                    isValid: true,
                    maxLength: 15,
                    isPassword: true,
                    title: "Old Password",
                    initialValue: oldPassword,
                    callback: (input) {
                      setState(() {
                        oldPassword = input;
                      });
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                UserInputField(
                    showSymbols: false,
                    isValid: true,
                    maxLength: 15,
                    isPassword: true,
                    title: "New Password",
                    initialValue: verifiedPassword,
                    callback: (input) {
                      setState(() {
                        verifiedPassword = input;
                      });
                    }),
                UserInputField(
                  showSymbols: false,
                  isPassword: true,
                  title: "Verify New Password",
                  initialValue: verifiedPassword,
                  isValid: true,
                  callback: (input) {
                    print("called)");
                    setState(() {
                      print("called)");
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: WideRoundedButton(
                    title: "Reset Password",
                    onPressed: () async {
                      if (await updatePassword(oldPassword, verifiedPassword)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountUpdatedPage()),
                        );
                      } else {
                        setState(() {
                          errorMessage =
                              "Something went wrong, please try again";
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 9),
                  child: TextButton(
                    child: Text(
                      "Forgot Password?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.accentElement,
                        fontFamily: "",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, EnterEmailPage.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
