import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/screens/customer/HomePage/details/RatingPage/rating_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/rating_comment_card.dart';

class RatingProductPage extends StatefulWidget {
  RatingProductPage({this.productId, this.isAdmin = false, Key key})
      : super(key: key);
  final String productId;
  final bool isAdmin;

  @override
  _RatingProductPageState createState() => _RatingProductPageState();
}

class _RatingProductPageState extends State<RatingProductPage>
    with AutomaticKeepAliveClientMixin {
  RatingController _controller = new RatingController();
  List commentList = [];
  bool _isLogging = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TOP
          Expanded(
            flex: 1,
            child: Container(
              color: kColorLightGrey.withOpacity(0.4),
              child: Stack(
                children: <Widget>[
                  //
                  Positioned(
                    child: IconButton(
                      color: kColorBlack,
                      iconSize: 27,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        // Rating Bar
                        StreamBuilder(
                            stream: _controller.averageStream,
                            builder: (context, snapshot) {
                              return RatingBar.builder(
                                allowHalfRating: true,
                                initialRating: snapshot.hasData ? snapshot.data : 0,
                                itemCount: 5,
                                minRating: 0,
                                itemSize: 27,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                ),
                              );
                            }),
                        SizedBox(
                          height: 2,
                        ),
                        StreamBuilder(
                            stream: _controller.totalReviewStream,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData ? '${snapshot.data} Reviews' : '0 Reviews',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  //TODO: Add Comment
                  Positioned(
                    top: 0,
                    right: 10,
                    child: IconButton(
                        icon: Icon(
                          Icons.add_comment,
                          size: 22,
                        ),
                        onPressed: () {
                          //TODO: Add comment
                          if (_isLogging) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  double _ratingPoint = 0;
                                  String _comment = '';
                                  return Dialog(
                                    elevation: 0.0,
                                    backgroundColor: kColorWhite,
                                    child: Container(
                                      height: 300,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 7,
                                          horizontal: 15,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            //Rating
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Đánh giá:',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: RatingBar.builder(
                                                        itemCount: 5,
                                                        onRatingUpdate: (value) {
                                                          _ratingPoint = value;
                                                        },
                                                        minRating: 0,
                                                        maxRating: 5,
                                                        allowHalfRating: true,
                                                        itemSize: 35,
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,
                                                          color: Colors.amberAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Comment
                                            Text(
                                              'Bình luận:',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 10,
                                                child: StreamBuilder(
                                                  stream: _controller.commentStream,
                                                  builder: (context, snapshot) => TextField(
                                                    decoration: InputDecoration(
                                                        errorText: snapshot.hasError ? snapshot.error : null,
                                                        errorStyle: kBoldTextStyle.copyWith(fontSize: 12),
                                                        border: OutlineInputBorder(),
                                                        labelStyle: kBoldTextStyle.copyWith(fontSize: 15)),
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: null,
                                                    onChanged: (cmt) {
                                                      _comment = cmt;
                                                      },),)),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  // Button Add
                                                  //TODO: Save Button
                                                  Expanded(
                                                    child: CusRaisedButton(
                                                      title: 'Thêm',
                                                      isDisablePress: true,
                                                      onPress: () {
                                                        StorageUtil.getUserInfo().then((user) async {
                                                          String username = user.fullName;
                                                          bool result = await _controller.onComment(
                                                              productId: widget.productId,
                                                              comment: _comment,
                                                              ratingPoint: _ratingPoint,
                                                              username: username);
                                                          if (result) {
                                                            setState(() {

                                                            });
                                                            Navigator.pop(context);
                                                          }
                                                        });
                                                      },
                                                      backgroundColor: kColorBlack,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  // Button Add
                                                  Expanded(
                                                    child: CusRaisedButton(
                                                      title: 'Thoát',
                                                      onPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                      backgroundColor: kColorLightGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Navigator.pushNamed(context, 'phone_in');
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),

          // TODO: BOTTOM
          Expanded(
            flex: 9,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Comments')
                    .orderBy('create_at')
                    .where('product_id', isEqualTo: widget.productId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    //TODO: set
                    double totalReview = 0;
                    // snapshot.data.documents.length.toDouble();
                    double ratingPoint = 0;

                    for (var rating in snapshot.data.docs) {
                      if (rating['type'] == 'customer') {
                        totalReview++;
                        ratingPoint += rating['point'];
                      }
                    }
                    _controller.setTotalReview(totalReview.toInt());
                    _controller.setAveragePoint(ratingPoint / totalReview);
                    commentList =
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return RatingComment(
                        username: document['name'],
                        isAdmin: (document['type'] == 'admin'),
                        comment: document['comment'],
                        ratingPoint: document['point'],
                        createAt:
                            Util.convertDateToFullString(document['create_at']),
                        isCanDelete: widget.isAdmin,
                        onDelete: () {
                          FirebaseFirestore.instance
                              .collection('Comments')
                              .doc(document.id)
                              .delete();
                          setState(() {});
                        },
                      );
                    }).toList();
                    return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: commentList.reversed.toList());
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
