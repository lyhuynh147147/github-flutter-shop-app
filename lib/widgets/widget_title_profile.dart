import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class TitleWidgetProfile extends StatelessWidget {
  TitleWidgetProfile({this.title = '', this.content = '', this.isSpaceBetween = true});

  final String title;
  final String content;
  final bool isSpaceBetween;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: isSpaceBetween
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: AutoSizeText(
                title,
                maxLines: 1,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                    fontSize: 18, color: kColorBlack.withOpacity(0.6)),
              ),
            ),
            Expanded(
              flex: 8,
              child: AutoSizeText(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                    fontSize: 18, color: kColorBlack),
              ),
            ),
          ],
        ),
      )
    );
  }
}


