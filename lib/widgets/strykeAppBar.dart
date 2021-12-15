import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:strykepay_merchant/values/colors.dart';

class StrykeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StrykeAppBar(
      {Key key,
      this.popCallback,
      this.canPop,
      this.hasButton,
      this.buttonCallback,
      this.buttonText})
      : super(key: key);
  @override
  final Function popCallback;
  final bool canPop;
  final bool hasButton;
  final Function buttonCallback;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      backgroundColor: Colors.white,
      leading: InkWell(
          child: (canPop == null || canPop)
              ? const Icon(
                  Icons.arrow_back,
                  color: AppColors.accentElement,
                )
              : SizedBox(),
//tooltip: 'Go to the previous page',
          onTap: () {
            print("Pressed");
            popCallback != null ? popCallback() : Navigator.pop(context);
          }),
      actions: [
        (hasButton != null && hasButton)
            ? TextButton(
                onPressed: buttonCallback,
                child: // Adobe XD layer: 'Forgot PIN? Copy' (text)
                    Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Semibold',
                    fontSize: 16,
                    color: AppColors.accentText,
                  ),
                  textAlign: TextAlign.center,
                ))
            : SizedBox(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
