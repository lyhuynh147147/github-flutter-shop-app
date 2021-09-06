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
import 'package:phone_verification/screens/admin/SignIn/login_admin.dart';
import 'package:phone_verification/screens/admin/SignIn/register_view.dart';
import 'package:phone_verification/screens/admin/SignIn/sign_in_form.dart';
import 'package:phone_verification/screens/customer/customer_home_view.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/phone/registerScreen.dart';
import 'package:phone_verification/widgets/background_image.dart';
import 'package:phone_verification/widgets/input_text.dart';
import 'package:phone_verification/widgets/pallete.dart';
import 'package:phone_verification/widgets/text_field_input.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';



final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginScreens extends StatefulWidget {
  LoginScreens({Key key}) : super(key: key);

  @override
  _LoginScreensState createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> with TickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController countryController = new TextEditingController(text: '+1');
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

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
    // Clean up the controller when the Widget is disposed
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return Stack(
      children: [
        // BackgroundImage(
        //   image: 'assets/images/login_bg.png',
        // ),
        Scaffold(
          
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Text('Đăng Nhập'),
            //backgroundColor: kBackgroundColor,
          ),
          backgroundColor: Color(0xff19208),
          body: ListView(children: [
            new Column(
                children: [
                  Form(
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
                                    //autofocus: true,
                                    //maxLength: null,
                                    //cursorColor: Colors.amber,
                                    style: kBodyText.copyWith(color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    controller: countryController,
                                    enabled: !isLoading,
                                    decoration: InputDecoration(
                                      //contentPadding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                      // floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                    //icon: Icons.phone_android_sharp,
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
                                // SizedBox(
                                //   width: 10,
                                // ),
                              ],
                            ),
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
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.black),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                          onTap: () => {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => PhoneUp()))
                                            //Navigator.pushNamed(context, 'register_screen')
                                          },
                                        ),
                                      ],
                                    ))),
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
                                    onTap: () => {
                                      Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => LoginAdmin()))
                                    }
                                  ),
                                ],
                              ),
                            ),
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
                                      onTap: () => {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => RegisterView()))
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

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('OTP Screens'),
        ),
        body: ListView(children: [
          Form(
            key: _formKeyOTP,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                            !isLoading
                                ? "Enter OTP from SMS"
                                : "Sending OTP code SMS",
                            textAlign: TextAlign.center))),
                ///
                !isLoading
                    ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                color: Color(0xffff9601),
                                borderRadius: BorderRadius.circular(15)),
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
                        child: new ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isResend = false;
                              isLoading = true;
                            });
                            await login();
                          },
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "Gửi lại ",
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
        ]));
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

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = phoneController.text.trim();
    //var name = passwordController.text.trim();

    var pwdSha512 = Util.encodePassword(passwordController.text);


     // UserCredential firebaseUser;
     // String uid = firebaseUser.user.uid;



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
      //StorageUtil.setUid(uid);
      //StorageUtil.setFullName(snapshot.data()['fullname']);
      StorageUtil.setIsLogging(true);
      //StorageUtil.setUserInfo(user);
      // StorageUtil.setAccountType('admin');
      // StorageUtil.setPassword(pwdSha512);
    });
    // await FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(uid)
    //     .get()
    //     .then((DocumentSnapshot snapshot) {
    //   Users user = new Users(
    //       snapshot[0].data()['fullname'],
    //       snapshot[0].data()['username'],
    //       snapshot[0].data()['password'],
    //       snapshot[0].data()['gender'],
    //       snapshot[0].data()['birthday'],
    //       snapshot[0].data()['phone'],
    //       snapshot[0].data()['address'],
    //       snapshot[0].data()['create_at'],
    //       snapshot[0].data()['id_scripe'],
    //       snapshot[0].data()['type']);
    //   print(user.toJson());
    //
    //   StorageUtil.setUid(uid);
    //   StorageUtil.setFullName(snapshot[0].data()['fullname']);
    //   StorageUtil.setIsLogging(true);
    //   StorageUtil.setUserInfo(user);
    //   StorageUtil.setAccountType('customer');
    //   StorageUtil.setPassword(Util.encodePassword(pwdSha512));
    // });
    if (isValidUser) {
      // setState(() {
      //   isLoading = false;
      //   isOTPScreen = false;
      // });
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => LoggedInScreen(),
      //   ),
      //       (route) => false,
      // );
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
            if (user != null)
              {
                //redirect
                setState(() {
                  isLoading = false;
                  isOTPScreen = false;
                }),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CustomerHomeView(),
                  ),
                      (route) => false,
                )
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
