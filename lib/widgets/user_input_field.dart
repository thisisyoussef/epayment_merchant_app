import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strykepay_merchant/values/colors.dart';

class UserInputField extends StatefulWidget {
  const UserInputField({
    Key key,
    this.initialValue,
    @required this.isPassword,
    this.callback,
    @required this.title,
    this.maxLength,
    this.isValid,
    this.isEnabled,
    this.alphanumeric,
    this.showSymbols,
    this.autofocus,
    this.imageInput,
  }) : super(key: key);
  final bool isPassword;
  final bool showSymbols;
  final Function callback;
  final String title;
  final String initialValue;
  final int maxLength;
  final bool isValid;
  final bool isEnabled;
  final bool alphanumeric;
  final bool autofocus;
  final Widget imageInput;
  @override
  _UserInputFieldState createState() => _UserInputFieldState();
}

class _UserInputFieldState extends State<UserInputField> {
  Timer searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            200); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping =
        new Timer(duration, () => widget.callback(value)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 8, top: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'SFUIDisplay-Regular',
                    fontSize: 14,
                    color: const Color(0xff525252),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 5,
                ),
                !widget.isValid
                    ? Icon(
                        Icons.arrow_circle_down_rounded,
                        size: 24,
                        color: AppColors.accentElement,
                      )
                    : widget.isValid
                        ? Icon(
                            Icons.check_circle_outline_rounded,
                            size: 24,
                            color: Colors.green,
                          )
                        : SizedBox()
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 18.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: const Color(0xffffffff),
                  border:
                      Border.all(width: 1.0, color: const Color(0xffdddddd)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: widget.imageInput != null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                //height: MediaQuery.of(context).size.height * 0.05,
                                child: widget.imageInput)
                            : SizedBox(
                                //width: MediaQuery.of(context).size.width * 0.15,
                                ),
                      ),
                      Expanded(
                        child: TextFormField(
                          autofocus:
                              widget.autofocus != null && widget.autofocus,
                          inputFormatters: widget.alphanumeric == true
                              ? <TextInputFormatter>[
                                  new FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z0-9]")),
                                ]
                              : [],
                          enabled: widget.isEnabled,
                          maxLengthEnforcement: widget.maxLength != null
                              ? MaxLengthEnforcement.enforced
                              : MaxLengthEnforcement.none,
                          maxLength: widget.maxLength,
                          initialValue: widget.initialValue,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              counterText: ""),
                          style: TextStyle(
                            fontFamily: 'SFUIDisplay-Regular',
                            fontSize: 16,
                            color: const Color(0xff525252),
                            height: 1.375,
                          ),
                          textAlign: TextAlign.left,
                          cursorColor: AppColors.accentElement,
                          obscureText: widget.isPassword,
                          keyboardType: widget.title.endsWith("Name")
                              ? TextInputType.name
                              : widget.title.contains("Address")
                                  ? TextInputType.streetAddress
                                  : widget.title.contains("Email")
                                      ? TextInputType.emailAddress
                                      : TextInputType.text,
                          onChanged: (widget.callback == null)
                              ? null
                              : (widget.callback != null &&
                                      widget.imageInput != null)
                                  ? (value) {
                                      _onChangeHandler(value);
                                    }
                                  : (value) {
                                      widget.callback(value);
                                    },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
