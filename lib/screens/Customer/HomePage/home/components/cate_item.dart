import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class CateItem extends StatelessWidget {
  CateItem({this.title, this.onTap, this.height = 80});

  final String title;
  final Function onTap;
  final double height;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: height,
        width: 380,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kColorBlack.withOpacity(0.1),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 12,
              left: 25),
          child: Text(
            title,
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
