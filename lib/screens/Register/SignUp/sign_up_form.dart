import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/Register/SignUp/sign_up_controller.dart';
import 'package:phone_verification/widgets/rounded_button.dart';
import 'package:phone_verification/widgets/text_field_input.dart';


class SignUpView extends StatefulWidget {
  SignUpView({this.typeAccount});
  final String typeAccount;
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<String> gender = ['Male', 'Female'];
  String genderData = 'Choose Gender';

  bool _isRegisterLoading = true;
  SignUpController signUpController = new SignUpController();

  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPwd = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // TODO: Full Name
        StreamBuilder(
          stream: signUpController.fullNameStream,
          builder: (context, snapshot) => TextInputField(
            icon: FontAwesomeIcons.user,
            hintText: 'Full Name',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _fullName = value;
            },
          ),
        ),
        SizedBox(
          height: 14,
        ),
        //TODO: phone number
        StreamBuilder(
          stream: signUpController.phoneStream,
          builder: (context, snapshot) => TextInputField(
            icon: FontAwesomeIcons.phoneAlt,
            hintText: 'Phone number',
            inputType: TextInputType.number,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _phone = value;
            },
          ),
        ),
        SizedBox(
          height: 14,
        ),
        //TODO: email
        StreamBuilder(
          stream: signUpController.emailStream,
          builder: (context, snapshot) => TextInputField(
            icon: FontAwesomeIcons.envelope,
            hintText: 'Email',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _email = value;
            },
          ),
        ),

        SizedBox(
          height: 14,
        ),
        //TODO: Password
        StreamBuilder(
          stream: signUpController.passwordStream,
          builder: (context, snapshot) => TextInputField(
            icon: FontAwesomeIcons.lock,
            hintText: 'Password',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        SizedBox(
          height: 14,
        ),
        //TODO: Confirm Password
        StreamBuilder(
          stream: signUpController.confirmPwdSteam,
          builder: (context, snapshot) => TextInputField(
            icon: FontAwesomeIcons.lock,
            hintText: 'Confirm',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _confirmPwd = value;
            },
          ),
        ),
        SizedBox(
          height:12,
        ),
        StreamBuilder(
            stream: signUpController.btnLoadingStream,
            builder: (context, snapshot) {
              return RoundedButton(
                backgroundColor: kColorBlack,
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                title: 'REGISTER',
                height: 50,
                onPress: () async {
                  bool result = await signUpController.onSubmitRegister(
                      fullName: _fullName,
                      phone: _phone,
                      email: _email,
                      password: _password,
                      confirmPwd: _confirmPwd,
                      typeAccount: widget.typeAccount);
                  if (result) {
                    if (widget.typeAccount == 'customer') {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: kColorWhite,
                        content: Row(
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: kColorGreen,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'Adding User Complete',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
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
                              'Sign Up failed.',
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
