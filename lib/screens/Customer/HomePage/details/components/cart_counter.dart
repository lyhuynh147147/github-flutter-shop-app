import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/model/product.dart';

class CartCounter extends StatefulWidget {
  final Product product;
  const CartCounter({Key key, this.product,}) : super(key: key);
  @override
  _CartCounterState createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int numOfItems = 1;
  //ProductProvider productProvider;
  @override
  Widget build(BuildContext context) {
   //numOfItems = widget.product.numOfItem;
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (numOfItems > 1) {
              setState(() {
                numOfItems--;
              });
            }
            /*productProvider.getCartData(
              numOfItem: numOfItems
            );*/
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        //numOfItems = ,
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                numOfItems++;
              });
              /*productProvider.getCartData(
                  numOfItem: numOfItems
              );*/
              //numOfItems =  widget.product.numOfItem;
            }),
      ],
    );
  }



  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}