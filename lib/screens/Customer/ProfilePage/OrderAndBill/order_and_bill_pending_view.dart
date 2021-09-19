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
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/card_order.dart';
import 'package:phone_verification/widgets/card_order_pending.dart';

class OrderAndBillPendingView extends StatefulWidget {
  OrderAndBillPendingView({this.status, this.isAdmin = false});
  final String status;
  final bool isAdmin;
  @override
  _OrderAndBillPendingViewState createState() => _OrderAndBillPendingViewState();
}

class _OrderAndBillPendingViewState extends State<OrderAndBillPendingView> {
  StreamController _controller = new StreamController();
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      this.uid = uid;
      _controller.sink.add(true);
    });
  }

  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: StreamBuilder(
            stream: _controller.stream,
            builder: (context, mainSnapshot) {
              if (mainSnapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                    stream: widget.isAdmin
                        ? FirebaseFirestore.instance
                        .collection('Orders')
                        .where('status', isEqualTo: widget.status)
                        .orderBy('create_at')
                        .snapshots()
                        : FirebaseFirestore.instance
                        .collection('Orders')
                        .where('id', isEqualTo: uid)
                        .where('status', isEqualTo: widget.status)
                        .orderBy('create_at')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (mainSnapshot.hasData && snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                            print(snapshot.data.docs.length);
                            OrderInfo orderInfo = new OrderInfo(
                                id: document['id'],
                                subId: document['sub_Id'],
                                customerName: document['customer_name'],
                                receiverName: document['receiver_name'],
                                address: document['address'],
                                phone: document['phone'],
                                status: document['status'],
                                total: document['total'],
                                createAt: Util.convertDateToFullString(document['create_at']),
                                shipping: document['shipping'],
                                discount: document['discount'],
                                discountPrice: document['discountPrice'],
                                maxBillingAmount: document['billingAmount']);
                            return OrderCardPending(
                              id: document['sub_Id'],
                              date: Util.convertDateToFullString(document['create_at']),
                              customerName: document['customer_name'],
                              //admin: document['admin'] ,
                              status: document['status'],
                              total: Util.intToMoneyType(int.parse(document['total'])),
                              isEnableCancel: (document['status'] != 'Canceled' && document['status'] != 'Completed'),
                              onViewDetail: () {
                                bool isCancelled = document['status'] == 'Canceled';
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
                                              horizontal: 7,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel Order',
                                                      style: kBoldTextStyle.copyWith(fontSize: 18),
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
                                                        child: CusRaisedButton(
                                                          title: 'ACCEPT',
                                                          backgroundColor: kColorBlack,
                                                          onPress: () async {
                                                            String adminName = await StorageUtil.geFullName();
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection('Orders')
                                                                .doc(document['sub_Id'])
                                                                .update({
                                                              'status': 'Canceled',
                                                              'description': (description == null) ? '   ' : description,
                                                              'admin': 'None'
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
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      //TODO: cancel
                                                      Expanded(
                                                        flex: 1,
                                                        child: CusRaisedButton(
                                                          title: 'CANCEL',
                                                          backgroundColor: kColorWhite,
                                                          onPress: () {
                                                            Navigator.pop(context);
                                                            setState(() {

                                                            });
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
                          }).toList().reversed.toList(),
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
