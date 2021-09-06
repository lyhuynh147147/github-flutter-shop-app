import 'package:flutter/material.dart';
import 'package:phone_verification/model/product.dart';

import 'cart_counter.dart';

class CounterWithFavBtn extends StatelessWidget {
  const CounterWithFavBtn({
    Key key, this.product,
  }) : super(key: key);
final Product product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(product: product,),
        Container(
          padding: EdgeInsets.all(4),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Color(0xFFFF6464),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.sentiment_satisfied_alt),
        )
      ],
    );
  }
}