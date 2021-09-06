import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class CusRaisedButton extends StatefulWidget {
  CusRaisedButton(
      {this.backgroundColor,
      @required this.title,
      this.onPress,
      this.width = 650,
      this.height = 80,
      this.isDisablePress = true});

  final Color backgroundColor;
  final String title;
  final Function onPress;
  final double width;
  final double height;
  final bool isDisablePress;
  @override
  _CusRaisedButtonState createState() => _CusRaisedButtonState();
}

class _CusRaisedButtonState extends State<CusRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: widget.height,
      minWidth: widget.width,
      color: widget.backgroundColor,
      child: widget.isDisablePress
          ? Text(
              widget.title,
              style: TextStyle(
                  fontSize: 14,
                  color: (widget.backgroundColor == kColorBlack)
                      ? kColorWhite
                      : kColorBlack),
            )
          : CircularProgressIndicator(
              backgroundColor: kColorWhite,
            ),
      onPressed: () {
        if (widget.isDisablePress) {
          widget.onPress();
        }
      },
    );
  }
}
