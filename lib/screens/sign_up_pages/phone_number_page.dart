import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:strykepay_merchant/data_handling.dart';
import 'package:strykepay_merchant/screens/mainScreens/home_page.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'package:strykepay_merchant/widgets/user_input_field.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';

import '../../models.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({Key key, this.userInfo, this.errorMessage})
      : super(key: key);
  final BusinessInfoDetails userInfo;
  final String errorMessage;

  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  bool showSymbols = false;
  String verifiedPassword = "";
  String localNumber;
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
            child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 9),
                child: Text(
                  widget.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.accentElement,
                    fontFamily: "",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              IntlPhoneField(
                initialValue: widget.userInfo.number.isNotEmpty
                    ? widget.userInfo.number.substring(3)
                    : '',
                textAlign: TextAlign.left,
                initialCountryCode: 'GB',
                onChanged: (phoneNumberInput) {
                  localNumber = phoneNumberInput.number;
                  widget.userInfo.number = phoneNumberInput.completeNumber;
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
