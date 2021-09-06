import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/customer/ProfilePage/Detail/edit_detail_views.dart';
import 'package:phone_verification/widgets/widget_title.dart';

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
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              //brightness: Brightness.dark,
              backgroundColor: Colors.white,
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
                'Detail',
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
      body: Container(
          child: Padding(
            padding: EdgeInsets.only(
                top: 25,
                left: 15),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TitleWidget(
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
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
    );
  }
}
