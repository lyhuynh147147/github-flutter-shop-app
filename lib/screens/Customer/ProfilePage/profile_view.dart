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
import 'package:phone_verification/widgets/more_raised.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String uid = '' ;
  bool _isLogging = false;
  // //StreamController _controller = new StreamController();
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.close();
  // }

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
                  Navigator.pushNamed(context, 'welcome_screen');
                },
              ),
              centerTitle: true,
              title: Text(
                'More',
                style: TextStyle(
                  fontSize: _w / 18,
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
                    Icons.settings,
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
                    if (_isLogging) {
                      Navigator.pushNamed(context, 'customer_cart_page');
                      //TODO: Add product
                    } else {
                      Navigator.pushNamed(context, 'register_screen');
                    }
                  },
                ),
                Text(''  ''),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: kColorWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: Detail
                SizedBox(height: 10,),
                MoreRaised(
                  icon: Icons.person,
                  title: 'Profile',
                  backgroundColor: Color(0xFFF5F6F9),
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
                SizedBox(height: 10,),
                //TODO: Change password
                MoreRaised(
                  icon: Icons.password,
                  title: 'Change Password',
                  backgroundColor: Color(0xFFF5F6F9),
                  height: 60,
                  onPress: () {
                    Navigator.pushNamed(context, 'customer_change_password_screen');
                  },
                ),
                SizedBox(height: 10,),
                //TODO: Order and bill
                MoreRaised(
                  icon: Icons.history,
                  title: 'Orders History',
                  backgroundColor: Color(0xFFF5F6F9),
                  height: 60,
                  onPress: () {
                    Navigator.pushNamed(context, 'customer_order_history_screen');
                  },
                ),
                SizedBox(height: 10,),
                //TODO: Bank Account
                MoreRaised(
                  icon: Icons.credit_card,
                  title: 'Bank Account',
                  backgroundColor: Color(0xFFF5F6F9),
                  height: 60,
                  onPress: () {
                    //Navigator.pushNamed(context, 'custommer_bank_account_screen');
                  },
                ),
                SizedBox(height: 10,),
                //TODO: Bank Account
                MoreRaised(
                  icon: Icons.credit_card,
                  title: 'Help Center',
                  backgroundColor: Color(0xFFF5F6F9),
                  height: 60,
                  onPress: () {
                    //Navigator.pushNamed(context, 'custommer_bank_account_screen');
                  },
                ),
                SizedBox(height: 10,),
                // TODO: Sign Out
                MoreRaised(
                  icon: Icons.logout,
                  title: 'Sign out',
                  backgroundColor: Color(0xFFF5F6F9),
                  height: 60,
                  onPress: () {
                    StorageUtil.clear();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'welcome_screen', (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          )
        ],
      ),
      //body: getBody(),
    );
  }

  // Widget getBody() {
  //   var size = MediaQuery.of(context).size;
  //   return ListView(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 70,
  //               height: 70,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   image: DecorationImage(
  //                       image: NetworkImage(profileUrl), fit: BoxFit.cover)),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             Column(
  //               children: [
  //                 StreamBuilder<DocumentSnapshot>(
  //                   stream: FirebaseFirestore.instance
  //                       .collection('Users')
  //                       .doc(widget.id)
  //                       .snapshots(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       print(widget.id);
  //                       return Text(
  //                         (snapshot.data['phone']),
  //                         style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
  //                       );
  //                     } else {
  //                       return CircularProgressIndicator();
  //                     }
  //
  //                   },
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Text(
  //                   "4 Orders",
  //                   style: TextStyle(fontSize: 15, color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //       SizedBox(
  //         height: 15,
  //       ),
  //       Divider(
  //         color: Colors.grey.withOpacity(0.8),
  //       ),
  //       SizedBox(
  //         height: 30,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 25, right: 25),
  //         child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: List.generate(menusMore.length, (index) {
  //
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 40),
  //                 child: Text(
  //                   menusMore[index],
  //                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
  //                 ),
  //               );
  //             })),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 25, right: 25),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               width: (size.width - 100) / 2,
  //               height: 50,
  //               decoration: BoxDecoration(
  //                   color: Colors.black, borderRadius: BorderRadius.circular(30)),
  //               child: Center(
  //                 child: Text(
  //                   "Settings",
  //                   style: TextStyle(fontSize: 15, color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               width: (size.width - 100) / 2,
  //               height: 50,
  //               decoration: BoxDecoration(
  //                   color: Colors.black, borderRadius: BorderRadius.circular(30)),
  //               child: Center(
  //                 child: Text(
  //                   "Sign Out",
  //                   style: TextStyle(fontSize: 15, color: Colors.white),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
