import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/widgets/widget_title.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    Key key,
    this.id,
    this.isAdmin = false,
    this.username = '',
    this.fullname = '',
    this.phone = '',
    this.createAt = '',
  }) : super(key: key);
  final String id;
  final String fullname;
  final String username;
  final String phone;
  final String createAt;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: isAdmin ? Colors.red[200] : Colors.lightBlueAccent,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 5),
                    child: Text(
                      isAdmin ? 'ADMIN' : 'CUSTOMER',
                      style: kBoldTextStyle.copyWith(
                        fontSize: 16,
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ),
              ),
              //TODO: id
              TitleWidget(
                title: 'ID',
                content: id,
                isSpaceBetween: false,
              ),
              //TODO: Username
              TitleWidget(
                title: 'Username',
                content: username,
                isSpaceBetween: false,
              ),
              //TODO: full name
              TitleWidget(
                title: 'Full name',
                content: fullname,
                isSpaceBetween: false,
              ),
              //TODO: phone number
              TitleWidget(
                title: 'Phone number',
                content: phone,
                isSpaceBetween: false,
              ),
              //TODO: Create at
              TitleWidget(
                title: 'Create at',
                content: createAt,
                isSpaceBetween: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
