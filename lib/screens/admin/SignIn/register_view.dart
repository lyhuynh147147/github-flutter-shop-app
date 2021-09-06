import 'package:flutter/material.dart';
import 'package:phone_verification/screens/admin/SignIn/sign_in_form.dart';
import 'package:phone_verification/widgets/background_image.dart';
import 'package:phone_verification/widgets/button_raised.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSignIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          // BackgroundImage(
          //   image: 'assets/images/welcome_wall.jpg',
          // ),
          IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 25,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              _isSignIn ? 'Đăng Nhập' : 'Đăng Ký',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SignInView(),
                              //: //SignUpView(typeAccount: 'customer',),
                          SizedBox(
                            height: 10,
                          ),
                          //TODO: Button Change SignIn <-> SignUp
                          CusRaisedButton(
                            backgroundColor: Colors.grey.shade100,
                            title: _isSignIn ? 'REGISTER' : 'SIGN IN',
                            onPress: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}