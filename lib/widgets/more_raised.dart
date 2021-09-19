import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class MoreRaised extends StatefulWidget {
  MoreRaised(
      {this.backgroundColor,
        @required this.title,
        this.onPress,
        this.width = 650,
        this.height = 80,
        this.isDisablePress = true, this.icon});

  final Color backgroundColor;
  final String title;
  final Function onPress;
  final double width;
  final IconData icon;
  final double height;
  final bool isDisablePress;
  @override
  _MoreRaisedState createState() => _MoreRaisedState();
}

class _MoreRaisedState extends State<MoreRaised> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      height: widget.height,
      minWidth: widget.width,
      color: widget.backgroundColor,
      child: widget.isDisablePress
          ? Row(
        children: [
          Icon(
            widget.icon,
            size: 22,
            color: Colors.redAccent,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text(
            widget.title,
            style: TextStyle(
                fontSize: 16,
                color: (widget.backgroundColor == kColorBlack)
                    ? kColorWhite
                    : Colors.black54),
          ),),
          Icon(
            Icons.arrow_forward_ios,
            size: 22,
            color: Colors.black,
          ),
        ],
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
