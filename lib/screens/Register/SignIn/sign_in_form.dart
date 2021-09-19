import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/model/user.dart';
import 'package:phone_verification/screens/Register/SignIn/sign_in_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/rounded_button.dart';
import 'package:phone_verification/widgets/text_field_input.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
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
            icon: FontAwesomeIcons.envelope,
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
            icon: FontAwesomeIcons.lock,
            hintText: 'Password',
            isPassword: true,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
            stream: signInController.btnLoadingStream,
            builder: (context, snapshot) {
              return RoundedButton(
                backgroundColor: Colors.white.withOpacity(.05),
                title: 'SIGN IN',
                height: 50,
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                onPress: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  var result = await signInController.onSubmitSignIn(
                      email: _email, password: _password,/* isAdmin: _isAdmin,*/);
                  print('Screen ' + result.toString());


                  if (result !='') {
                    Navigator.pushNamed(context, result);
                  } else {
                    print('object');
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
