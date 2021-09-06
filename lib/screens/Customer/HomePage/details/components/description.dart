import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/product.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin/2),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${product.productName}\n",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    /*TextSpan(
                      text: "Price\n",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: "\$${product.price}",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),*/

                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              //TODO: Price
              Text(
                Util.intToMoneyType(int.parse(product.price)) +
                    ' VND',
                style: TextStyle(
                    fontSize: 20,
                    color: kColorBlack,
                    decoration: (product.salePrice != '0')
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              SizedBox(
                width: 10,
              ),
              //TODO: Sale Price
              Text(
                (product.salePrice != '0')
                    ? Util.intToMoneyType(
                    int.parse(product.salePrice)) +
                    ' VND'
                    : '',
                style: TextStyle(
                  fontSize: 20,
                  color: kColorRed,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Divider(height: 2,color: Colors.black, thickness: 2.0,),
          SizedBox(height: 10,),
          Text(
            product.description,
            style: TextStyle(height: 1.6),
          ),
        ],
      ),
    );
  }
}