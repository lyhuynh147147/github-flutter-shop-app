import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class ButtonTap extends StatelessWidget {
  ButtonTap({this.text, this.isSelected = false, this.function});
  final text;
  final isSelected;
  final function;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: function,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? kColorWhite : null,
          border: isSelected ? null : Border.all(color: kColorWhite),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : kColorWhite,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
