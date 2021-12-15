import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

import '../../models.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key key, this.isReset, this.user, this.errorMessage})
      : super(key: key);
  final BusinessInfoDetails user;
  final String errorMessage;
  final bool isReset;

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool showSymbols = false;
  String verifiedPassword = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 33,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 33,
                  ),
                  child: Text(
                    'Password',
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
                    widget.isReset == null
                        ? 'Secure your account \nwith a password'
                        : "Set up a new password \nfor your account",
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
                    widget.isReset == null ? errorMessage : "",
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
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Visibility(
                  visible: errorMessage == "User already registered",
                  child: UserInputField(
                    showSymbols: false,
                    isValid: EmailValidator.validate(widget.user.email),
                    initialValue: widget.user.email,
                    title: "Email",
                    isPassword: false,
                    callback: (String input) {
                      setState(() {
                        widget.user.email = input;
                      });
                    },
                  ),
                ),
                UserInputField(
                    showSymbols: false,
                    isValid: widget.user.password == verifiedPassword,
                    maxLength: 15,
                    isPassword: true,
                    title: "Password",
                    initialValue: widget.user.password,
                    callback: (input) {
                      setState(() {
                        widget.user.password = input;
                      });
                    }),
                UserInputField(
                  showSymbols: false,
                  isPassword: true,
                  title: "Verify Password",
                  initialValue: verifiedPassword,
                  isValid: verifiedPassword == widget.user.password,
                  callback: (input) {
                    print("called)");
                    setState(() {
                      print("called)");
                    });
                  },
                ),
                widget.isReset != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: WideRoundedButton(
                          title: "Reset Password",
                          onPressed: () {},
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
