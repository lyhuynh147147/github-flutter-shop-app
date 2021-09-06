import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/size_config.dart';
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

  @override
  Widget build(BuildContext context) {
    //RatingController _controller = new RatingController();
    return GestureDetector(
      onTap: widget.onTap,
      child:  Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
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
                      PrimaryText(
                          text: widget.productName, fontWeight: FontWeight.w700, color: Color(
                          0xff231919), size: 20),
                      // SizedBox(height: 5),
                      // PrimaryText(
                      //     text: 'widget.product.price', size: 18, fontWeight: FontWeight.w700),
                      // SizedBox(height: 5),
                      AutoSizeText(
                        Util.intToMoneyType(widget.price) + ' VND',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 15,
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
                            fontSize: 22,
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
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 0,
                      constraints: BoxConstraints(
                        minWidth: 0,
                      ),
                      shape: CircleBorder(),
                      fillColor:  Color(0xffec6813),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.add, size: 16, color: Colors.white)),
                )
              ],
            )
          ],
        ),
        // child: Column(
        //   children: <Widget>[
        //     // Expanded(
        //     //   child: Padding(
        //     //     padding: const EdgeInsets.all(2.0),
        //     //     child: ClipRRect(
        //     //         borderRadius: BorderRadius.only(
        //     //           topLeft: Radius.circular(5),
        //     //           topRight: Radius.circular(5),
        //     //         ),
        //     //         child: Image.network(
        //     //           widget.image,
        //     //           fit: BoxFit.fill,
        //     //           width: double.infinity,
        //     //         )
        //     //       /*child: Hero(
        //     //         tag: "${widget.id}",
        //     //         child: Image.network(
        //     //           widget.image,
        //     //           fit: BoxFit.fill,
        //     //           width: double.infinity,
        //     //           //width: double.infinity,
        //     //         ),
        //     //       )*/
        //     //     ),
        //     //   ),
        //     // ),
        //     CustomText(
        //       text: widget.productName,
        //       size: 18,
        //       weight: FontWeight.bold,
        //     ),
        //     ///Start
        //     /*Container(
        //     child: StreamBuilder(
        //         stream: _controller.averageStream,
        //         builder: (context, snapshot) {
        //           return RatingBar.builder(
        //             allowHalfRating: true,
        //             initialRating: snapshot.hasData ? snapshot.data : 0,
        //             itemCount: 5,
        //             minRating: 0,
        //             itemSize: 27,
        //             itemBuilder: (context, _) => Icon(
        //               Icons.star,
        //               color: Colors.amberAccent,
        //             ),
        //           );
        //         }),
        //   ),*/
        //     CustomText(
        //       text: widget.brand,
        //       color: Colors.grey,
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         /*Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.only(left: 8.0),
        //           child: CustomText(
        //             text: "\$${widget.price}",
        //             size: 22,
        //             weight: FontWeight.bold,
        //           ),
        //         ),
        //       ),*/
        //         Expanded(
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Column(
        //               children: [
        //                 //TODO: Product Price
        //                 AutoSizeText(
        //                   Util.intToMoneyType(widget.price) + ' VND',
        //                   maxLines: 1,
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       color: kColorBlack,
        //                       decoration: (widget.salePrice != 0)
        //                           ? TextDecoration.lineThrough
        //                           : TextDecoration.none),
        //                   minFontSize: 5,
        //                   textAlign: TextAlign.center,
        //                 ),
        //                 //TODO: Sale Price
        //                 (widget.salePrice != 0)
        //                     ? AutoSizeText(
        //                   Util.intToMoneyType(widget.salePrice) + ' VND',
        //                   maxLines: 1,
        //                   style: TextStyle(
        //                       fontSize: 22,
        //                       color: kColorRed,
        //                       fontWeight: FontWeight.bold
        //                   ),
        //                   minFontSize: 5,
        //                   textAlign: TextAlign.center,
        //                 )
        //                     : Text(' '),
        //               ],
        //             ),
        //           ),
        //         ),
        //         IconButton(
        //           icon: Icon(Icons.star),
        //           onPressed: () {
        //             //cartController.addProductToCart(product);
        //           },
        //         ),
        //         /*Positioned(
        //         left: 330,
        //         top: 2,
        //         child: IconButton(
        //           onPressed: () {
        //             //TODO: Check logging
        //             if (_isLogging) {
        //               if (!_isLoveCheck) {
        //                 //TODO: Adding product to Wishlist
        //                 _controller
        //                     .addProductToWishlist(product: widget.product)
        //                     .then((value) {
        //                   if (value) {
        //                     setState(() {
        //                       _isLoveCheck = true;
        //                     });
        //                     Scaffold.of(context).showSnackBar(SnackBar(
        //                       backgroundColor: kColorWhite,
        //                       content: Row(
        //                         children: <Widget>[
        //                           Icon(
        //                             Icons.check,
        //                             color: kColorGreen,
        //                             size:25,
        //                           ),
        //                           SizedBox(
        //                             width: 10,
        //                           ),
        //                           Expanded(
        //                             child: Text(
        //                               'Product has been add to Wishlist.',
        //                               style: kBoldTextStyle.copyWith(
        //                                   fontSize: 14),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ));
        //                   }
        //                 });
        //               }
        //             } else {
        //               Navigator.pushNamed(context, 'register_screen');
        //             }
        //           },
        //           icon: Icon(
        //             _isLoveCheck ? Icons.favorite : Icons.favorite_border,
        //             color: _isLoveCheck ? kColorRed : kColorBlack,
        //             size: 30,
        //           ),
        //         ),
        //       ),*/
        //       ],
        //     ),
        //   ],
        // ),
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

/*GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              /*decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),*/
              child: Hero(
                tag: "${product.id}",
                child: Image.asset(product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\$${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    )*/
/*child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                //color: new Color(products.color),
                //color: Color(products.color.alpha).withOpacity(1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Hero(
                tag: "${widget.id}",
                child: Image.network(widget.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              widget.productName,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\$${widget.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

        ],
      ),*/