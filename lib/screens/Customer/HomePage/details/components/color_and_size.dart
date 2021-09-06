import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/details/RatingPage/rating_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../product_controller.dart';
import 'color_picker.dart';
import 'description.dart';
import 'image_product_view.dart';

class ColorAndSize extends StatefulWidget {
   ColorAndSize({
    Key key,
    this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ColorAndSizeState createState() => _ColorAndSizeState();
}

class _ColorAndSizeState extends State<ColorAndSize>
    with AutomaticKeepAliveClientMixin{
  RatingController _controllers = new RatingController();

  ProgressDialog pr;
  bool _isLogging = false;
  List _sizeList = ['S', 'M', 'L', 'XL'];
  bool _isLoveCheck = false;
  bool _isAddBtnPress = true;
  int _isColorFocus = 1;
  List<ColorInfo> _listColorPicker = [];

  ProductController _controller = new ProductController();
  CarouselController buttonCarouselController = new CarouselController();

  bool _isSoldOut = false;
  int _indexPage = 1;
  //TODO: value
  int colorValue;
  String sizeValue;
  int numOfItems = 1;

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

  //TODO: Check isCheckWishList
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

  //TODO: Create Color Picker Bar
  Widget renderColorBar() {
    List<Widget> listWidget = [];
    for (var value in _listColorPicker) {
      listWidget.add(Padding(
        padding: EdgeInsets.only(left: 4),
        child: ColorPicker(
          color: value.color,
          isCheck: _isColorFocus == value.id,
          onTap: () {
            setState(() {
              _isColorFocus = value.id;
            });
            //TODO: jump to color
            if (_listColorPicker.length > 1) {
              print(value.id);
              if (value.id <= 2) {
                if (value.id == 1) {
                  buttonCarouselController.jumpToPage(0);
                } else {
                  buttonCarouselController.jumpToPage(2);
                }
              } else {
                buttonCarouselController.jumpToPage(value.id - 2);
              }
            }
            //TODO: color value pick
            colorValue = value.color.value;
          },
        ),
      ));
    }
    return Row(
      children: listWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: size.height * 0.5,
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 400,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,

                  // height: 400,
                  // aspectRatio: 16/9,
                  // viewportFraction: 0.8,
                  // initialPage: 0,
                  // enableInfiniteScroll: true,
                  // reverse: false,
                  // autoPlay: false,
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  // enlargeCenterPage: true,
                  // //onPageChanged: callbackFunction,
                  // scrollDirection: Axis.horizontal,

                ),
                carouselController: buttonCarouselController,
                items: widget.product.imageList.map((image) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageProductView(
                                onlineImage: image,
                              )));
                    },
                    child: CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: image,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }).toList(),
              ),
            ),
            //TODO: Close Button
            //SizedBox(width: kDefaultPaddin / 2),
            SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              IconButton(
                                color: kColorBlack,
                                iconSize: 25,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 25,
                                ),
                              ),
                              Text(
                                'Back' ,
                                style: TextStyle(
                                    color: kColorBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            //TODO: Check logging
                            if (_isLogging) {
                              if (!_isLoveCheck) {
                                //TODO: Adding product to Wishlist
                                _controller
                                    .addProductToWishlist(product: widget.product)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      _isLoveCheck = true;
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: kColorWhite,
                                      content: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.check,
                                            color: kColorGreen,
                                            size:25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Sản phẩm đã được thêm vào Danh sách yêu thích.',
                                              style: kBoldTextStyle.copyWith(
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  }
                                });
                              }
                              else{
                                print('sss');
                                _controller
                                    .deleteProductToWishlist(product: widget.product)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      _isLoveCheck = false;
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: kColorWhite,
                                      content: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.check,
                                            color: kColorGreen,
                                            size:25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Sản phẩm đã được xoá vào Danh sách yêu thích.',
                                              style: kBoldTextStyle.copyWith(
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  }
                                });
                              }
                            } else {
                              Navigator.pushNamed(context, 'phone_in');
                            }
                          },
                          icon: Icon(
                            _isLoveCheck ? Icons.favorite : Icons.favorite_border,
                            color: _isLoveCheck ? kColorRed : kColorBlack,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black87,
                            size: 30,
                          ),
                          onPressed: () {
                            /* Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (ctx) => CartScreen()));*/
                            if (_isLogging) {
                              /*setState(() {
                        _isAddBtnPress = false;
                      });*/
                              Navigator.pushNamed(context, 'customer_cart_page');

                              //TODO: Add product
                            } else {
                              Navigator.pushNamed(context, 'phone_in');
                            }
                            //Navigator.pushNamed(context, 'customer_cart_page');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       child: Row(
            //         children: [
            //           IconButton(
            //             color: kColorBlack,
            //             iconSize: 25,
            //             onPressed: () {
            //               Navigator.pop(context);
            //             },
            //             icon: Icon(
            //               Icons.arrow_back_ios,
            //               size: 25,
            //             ),
            //           ),
            //           Text(
            //             'Back' ,
            //             style: TextStyle(
            //                 color: kColorBlack,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500),
            //           ),
            //         ],
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(
            //         Icons.shopping_cart_outlined,
            //         color: Colors.black87,
            //         size: 30,
            //       ),
            //       onPressed: () {
            //         /* Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //         builder: (ctx) => CartScreen()));*/
            //         if (_isLogging) {
            //           /*setState(() {
            //             _isAddBtnPress = false;
            //           });*/
            //           Navigator.pushNamed(context, 'customer_cart_page');
            //
            //           //TODO: Add product
            //         } else {
            //           Navigator.pushNamed(context, 'phone_in');
            //         }
            //         //Navigator.pushNamed(context, 'customer_cart_page');
            //       },
            //     ),
            //   ],
            // ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                //border: Border.all(color: Colors.black)
              ),
              width: double.infinity,
              margin: EdgeInsets.only(top: size.height*0.45),
              //padding: EdgeInsets.only(left: 10,right: 10),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      child: Container(
                        width: 150,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      child: renderColorBar(),
                    ),
                    SizedBox(height: kDefaultPaddin / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Row(
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
                        ),
                        Expanded(
                          flex: 2,
                          child: StreamBuilder(
                              stream: _controller.sizeStream,
                              builder: (context, snapshot) {
                                return DropdownButton(
                                  isExpanded: true,
                                  style: TextStyle(fontSize: 15),
                                  value: sizeValue,
                                  hint: (snapshot.hasError)
                                      ? Text(
                                    snapshot.error,
                                    style: kBoldTextStyle.copyWith(
                                        color: kColorRed),
                                  )
                                      : Text('Select size'),
                                  onChanged: (value) {
                                    setState(() {
                                      sizeValue = value;
                                    });
                                  },
                                  items: _sizeList.map((value) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        'Size ' + value,
                                        style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: 15,
                                        ),
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                );
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    ///Button
                    Row(
                      children: [
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
                            onPressed: () async {
                              //_addToCart();
                              //_addToQuentity();
                              if (_isLogging) {
                                setState(() {
                                  _isAddBtnPress = false;
                                });
                                //TODO: Add product
                                await _controller
                                    .addProductToCart(
                                    color: colorValue,
                                    quantity: numOfItems.toString(),
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
                                                'Sản phẩm đã được thêm vào giỏ hàng của bạn.',
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
                                Navigator.pushNamed(context, 'phone_in');
                              }
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
                                      quantity: numOfItems.toString(),
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
                                        Navigator.pushNamed(context, 'customer_cart_page');
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
                                  Navigator.pushNamed(context, 'phone_in');
                                }
                              },
                              child: Text(
                                "Mua ".toUpperCase(),
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
                    Description(
                      product: widget.product,
                    ),
                  ],
                ),
              ),
            )
            ///TODO: Wistlist IconButton
          ],
        ),
        //Divider(height: 1,color: Colors.black, thickness: 2.0,),
      ],
    );
  }

  Widget soldOutWidget() {
    return CusRaisedButton(
      title: 'SOLD OUT',
      backgroundColor: kColorRed,
      onPress: () {},
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorDot({
    Key key,
    this.color,
    // by default isSelected is false
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: kDefaultPaddin / 4,
        right: kDefaultPaddin / 2,
      ),
      padding: EdgeInsets.all(2.5),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
