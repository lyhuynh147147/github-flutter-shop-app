import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/orderInfo.dart';
import 'package:phone_verification/widgets/card_product_order.dart';
import 'package:phone_verification/widgets/widget_title.dart';

class OrderInfoView extends StatefulWidget {
  OrderInfoView({this.id, this.orderInfo, this.descriptionCancel = ' '});
  final OrderInfo orderInfo;
  final String id;
  final String descriptionCancel;
  @override
  _OrderInfoViewState createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Order Info',
          style: kBoldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: ListView(
          children: <Widget>[
            //TODO: Main Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //TODO: Order ID
                  TitleWidget(
                    title: 'Mã đơn hàng:',
                    content: widget.id,
                  ),
                  TitleWidget(
                    title: 'Ngày đặt:',
                    content: widget.orderInfo.createAt,
                  ),
                  TitleWidget(
                    title: 'Customer',
                    content: widget.orderInfo.customerName,
                  ),
                  TitleWidget(
                    title: 'Người nhận:',
                    content: widget.orderInfo.receiverName,
                  ),
                  TitleWidget(
                    title: 'Tình trạng',
                    content: widget.orderInfo.status,
                  ),
                  // TitleWidget(
                  //   title: 'SubTotal',
                  //   content:
                  //       '${Util.intToMoneyType(int.parse(widget.orderInfo.total) + int.parse(widget.orderInfo.shipping) + int.parse(widget.orderInfo.maxBillingAmount))} VND',
                  // ),
                  TitleWidget(
                    title: 'Phí giao hàng:',
                    content:
                        '+${Util.intToMoneyType(int.parse(widget.orderInfo.shipping))} VND',
                  ),
                  TitleWidget(
                    title: 'Mã giảm giá:',
                    content:
                        'Discount: ${widget.orderInfo.discount}% \n-${Util.intToMoneyType(int.parse(widget.orderInfo.discountPrice))} VND',
                  ),

                  // TODO: Err total 200,000
                  Card(
                    child: TitleWidget(
                        title: 'Tổng giá:',
                        content: '${widget.orderInfo.total} VND'),
                  ),
                ],
              ),
            ),
            //TODO: Cancelled Order
            (widget.descriptionCancel != ' ')
                ? Container(
                    color: kColorLightGrey,
                    height: 35,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          'Order Was Cancelled!',
                          maxLines: 1,
                          minFontSize: 10,
                          style: kBoldTextStyle.copyWith(
                            fontSize: 16,
                            color: kColorRed,),
                        ),
                      ),
                    ),
                  )
                : Container(),
            (widget.descriptionCancel != ' ')
                ? Padding(padding: EdgeInsets.only(
              top: 5,
              left: 13,),
              child: AutoSizeText(
                widget.descriptionCancel,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                  fontSize: 14,
                  color: kColorBlack,),
              ),
                  )
                : Container(),
            SizedBox(
              height:7,
            ),
            Container(
              color: kColorLightGrey,
              height: 35,
              child: Padding(
                padding: EdgeInsets.only(left:15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Chi tiết sản phẩm:',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                      fontSize: 16,
                      color: kColorBlue,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            //TODO: List Product
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .doc(widget.orderInfo.subId)
                  .collection(widget.orderInfo.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data.docs
                        .map((DocumentSnapshot document) {
                      return ProductOrderDetail(
                        name: document['name'],
                        price: document['price'],
                        quantity: document['quantity'],
                        color: Color(document['color']),
                        size: document['size'],
                      );
                    }).toList(),
                  );
                } else {
                  return Container();
                }
              },
            ),

            //TODO: Phone number
            Container(
              color: kColorLightGrey,
              height: 35,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Số điện thoại:',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                      fontSize: 16,
                      color: kColorBlue,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 25,
              ),
              child: AutoSizeText(
                widget.orderInfo.phone,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                    fontSize: 15, color: kColorBlack),
              ),
            ),
            //TODO: Shipping Address
            Container(
              color: kColorLightGrey,
              height: 35,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Địa chỉ giao hàng:',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                      fontSize: 16,
                      color: kColorBlue,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left:25,),
              child: AutoSizeText(
                widget.orderInfo.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                  fontSize: 15,
                  color: kColorBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
