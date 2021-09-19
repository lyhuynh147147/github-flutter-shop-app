import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/item_cards.dart';
import 'package:phone_verification/screens/customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/screens/customer/HomePage/home/components/item_card.dart';
import 'package:phone_verification/widgets/card_product.dart';

import '../../../link.dart';

class WishListView extends StatefulWidget {
  @override
  _WishListViewState createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView>
    with AutomaticKeepAliveClientMixin {
  StreamController _uidStreamController = new StreamController();
  StreamController _dataStreamController = new StreamController();
  List<ItemCards> listProduct = [];
  //List<ProductCard> listProduct = [];
  bool _isLogging = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      _uidStreamController.add(uid);
      getWishlistList(uid);
    });
    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });

  }

  removeProduct(String idProduct) {
    var result =
        listProduct.firstWhere((it) => it.id == idProduct, orElse: () => null);
    if (result != null) {
      int index = listProduct.indexOf(result);
      setState(() {
        listProduct.removeAt(index);
      });
    }
  }

  Future<void> getWishlistList(String uid) async {
    List<ProductCard> list = [];
    await FirebaseFirestore.instance
        .collection('Wishlists')
        .doc(uid)
        .collection(uid)
        .get()
        .then((snap) async {
      if (snap.docs != null) {
        for (var document in snap.docs) {
          var doc = await FirebaseFirestore.instance
              .collection('Products')
              .doc(document['id'])
              .get();
          listProduct.add(/*ItemCard(
            id: doc['id'],
            productName: doc['name'],
            image: doc['image'][0],
            isSoldOut: (doc['quantity'] == '0'),
            price: int.parse(doc['price']),
            salePrice: int.parse(doc['sale_price']),
            isIconClose: true,
            onTap: () {
              Product product = new Product(
                id: doc['id'],
                productName: doc['name'],
                imageList: doc['image'],
                category: doc['categogy'],
                sizeList: doc['size'],
                colorList: doc['color'],
                price: doc['price'],
                salePrice: doc['sale_price'],
                brand: doc['brand'],
                madeIn: doc['made_in'],
                quantityMain: doc['quantity'],
                quantity: '',
                description: doc['description'],
                rating: doc['rating'],
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                    product: product,
                  ),
                ),
              );
            },
            onClosePress: () {
              FirebaseFirestore.instance
                  .collection('Wishlists')
                  .doc(uid)
                  .collection(uid)
                  .doc(doc['id'])
                  .delete();
              removeProduct(doc['id']);
            },
          ),*/
              ItemCards(
                id: doc['id'],
                brand: doc['brand'],
                productName: doc['name'],
                image: doc['image'][0],
                isSoldOut: (doc['quantity'] == '0'),
                price: int.parse(doc['price']),
                salePrice: (doc['sale_price'] != '0')
                    ? int.parse(doc['sale_price'])
                    : 0,

                isIconClose: true,
                onTap: ()  {
                  Product product = new Product(
                    id: doc['id'],
                    productName: doc['name'],
                    imageList: doc['image'],
                    category: doc['categogy'],
                    sizeList: doc['size'],
                    colorList: doc['color'],
                    price: doc['price'],
                    salePrice: doc['sale_price'],
                    brand: doc['brand'],
                    madeIn: doc['made_in'],
                    quantityMain: doc['quantity'],
                    quantity: '',
                    description: doc['description'],
                    rating: doc['rating'],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        product: product,
                      ),
                    ),
                  );
                },
              )
          );
        }
      }

      _dataStreamController.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
   // ConstScreen.setScreen(context);

    double _w = MediaQuery.of(context).size.width;
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
              centerTitle: true,
              title: Text(
                'Favonte',
                style: TextStyle(
                  fontSize: _w / 19,
                  //color: Colors.white.withOpacity(.7),
                  color: Colors.black.withOpacity(.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Settings',
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon:
                  Icon(
                    Icons.shopping_cart_outlined,
                    //size: 32,
                    color: Colors.black.withOpacity(.7),
                  ),
                  /*onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RouteWhereYouGo2();
                        },
                      ),
                    );
                  },*/
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
                    Navigator.pushNamed(context, 'register_screen');
                  }
                  //Navigator.pushNamed(context, 'customer_cart_page');
                },
                ),
                Text(''  ''),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _uidStreamController.stream,
          builder: (context, snapshotMain) {
            if (snapshotMain.hasData) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: StreamBuilder(
                    stream: _dataStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (listProduct.length != 0) {
                          return StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(1, index.isEven ? 1.5: 1.5),
                            crossAxisCount: 2,
                            scrollDirection: Axis.vertical,
                            itemCount: listProduct.length,
                            itemBuilder: (_, index) => listProduct[index],
                          );
                        } else {
                          return Container(
                            width: 350,
                            height: 500,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    width: 187,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            KImageAddress + 'emptyInbox.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 340,
                                  left: 80,
                                  child: Text(
                                    'Sorry, No Product Found',
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
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  /*Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: StaggeredGridView.count(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          //childAspectRatio: 0.7,
                          // staggeredTiles: [
                          //   StaggeredTile.extent(1, 250),
                          //   StaggeredTile.extent(1, 230),
                          // ],

                          staggeredTiles: generateTiles(snapshot.data.docs.length),
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return ItemCards(
                              brand: document['brand'],
                              productName: document['name'],
                              image: document['image'][0],
                              isSoldOut: (document['quantity'] == '0'),
                              price: int.parse(document['price']),
                              salePrice: (document['sale_price'] != '0')
                                  ? int.parse(document['sale_price'])
                                  : 0,
                              onTap: ()  {
                                Product product = new Product(
                                  id: document['id'],
                                  productName: document['name'],
                                  imageList: document['image'],
                                  category: document['categogy'],
                                  sizeList: document['size'],
                                  colorList: document['color'],
                                  price: document['price'],
                                  salePrice: document['sale_price'],
                                  brand: document['brand'],
                                  madeIn: document['made_in'],
                                  quantityMain: document['quantity'],
                                  quantity: '',
                                  description: document['description'],
                                  rating: document['rating'],
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    )*/

  List<StaggeredTile> generateTiles(int count) {
    List<StaggeredTile> _staggeredTiles = [];
    for (int i=0; i<count; i++) {
      if(i%2==0) {
        _staggeredTiles.add(new StaggeredTile.extent(1, 320));
      }else{
        _staggeredTiles.add(new StaggeredTile.extent(1, 320));
      }
    }
    return _staggeredTiles;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
