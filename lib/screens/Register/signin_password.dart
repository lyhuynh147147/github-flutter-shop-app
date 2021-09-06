import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/user.dart';
import 'package:phone_verification/screens/Customer/customer_home_view.dart';
import 'package:phone_verification/screens/Register/phoneIn/phone_in.dart';
import 'package:phone_verification/screens/phone/loginScreens.dart';
import 'package:phone_verification/screens/phone/registerScreen.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';

import '../phone/loggedInScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SignInPassword extends StatefulWidget {
  @override
  _SignInPasswordState createState() => _SignInPasswordState();
}

class _SignInPasswordState extends State<SignInPassword> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPwdController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  AnimationController controller1;
  AnimationController controller2;
  Animation<double> animation1;
  Animation<double> animation2;
  Animation<double> animation3;
  Animation<double> animation4;

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';
  bool isShowPassword = false;
  bool isShowConfPwd = false;

  //Form controllers
  @override
  void initState() {

    controller1 =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });
    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    controller2 =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation3 = Tween<double>(begin: .45, end: .4).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    Timer(Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
    ///

    super.initState();
    isShowPassword = true;
    isShowConfPwd = true;
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();

    // Clean up the controller when the Widget is disposed
    passwordController.dispose();
    confirmPwdController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  registerScreen();
  }

  Widget registerScreen() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                brightness: Brightness.dark,
                backgroundColor: Colors.white.withOpacity(.01),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //         builder: (ctx) => WelcomeScreen()));
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Nhập mật khẩu',
                  style: TextStyle(
                    fontSize: _width / 17,
                    //color: Colors.white.withOpacity(.7),
                    color: Colors.black.withOpacity(.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: SizedBox(
                height: _height -70,
                child: Stack(
                  children: [
                    Positioned(
                      top: _height * (animation2.value + .6),
                      left: _width * .2,
                      child: CustomPaint(
                        painter: MyPainter(50),
                      ),
                    ),
                    Positioned(
                      top: _height * .98,
                      left: _width * .1,
                      child: CustomPaint(
                        painter: MyPainter(animation4.value - 30),
                      ),
                    ),
                    Positioned(
                      top: _height * .5,
                      left: _width * (animation2.value + .8),
                      child: CustomPaint(
                        painter: MyPainter(30),
                      ),
                    ),
                    Positioned(
                      top: _height * animation3.value,
                      left: _width * (animation1.value + .1),
                      child: CustomPaint(
                        painter: MyPainter(60),
                      ),
                    ),
                    Positioned(
                      top: _height * .1,
                      left: _width * .8,
                      child: CustomPaint(
                        painter: MyPainter(animation4.value),
                      ),
                    ),
                    ///
                    ListView(children: [
                      new Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Container(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 10.0, horizontal: 10.0),
                                  //       child: TextFormField(
                                  //         enabled: !isLoading,
                                  //         controller: nameController,
                                  //         textInputAction: TextInputAction.none,
                                  //         onEditingComplete: () => node.nextFocus(),
                                  //         decoration: InputDecoration(
                                  //           // floatingLabelBehavior: FloatingLabelBehavior.never,
                                  //           labelText: 'Name',
                                  //         ),
                                  //         validator: (value) {
                                  //           if (value.isEmpty) {
                                  //             return 'Please enter a name';
                                  //           }
                                  //         },
                                  //       ),
                                  //     )),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                        child: TextInputFormField(
                                          isPassword: false,
                                          icon: Icons.person_sharp,
                                          labelText: 'Name',
                                          inputAction: TextInputAction.next,
                                          inputType: TextInputType.phone,
                                          onChanged: (value){
                                            nameController.text = value;
                                          },
                                          validator: (value) {
                                            if(value.isEmpty){
                                              return 'Please enter phone number';
                                            }
                                          },
                                        ),
                                      )),
                                  ///
                                  // Container(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 10.0, horizontal: 10.0),
                                  //       child: TextFormField(
                                  //         enabled: !isLoading,
                                  //         controller: passwordController,
                                  //         obscureText: isShowPassword,
                                  //         textInputAction: TextInputAction.none,
                                  //         onEditingComplete: () => node.nextFocus(),
                                  //         decoration: InputDecoration(
                                  //           //floatingLabelBehavior: FloatingLabelBehavior.never,
                                  //           labelText: 'Mật khẩu',
                                  //           suffixIcon: GestureDetector(
                                  //             child: Icon(
                                  //               isShowPassword
                                  //                   ? Icons.remove_red_eye
                                  //                   : Icons.visibility_off,
                                  //             ),
                                  //             onTap: (){
                                  //               setState(() {
                                  //                 isShowPassword = !isShowPassword;
                                  //               });
                                  //             },
                                  //           )
                                  //         ),
                                  //         validator: (value) {
                                  //           if (value.isEmpty) {
                                  //             return 'Please enter a Password';
                                  //           }
                                  //         },
                                  //       ),
                                  //     )),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        child:  TextInputFormField(
                                          isPassword: true,
                                          icon: Icons.lock,
                                          labelText: 'Mật khẩu',
                                          inputAction: TextInputAction.next,
                                          inputType: TextInputType.text,
                                          onChanged: (value){
                                            passwordController.text = value;
                                          },

                                          validator: (value) {
                                            if(value.isEmpty){
                                              return 'Please enter phone number';
                                            }
                                          },
                                        ),
                                      )),
                                  ///
                                  // Container(
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 10.0, horizontal: 10.0),
                                  //       child: TextFormField(
                                  //         enabled: !isLoading,
                                  //         obscureText: isShowConfPwd,
                                  //         //keyboardType: TextInputType.text,
                                  //         controller: confirmPwdController,
                                  //         textInputAction: TextInputAction.done,
                                  //         onFieldSubmitted: (_) => node.unfocus(),
                                  //         decoration: InputDecoration(
                                  //           //hintText: 'Nhập lại mật khẩu',
                                  //           //floatingLabelBehavior: FloatingLabelBehavior.never,
                                  //           labelText: 'Nhập lại mật khẩu',
                                  //           suffixIcon: GestureDetector(
                                  //               child: Icon(
                                  //                 isShowConfPwd
                                  //                     ? Icons.remove_red_eye
                                  //                     : Icons.visibility_off,
                                  //               ),
                                  //               onTap: (){
                                  //                 setState(() {
                                  //                   isShowConfPwd = !isShowConfPwd;
                                  //                 });
                                  //               },
                                  //             ),
                                  //         ),
                                  //         validator: (value) {
                                  //           if (value.isEmpty) {
                                  //             return 'Please Nhập lại mật khẩu';
                                  //           }
                                  //           if (confirmPwdController!= passwordController) {
                                  //             return 'Please Nhập lại mật khẩu không giống nhau';
                                  //           }
                                  //         },
                                  //       ),
                                  //     )),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        child:  TextInputFormField(
                                          isPassword: true,
                                          icon: Icons.lock,
                                          labelText: 'Nhập lại mật khẩu',
                                          inputAction: TextInputAction.next,
                                          inputType: TextInputType.text,
                                          onChanged: (value){
                                            confirmPwdController.text = value;
                                          },

                                          validator: (value) {
                                            if(value.isEmpty){
                                              return 'Please enter phone number';
                                            }
                                            if (confirmPwdController!= passwordController){
                                              return 'Please Nhập lại mật khẩu không giống nhau';
                                            }
                                          },
                                        ),
                                      )),
                                  ///
                                  InkWell(
                                    onTap: () {
                                      //TODO: Add data to database
                                      String createAt = _auth.currentUser.metadata.creationTime.toString();
                                      //String createAts = user.user.uid..metadata.creationTime.toString();
                                      //TODO: encode password
                                      if (passwordController.text != confirmPwdController.text ||
                                          nameController.text == '' ||
                                          passwordController.text =='' || confirmPwdController.text =='') {
                                        if (_formKey.currentState.validate()) {
                                          displaySnackBar('Mật khẩu không giống nhau');
                                          //print('sssssss');
                                        }
                                        displaySnackBar('Vui lòng nhập đầy đủ thông tin!!');
                                        //print('ssss');
                                      } else {
                                        String pwdSha512 = Util.encodePassword(passwordController.text);
                                        FirebaseFirestore
                                            .instance
                                            .collection('Users')
                                            .doc(_auth.currentUser.uid)
                                            .update({
                                          'id': _auth.currentUser.uid,
                                          //'username': email,
                                          'fullname':nameController.text,
                                          'password': pwdSha512,
                                          //'fullname': nameController.text,
                                          'gender': '',
                                          'birthday': '',
                                          //'phone': _auth.currentUser.phoneNumber.toString(),
                                          'address': '',
                                          'create_at': createAt,
                                          'id_scripe': '',
                                          'type': 'customer',
                                        });
                                        Users userInfo = new Users(
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            ''/*createAt*/,
                                            '',
                                            'customer');
                                        StorageUtil.setUid(_auth.currentUser.uid);
                                        //StorageUtil.setFullName(fullName);
                                        /*await*/ StorageUtil.setIsLogging(true);
                                        StorageUtil.setUserInfo(userInfo);
                                        StorageUtil.setAccountType('customer');
                                        //StorageUtil.setPassword(pwdSha512);
                                        //_isBtnLoadingController.sink.add(true);
                                        Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                            builder: (BuildContextcontext) => CustomerHomeView(),),
                                              (route) => false,
                                        );
                                      }

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.black),
                                          ),
                                          margin: EdgeInsets.only(top: 40, bottom: 5),
                                          child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Center(
                                                child: Text(
                                                    'Tiếp theo'
                                                ),
                                              ))),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ])
                  ],
                ),
              ),
            )
        ),
    );
  }
  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
