import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({this.title = '', this.content = '', this.isSpaceBetween = true});

  final String title;
  final String content;
  final bool isSpaceBetween;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 12),
      child: Row(
        mainAxisAlignment: isSpaceBetween
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: AutoSizeText(
              title,
              maxLines: 1,
              minFontSize: 10,
              style: kBoldTextStyle.copyWith(
                  fontSize: 15, color: kColorBlack.withOpacity(0.6)),
            ),
          ),
          Expanded(
            flex: 7,
            child: AutoSizeText(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              style: kBoldTextStyle.copyWith(
                  fontSize: 15, color: kColorBlack),
            ),
          ),
        ],
      ),
    );
  }
}
