import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/orderInfo.dart';
import 'package:phone_verification/model/quantityOrder.dart';
import 'package:phone_verification/screens/customer/ProfilePage/OrderAndBill/order_info_view.dart';
import 'package:phone_verification/services/stripe_payment.dart';
import 'package:phone_verification/widgets/OrderAdminCard.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/card_order.dart';

class SoldAndOrderView extends StatefulWidget {
  SoldAndOrderView({this.title});

  final String title;
  final _globalKey = new GlobalKey<ScaffoldState>();

  @override
  _SoldAndOrderViewState createState() => _SoldAndOrderViewState();
}

class _SoldAndOrderViewState extends State<SoldAndOrderView> {
  StreamController _controller = new StreamController();
  String uid = '';
  bool isOrderPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.title == 'Order List') {
      isOrderPage = true;
    } else {
      isOrderPage = false;
    }
    StorageUtil.getUid().then((uid) {
      this.uid = uid;
      _controller.sink.add(true);
      _controller.close();
    });
    //StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          //widget.title,
          'Danh sách đặt hàng',
          style: kBoldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10),
          child: StreamBuilder(
            stream: _controller.stream,
            builder: (context, mainSnapshot) {
              if (mainSnapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                    stream: isOrderPage
                        ? FirebaseFirestore.instance
                            .collection('Orders')
                            .orderBy('create_at')
                            .where('status', isEqualTo: 'Pending')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Orders')
                            .where('status', isLessThan: 'Pending')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (mainSnapshot.hasData && snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            OrderInfo orderInfo = new OrderInfo(
                                id: document['id'],
                                subId: document['sub_Id'],
                                customerName: document['customer_name'],
                                receiverName: document['receiver_name'],
                                address: document['address'],
                                phone: document['phone'],
                                status: document['status'],
                                total: document['total'],
                                createAt: Util.convertDateToFullString(
                                    document['create_at']),
                                shipping: document['shipping'],
                                discount: document['discount'],
                                discountPrice: document['discountPrice'],
                                maxBillingAmount: document['billingAmount']);
                            if (isOrderPage) {
                              //TODO: Order List View
                              return OrderAdminCard(
                                id: document['sub_Id'],
                                date: Util.convertDateToFullString(
                                    document['create_at']),
                                customerName: document['customer_name'],
                                status: document['status'],
                                total: Util.intToMoneyType(
                                    int.parse(document['total'])),
                                isEnableCancel:
                                    (document['status'] != 'Canceled'),
                                onViewDetail: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfoView(
                                                orderInfo: orderInfo,
                                                id: document['sub_Id'],
                                              )));
                                },
                                onAccept: () async {
                                  // ///
                                  // //TODO: Accept order
                                  // bool result =
                                  //     await StripeService.confirmPaymentIntent(
                                  //         clientSecret:
                                  //             document['client_secret'],
                                  //         paymentMethodId:
                                  //             document['payment_method_id']);
                                  // if (result) {
                                  //   String adminName =
                                  //       await StorageUtil.geFullName();
                                  //   FirebaseFirestore.instance
                                  //       .collection('Orders')
                                  //       .doc(document['sub_Id'])
                                  //       .update({
                                  //     'status': 'Completed',
                                  //     'description': '',
                                  //     'admin': adminName
                                  //   });
                                  //   //TODO: delete coupon
                                  //   FirebaseFirestore.instance
                                  //       .collection('Orders')
                                  //       .doc(document['couponId'])
                                  //       .delete();
                                  //   setState(() {});
                                  // } else {
                                  //   //TODO: invalid card
                                  //   widget._globalKey.currentState
                                  //       .showSnackBar(SnackBar(
                                  //     backgroundColor: kColorWhite,
                                  //     content: Row(
                                  //       children: <Widget>[
                                  //         Icon(
                                  //           Icons.error,
                                  //           color: kColorRed,
                                  //           size: 25,
                                  //         ),
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //         Expanded(
                                  //           child: Text(
                                  //             'Invalid Bank Cards.',
                                  //             style: kBoldTextStyle.copyWith(
                                  //                 fontSize: 14),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ));
                                  // }

                                  ///
                                  ///
                                  String adminName =
                                  await StorageUtil.geFullName();
                                  FirebaseFirestore.instance
                                      .collection('Orders')
                                      .doc(document['sub_Id'])
                                      .update({
                                    'status': 'Completed',
                                    'description': '',
                                    'admin': adminName
                                  });
                                  //TODO: delete coupon
                                  FirebaseFirestore.instance
                                      .collection('Orders')
                                      .doc(document['couponId'])
                                      .delete();
                                  setState(() {});
                                },
                                onCancel: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String description = '';
                                        return Dialog(
                                          child: Container(
                                            height: 350,
                                            width: 300,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 7),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        'Cancel Order',
                                                        style: kBoldTextStyle.copyWith(
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  //TODO: description
                                                  Expanded(
                                                    flex: 5,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: TextField(
                                                        decoration: InputDecoration(
                                                            hintStyle: kBoldTextStyle.copyWith(fontSize: 12),
                                                            hintText: 'Description',
                                                            border: OutlineInputBorder(),
                                                            labelStyle: kBoldTextStyle.copyWith(fontSize: 15)),
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: null,
                                                        onChanged: (value) {
                                                          description = value;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  //TODO: Button
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: <Widget>[
                                                        //TODO: accept cancel
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              CusRaisedButton(
                                                            title: 'ACCEPT',
                                                            backgroundColor:
                                                                kColorBlack,
                                                            onPress: () async {
                                                              String adminName =
                                                                  await StorageUtil
                                                                      .geFullName();
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection('Orders')
                                                                  .doc(document['sub_Id'])
                                                                  .update({
                                                                'status': 'Canceled',
                                                                'description': (description == null) ? '   ' : description,
                                                                'admin': adminName
                                                              });
                                                              //TODO: increase quantity
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection('Orders')
                                                                  .doc(document['sub_Id'])
                                                                  .collection(document['id'])
                                                                  .get()
                                                                  .then((document) {
                                                                List<QuantityOrder> quantityOrderList = [];
                                                                for (var document in document.docs) {
                                                                  QuantityOrder quantityOrder = new QuantityOrder(
                                                                          productId: document['id'],
                                                                          quantity: int.parse(document['quantity']));
                                                                  quantityOrderList.add(quantityOrder);
                                                                }
                                                                for (var qtyOrder in quantityOrderList) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection('Products')
                                                                      .doc(qtyOrder.productId)
                                                                      .get()
                                                                      .then((document) {
                                                                    int quantity = int.parse(document.data()['quantity']);
                                                                    int result = quantity + qtyOrder.quantity;
                                                                    print(result);
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection('Products')
                                                                        .doc(qtyOrder.productId)
                                                                        .update({
                                                                      'quantity': result.toString(),
                                                                    });
                                                                  });
                                                                }
                                                              });
                                                              setState(() {

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        //TODO: cancel
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              CusRaisedButton(
                                                            title: 'CANCEL',
                                                            backgroundColor: kColorWhite,
                                                            onPress: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              );
                            } else {
                              //TODO: Sold order list view
                              return OrderCard(
                                id: document['sub_Id'],
                                date: Util.convertDateToFullString(
                                    document['create_at']),
                                admin: document['admin'],
                                customerName: document['customer_name'],
                                status: document['status'],
                                total: Util.intToMoneyType(
                                    int.parse(document['total'])),
                                isEnableCancel:
                                    (document['status'] != 'Canceled' &&
                                        document['status'] != 'Completed'),
                                onViewDetail: () {
                                  bool isCancelled =
                                      document['status'] == 'Canceled';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfoView(
                                                orderInfo: orderInfo,
                                                id: document['sub_Id'],
                                                descriptionCancel: isCancelled
                                                    ? document['description']
                                                    : ' ',
                                              )));
                                },
                                onCancel: () {
                                  FirebaseFirestore.instance
                                      .collection('Orders')
                                      .doc(document['sub_Id'])
                                      .update({
                                    'status': 'Canceled',
                                    'client_secret': "null",
                                    'payment_method_id': "null"
                                  });
                                },
                              );
                            }
                          }).toList(),
                        );
                      } else
                        return Container();
                    });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          )),
    );
  }
}
