import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

import '../link.dart';


class CustomBanner extends StatelessWidget {
  CustomBanner({this.title, this.description, this.onPress, this.image});

  final String title;
  final String description;
  final String image;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(KImageAddress + image),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 42,
                  color: kColorWhite,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: kColorWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kColorWhite, width: 2)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 30),
                child: Text('View',
                    style: TextStyle(
                        fontSize: 20,
                        color: kColorWhite,
                        fontWeight: FontWeight.w900)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
