import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';

import 'box_info.dart';

class CartProductCard extends StatefulWidget {
  CartProductCard({
    this.id,
    this.productName = '',
    this.productSize = '',
    this.productColor = kColorWhite,
    this.productPrice = 0,
    this.productImage = '',
    this.productSalePrice = 0,
    this.quantity = 1,
    this.brand,
    this.madeIn,
    this.onQtyChange,
    this.onClose,
    //this.numOfItems = 1,
  });
  final String productName;
  final Color productColor;
  final String productSize;
  final int productPrice;
  final int productSalePrice;
  final String productImage;
  int quantity;
  final String brand;
  final String madeIn;
  final Function onClose;
  final Function onQtyChange;
  final String id;
  //int numOfItems;

  @override
  _CartProductCardState createState() => _CartProductCardState();
}


class _CartProductCardState extends State<CartProductCard> {
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

  @override
  Widget build(BuildContext context) {
    double discount = 100 - ((widget.productSalePrice / widget.productPrice) * 100);
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Xóa',
            color: Colors.grey,
            icon: Icons.delete,
            onTap: () {
              widget.onClose();
            },
          ),
        ],
        ///
        child: Container(
          height: 130,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    offset: Offset(3, 2),
                    blurRadius: 7)
              ]
          ),
          //color: Colors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO: Image Product
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: <Widget>[
                        //TODO: image
                        Container(
                          width: 110,
                          height: 130,
                          decoration: BoxDecoration(
                            //border: Border.all(color: kColorBlack.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(widget.productImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Detail product
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //// TODO: Name Product
                      Container(
                        child: Expanded(
                          flex: 5,
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText(
                                  widget.productName,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  minFontSize: 15,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: kColorBlack,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // TODO: Product Size
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Size: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kColorBlack,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: AutoSizeText(
                                            widget.productSize,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            minFontSize: 15,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: kColorBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //SizedBox(width: 50,),
                                  // TODO: Product Color
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Màu:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kColorBlack,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: kColorBlack.withOpacity(0.5)),
                                            borderRadius: BorderRadius.circular(30),
                                            color: widget.productColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //TODO: quantity
                                  /*Row(
                                    children: <Widget>[
                                      buildOutlineButton(
                                        icon: Icons.remove,
                                        press: () {
                                          if (widget.quantity > 1) {
                                            setState(() {
                                              widget.quantity--;
                                              //widget.quantity = qty;
                                              //widget.onQtyChange = qty;
                                            });
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                                        child: Text(
                                          // if our item is less  then 10 then  it shows 01 02 like that
                                          widget.quantity.toString().padLeft(2, "0"),
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      ),
                                      //numOfItems = ,
                                      buildOutlineButton(
                                          icon: Icons.add,
                                          press: () {
                                            setState(() {
                                              widget.quantity++;
                                            });
                                            //widget.onQtyChange;
                                          }),
                                    ],
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              //flex: 1,
                              child:TextFormField(
                                initialValue: widget.quantity.toString(),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Số lượng',
                                  hintStyle: kBoldTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  focusColor: Colors.black,
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                onChanged: (qty) {
                                  widget.onQtyChange(qty);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: (widget.productSalePrice == 0)
                                    ? AutoSizeText(
                                        '${Util.intToMoneyType(widget.productPrice)} VND',
                                        maxLines: 1,
                                        minFontSize: 10,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: kColorBlack,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.end,
                                      )
                                    : Column(
                                        children: <Widget>[
                                          //TODO: discount
                                          AutoSizeText(
                                            '${discount.toInt()}% OFF',
                                            maxLines: 1,
                                            minFontSize: 5,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: kColorRed,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.end,
                                          ),
                                          //TODO: price sale
                                          AutoSizeText(
                                            '${Util.intToMoneyType(widget.productSalePrice)} VND',
                                            maxLines: 1,
                                            minFontSize: 5,
                                            style: TextStyle(
                                                fontSize: 21,
                                                color: kColorRed,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(width: 10,)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* Container(
          height: 210,
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO: Image Product
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10),
                    child: Stack(
                      children: <Widget>[
                        //TODO: image
                        CachedNetworkImage(
                          imageUrl: widget.productImage,
                          fit: BoxFit.fill,
                          height: 200,
                          width: 140,
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Detail product
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //// TODO: Name Product
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                widget.productName,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            //TODO: Brand
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                'Brand: ${widget.brand}',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            //TODO: Made In
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                'Made in: ${widget.madeIn}',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            // TODO: Size, color Product and Quantity
                            Row(
                              children: <Widget>[
                                // TODO: Product Color
                                Expanded(
                                  flex: 1,
                                  child: BoxInfo(
                                    color: widget.productColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                // TODO: Product Size
                                Expanded(
                                  flex: 1,
                                  child: BoxInfo(
                                    sizeProduct: widget.productSize,
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                //TODO: quantity
                                Expanded(
                                  flex: 3,
                                  child:Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: TextFormField(
                                      initialValue: widget.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        hintStyle: kBoldTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        focusColor: Colors.black,
                                      ),
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      onChanged: (qty) {
                                        widget.onQtyChange(qty);
                                        },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                /*Row(
                                  children: <Widget>[
                                    buildOutlineButton(
                                      icon: Icons.remove,
                                      press: () {
                                        if (widget.quantity > 1) {
                                          setState(() {
                                            widget.quantity--;
                                            //widget.quantity = qty;
                                            //widget.onQtyChange = qty;
                                          });
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                                      child: Text(
                                        // if our item is less  then 10 then  it shows 01 02 like that
                                        widget.quantity.toString().padLeft(2, "0"),
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    ),
                                    //numOfItems = ,
                                    buildOutlineButton(
                                        icon: Icons.add,
                                        press: () {
                                          setState(() {
                                            widget.quantity++;
                                          });
                                          //widget.onQtyChange;
                                        }),
                                  ],
                                ),*/
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: (widget.productSalePrice == 0)
                              ? AutoSizeText(
                                  '${Util.intToMoneyType(widget.productPrice)} VND',
                                  maxLines: 1,
                                  minFontSize: 10,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: kColorBlack,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.end,
                                )
                              : Column(
                                  children: <Widget>[
                                    //TODO: discount
                                    AutoSizeText(
                                      '${discount.toInt()}% OFF',
                                      maxLines: 1,
                                      minFontSize: 5,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: kColorRed,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.end,
                                    ),
                                    //TODO: price sale
                                    AutoSizeText(
                                      '${Util.intToMoneyType(widget.productSalePrice)} VND',
                                      maxLines: 1,
                                      minFontSize: 5,
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: kColorRed,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),*/