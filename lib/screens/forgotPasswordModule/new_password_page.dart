import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/forgotPasswordModule/enter_email_page.dart';
import 'package:strykepay_merchant/screens/loginPages/login_page.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/strykeAppBar.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/update.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key key, this.email}) : super(key: key);
  static String id = "new_password_page";
  final String email;
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
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
                      if (await resetPassword(verifiedPassword, widget.email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            action: SnackBarAction(
                              label: 'Login',
                              textColor: AppColors.accentElement,
                              onPressed: () {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        LoginPage.id)); // Code to execute.
                              },
                            ),
                            content: const Text('Your password has been reset'),
                            duration: const Duration(milliseconds: 1500),
                            width: MediaQuery.of(context)
                                .size
                                .width, // Width of the SnackBar.
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  0.0, // Inner padding for SnackBar content.
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
