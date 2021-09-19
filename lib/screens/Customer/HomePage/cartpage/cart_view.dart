import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/link.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/card_cart_product.dart';
import 'checkout_view.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  StreamController _streamController = new StreamController();
  StreamController _productController = new StreamController();
  List<Product> productInfoList = [];
  List<CartProductCard> uiProductList = [];
  int totalPrice = 0;
  String totalPriceText = '';
  String uidUser = '';

  void dispose() {
    super.dispose();
    _productController.close();
  }


  //TODO: Delete product
  void onDelete(String productID) {
    // TODO: find Product widget
    var find = uiProductList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (find != null) {
      FirebaseFirestore.instance
          .collection('Carts')
          .doc(uidUser)
          .collection(uidUser)
          .doc(productID)
          .delete();
      setState(() {
        uiProductList.removeAt(uiProductList.indexOf(find));
      });
    } else {
      print(('Close faild'));
    }
    // TODO: find Product Info
    var findProInfo = productInfoList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (findProInfo != null) {
      productInfoList.removeAt(productInfoList.indexOf(findProInfo));
      getTotal();
    }
  }

//TODO: Update new quantity
  void onChangeQty(String qty, String productID) {
    var find = productInfoList.firstWhere((it) => it.id == productID,
        orElse: () => null);
    if (find != null) {
      int index = productInfoList.indexOf(find);
      productInfoList.elementAt(index).quantity = qty;
      FirebaseFirestore.instance
          .collection('Carts')
          .doc(uidUser)
          .collection(uidUser)
          .doc(productInfoList.elementAt(index).id)
          .update({'quantity': qty});
      getTotal();
    }
  }

//TODO: get total
  void getTotal() {
    totalPrice = 0;
    for (var product in productInfoList) {
      int price = (product.salePrice == '0')
          ? int.parse(product.price)
          : int.parse(product.salePrice);
      totalPrice += (price * int.parse(product.quantity));
    }
    setState(() {
      totalPriceText = Util.intToMoneyType(totalPrice);
    });
  }

//TODO: get product quantity Server
  void getQuantity() {
    for (var product in productInfoList) {
      FirebaseFirestore.instance
          .collection('Products')
          .doc(product.id)
          .get()
          .then((document) {
        product.quantityMain = document['quantity'];
      });
    }
  }


  void onTaps() {
    // FirebaseFirestore.instance
    //     .collection('Products')
    //     .orderBy('create_at',descending: true)
    //     .get().then((value) {
    //
    //   Product products = new Product(
    //     id: value.docs['id'],
    //     productName: value.data()['name'],
    //     imageList: value.data()['image'],
    //     category: value.data()['categogy'],
    //     sizeList: value.data()['size'],
    //     colorList: value.data()['color'],
    //     price: value.data()['price'],
    //     salePrice: value.data()['sale_price'],
    //     brand: value.data()['brand'],
    //     madeIn: value.data()['made_in'],
    //     quantityMain: value.data()['quantity'],
    //     quantity: '',
    //     description: value.data()['description'],
    //     rating: value.data()['rating'],
    //   );
    //
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DetailsScreen(
    //         product: products,
    //       ),
    //     ),
    //   );
    // });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    StorageUtil.getUid().then((uid) {
      _streamController.add(uid);
      uidUser = uid;
      //TODO: count item
      FirebaseFirestore.instance
          .collection('Carts')
          .doc(uid)
          .collection(uid)
          .get()
          .then((onValue) {
        int index = 0;
        //TODO:Get list product
        for (var value in onValue.docs) {
          print('Sale: ' + value.data()['sale_price']);
          Product product = new Product(
            id: value.data()['id'],
            productName: value.data()['name'],
            image: value.data()['image'],
            category: value.data()['categogy'],
            size: value.data()['size'],
            color: value.data()['color'],
            price: value.data()['price'],
            salePrice: value.data()['sale_price'],
            brand: value.data()['brand'],
            madeIn: value.data()['made_in'],
            quantity: value.data()['quantity'],


          );
          productInfoList.add(product);
          getQuantity();
        }
        // TODO: add list product widget
        uiProductList = productInfoList.map((product) {
          return CartProductCard(
            id: product.id,
            productName: product.productName,
            productPrice: int.parse(product.price),
            productSalePrice: int.parse(product.salePrice),
            productColor: Color(product.color),
            productSize: product.size,
            productImage: product.image,
            brand: product.brand,
            madeIn: product.madeIn,
            quantity: int.parse(product.quantity),
            //TODO: onQtyChange
            onQtyChange: (qty) {
              print(qty);
              setState(() {
                product.quantity = qty;
              });
              onChangeQty(qty, product.id);
            },
            onClose: () {
              onDelete(product.id);
            },
            onTap: () {
              onTaps();

            },

          );
        }).toList();
        //TODO: update Item count
        setState(() {
          uiProductList.length;
        });
        getTotal();
        _productController.sink.add(true);
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.white.withOpacity(.05),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black87,
                  //size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Giỏ hàng:  ' + uiProductList.length.toString() + ' Sản phẩm'  ,
                style: TextStyle(
                  fontSize: 20,
                  //color: Colors.white.withOpacity(.7),
                  color: Colors.black.withOpacity(.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
               /* IconButton(
                  tooltip: 'Settings',
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon:
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 32,
                    color: Colors.black.withOpacity(.7),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RouteWhereYouGo2();
                        },
                      ),
                    );
                  },
                ),*/
                Text(''  ''),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshotMain) {
          if (snapshotMain.hasData) {
            //TODO: Load list cart product
            return StreamBuilder(
              stream: _productController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (uiProductList.length != 0) {
                    return ListView.builder(
                      itemCount: uiProductList.length,
                      itemBuilder: (_, index) => uiProductList[index],);
                  } else {
                    return Container(
                      width: 350,
                      height: 500,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 175,
                            left: 70,
                            child: Container(
                              width: 240,
                              height: 125,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      KImageAddress + 'noItemsCart.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 325,
                            left: 125,
                            child: Text(
                              'No Product Order',
                              style: kBoldTextStyle.copyWith(
                                  color: kColorBlack.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: kColorBlack.withOpacity(0.5), width: 1),
          ),
        ),
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: Total price
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: AutoSizeText(
                          'Thành Tiền:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          minFontSize: 15,
                        ),
                      ),
                      // TODO: Total Price Value

                      Expanded(
                        flex: 5,
                        child: AutoSizeText(
                          totalPriceText + ' VND',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,),
                          minFontSize: 15,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //TODO: Purchase button
            Expanded(
              flex: 2,
              child: CusRaisedButton(
                title: 'PLACE THIS ORDER',
                backgroundColor: kColorBlack,
                height: 75,
                onPress: () {
                  if (totalPrice != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProcessingOrderView(
                          productList: productInfoList,
                          total: totalPrice,
                          uid: uidUser,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
