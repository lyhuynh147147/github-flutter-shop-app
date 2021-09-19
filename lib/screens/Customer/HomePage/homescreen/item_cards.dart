import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/style.dart';
import 'package:phone_verification/screens/customer/HomePage/details/product_controller.dart';

class ItemCards extends StatefulWidget {
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
  const ItemCards({
    Key key,
    this.product,
    this.press, this.id, this.productName, this.image, this.price, this.salePrice, this.isIconClose, this.onTap, this.onClosePress, this.isSoldOut, this.brand,
  }) : super(key: key);

  @override
  _ItemCardsState createState() => _ItemCardsState();
}


class _ItemCardsState extends State<ItemCards>  {

  bool _isLogging = false;
  List _sizeList = ['S', 'M', 'L', 'XL'];
  bool _isLoveCheck = false;
  bool _isAddBtnPress = true;
  int _isColorFocus = 1;
  List<ColorInfo> _listColorPicker = [];
  ProductController _controller = new ProductController();
  //CarouselController buttonCarouselController = CarouselController();
  bool _isSoldOut = false;
  int _indexPage = 1;
  //TODO: value
  int colorValue;
  String sizeValue;



  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    *//*if (int.parse(widget.product.quantityMain) == 0) {
      _isSoldOut = true;
    }*//*
    getIsCheckWishlist();
   *//* int i = 1;
    for (var value in widget.product.colorList) {
      _listColorPicker.add(ColorInfo(id: i, color: Color(value)));
      i++;
    }*//*
    *//*_sizeList = widget.product.sizeList;
    colorValue = _listColorPicker.elementAt(0).color.value;*//*

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }*/

  // //TODO: Check isCheckWishList
  // getIsCheckWishlist() async {
  //   String userUid = await StorageUtil.getUid();
  //   final snapShot = await FirebaseFirestore.instance
  //       .collection('Wishlists')
  //       .doc(userUid)
  //       .collection(userUid)
  //       .doc(widget.product.id)
  //       .get();
  //   bool isExists = snapShot.exists;
  //   if (isExists) {
  //     setState(() {
  //       _isLoveCheck = true;
  //     });
  //   }
  // }
/*'${discount.toInt()}% OFF',*/
  @override
  Widget build(BuildContext context) {

    double discount = 100 - ((widget.salePrice / widget.price) * 100);

    return GestureDetector(
      onTap: widget.onTap,
      child:  Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (discount != 0)
                ? Expanded(
              flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8,bottom: 125),
                    child: Container(
              //padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
              ),
              //height: 30,
              width: 65,
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
                  ),
                )
                : Expanded(
              flex: 9,
                  child: Container(
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


            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.withOpacity(.5)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CustomText(
                          //   text: widget.productName,
                          //   size: 20,
                          //   weight: FontWeight.bold,
                          // ),
                          Expanded(
                            flex: 5,
                            child: PrimaryText(
                              text: widget.productName,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff231919),
                              size: 20,
                            ),
                          ),
                          // SizedBox(height: 5),
                          // PrimaryText(
                          //     text: 'widget.product.price', size: 18, fontWeight: FontWeight.w700),
                          // SizedBox(height: 5),
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
                            textAlign: TextAlign.center,
                          ),
                          //TODO: Sale Price
                          (widget.salePrice != 0)
                              ? AutoSizeText(
                            Util.intToMoneyType(widget.salePrice) + ' VND',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 20,
                                color: kColorRed,
                                fontWeight: FontWeight.bold
                            ),
                            minFontSize: 5,
                            textAlign: TextAlign.center,
                          )
                              : Text(' '),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
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
