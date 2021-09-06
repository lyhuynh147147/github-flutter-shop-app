import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/customer/ProfilePage/ChangePassword/change_password_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/input_text.dart';

class ChangePasswordView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  ChangePwdController _controller = new ChangePwdController();
  String currentPwd;
  String newPwd;
  String confirmPwd;
  bool isBtnLoading = true;
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change My Password',
          style: kBoldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            //TODO: Current password
            StreamBuilder(
                stream: _controller.currentPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'Current password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      currentPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: 6,
            ),
            //TODO: New password
            StreamBuilder(
                stream: _controller.newPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'New password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      newPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: 6,
            ),
            //TODO: Confirm new password
            StreamBuilder(
                stream: _controller.confirmPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'Confirm new password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      confirmPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: 10,
            ),
            //TODO: Change password Button
            StreamBuilder(
                stream: _controller.btnLoadingStream,
                builder: (context, snapshot) {
                  return CusRaisedButton(
                    title: 'Save',
                    backgroundColor: kColorBlack,
                    isDisablePress: snapshot.hasData ? snapshot.data : true,
                    onPress: () async {
                      setState(() {
                        isBtnLoading = false;
                      });
                      bool result = await _controller.onChangePwd(
                          currentPwd: currentPwd,
                          newPwd: newPwd,
                          confirmPwd: confirmPwd);
                      print(result);
                      if (result) {
                        setState(() {
                          isBtnLoading = true;
                        });
                        widget._globalKey.currentState.showSnackBar(SnackBar(
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
                                  'Your password has been changed.',
                                  style: kBoldTextStyle.copyWith(
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ));
                      } else {
                        setState(() {
                          isBtnLoading = true;
                        });
                        widget._globalKey.currentState.showSnackBar(SnackBar(
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
                                  'Changed error.',
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
                })
          ],
        ),
      ),
    );
  }
}
