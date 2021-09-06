import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/admin/SignIn/sign_in_controller.dart';
import 'package:phone_verification/widgets/rounded_button.dart';
import 'package:phone_verification/widgets/text_field_input.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isAdmin = false;
  SignInController signInController = new SignInController();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //TODO: Username
        StreamBuilder(
          stream: signInController.emailStream,
          builder: (context, snapshot) => TextInputField(
            icon: Icons.person,
            inputAction: TextInputAction.done,
            hintText: 'Email',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _email = value;
            },
          ),
        ),
        SizedBox(
          height: 9,
        ),
        //TODO: Password
        StreamBuilder(
          stream: signInController.passwordStream,
          builder: (context, snapshot) => TextInputField(
            inputAction: TextInputAction.done,
            icon: Icons.person,
            hintText: 'Password',
            isPassword: true,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        //TODO: Button Sign In
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //TODO: Admin
            Container(
              height: 25,
              child: MaterialButton(
                height: 25,
                color: _isAdmin ? kColorBlack : kColorWhite,
                child: Text(
                  'MANAGER',
                  style: TextStyle(
                      color: _isAdmin ? kColorWhite : kColorBlack,
                      fontSize: 15),
                ),
                onPressed: () {
                  setState(() {
                    _isAdmin = true;
                  });
                },
              ),
            ),
            //TODO: Customer
            Container(
              height: 25,
              child: MaterialButton(
                height: 45,
                color: _isAdmin ? kColorWhite : kColorBlack,
                child: Text(
                  'CUSTOMER',
                  style: TextStyle(
                      color: _isAdmin ? kColorBlack : kColorWhite,
                      fontSize: 15),
                ),
                onPressed: () {
                  setState(() {
                    _isAdmin = false;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
            stream: signInController.btnLoadingStream,
            builder: (context, snapshot) {
              return RoundedButton(
                backgroundColor: kColorBlack,
                title: 'SIGN IN',
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                onPress: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  var result = await signInController.onSubmitSignIn(
                      email: _email, password: _password, isAdmin: _isAdmin);
                  print('Screen' + result.toString());
                  Navigator.pushNamed(context, result);
                  if (result != '') {
                    Navigator.pushNamed(context, result);
                    SignInController().dispose();
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: kColorWhite,
                      content: Row(
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: kColorRed,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Sign In failed.',
                              style: kBoldTextStyle.copyWith(
                                  fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ));
                  }
                },
              );
            }),
      ],
    );
  }
}
