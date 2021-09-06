import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/link.dart';
import 'package:phone_verification/model/coupon.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/cartpage/payment_complete_view.dart';
import 'package:phone_verification/services/stripe_payment.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/card_product_order.dart';
import 'package:phone_verification/widgets/category_item.dart';
import 'package:phone_verification/widgets/input_text.dart';import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'checkout_controller.dart';

class ProcessingOrderView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();

  ProcessingOrderView({this.productList, this.total, this.uid});

  final int total;
  final List<Product> productList;
  final String uid;

  @override
  _ProcessingOrderViewState createState() => _ProcessingOrderViewState();
}

class _ProcessingOrderViewState extends State<ProcessingOrderView> {
  CheckoutController _checkoutController = new CheckoutController();
  String _receiverName = '';
  String _phoneNumber = '';
  String _address = '';
  String cardNumber = '';
  int expiryMonth;
  int expiryYear;
  String cardHolderName = '';
  String cvvCode = '';
  Coupon coupon = new Coupon();
  double discountPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Checkout',
          style: TextStyle(
            color: kColorBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: Shipping info
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              AutoSizeText(
                                'SHIPING INFO:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //TODO: Name
                        StreamBuilder(
                          stream: _checkoutController.nameStream,
                          builder: (context, snapshot) {
                            return InputText(
                              title: 'Receiver\'s Name',
                              errorText: snapshot.hasError ? snapshot.error : '',
                              inputType: TextInputType.text,
                              onValueChange: (name) {
                                _receiverName = name;
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //TODO: Phone number
                        StreamBuilder(
                          stream: _checkoutController.phoneStream,
                          builder: (context, snapshot) {
                            return InputText(
                              title: 'Phone number',
                              errorText:
                                  snapshot.hasError ? snapshot.error : '',
                              inputType: TextInputType.number,
                              onValueChange: (phoneNumber) {
                                _phoneNumber = phoneNumber;
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // TODO: get Address
//                        GestureDetector(
//                          onTap: () async {
//                            Prediction p = await PlacesAutocomplete.show(
//                                context: context,
//                                apiKey:
//                                    'AIzaSyAAsiJbTpLEeB2dEPVTVWDF5HjyU2lbwAo', // Mode.fullscreen
//                                mode: Mode.fullscreen,
//                                language: "vn",
//                                components: [
//                                  new Component(Component.country, "vn")
//                                ]);
//                            if (p.description != null) {
//                              setState(() {
//                                _address = p.description;
//                              });
//                            }
//                          },
//                          child: Container(
//                            width: double.infinity,
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                  color: kColorBlack.withOpacity(0.3)),
//                            ),
//                            child: Padding(
//                              padding: EdgeInsets.only(
//                                  top: ConstScreen.setSizeHeight(20),
//                                  bottom: ConstScreen.setSizeHeight(20),
//                                  left: ConstScreen.setSizeHeight(20),
//                                  right: ConstScreen.setSizeHeight(20)),
//                              child: AutoSizeText('Address: ' + _address,
//                                  textAlign: TextAlign.start,
//                                  maxLines: 2,
//                                  minFontSize: 15,
//                                  style: TextStyle(
//                                      fontSize: FontSize.setTextSize(30),
//                                      color: kColorBlack,
//                                      fontWeight: FontWeight.normal)),
//                            ),
//                          ),
//                        ),
                        //TODO: Error address check
                        StreamBuilder(
                          stream: _checkoutController.addressStream,
                          builder: (context, snapshot) {
                            return InputText(
                              title: 'Address',
                              errorText: snapshot.hasError ? snapshot.error : '',
                              onValueChange: (address) {
                                _address = address;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Coupon
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.ticketAlt,
                                size: 17,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              AutoSizeText(
                                'YOUR COUPON:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //TODO: Coupon key
                        Column(
                          children: <Widget>[
                            (coupon.discount != null && coupon.discount != '')
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          ('Discount : ${coupon.discount}%'),
                                          style: kNormalTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                        Text(
                                          ('Billing amount: ${Util.intToMoneyType(int.parse(coupon.maxBillingAmount))}'),
                                          style: kNormalTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 7,
                            ),
                            //TODO: Coupon Dialog
                            CusRaisedButton(
                              title: 'Get Coupon',
                              backgroundColor: kColorBlack,
                              onPress: () {
                                List<CategoryItem> privateCoupon = [];
                                List<CategoryItem> globalCoupon = [];
                                showDialog(
                                    builder: (context) => Dialog(
                                      backgroundColor: kColorWhite,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Container(
                                        height: 300,
                                        child: Column(
                                          children: <Widget>[
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 10),
                                                child: Text(
                                                  'COUPON',
                                                  style: kBoldTextStyle.copyWith(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  //TODO: your coupon
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Coupon')
                                                          .where('uid', isEqualTo: widget.uid)
                                                          .orderBy('create_at')
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          for (var document in snapshot.data.docs) {
                                                            if (Util.isDateGreaterThanNow(document['expired_date'])) {
                                                              privateCoupon.add(CategoryItem(
                                                                title: 'Discount: ${document['discount']}% \nBilling amount: ${Util.intToMoneyType(int.parse(document['max_billing_amount']))} VND \nExpired date: ${Util.convertDateToString(document['expired_date'].toString())}',
                                                                onTap: () {
                                                                  Coupon coup = new Coupon(
                                                                    id: document.id,
                                                                    discount: document['discount'],
                                                                    maxBillingAmount: document['max_billing_amount'],);
                                                                  setState(() {
                                                                    coupon = coup;
                                                                  });
                                                                  discountPrice = widget.total * (double.parse(coupon.discount) / 100);
                                                                  if (discountPrice > double.parse(coupon.maxBillingAmount)) {
                                                                    discountPrice = double.parse(coupon.maxBillingAmount);
                                                                  }
                                                                  Navigator.pop(context);
                                                                },
                                                                height: 150,
                                                              ));
                                                            }
                                                          }
                                                          return ExpansionTile(
                                                            title: Text(
                                                              'Your Coupon',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: kColorBlack,
                                                                fontWeight: FontWeight.w400,),
                                                            ),
                                                            children: snapshot.hasData ? privateCoupon : [],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                  //TODO: global coupon
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Coupon')
                                                          .where('uid', isEqualTo: 'global')
                                                          .orderBy('create_at')
                                                          .snapshots(),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          for (var document in snapshot.data.docs) {
                                                            if (Util.isDateGreaterThanNow(document['expired_date'])) {
                                                              globalCoupon.add(CategoryItem(
                                                                title: 'Discount: ${document['discount']}% \nBilling amount: ${Util.intToMoneyType(int.parse(document['max_billing_amount']))} VND \nExpired date: ${Util.convertDateToString(document['expired_date'].toString())}',
                                                                onTap: () {
                                                                  Coupon coup = new Coupon(
                                                                      id: document.id,
                                                                      discount: document['discount'],
                                                                      maxBillingAmount: document['max_billing_amount']);
                                                                  setState(() {
                                                                    coupon =
                                                                        coup;
                                                                  });
                                                                  discountPrice = widget.total * (double.parse(coupon.discount) / 100);
                                                                  if (discountPrice > double.parse(coupon.maxBillingAmount)) {
                                                                    discountPrice = double.parse(coupon.maxBillingAmount);
                                                                  }
                                                                  Navigator.pop(context);
                                                                  },
                                                                height: 150,
                                                              ));
                                                            }
                                                          }
                                                          return ExpansionTile(
                                                            title: Text(
                                                              'Global Coupon',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: kColorBlack,
                                                                fontWeight: FontWeight.w400,),
                                                            ),
                                                            children: (snapshot.hasData) ? globalCoupon : [],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), context: context);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Your Order
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20,),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.list,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              AutoSizeText(
                                'YOUR ODER:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //TODO: list order item
                        Column(
                          children: widget.productList.map((product) {
                            return ProductOrderDetail(
                              name: product.productName,
                              price: (product.salePrice == '0') ? product.price : product.salePrice,
                              quantity: product.quantity,
                              color: Color(product.color),
                              size: product.size,
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //TODO: Sub total
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: AutoSizeText(
                                'Subtotal',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: AutoSizeText(
                                Util.intToMoneyType(widget.total) + ' VND',
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        ),
                        //TODO: Shipping
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: AutoSizeText(
                                'Shipping',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: AutoSizeText(
                                (widget.total > 300000) ? '+0 VND' : '+20,000 VND',
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        ),
                        //TODO: coupon
                        (coupon.discount != null && coupon.discount != '')
                            ? Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: AutoSizeText(
                                      'Discount',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      minFontSize: 15,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: kColorBlack,
                                        fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: AutoSizeText(
                                      coupon.discount + '%\n-${Util.intToMoneyType(discountPrice.toInt())} VND',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      minFontSize: 15,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: kColorBlack,
                                        fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),

                        //TODO: TOTAL
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: AutoSizeText(
                                'TOTAL',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: AutoSizeText(
                                Util.intToMoneyType((widget.total > 300000)
                                        ? widget.total - discountPrice.floor()
                                        : widget.total + 20000 - discountPrice.floor()) + ' VND',
                                textAlign: TextAlign.end,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: kColorBlack,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ],
                        ),
                        //TODO: Error quantity check
                        StreamBuilder(
                          stream: _checkoutController.quantityStream,
                          builder: (context, snapshot) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 11,
                                ),
                                child: AutoSizeText(
                                    snapshot.hasError ? snapshot.error : '',
                                    textAlign: TextAlign.start,
                                    maxLines: 20,
                                    minFontSize: 12,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: snapshot.hasError
                                          ? kColorRed
                                          : kColorBlack,
                                      fontWeight: FontWeight.normal,),),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: StreamBuilder(
            stream: _checkoutController.btnLoadingStream,
            builder: (context, snapshot) {
              return CusRaisedButton(
                title: 'PAYMENT',
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                height: 75,
                backgroundColor: Colors.orangeAccent.shade700,
                onPress: () async {
                  bool isValidate = await _checkoutController.onValidate(
                    name: _receiverName,
                    phoneNumber: _phoneNumber,
                    address: _address,
                    productList: widget.productList,
                    total: widget.total.toString(),
                  );
                  if (isValidate) {
                    showModalBottomSheet(context: context, builder: (context) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.payment,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        AutoSizeText(
                                          'PAYMENT:',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          minFontSize: 15,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: kColorBlack,
                                            fontWeight: FontWeight.w500,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //TODO: Pay via new card
                                  CusRaisedButton(
                                    title: 'Pay via new card',
                                    backgroundColor: Colors.deepOrangeAccent,
                                    onPress: () async {
                                      String orderId = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      var response = await StripeService
                                          .paymentWithNewCard(
                                              amount: (((widget.total >= 300000) ? 0 : 20000) + widget.total - discountPrice.floor()).toString(),
                                              currency: 'VND',
                                              orderId: orderId,);
                                      // TODO: Create Order
                                      /*if (response.success) {
                                        _checkoutController.onPayment(
                                          name: _receiverName,
                                          phoneNumber: _phoneNumber,
                                          address: _address,
                                          productList: widget.productList,
                                          total: widget.total.toString(),
                                          clientSecret: response.clientSecret,
                                          orderId: orderId,
                                          paymentMethodId: response.paymentMethodId,
                                          discountPrice: discountPrice.floor().toString(),
                                          coupon: coupon,
                                        );
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => PaymentCompleteView(
                                            totalPrice: widget.total,
                                          ),),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                        widget._globalKey.currentState.showSnackBar(SnackBar(
                                          content: Text(response.clientSecret),
                                          duration: Duration(seconds: 10),
                                        ));
                                      }*/

                                      _checkoutController.onPayment(
                                        name: _receiverName,
                                        phoneNumber: _phoneNumber,
                                        address: _address,
                                        productList: widget.productList,
                                        total: widget.total.toString(),
                                        clientSecret: response.clientSecret,
                                        orderId: orderId,
                                        paymentMethodId: response.paymentMethodId,
                                        discountPrice: discountPrice.floor().toString(),
                                        coupon: coupon,
                                      );
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => PaymentCompleteView(
                                          totalPrice: widget.total,
                                        ),),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  //TODO: Payment via existing card
                                  CusRaisedButton(
                                    title: 'Pay via existing card',
                                    backgroundColor: Colors.deepOrangeAccent,
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('Cards')
                                                      .where('uid', isEqualTo: widget.uid)
                                                      .snapshots(),
                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height:7,
                                                          ),
                                                          AutoSizeText(
                                                            'Bank Cards',
                                                            textAlign: TextAlign.center,
                                                            maxLines: 2,
                                                            minFontSize: 15,
                                                            style: TextStyle(
                                                                fontSize:17,
                                                                color: kColorBlack,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          (snapshot.data.docs.length != 0)
                                                              ? ListView(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.vertical,
                                                            children: snapshot.data.docs.map((DocumentSnapshot document) {
                                                              return Center(
                                                                child: GestureDetector(
                                                                        //TODO: Payment with exist card
                                                                  onTap: () async {
                                                                    ProgressDialog
                                                                    dialog = new ProgressDialog(context);
                                                                    dialog.style(message: 'Please wait...');
                                                                    dialog.show();
                                                                          //TODO: Show dialog loading
                                                                    cardNumber = document['cardNumber'];
                                                                    expiryMonth = document['expiryMonth'];
                                                                    expiryYear = document['expiryYear'];
                                                                    cardHolderName = document['cardHolderName'];
                                                                    cvvCode = document['cvvCode'];
                                                                    CreditCard stripeCard = CreditCard(
                                                                      number: cardNumber,
                                                                      expMonth: expiryMonth,
                                                                      expYear: expiryYear,);
                                                                    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
                                                                    var response = await StripeService.paymentWithExistCard(
                                                                        amount: (((widget.total >= 300000) ? 0 : 20000) + widget.total - discountPrice.floor()).toString(),
                                                                        currency: 'VND',
                                                                        card: stripeCard,
                                                                        orderId: orderId);
                                                                    dialog.hide();
                                                                          // TODO: Create Order
                                                                    if (response.success) {
                                                                      _checkoutController.onPayment(
                                                                          name: _receiverName,
                                                                          phoneNumber: _phoneNumber,
                                                                          address: _address,
                                                                          productList: widget.productList,
                                                                          total: widget.total.toString(),
                                                                          orderId: orderId,
                                                                          clientSecret: response.clientSecret,
                                                                          paymentMethodId: response.paymentMethodId,
                                                                          discountPrice: discountPrice.floor().toString(),
                                                                          coupon: coupon);
                                                                            //TODO: Payment success
                                                                      Navigator.push(context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => PaymentCompleteView(totalPrice: widget.total,)));
                                                                          } else {
                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                            widget._globalKey.currentState.showSnackBar(SnackBar(
                                                                              content: Text(response.clientSecret),
                                                                              duration: Duration(seconds: 10),
                                                                            ));
                                                                          }
                                                                        },
                                                                        child:
                                                                            CreditCardWidget(
                                                                          height: 170,
                                                                          width: 260,
                                                                          textStyle: TextStyle(
                                                                              fontSize: 17,
                                                                              color: kColorWhite,
                                                                              fontWeight: FontWeight.bold),
                                                                          cardNumber: document['cardNumber'],
                                                                          expiryDate: '${document['expiryMonth'].toString()} / ${document['expiryYear'].toString()}',
                                                                          cardHolderName: document['cardHolderName'],
                                                                          cvvCode: document['cvvCode'],
                                                                          showBackView: false,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                )
                                                              : Container(
                                                                  height:400,
                                                                  width: 260,
                                                                  child: Stack(
                                                                    children: <Widget>[
                                                                      Positioned(
                                                                        top: 175,
                                                                        left: 60,
                                                                        child: Container(
                                                                          width: 162,
                                                                          height: 85,
                                                                          decoration: BoxDecoration(
                                                                            image: DecorationImage(
                                                                              image: AssetImage(KImageAddress + 'noCreditCard.png'),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 325,
                                                                        left: 50,
                                                                        child: Text(' No Credit Card Found',
                                                                          style: kBoldTextStyle.copyWith(
                                                                              color: kColorBlack.withOpacity(0.8),
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Center(
                                                          child: CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                              ));
                                    },
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  CusRaisedButton(
                                    title: 'Cancel',
                                    backgroundColor: kColorBlack,
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              );
            }),
      ),
    );
  }
}
