import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/Register/signin_password.dart';
import 'package:phone_verification/widgets/my_text_field.dart';
import 'package:phone_verification/widgets/pallete.dart';
import 'package:phone_verification/widgets/text_field_input.dart';
import 'package:phone_verification/widgets/text_formfield_input.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController countryController = new TextEditingController(text: '+84');
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();


  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';


  //Form controllers
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

    final node = FocusScope.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
          title: Text('Register new user'),
          backgroundColor: kBackgroundColor,
          elevation: 0,
        ),
      //backgroundColor: kBackgroundColor,
      body: ListView(
          children: [
            new Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     /* Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                 // floatingLabelBehavior: FloatingLabelBehavior.never,
                                  labelText: 'Name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a name';
                                }
                              },
                            ),
                          )),*/
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
                                  //contentPadding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                  // floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      // Container(
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           vertical: 10.0, horizontal: 10.0),
                      //       child: TextInputFormField(
                      //         isPassword: false,
                      //         icon: Icons.phone_android_sharp,
                      //         labelText: 'Phone Number',
                      //         inputAction: TextInputAction.next,
                      //         inputType: TextInputType.phone,
                      //         onChanged: (value){
                      //           phoneController.text = value;
                      //         },
                      //         validator: (value) {
                      //           if(value.isEmpty){
                      //             return 'Please enter phone number';
                      //           }
                      //         },
                      //       ),
                      //     )),
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
                                child: new Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Text(
                                          "Tiếp Theo",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
                    ],
                  ))
            ],
          ),
        ],),
    );
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('OTP Screen'),
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
                Container(
                  child: Center(
                    child: Text(
                      '(${countryController.text.trim()})'+' '+phoneController.text.trim(),
                      style: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
                // !isLoading
                //     ? Container(
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 10.0, horizontal: 10.0),
                //         child: TextFormField(
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 60,
                //             fontWeight: FontWeight.bold,
                //           ).copyWith(color: Colors.black),
                //           enabled: !isLoading,
                //           controller: otpController,
                //           //controller: otp,
                //           keyboardType: TextInputType.number,
                //           inputFormatters: <TextInputFormatter>[
                //             FilteringTextInputFormatter.digitsOnly
                //           ],
                //           initialValue: null,
                //           autofocus: true,
                //           decoration: InputDecoration(
                //               hintText: 'OTP',
                //               labelStyle: TextStyle(color: Colors.black)),
                //           validator: (value) {
                //             if (value.isEmpty) {
                //               return 'Please enter OTP';
                //             }
                //           },
                //         ),
                //       ),
                //     ))
                //     : Container(),
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
                ///
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       _textFieldOTP1(first: true, last: false,),
                //       _textFieldOTP2(first: false, last: false),
                //       _textFieldOTP3(first: false, last: false),
                //       _textFieldOTP4(first: false, last: false),
                //       _textFieldOTP5(first: false, last: false),
                //       _textFieldOTP6(first: false, last: true),
                //     ],
                //   ),
                // ),
                ///
                !isLoading
                    ? Container(
                    margin: EdgeInsets.only(top: 40, bottom: 5),
                    child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: new ElevatedButton(
                          onPressed: () async {
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
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext
                                          context) =>
                                              SignInPassword(),
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "Tiếp Theo",
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
                            await signUp();
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
                                    "Gửi Lại",
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
        ]));
  }

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
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
                  //navigate to is
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoggedInScreen(),
                    ),
                        (route) => false,
                  );
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
