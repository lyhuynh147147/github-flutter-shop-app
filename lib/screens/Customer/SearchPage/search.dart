import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/category_list.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/item_cards.dart';
import 'package:phone_verification/screens/Customer/SearchPage/search_view.dart';
import 'package:phone_verification/screens/customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/screens/customer/HomePage/home/components/categories.dart';
import 'package:phone_verification/screens/customer/HomePage/home/components/item_card.dart';

import '../../../../../link.dart';

class Search extends StatefulWidget {
  final List<Product> product;
  final String search;
  const Search({Key key, this.product, this.search}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin{
  bool isSearch = false;
  bool isSale = false;
  bool _isLogging = false;
  String title = '';


  getFirestoreSnapshot() {
    if (widget.search == 'sale') {
      setState(() {
        title = 'SALE';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .where('sale_price', isGreaterThan: '0')
          .snapshots();
    } else if (widget.search != '') {
      setState(() {
        title = 'SEARCHING';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .orderBy('create_at')
          .where('categogy', isEqualTo: widget.search)
          .snapshots();
    } else {
      setState(() {
        title = 'NEW IN';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .orderBy('create_at')
          .snapshots();
    }
  }

  ///
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: 0, end: -30)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  ///


  Widget searchBar() {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(_w/20, _w/25, _w/20,0 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: _w/8.5,
            width: _w/1.36,
            padding: EdgeInsets.symmetric(horizontal: _w/60),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 30,
                    offset: Offset(0,15),
                  ),
                ]
            ),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(.4),
                  fontWeight: FontWeight.w600,
                  fontSize: _w/22,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(.6),
                ),
                hintText: 'Search anything....',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
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
                  //Navigator.pushNamed(context, 'customer_search_page');
                },
              ),
              title: Text(
                ' Your App\'s name',
                style: TextStyle(
                  fontSize: _w / 17,
                  //color: Colors.white.withOpacity(.7),
                  color: Colors.black.withOpacity(.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Search',
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon:
                  Icon(
                    Icons.search,
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
                    Navigator.pushNamed(context, 'customer_search_page');
                  },
                ),
                IconButton(
                  tooltip: 'Card',
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon:
                  Icon(
                    Icons.shopping_cart_outlined,
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
                      Navigator.pushNamed(context, 'phone_in');
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
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: _w / 6),
          // //searchBar(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin,vertical: kDefaultPaddin),
          //   child: Text(
          //     "Womens",
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline5
          //         .copyWith(fontWeight: FontWeight.bold),
          //   ),
          // ),
          // //searchBar(),
          //Categories(),
          //CategoryList(),

          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: getFirestoreSnapshot(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
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
                                      KImageAddress + 'noSearchResult.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 325,
                            left: 80,
                            child: Text(
                              'Sorry, No Search Result',
                              style: kBoldTextStyle.copyWith(
                                  color: kColorBlack.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    // return Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(0),
                    //     child: GridView.count(
                    //       shrinkWrap: true,
                    //       physics: ScrollPhysics(),
                    //       scrollDirection: Axis.vertical,
                    //       crossAxisCount: 2,
                    //       padding: const EdgeInsets.all(10),
                    //       crossAxisSpacing: 10,
                    //       mainAxisSpacing: 6,
                    //       childAspectRatio: 0.7,
                    //       children: snapshot.data.docs
                    //           .map((DocumentSnapshot document) {
                    //         return ItemCard(
                    //           brand: document['brand'],
                    //           productName: document['name'],
                    //           image: document['image'][0],
                    //           isSoldOut: (document['quantity'] == '0'),
                    //           price: int.parse(document['price']),
                    //           salePrice: (document['sale_price'] != '0')
                    //               ? int.parse(document['sale_price'])
                    //               : 0,
                    //           onTap: ()  {
                    //             Product product = new Product(
                    //               id: document['id'],
                    //               productName: document['name'],
                    //               imageList: document['image'],
                    //               category: document['categogy'],
                    //               sizeList: document['size'],
                    //               colorList: document['color'],
                    //               price: document['price'],
                    //               salePrice: document['sale_price'],
                    //               brand: document['brand'],
                    //               madeIn: document['made_in'],
                    //               quantityMain: document['quantity'],
                    //               quantity: '',
                    //               description: document['description'],
                    //               rating: document['rating'],
                    //             );
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => DetailsScreen(
                    //                   product: product,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // );

                    return Expanded(
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
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
  Widget buildMain(){
    return StreamBuilder<QuerySnapshot>(
        stream: getFirestoreSnapshot(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
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
                              KImageAddress + 'noSearchResult.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 325,
                    left: 80,
                    child: Text(
                      'Sorry, No Search Result',
                      style: kBoldTextStyle.copyWith(
                          color: kColorBlack.withOpacity(0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            );
          } else {
            // return Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.all(0),
            //     child: GridView.count(
            //       shrinkWrap: true,
            //       physics: ScrollPhysics(),
            //       scrollDirection: Axis.vertical,
            //       crossAxisCount: 2,
            //       padding: const EdgeInsets.all(10),
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 6,
            //       childAspectRatio: 0.7,
            //       children: snapshot.data.docs
            //           .map((DocumentSnapshot document) {
            //         return ItemCard(
            //           brand: document['brand'],
            //           productName: document['name'],
            //           image: document['image'][0],
            //           isSoldOut: (document['quantity'] == '0'),
            //           price: int.parse(document['price']),
            //           salePrice: (document['sale_price'] != '0')
            //               ? int.parse(document['sale_price'])
            //               : 0,
            //           onTap: ()  {
            //             Product product = new Product(
            //               id: document['id'],
            //               productName: document['name'],
            //               imageList: document['image'],
            //               category: document['categogy'],
            //               sizeList: document['size'],
            //               colorList: document['color'],
            //               price: document['price'],
            //               salePrice: document['sale_price'],
            //               brand: document['brand'],
            //               madeIn: document['made_in'],
            //               quantityMain: document['quantity'],
            //               quantity: '',
            //               description: document['description'],
            //               rating: document['rating'],
            //             );
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => DetailsScreen(
            //                   product: product,
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // );

            return Expanded(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: StaggeredGridView.count(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
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
                    return ItemCard(
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
            );
          }
        });
  }

  List<StaggeredTile> generateTiles(int count) {
    //Random rnd = new Random();
    List<StaggeredTile> _staggeredTiles = [];
    for (int i=0; i<count; i++) {
      // num mainAxisCellCount = 0;
      // double temp = rnd.nextDouble();
      //double temp = 1;
      // if (temp > 0.6) {
      //   mainAxisCellCount = temp + 0.6;
      // } else if (temp < 0.3) {
      //   mainAxisCellCount = temp + 0.9;
      // } else {
      //   mainAxisCellCount = temp + 0.7;
      // }
      // _staggeredTiles.add(new StaggeredTile.count(rnd.nextInt(1) + 1, mainAxisCellCount));
      //_staggeredTiles.add(new StaggeredTile.extent(1, 250));
      if(i%2==0) {
        _staggeredTiles.add(new StaggeredTile.extent(1, 300));
      }else{
        _staggeredTiles.add(new StaggeredTile.extent(1,300));
      }
    }
    return _staggeredTiles;
  }
}