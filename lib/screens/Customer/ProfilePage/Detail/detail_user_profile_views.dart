import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/customer/ProfilePage/Detail/edit_detail_views.dart';
import 'package:phone_verification/widgets/widget_title.dart';
import 'package:phone_verification/widgets/widget_title_profile.dart';

class DetailProfileView extends StatefulWidget {
  DetailProfileView({this.uid});
  final String uid;
  @override
  _DetailProfileViewState createState() => _DetailProfileViewState();
}

class _DetailProfileViewState extends State<DetailProfileView> {
  DateTime birthDay;
  List<String> gender = ['Male', 'Female'];
  String uid = '';
  //TODO: data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              //brightness: Brightness.dark,
              backgroundColor: Color(0xFF84AB5C),
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
              centerTitle: true,
              title: Text(
                'Profile',
                style: kBoldTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              // title: InkWell(
              //   onTap: () {
              //     Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => SearchView(),
              //       ),
              //     );
              //   },
              //   child:  ClipRRect(
              //     borderRadius: BorderRadius.circular(99),
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              //       child: InkWell(
              //         //highlightColor: Colors.transparent,
              //         //splashColor: Colors.transparent,
              //         //onTap: voidCallback,
              //         child: Container(
              //           height: 40 ,
              //           width: _w ,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //             color: Colors.white.withOpacity(.05),
              //             borderRadius: BorderRadius.circular(99),
              //             border: Border.all(color: Colors.black),
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.only(left: 10),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.search,
              //                     color: Colors.black.withOpacity(.6)
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   'Search...',
              //                   style: TextStyle(color: Colors.black.withOpacity(.6)),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.edit),
                  color: kColorBlack,
                  iconSize: 17,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditDetailView()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(widget.uid);
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      /*TitleWidget(
                        title: 'Full name:',
                        content: snapshot.data['fullname'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Gender:',
                        content: snapshot.data['gender'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Phone:',
                        content: snapshot.data['phone'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Address:',
                        content: snapshot.data['address'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Birthday:',
                        content: snapshot.data['birthday'],
                        isSpaceBetween: false,
                      ),*/
                      SizedBox(
                        //height: 150,
                        child: Stack(
                          children: <Widget>[
                            ClipPath(
                              clipper: CustomShape(),
                              child: Container(
                                height: 180,
                                color: Color(0xFF84AB5C),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10), //10
                                    height: 180, //140
                                    width: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5, //8
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/images/welcome_wall.jpg"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 450,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TitleWidgetProfile(
                                  title: "Name",
                                  content: snapshot.data['fullname'],
                                ),
                                TitleWidgetProfile(
                                  title: 'Gender:',
                                  content: snapshot.data['gender'],
                                  isSpaceBetween: false,
                                ),
                                TitleWidgetProfile(
                                  title: 'Phone:',
                                  content: snapshot.data['phone'],
                                  isSpaceBetween: false,
                                ),
                                TitleWidgetProfile(
                                  title: 'Address:',
                                  content: snapshot.data['address'],
                                  isSpaceBetween: false,
                                ),
                                TitleWidgetProfile(
                                  title: 'Birthday:',
                                  content: snapshot.data['birthday'],
                                  isSpaceBetween: false,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }



}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
