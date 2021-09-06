import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/helpers/validator.dart';
import 'package:phone_verification/model/user.dart';

class SignInController {
  StreamController _isEmail = new StreamController();
  StreamController _isPassword = new StreamController();
  StreamController _isBtnLoading = new StreamController();

  Stream get emailStream => _isEmail.stream;
  Stream get passwordStream => _isPassword.stream;
  Stream get btnLoadingStream => _isBtnLoading.stream;

  Validators validators = new Validators();

  Future<String> onSubmitSignIn({
    @required String email,
    @required String password,
    @required bool isAdmin,
  }) async {
    int countError = 0;
    String result = '';
    _isEmail.sink.add('Ok');
    _isPassword.sink.add('Ok');

    if (!validators.isValidEmail(email)) {
      _isEmail.sink.addError('Invalid email address.');
      countError++;
    }

    if (!validators.isPassword(password)) {
      _isPassword.addError('Invaid password.');
      countError++;
    }

    //TODO: Sign in function
    if (countError == 0) {
      try {
        _isBtnLoading.sink.add(false);


        UserCredential firebaseUser;
        firebaseUser = await FirebaseAuth
            .instance
            .signInWithEmailAndPassword(
            email: email,
            password: password);
        String uid = firebaseUser.user.uid;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get()
            .then((DocumentSnapshot snapshot ) {
          Users user = new Users(
              snapshot[0].data()['fullname'] ,
              snapshot[0].data()['username'],
              snapshot[0].data()['password'],
              snapshot[0].data()['gender'],
              snapshot[0].data()['birthday'],
              snapshot[0].data()['phone'],
              snapshot[0].data()['address'],
              snapshot[0].data()['create_at'],
              snapshot[0].data()['id_scripe'],
              snapshot[0].data()['type']);
          print(user.toJson());
          print('sss');

          //TODO: Navigator
          if (isAdmin) {
            //TODO: Admin Sign In
            if (snapshot[0].data()['type'] == 'admin') {
              result = 'admin_home_screen';

              //TODO: Add data to shared preference
              StorageUtil.setUid(uid);
              StorageUtil.setFullName(snapshot[0].data()['fullname']);
              StorageUtil.setIsLogging(true);
              StorageUtil.setUserInfo(user);
              StorageUtil.setAccountType('admin');
              StorageUtil.setPassword(password);
            }
          } else {
            //TODO: Customer Sign In
            if (snapshot[0].data() ['type'] == 'customer') {
              result = 'customer_home_screen';
              //TODO: Add data to shared preference
              StorageUtil.setUid(uid);
              StorageUtil.setFullName(snapshot[0].data()['fullname']);
              StorageUtil.setIsLogging(true);
              StorageUtil.setUserInfo(user);
              StorageUtil.setAccountType('customer');
              StorageUtil.setPassword(Util.encodePassword(password));
            }
          }
          // result = 'admin_home_screen';
          // print('adminnnn');
          // //TODO: Add data to shared preference
          // StorageUtil.setUid(uid);
          // StorageUtil.setFullName(snapshot.data()??['fullname']);
          // StorageUtil.setIsLogging(true);
          // StorageUtil.setUserInfo(user);
          // StorageUtil.setAccountType('admin');
          // StorageUtil.setPassword(password);
        });
      } catch (e) {
        _isBtnLoading.sink.add(true);
      }
      _isBtnLoading.sink.add(true);
      return result;
    }
  }

  void dispose() {
    _isEmail.close();
    _isPassword.close();
    _isBtnLoading.close();
  }
}
