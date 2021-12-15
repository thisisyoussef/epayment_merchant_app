import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/values/colors.dart';

class WideRoundedButton extends StatelessWidget {
  WideRoundedButton(
      {this.color, this.title, this.onPressed, this.textColor, this.isEnabled});
  final Color color;
  final String title;
  final Function onPressed;
  final textColor;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: CupertinoButton(
            color: AppColors.accentElement,
            child: Text(title),
            onPressed: onPressed),
      ),
    );
  }
}
