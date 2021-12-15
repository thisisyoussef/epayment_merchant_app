import 'dart:io' show Platform;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/screens/sign_up_pages/register.dart';
import 'package:strykepay_merchant/values/borders.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/values/radii.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import '../../models.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key key, this.user, this.errorMessage}) : super(key: key);
  final BusinessInfoDetails user;
  final String errorMessage;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String verifiedPassword = "";
  static bool tocAgree = false;
  String localDob;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, right: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 0, top: 17, right: 0),
            child: Text(
              "Get started",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 75, top: 9, right: 76),
            child: Text(
              "First, tell us about your Business",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 9),
            child: Text(
              widget.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.accentElement,
                fontFamily: "",
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            child: UserInputField(
              autofocus: false,
              isValid: widget.user.name != null,
              initialValue: widget.user.name,
              title: "Business Name",
              isPassword: false,
              callback: (String input) {
                setState(() {
                  widget.user.validName = true;
                  widget.user.name = input;
                });
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 100),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100,
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            child: UserInputField(
              autofocus: false,
              isValid: true,
              initialValue: widget.user.companyNumber,
              title: "Business Number",
              isPassword: false,
              callback: (String input) {
                setState(() {
                  widget.user.companyNumber = input;
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100,
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            child: UserInputField(
              isValid: widget.user.validEmail,
              initialValue: widget.user.email,
              title: "Email",
              isPassword: false,
              callback: (String input) {
                setState(() {
                  widget.user.email = input;

                  widget.user.validEmail =
                      EmailValidator.validate(widget.user.email);
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100,
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
                  if (verifiedPassword == widget.user.password) {
                    Register.validatedPassword = true;
                  } else {
                    Register.validatedPassword = false;
                  }
                });
              }),
          UserInputField(
              showSymbols: false,
              isPassword: true,
              title: "Verify Password",
              initialValue: verifiedPassword,
              isValid: verifiedPassword == widget.user.password,
              callback: (input) {
                setState(() {
                  verifiedPassword = input;
                  if (verifiedPassword == widget.user.password) {
                    Register.validatedPassword = true;
                    print("validated");
                  } else {
                    Register.validatedPassword = false;
                  }
                });
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Container(
            height: 44,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "I agree to the Terms and Conditions.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 75, 74, 75),
                      fontFamily: "",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 64,
                  height: 44,
                  child: Switch(
                      inactiveThumbColor: AppColors.secondaryAccent,
                      inactiveTrackColor: AppColors.accentElement,
                      activeTrackColor: AppColors.secondaryAccent,
                      activeColor: AppColors.accentElement,
                      value: Register.tocAgree,
                      onChanged: (toggle) {
                        setState(() {
                          Register.tocAgree = toggle;
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
