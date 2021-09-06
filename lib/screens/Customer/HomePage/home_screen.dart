import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/bodys.dart';
import 'package:phone_verification/screens/Customer/SearchPage/search_view.dart';

import 'home/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      //appBar: buildAppBar(context),
      body: Bodys(),
    );
  }
/*Categories(),*/
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Colors.black87,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: Colors.black87,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (ctx) => SearchView()));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.black87,
            //color: Color(0xfff4cce8),
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'customer_cart_page');
          },
        ),
        SizedBox(width: kDefaultPaddin / 2),
      ],
    );
  }
}