import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class ColorPicker extends StatelessWidget {
  ColorPicker({
    this.isCheck = false,
    this.onTap,
    this.color
  });
  final bool isCheck;
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 27,
        width: 27,
        decoration: BoxDecoration(
            border: (color == kColorWhite)
                ? Border.all(color: kColorBlack, width: 1)
                : Border.all(color: isCheck ? kColorBlack : color, width: 2),
            borderRadius: BorderRadius.circular(180),
            color: color),
        child: Center(
            child: isCheck
                ? Icon(
              Icons.check,
              size: 17,
              color: (color == kColorBlack) ? kColorWhite : kColorBlack,
            )
                : null),
      ),
    );
  }
}
