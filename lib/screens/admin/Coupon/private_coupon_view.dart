import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/coupon.dart';
import 'package:phone_verification/screens/admin/Users/admin_coupon_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/category_item.dart';
import 'package:phone_verification/widgets/input_text.dart';

class PrivateCouponView extends StatefulWidget {
  @override
  _PrivateCouponViewState createState() => _PrivateCouponViewState();
}

class _PrivateCouponViewState extends State<PrivateCouponView> {
  @override
  Widget build(BuildContext context) {
   // ConstScreen.setScreen(context);
    return Scaffold(
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('type', isEqualTo: 'customer')
            .orderBy('create_at')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((document) {
                Map data = document.data();
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Gửi',
                      color: Colors.deepOrangeAccent.shade200,
                      icon: FontAwesomeIcons.ticketAlt,
                      onTap: () {
                        Coupon coupon = new Coupon();
                        DateTime expiredDate;
                        CouponController couponController =
                            new CouponController();
                        TextEditingController discountTextController =
                            new TextEditingController();
                        TextEditingController billingAmountTextController =
                            new TextEditingController();
                        //TODO: sent Coupon
                        showDialog(
                            builder: (context) => Dialog(
                              child: Container(
                                height: 350,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: <Widget>[
                                      //TODO: Tittle
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical:12),
                                        child: Text(
                                          'Phiếu mua hàng',
                                          style: kBoldTextStyle.copyWith(fontSize:22),
                                        ),
                                      ),
                                      //TODO: Discount
                                      StreamBuilder(
                                          stream:
                                              couponController.discountStream,
                                          builder: (context, snapshot) {
                                            return InputText(
                                              title: 'Giảm giá',
                                              controller:
                                                  discountTextController,
                                              errorText: snapshot.hasError
                                                  ? snapshot.error
                                                  : null,
                                              inputType: TextInputType.number,
                                              hintText: '50%',
                                            );
                                          }),
                                      SizedBox(height: 7,),
                                      //TODO: Max discount price
                                      StreamBuilder(
                                          stream: couponController
                                              .billingAmountStream,
                                          builder: (context, snapshot) {
                                            return InputText(
                                              title: 'Số tiền thanh toán',
                                              controller:
                                                  billingAmountTextController,
                                              errorText: snapshot.hasError
                                                  ? snapshot.error
                                                  : null,
                                              inputType: TextInputType.number,
                                              hintText: '100,000',
                                            );
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //TODO: Date time picker
                                      FlatButton(
                                        onPressed: () {
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              maxTime: DateTime(
                                                  DateTime.now().year + 50,
                                                  12,
                                                  31), onChanged: (date) {
                                            expiredDate = date;
                                          }, onConfirm: (date) {
                                            expiredDate = date;
                                            coupon.expiredDate =
                                                date.toString();
                                            couponController.expiredDateSink
                                                .add(true);
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.vi);
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kColorBlack
                                                      .withOpacity(0.7))),
                                          child: Center(
                                            child: StreamBuilder(
                                                stream: couponController
                                                    .expiredDateStream,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasError
                                                      ? Text(snapshot.error,
                                                    style: TextStyle(
                                                        color: kColorRed,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w400),
                                                  )
                                                      : Text(snapshot.hasData
                                                              ? ('Ngày hết hạn: ' +
                                                                  expiredDate.day.toString() +
                                                                  '/' +
                                                                  expiredDate.month.toString() +
                                                                  '/' +
                                                                  expiredDate.year.toString())
                                                              : 'Chọn ngày hết hạn',
                                                    style: TextStyle(
                                                        color: kColorBlack,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w400),);
                                                }),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //TODO: button
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: CusRaisedButton(
                                              title: 'TẠO',
                                              backgroundColor: kColorBlack,
                                              onPress: () {
                                                coupon.discount =
                                                    discountTextController.text;

                                                coupon.maxBillingAmount =
                                                    billingAmountTextController
                                                        .text;
                                                coupon.uid = document.id;
                                                coupon.couponKey =
                                                    Coupon.randomCouponKey(10);
                                                coupon.createAt =
                                                    DateTime.now().toString();
                                                var result = couponController
                                                    .onCreateCoupon(coupon);
                                                if (result == 0) {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: CusRaisedButton(
                                              title: 'THOÁT',
                                              backgroundColor: kColorLightGrey,
                                              onPress: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), context: context);
                      },
                    ),
                  ],
                  child: Card(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Coupon')
                            .where('uid', isEqualTo: document.id)
                            .orderBy('create_at')
                            .snapshots(),
                        builder: (context, snapshot) {
                          int index = 0;
                          if (snapshot.hasData) {
                            List<Slidable> privateCouponList = [];
                            for (var coupon in snapshot.data.docs) {
                              if (Util.isDateGreaterThanNow(
                                  coupon['expired_date'])) {
                                privateCouponList.add(Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: kColorRed,
                                      icon: Icons.delete,
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('Coupon')
                                            .doc(coupon.id)
                                            .delete();
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                  child: CategoryItem(
                                    title:
                                        'ID: ${++index}\nDiscount: ${coupon['discount']}% \nBilling amount: ${Util.intToMoneyType(int.parse(coupon['max_billing_amount']))} VND\nCreate at: ${Util.convertDateToString(coupon['create_at'].toString())} \nExpired date: ${Util.convertDateToString(coupon['expired_date'].toString())}',
                                    height: 200,
                                  ),
                                ));
                              }
                            }
                            return ExpansionTile(
                              title: Text(
                                  '${data['fullname']} - ${data['username']}'),
                              children: privateCouponList,
                            );
                          } else {
                            return ExpansionTile(
                              title: Text(
                                  '${data['fullname']} - ${data['username']}'),
                            );
                          }
                        }),
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
