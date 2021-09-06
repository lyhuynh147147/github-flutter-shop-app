import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/product.dart';

import '../product_controller.dart';

class AddToCart extends StatefulWidget {
  AddToCart({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  ProductController _controller = new ProductController();
  bool _isLogging = false;
  bool _isAddBtnPress = true;
  int colorValue;
  bool _isLoveCheck = false;
  String sizeValue;
  List<ColorInfo> _listColorPicker = [];
  List _sizeList = ['S', 'M', 'L', 'XL'];
  bool _isSoldOut = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (int.parse(widget.product.quantityMain) == 0) {
      _isSoldOut = true;
    }
    getIsCheckWishlist();
    int i = 1;
    for (var value in widget.product.colorList) {
      _listColorPicker.add(ColorInfo(id: i, color: Color(value)));
      i++;
    }
    _sizeList = widget.product.sizeList;
    colorValue = _listColorPicker.elementAt(0).color.value;

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }

  getIsCheckWishlist() async {
    String userUid = await StorageUtil.getUid();
    final snapShot = await FirebaseFirestore.instance
        .collection('Wishlists')
        .doc(userUid)
        .collection(userUid)
        .doc(widget.product.id)
        .get();
    bool isExists = snapShot.exists;
    if (isExists) {
      setState(() {
        _isLoveCheck = true;
      });
    }
  }
  /*FirestoreService _firebaseServices = FirestoreService();
  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.product.id)
        .set(widget.product.toMap());
  }
  Future _addToQuentity() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.product.id)
        .set({
      'id':widget.product.id,
      'image':widget.product.image,
      'name':widget.product.name,
      'price':widget.product.price,
      'description':widget.product.description,
      'size':widget.product.size,
      'numOfItems': numOfItems,

    });
  }*/
  int numOfItems = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Column(
        children:[
          Row(
            children: <Widget>[
              buildOutlineButton(
                icon: Icons.remove,
                press: () {
                  if (numOfItems > 1) {
                    setState(() {
                      numOfItems--;
                    });
                  }
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
                  }),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: kDefaultPaddin),
                height: 50,
                width: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    //color: product.color,
                    color: Colors.grey
                  ),
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      //color: product.color,
                      color: Colors.grey,
                      size: 30,
                    ),
                  onPressed: () {
                    //_addToCart();
                    //_addToQuentity();
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    //color: product.color,
                    color: Colors.grey,
                    onPressed: () async {
                      if (_isLogging) {
                        setState(() {
                          _isAddBtnPress = false;
                        });
                        //TODO: Add product
                        await _controller
                            .addProductToCart(
                            color: colorValue,
                            size: sizeValue,
                            product: widget.product)
                            .then((isComplete) {
                          if (isComplete != null) {
                            if (isComplete) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: kColorWhite,
                                content: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.check,
                                      color: kColorGreen,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width:10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Product has been add to Your Cart.',
                                        style: kBoldTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: kColorWhite,
                                content: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: kColorRed,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Added error.',
                                        style: kBoldTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                            }
                          }
                          setState(() {
                            _isAddBtnPress = true;
                          });
                        });
                      } else {
                        Navigator.pushNamed(context, 'register_screen');
                      }
                    },
                    child: Text(
                      "Buy  Now".toUpperCase(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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