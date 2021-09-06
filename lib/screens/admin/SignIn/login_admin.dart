import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/screens/customer/customer_home_view.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/phone/registerScreen.dart';
import 'package:phone_verification/widgets/pallete.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginAdmin extends StatefulWidget {
  LoginAdmin({Key key}) : super(key: key);

  @override
  _LoginAdminState createState() => _LoginAdminState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();
class _LoginAdminState extends State<LoginAdmin> {


  //final TextEditingController otpC = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';


  bool isShowPassword = false;

  //Form controllers
  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    isShowPassword = true;
    if (_auth.currentUser != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>CustomerHomeView(),
        ), (route) => false,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    //phoneController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _loginFormLoading = false;
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Thông báo"),
            content: Container(
              child: Text(
                "Tài khoản - mật khẩu không đúng.",
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Đóng"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  UserCredential authResult;
  Future<String> _loginAccount() async {
    try {
      authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text);

    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });

    String _loginFeedback = await _loginAccount();
    //
    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      setState(() {
        _loginFormLoading = true;
      });
    } else {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (ctx)=> AdminPage(),
      //   ),
      // );
      Navigator.pushNamed(context, 'admin_home_screen');
    }
  }

  FocusNode _passwordFocusNode;
  void vaildation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mời nhập tài khoản mật khẩu "),
        ),
      );
    } else if (email.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mời nhập Email "),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập Email hợp lệ "),
        ),
      );
    } else if (password.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mời nhập mật khẩu "),
        ),
      );
    } else if (password.text.length < 6) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Mật khẩu quá ngắn "),
        ),
      );
    } else {
      _submitForm();
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return returnLoginScreen();
  }



  Widget returnLoginScreen() {
    return Stack(
      children: [
        /*BackgroundImage(
          image: 'assets/images/login_bg.png',
        ),*/
        Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Text('Admin'),
            backgroundColor: kBackgroundColor,
          ),
          //backgroundColor: kBackgroundColor,
          body: ListView(children: [
            new Column(
              children: [
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TextInputFormField(
                              isPassword: false,
                              icon: Icons.person,
                              hint: 'Tài khoản',
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.phone,
                              onChanged: (value) {
                                email.text = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: TextInputFormField(
                              isPassword: true,
                              icon: Icons.vpn_key,
                              hint: 'Mật khẩu',
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.text,
                              onChanged: (value) {
                                password.text = value;
                              },

                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Text(
                                    'Forgot your password ?',
                                    style: TextStyle(color: Colors.blue),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () {

                                  },
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //           vertical: 10.0, horizontal: 10.0),
                          //       child: TextFormField(
                          //         //enabled: !isLoading,
                          //         obscureText: isShowPassword,
                          //         controller: passwordController,
                          //         keyboardType: TextInputType.text,
                          //         decoration: InputDecoration(
                          //             labelText: 'Password',
                          //             suffixIcon: GestureDetector(
                          //               child: Icon(
                          //                 isShowPassword
                          //                     ? Icons.remove_red_eye
                          //                     : Icons.visibility_off,
                          //               ),
                          //               onTap: (){
                          //                 setState(() {
                          //                   isShowPassword = !isShowPassword;
                          //                 });
                          //               },
                          //             )
                          //         ),
                          //         validator: (value) {
                          //           if (value.isEmpty) {
                          //             return 'Please enter password';
                          //           }
                          //         },
                          //       ),
                          //     )),
                          Container(
                              margin: EdgeInsets.only(top: 20, bottom: 5),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: !isLoading
                                      ? new InkWell(
                                    onTap: () async {
                                      /*if (!isLoading) {
                                        if (_formKey.currentState.validate()) {
                                          *//*displaySnackBar('Please wait...');
                                          await login();*//*
                                        }
                                      }*/
                                      vaildation();
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          border: Border.all(
                                              color: Colors.black),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          horizontal: 15.0,
                                        ),
                                        child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(
                                                  "Sign In",
                                                  textAlign: TextAlign.center,
                                                )),
                                          ],
                                        )),
                                  )
                                      : CircularProgressIndicator())),
                          Container(
                              margin: EdgeInsets.only(top: 15, bottom: 5),
                              alignment: AlignmentDirectional.center,
                              child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            "No Account ?",
                                          )),
                                      InkWell(
                                        child: Text(
                                          'Sign up',
                                        ),
                                        onTap: () =>
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterScreen()))
                                        },
                                      ),
                                    ],
                                  ))),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    child: Text(
                                      'Forgot your password ?',
                                      style: TextStyle(color: Colors.blue),
                                      textAlign: TextAlign.right,
                                    ),
                                    onTap: () =>
                                    {
                                      /*Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => SignInView()))*/
                                    }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ]),
        ),
      ],
    );
  }
}