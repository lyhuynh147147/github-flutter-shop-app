import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';


class DashboardCard extends StatelessWidget {
  DashboardCard(
      {this.title = '',
      this.value = '',
      this.icon = Icons.title,
      this.color = kColorWhite,
      this.onPress});
  final String title;
  final IconData icon;
  final String value;
  final Color color;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 7),
      child: Container(
        height: 90,
        child: RaisedButton(
          //TODO: Navigator
          onPressed: () {
            onPress();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: kColorWhite,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7),
            child: Row(
              children: <Widget>[
                // TODO: Revenue
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        title,
                        style: kBoldTextStyle.copyWith(
                            fontSize: 18, color: color),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //TODO: Revenue
                      AutoSizeText(
                        value,
                        style: kBoldTextStyle.copyWith(
                            fontSize: 25),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                //TODO: Icon
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 9),
                        child: Icon(
                          icon,
                          color: kColorWhite,
                          size: 20,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
