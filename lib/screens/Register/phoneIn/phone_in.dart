import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/user.dart';
import 'package:phone_verification/screens/Register/phoneUp/phone_up.dart';
import 'package:phone_verification/screens/customer/customer_home_view.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/welcome_view.dart';
import 'package:phone_verification/widgets/pallete.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';




final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class PhoneIn extends StatefulWidget {
  PhoneIn({Key key}) : super(key: key);

  @override
  _PhoneInState createState() => _PhoneInState();
}

class _PhoneInState extends State<PhoneIn> with TickerProviderStateMixin{
  AnimationController controller1;
  AnimationController controller2;
  Animation<double> animation1;
  Animation<double> animation2;
  Animation<double> animation3;
  Animation<double> animation4;

  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController countryController = new TextEditingController(text: '+1');
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';
  bool isShowPassword = false;

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
    isShowPassword = true;

    if (_auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoggedInScreen(),
          ), (route) => false,
        );
      }
    super.initState();
  }

  @override
  void dispose() {

    controller1.dispose();
    controller2.dispose();

    // Clean up the controller when the Widget is disposed
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();

  }
  ///
  Widget component1(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    double _width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 15,
          sigmaX: 15,
        ),
        child: Container(
          height: _width / 8,
          width: _width / 1.2,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: _width / 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white.withOpacity(.8)),
            cursorColor: Colors.white,
            obscureText: isPassword,
            keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(.7),
              ),
              border: InputBorder.none,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle:
              TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget component2(
      String string, double width, VoidCallback voidCallback) {
    double _width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: voidCallback,
          child: Container(
            height: _width / 8,
            width: _width / width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              string,
              style: TextStyle(color: Colors.white.withOpacity(.8)),
            ),
          ),
        ),
      ),
    );
  }
  ///
  Widget returnLoginScreen() {
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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (ctx) => WelcomeScreen()));
                  },
                ),
                title: Text(
                  'Đăng Nhập',
                  style: TextStyle(
                    fontSize: _width / 17,
                    color: Colors.black.withOpacity(.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Settings',
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon:
                    Icon(
                      Icons.settings,
                      color: Colors.white.withOpacity(.02),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'register_screen');
                    },
                  ),
                  Text(''  ''),
                ],
              ),
            ),
          ),
        ),
      backgroundColor: Colors.grey.shade700,
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
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(top: _height * .1),
                        child: Text(
                          'APP NAME',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            wordSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      style: kBodyText.copyWith(color: Colors.black),
                                      textInputAction: TextInputAction.next,
                                      controller: countryController,
                                      enabled: !isLoading,
                                      decoration: InputDecoration(
                                        hintText: 'Mã vùng',
                                        labelStyle: TextStyle(fontSize: 20),
                                        counterText: ' ',
                                        icon: Icon(
                                          Icons.phone_android,
                                        ),
                                      ),
                                      validator: (value) {
                                        if(value.isEmpty){
                                          return 'Please enter country number';
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 12,
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

                                ],
                              ),
                              /**/
                              Container(
                                child: TextInputFormField(
                                  isPassword: true,
                                  icon: Icons.vpn_key,
                                  hint: 'Mật khẩu',
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
                              ),
                              ///
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 5, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        'Forgot your password ?',
                                        style: TextStyle(color: Colors.blue),
                                        textAlign: TextAlign.right,
                                      ),
                                      onTap: (){

                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 5),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: !isLoading
                                          ? new InkWell(
                                        onTap: () async {
                                          if (!isLoading) {
                                            if (_formKey.currentState.validate()) {displaySnackBar('Please wait...');
                                            await login();
                                            }
                                          }},
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                                            child: InkWell(
                                              highlightColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              //onTap: voidCallback,
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
                                                  'Đăng Nhập',
                                                  style: TextStyle(color: Colors.white.withOpacity(.8)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ) : CircularProgressIndicator())),
                              ///
                            ],
                          ),
                        )),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          component2(
                            'Create a new Account',
                            2, () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => PhoneUp()));
                            },
                          ),
                          SizedBox(height: _height * .05),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget returnOTPScreen() {
    var pwdSha512 = Util.encodePassword(passwordController.text);
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
                  ' Nhập mã xác nhận',
                  style: TextStyle(
                    fontSize: _width / 17,
                    //color: Colors.white.withOpacity(.7),
                    color: Colors.black.withOpacity(.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),),
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
                            height: 30,
                          ),
                          Container(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                child: Text(
                                  !isLoading
                                      ? "Mã xác minh sẽ được gửi qua tin nhắn SMS đến"
                                      : "Mã xác minh đã được gữi qua SMS",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ),
                          ///
                          !isLoading
                              ? Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                              child: otpField(),
                            ),)
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
                                                smsCode: otpController.text.toString()),)
                                              .then((user) async => {
                                            //sign in was success
                                            if (user != null)
                                              {
                                                //store registration details in firestore database
                                                setState(() {
                                                  isLoading = false;
                                                  isResend = false;

                                                              var phoneNumber = /*'+'*/ countryController.text.trim() + phoneController.text.trim();

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
                                                  StorageUtil.setFullName(phoneNumber);
                                                  /*await*/ StorageUtil.setIsLogging(true);
                                                  StorageUtil.setUserInfo(userInfo);
                                                  StorageUtil.setAccountType('customer');
                                                  StorageUtil.setPassword(pwdSha512);
                                                  //_isBtnLoadingController.sink.add(true);
                                                }),
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContextcontext) => CustomerHomeView(),
                                                  ),
                                                      (route) => false,
                                                )
                                              }
                                          })
                                              .catchError((error) => {
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
                                      await login();
                                    },
                                    child: new Container(
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
                              : Column()
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

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = /*'+'*/ countryController.text.trim() + phoneController.text.trim();

    var isValidUser = false;
    var number = phoneController.text.trim();

    var pwdSha512 = Util.encodePassword(passwordController.text);

    ///

    await _firestore
        .collection('Users')
        .where('phone', isEqualTo: number)
        .where('password',isEqualTo: pwdSha512)
        .get()
        .then((result ) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });
    if (isValidUser) {
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
            if (user != null)
              {
                setState(() async {
                  isLoading = false;
                  isOTPScreen = false;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CustomerHomeView(),
                    ),
                        (route) => false,
                  );
                  return true;
                }),

              }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('Validation error, please try again later');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;

    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('Number not found, please sign up first');
    }
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 51,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Colors.transparent,
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
class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
          colors: [Color(0xffFD5E3D), Color(0xffC43990)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


