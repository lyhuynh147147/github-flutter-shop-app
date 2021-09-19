import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/customer/HomePage/details/product_controller.dart';

class ItemCard extends StatefulWidget {
  final Product product;
  final Function press;
  final String id;
  final String productName;
  final String image;
  final String brand;
  final int price;
  final int salePrice;
  final bool isIconClose;
  final Function onTap;
  final Function onClosePress;
  final bool isSoldOut;
  const ItemCard({
    Key key,
    this.product,
    this.press, this.id, this.productName, this.image, this.price, this.salePrice, this.isIconClose, this.onTap, this.onClosePress, this.isSoldOut, this.brand,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}


class _ItemCardState extends State<ItemCard>  {

  //TODO: value
  int colorValue;
  String sizeValue;

  @override
  Widget build(BuildContext context) {
    double discount = 100 - ((widget.salePrice / widget.price) * 100);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  offset: Offset(3, 2),
                  blurRadius: 7)
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: (discount != 0)
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8,bottom: 175,right: 120),
                      child: Container(
                        //height: 10,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            ' ${discount.toInt()}% off ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container(
                      //padding: EdgeInsets.only(top: 10),
                      // decoration: BoxDecoration(
                      //   color: Colors.pink,
                      //   borderRadius: BorderRadius.only(
                      //     //bottomLeft: Radius.circular(20.0),
                      //   ),
                      // ),
                      // height: 40,
                      // width: 60,
                      // child: Center(
                      //   child: Text(
                      //     '${discount.toInt()}%FF',
                      //     style: TextStyle(
                      //         fontSize: 16,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold
                      //     ),
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 5),
                child: CustomText(
                  text: widget.productName,
                  size: 20,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    SizedBox(
                      height: 5,
                    ),
                    //TODO: Product Price
                    AutoSizeText(
                      Util.intToMoneyType(widget.price) + ' VND',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          color: kColorBlack,
                          decoration: (widget.salePrice != 0)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      minFontSize: 5,
                      //textAlign: TextAlign.center,
                    ),
                    //TODO: Sale Price
                    (widget.salePrice != 0)
                        ? AutoSizeText(
                      Util.intToMoneyType(widget.salePrice) + ' VND',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 22,
                          color: kColorRed,
                          fontWeight: FontWeight.bold
                      ),
                      minFontSize: 5,
                      //textAlign: TextAlign.center,
                    )
                        : Text(' '),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;

  const CustomText({Key key, this.text, this.size, this.color, this.weight}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size ?? 16, color: color ?? Colors.black, fontWeight: weight ?? FontWeight.normal),
    );
  }
}
