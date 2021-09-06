import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_verification/screens/Register/phoneIn/phone_in.dart';
import 'package:phone_verification/screens/Register/phoneUp/phone_up.dart';
import 'package:phone_verification/screens/phone/loggedInScreen.dart';
import 'package:phone_verification/screens/phone/loginScreens.dart';
import 'package:phone_verification/screens/Register/signin_password.dart';
import 'package:phone_verification/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarIconBrightness: Brightness.dark,
  //     statusBarColor: Colors.transparent,
  //
  //   ),
  // );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
//      locale: DevicePreview.of(context).locale,
//      builder: DevicePreview.appBuilder,
      initialRoute: initialRoute,
      routes: routes,
    );*/
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: routes,
      //home: RegisterView(),
    );
  }
}

//
// class InitializerWidget extends StatefulWidget {
//   @override
//   _InitializerWidgetState createState() => _InitializerWidgetState();
// }
//
// class _InitializerWidgetState extends State<InitializerWidget> {
//
//   FirebaseAuth _auth;
//
//   User _user;
//
//   bool isLoading = true;
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _auth = FirebaseAuth.instance;
//     _user = _auth.currentUser;
//     isLoading = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading ? Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     ) : _user == null ? LoginScreens() : LoggedInScreen();
//   }
// }
