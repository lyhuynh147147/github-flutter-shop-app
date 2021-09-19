import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/user.dart';
import 'package:phone_verification/screens/Register/phoneIn/phone_in.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/Register/signin_password.dart';
import 'package:phone_verification/widgets/pallete.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class PhoneUp extends StatefulWidget {
  PhoneUp({Key key}) : super(key: key);

  @override
  _PhoneUpState createState() => _PhoneUpState();
}

class _PhoneUpState extends State<PhoneUp>  with TickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController countryController = new TextEditingController(text: '+84');
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
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
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return isOTPScreen ? returnOTPScreen() : registerScreen();
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
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: _width / 17,
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
                  Column(
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      child: TextFormField(
                                        autofocus: true,
                                        style: kBodyText.copyWith(color: Colors.black),
                                        //maxLength: null,
                                        textInputAction: TextInputAction.next,
                                        controller: countryController,
                                        enabled: !isLoading,
                                        decoration: InputDecoration(
                                          hintText: 'Country',
                                          counterText: ' ',
                                          icon: Icon(
                                            Icons.phone_android,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TextInputFormField(
                                      isPassword: false,
                                      maxLength: 10,
                                      hint: 'Số điện thoại',
                                      inputAction: TextInputAction.next,
                                      inputType: TextInputType.phone,
                                      onChanged: (value){
                                        phoneController.text = value;
                                      },
                                      validator: (value) {
                                        if(value.isEmpty){
                                          return 'Please enter phone number';
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 5),
                                  child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: new InkWell(
                                        onTap: () {
                                          print(phoneController);
                                          if (!isLoading) {
                                            if (_formKey.currentState.validate()) {
                                              // If the form is valid, we want to show a loading Snackbar
                                              setState(() {
                                                signUp();
                                                isRegister = false;
                                                isOTPScreen = true;
                                              });
                                            }
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                                            child: InkWell(
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              child: Container(
                                                height: _width / 8,
                                                width: _width ,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(.05),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(color: Colors.black),
                                                ),
                                                child: Text(
                                                  'Đăng ký',
                                                  style: TextStyle(color: Colors.white.withOpacity(.8)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget returnOTPScreen() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
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
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: _width / 17,
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
                    Form(
                      key: _formKeyOTP,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Text(
                                      !isLoading
                                          ? "Mã xác minh sẽ được gửi qua tin nhắn SMS đến"
                                          : "Mã xác minh đã được gữi qua SMS",
                                      textAlign: TextAlign.center))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '(${countryController.text.trim()})'+' '+phoneController.text.trim(),
                                style: TextStyle(
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ///
                          !isLoading
                              ? Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: otpField(),
                                ),
                              ))
                              : Container(),
                          ///
                          !isLoading
                              ? Container(
                              margin: EdgeInsets.only(top: 40, bottom: 5),
                              child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: new InkWell(
                                    onTap: () async {
                                      print(otpController);
                                      if (_formKeyOTP.currentState.validate()) {
                                        // If the form is valid, we want to show a loading Snackbar
                                        // If the form is valid, we want to do firebase signup...
                                        setState(() {
                                          isResend = false;
                                          isLoading = true;
                                        });
                                        try {
                                          await _auth.signInWithCredential(
                                              PhoneAuthProvider.credential(
                                                  verificationId: verificationCode,
                                                  smsCode: otpController.text.toString()))
                                              .then((user) async => {
                                            //sign in was success
                                            if (user != null)
                                              {
                                                //store registration details in firestore database
                                                await _firestore
                                                    .collection('Users')
                                                    .doc(
                                                    _auth.currentUser.uid)
                                                    .set(
                                                    {
                                                      //'name': nameController.text.trim(),
                                                      'phone': phoneController.text.trim(),
                                                    },
                                                    SetOptions(merge: true)).then((value) => {
                                                  //then move to authorised area
                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  })
                                                }),
                                                setState(() {
                                                  isLoading = false;
                                                  isResend = false;

                                                }),
                                                Navigator.pushAndRemoveUntil(context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContextcontext) => SignInPassword(),
                                                  ),
                                                      (route) => false,
                                                )
                                              }
                                          }).catchError((error) => {
                                            setState(() {
                                              isLoading = false;
                                              isResend = true;
                                            }),
                                          });
                                          setState(() {
                                            isLoading = true;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: new Container(
                                      // decoration: BoxDecoration(
                                      //     color: Color(0xffff9601),
                                      //     borderRadius: BorderRadius.circular(15)),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.05),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: 15.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Expanded(
                                            child: Text(
                                              "Tiếp tục",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )))
                              : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      backgroundColor:
                                      Theme.of(context).primaryColor,
                                    )
                                  ].where((c) => c != null).toList(),
                                )
                              ]),
                          isResend
                              ? Container(
                              margin: EdgeInsets.only(top: 40, bottom: 5),
                              child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: new InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isResend = false;
                                        isLoading = true;
                                      });
                                      await signUp();
                                    },
                                    child: new Container(
                                      // decoration: BoxDecoration(
                                      //     color: Color(0xffff9601),
                                      //     borderRadius: BorderRadius.circular(15)),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.05),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: 15.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Expanded(
                                            child: Text(
                                              "Gửi lại",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )))
                              : Column(),


                        ],
                      ),
                    )
                  ])
                ],
              ),
            ),
          )
      ),
    );
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    //UserCredential user;

    //TODO: Add data to database
    //String createAt = user.user.metadata.creationTime.toString();
    //TODO: encode password
    //String pwdSha512 = Util.encodePassword(password);
    debugPrint('Gideon test 1');
    var phoneNumber = /*'+' +*/ countryController.text.toString() + phoneController.text.toString();
    debugPrint('Gideon test 2');
    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        debugPrint('Gideon test 3');
        //auto code complete (not manually)
        _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
          if (user != null)
            {
              //store registration details in firestore database
              await _firestore
                  .collection('Users')
                  .doc(_auth.currentUser.uid)
                  .set({
                //'name': nameController.text.trim(),
                'phone': phoneController.text.trim()
              }, SetOptions(merge: true))
                  .then((value) => {
                //then move to authorised area
                setState(() {
                  isLoading = false;
                  isRegister = false;
                  isOTPScreen = false;

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


                  //navigate to is
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoggedInScreen(),
                    ),
                        (route) => false,
                  );
                  return true;
                })
              })
                  .catchError((onError) => {
                debugPrint(
                    'Error saving user to db.' + onError.toString())
              })
            }
        });
        debugPrint('Gideon test 4');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Gideon test 5' + error.message);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        debugPrint('Gideon test 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Gideon test 7');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
    debugPrint('Gideon test 7');
    await verifyPhoneNumber;
    debugPrint('Gideon test 8');
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 60,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        focusBorderColor: Colors.black,
      ),
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 18, color: Colors.black),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          otpController.text = pin;
        });
      },
    );
  }
}
