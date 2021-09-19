import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key key,
    @required this.title, this.onPress, this.backgroundColor, this.width, this.height, this.isDisablePress,
  }) : super(key: key);

  final Color backgroundColor;
  final Function onPress;
  final String title;
  final double width;
  final double height;
  final bool isDisablePress;

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
     /* height: widget.height,
      minWidth: widget.width,*/
      //color: widget.backgroundColor,
      onPressed : () {
        if (widget.isDisablePress) {
          widget.onPress();
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          color: widget.backgroundColor
        ),
        child: widget.isDisablePress
            ? Center(
              child: Text(
          widget.title,
          style: TextStyle(
              fontSize: 16,
              color: (widget.backgroundColor == kColorBlack)
                  ? kColorWhite
                  :kColorBlack,
              // height: 1.5,
          ),
        ),
            ) : CircularProgressIndicator(
          backgroundColor: kColorWhite,
        ),
      ),
    );
  }
}