import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class BoxInfo extends StatelessWidget {
  BoxInfo({this.sizeProduct, this.color = kColorWhite, this.size = 50});

  bool isTextBox;
  final Color color;
  final String sizeProduct;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (sizeProduct == null) {
      isTextBox = false;
    } else
      isTextBox = true;
    return Container(
      height: size,
      width: size + 20,
      /*decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kColorBlack.withOpacity(0.5)),
      ),*/
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kColorBlack.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(size),
            color:  isTextBox ? kColorWhite : color,
          ),
          //color: isTextBox ? kColorWhite : color,
          child: Center(
            child: isTextBox
                ? AutoSizeText(
                    sizeProduct,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kColorBlack),
                    minFontSize: 5,
                  )
                : Text(''),
          ),
        ),
      ),
    );
  }
}
