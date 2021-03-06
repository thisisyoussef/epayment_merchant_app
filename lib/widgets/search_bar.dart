import 'package:flutter/material.dart';
import 'package:strykepay_merchant/values/colors.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
    this.callback,
  }) : super(key: key);
  final Function callback;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 8, top: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Search",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                color: AppColors.accentElement,
                letterSpacing: 0.8,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Container(
          width: 327,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(color: AppColors.accentElement),
            color: const Color(0x34ffffff),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: AppColors.accentElement,
            textAlign: TextAlign.center,
            onChanged: (value) {
              widget.callback(value);
            },
          ),
        ),
      ],
    );
  }
}
