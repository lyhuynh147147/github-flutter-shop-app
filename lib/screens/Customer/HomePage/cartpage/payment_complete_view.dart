import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/widgets/button_raised.dart';

class PaymentCompleteView extends StatefulWidget {
  PaymentCompleteView({this.totalPrice});

  final int totalPrice;

  @override
  _PaymentCompleteViewState createState() => _PaymentCompleteViewState();
}

class _PaymentCompleteViewState extends State<PaymentCompleteView> {
  @override
  Widget build(BuildContext context) {
   // ConstScreen.setScreen(context);
    return Scaffold(
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: kColorGreen,
                    size: 125,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Text(
                      Util.intToMoneyType(widget.totalPrice) + ' VND',
                      textAlign: TextAlign.center,
                      style: kNormalTextStyle.copyWith(fontSize: 37),
                    ),
                    Text(
                      'Your payment is complete.',
                      textAlign: TextAlign.center,
                      style: kNormalTextStyle.copyWith(fontSize: 20),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: CusRaisedButton(
                          title: 'CONTINUTE SHOPPING',
                          backgroundColor: kColorGreen,
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                'customer_home_screen',
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
