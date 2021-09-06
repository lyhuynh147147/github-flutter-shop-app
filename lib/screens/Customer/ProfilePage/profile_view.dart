import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/screens/customer/ProfilePage/Detail/detail_user_profile_views.dart';
import 'package:phone_verification/widgets/button_raised.dart';

class ProfileView extends StatefulWidget {
  final String uid;

  const ProfileView({Key key, this.uid}) : super(key: key);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String uid = '';
  bool _isLogging = false;
  StreamController _controller = new StreamController();

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((onValue) {
      uid = onValue;
    });
    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);

    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.white.withOpacity(.05),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black87,
                  //size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: _w / 17,
                  //color: Colors.white.withOpacity(.7),
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
                    Icons.shopping_cart_outlined,
                    //size: 32,
                    color: Colors.black.withOpacity(.7),
                  ),
                  /*onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RouteWhereYouGo2();
                        },
                      ),
                    );
                  },*/
                  onPressed: () {
                    /* Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (ctx) => CartScreen()));*/
                    if (_isLogging) {
                      /*setState(() {
                        _isAddBtnPress = false;
                      });*/
                      Navigator.pushNamed(context, 'customer_cart_page');
                      //TODO: Add product
                    } else {
                      Navigator.pushNamed(context, 'register_screen');
                    }
                    //Navigator.pushNamed(context, 'customer_cart_page');
                  },
                ),
                Text(''  ''),
              ],
            ),
          ),
        ),
      ),
      /*body: Container(
        padding: EdgeInsets.all(20),
        color: kColorWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //TODO: Detail
            SizedBox(height: 10,),
            Container(
              //height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
                  //color:
              ),
              child: CusRaisedButton(
                title: 'Detail',
                backgroundColor: Colors.white,
                height: 60,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailProfileView(
                                uid: uid,
                              )));
                },
              ),
            ),
            SizedBox(height: 10,),
            //TODO: Change password
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
                //color:
              ),
              child: CusRaisedButton(
                title: 'Change Password',
                backgroundColor: kColorWhite,
                height: 60,
                onPress: () {
                  Navigator.pushNamed(context, 'customer_change_password_screen');
                },
              ),
            ),
            SizedBox(height: 10,),
            //TODO: Order and bill
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
                //color:
              ),
              child: CusRaisedButton(
                title: 'Orders History',
                backgroundColor: kColorWhite,
                height: 60,
                onPress: () {
                  Navigator.pushNamed(context, 'customer_order_history_screen');
                },
              ),
            ),
            SizedBox(height: 10,),
            //TODO: Bank Account
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
                //color:
              ),
              child: CusRaisedButton(
                title: 'Bank Account',
                backgroundColor: kColorWhite,
                height: 60,
                onPress: () {
                  Navigator.pushNamed(context, 'custommer_bank_account_screen');
                },
              ),
            ),
            SizedBox(height: 10,),
            // TODO: Sign Out
            CusRaisedButton(
              title: 'Sign out',
              backgroundColor: kColorBlack,
              height: 60,
              onPress: () {
                StorageUtil.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, 'welcome_screen', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),*/
      body: getBody(),
    );
  }

  /*
  // Container(
  //         child: Padding(
  //           padding: EdgeInsets.only(
  //               top: 25,
  //               left: 15),
  //           child: StreamBuilder(
  //             stream: FirebaseFirestore.instance
  //                 .collection('Users')
  //                 .doc(widget.uid)
  //                 .snapshots(),
  //             builder: (context, snapshot) {
  //               if (snapshot.hasData) {
  //                 return Column(
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: <Widget>[
  //                     TitleWidget(
  //                       title: 'Full name:',
  //                       content: snapshot.data['fullname'],
  //                       isSpaceBetween: false,
  //                     ),
  //                     TitleWidget(
  //                       title: 'Gender:',
  //                       content: snapshot.data['gender'],
  //                       isSpaceBetween: false,
  //                     ),
  //                     TitleWidget(
  //                       title: 'Phone:',
  //                       content: snapshot.data['phone'],
  //                       isSpaceBetween: false,
  //                     ),
  //                     TitleWidget(
  //                       title: 'Address:',
  //                       content: snapshot.data['address'],
  //                       isSpaceBetween: false,
  //                     ),
  //                     TitleWidget(
  //                       title: 'Birthday:',
  //                       content: snapshot.data['birthday'],
  //                       isSpaceBetween: false,
  //                     ),
  //                   ],
  //                 );
  //               } else {
  //                 return Container();
  //               }
  //             },
  //           ),
  //         ),
  //       )*/

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(profileUrl), fit: BoxFit.cover)),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  StreamBuilder(
                    stream: _controller.stream,
                    builder: (context, mainSnapshot){
                      if (mainSnapshot.hasData){
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot.data['fullname']);
                              return Container(
                                child: Text(
                                  snapshot.data['fullname'],
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                                ),
                              );
                            } else {
                              return Container();
                            }

                          },
                        );
                      }else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),

                  Text(
                    "Daniel",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "4 Orders",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: 15,
        ),
        Divider(
          color: Colors.grey.withOpacity(0.8),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(menusMore.length, (index) {

                return Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    menusMore[index],
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
                  ),
                );
              })),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: (size.width - 100) / 2,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: (size.width - 100) / 2,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
