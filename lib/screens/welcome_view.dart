import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/screens/phone/loginScreens.dart';
import 'package:phone_verification/widgets/button_tap.dart';
import 'package:phone_verification/widgets/icon_instacop.dart';

import '../link.dart';
import 'Register/phoneIn/phone_in.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth _auth;

  User _user;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;

  }


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(KImageAddress + 'welcome_wall.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.3),
                  Colors.black.withOpacity(.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10,10,10,45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: IconInstacop(
                      textSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // new ButtonTap(
                  //   text: 'Sign Up / Sign In',
                  //   isSelected: true,
                  //   function: () {
                  //     Navigator.pushNamed(context, 'register_screen');
                  //     //Navigator.pushNamed(context, 'login_screen');
                  //
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  new ButtonTap(
                    text: "Start Browsing",
                    isSelected: false,
                    function: () {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    },
                  ),
                  new ButtonTap(
                    text: "Phone",
                    isSelected: false,
                    function: () {
                      StorageUtil.clear();
                      signOut();
                      // Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(
                      //         builder: (ctx) => LoginScreens()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  signOut() {
    //redirect
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => PhoneIn())));
  }
}
