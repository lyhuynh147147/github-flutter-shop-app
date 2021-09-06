import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class AdminAddingAccount extends StatefulWidget {
  @override
  _AdminAddingAccountState createState() => _AdminAddingAccountState();
}

class _AdminAddingAccountState extends State<AdminAddingAccount> {
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Adding User',
          style: TextStyle(
              color: kColorBlack,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
       centerTitle: true,
      ),
      body: Container(
        /*decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),*/
        color: Colors.grey[500],
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 25,
          ),
          // child: SignUpView(
          //   typeAccount: 'admin',
          // ),
        ),
      ),
    );
  }
}
