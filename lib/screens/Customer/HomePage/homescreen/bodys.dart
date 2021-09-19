import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/model/categogy.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/item_card.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/item_cards.dart';
import 'package:phone_verification/screens/customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/screens/customer/HomePage/home/components/categories.dart';


import '../../../../../link.dart';


class Bodys extends StatefulWidget {
  final List<Product> product;
  final String search;
  //final String clothing ='';
  const Bodys({Key key, this.product, this.search,}) : super(key: key);

  @override
  _BodysState createState() => _BodysState();
}

class _BodysState extends State<Bodys> {
  bool isSearch = false;
  bool isSale = false;
  bool _isLogging = false;
  String title = '';
  Category _category;

  int currentIndex = 0;
  int _currentIndex = 0;


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
          .orderBy('create_at', descending: true)
          .where('categogy', isEqualTo: widget.search)
          .snapshots();
    } else {
      setState(() {
        title = 'NEW IN';
      });
      return FirebaseFirestore.instance
          .collection('Products')
          .orderBy('create_at' ,descending: true)
          .snapshots();
    }
  }

  getFirestoreNew(){
    return FirebaseFirestore.instance
        .collection('Products')
        .orderBy('create_at',descending: true)
        .snapshots();
  }
  getFirestoreBanner(){
    return FirebaseFirestore.instance
        .collection('Products')
        .orderBy('create_at',descending: true)
        .limit(5)
        .snapshots();
  }
  // List<String> categories = [
  //   'Teen',
  //   'Hoodies & áo nỉ',
  //   'Áo sơ mi',
  //   'Quần short',
  //   'Áo khoác',
  //   'Quân dai',
  //   'Quần jean',
  //   'Người chạy bộ',
  //   'Quần bó sát',];
  String categories = 'Hoodies & áo nỉ';
  String categoriess = 'Áo sơ mi';
  getFirestoreSnapshot1() {
    return FirebaseFirestore.instance
        .collection('Products')
        //.where('categogy', isEqualTo: categoriess)
        .where('categogy', isEqualTo: categories)
        //.where('categogy', isEqualTo: null)
        //.orderBy([categogy], descending: true)
        .orderBy('create_at',descending: true)
        .limitToLast(2)
        //.orderBy('create_at',descending: true)
        .snapshots();
  }

  ///
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 3), (Timer timer) {
    //   if (currentIndex < sliderImages.length) {
    //     currentIndex++;
    //   } else {
    //     currentIndex = 0;
    //   }
    //   pageController.animateToPage(
    //     currentIndex,
    //     duration: Duration(milliseconds: 350),
    //     curve: Curves.easeIn,
    //   );
    // });
    ///
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 1),
    // );
    //
    // _animation = Tween<double>(begin: 0, end: 1)
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
    //   ..addListener(() {
    //     setState(() {});
    //   });
    //
    // _animation2 = Tween<double>(begin: 0, end: -30)
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    //
    // _controller.forward();
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
    //_controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: getFirestoreBanner(),
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
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 500,
                        aspectRatio: 16/9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        //onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, carouselPageChangedReason) {
                          setState(() {
                            currentIndex = index;
                            print("${currentIndex}");
                          },
                          );
                        },
                      ),
                      items: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Builder(
                          builder: (BuildContext context, ) {
                            return GestureDetector(
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
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Image.network(
                                      document['image'][0],
                                      fit: BoxFit.cover,
                                      //height: 400,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            document['name'],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (document['sale_price']),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: 18,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   bottom: 10,
                                  //   right: 10,
                                  //   child: DotsIndicator(
                                  //     dotsCount: snapshot.data.docs.length == 0 ? 1 : snapshot.data.docs.length,
                                  //     position: currentIndex.toDouble(),
                                  //     decorator: DotsDecorator(
                                  //       color: Colors.black.withOpacity(0.5),
                                  //       activeColor: Colors.black.withOpacity(0.5),
                                  //       size: const Size.square(10.0),
                                  //       activeSize: const Size(30.0, 10.0),
                                  //       activeShape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(5.0),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),

                    );
                  }},),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
                            color: Colors.white,
                            //iconSize: 25,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Search',
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon:
                        Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(.7),
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'customer_search_page');
                        },
                      ),
                      IconButton(
                        tooltip: 'Cart',
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon:
                        Icon(
                          Icons.chat,
                          color: Colors.white.withOpacity(.7),
                          size: 28,
                        ),

                        onPressed: () {
                          if (_isLogging) {
                            //Navigator.pushNamed(context, 'customer_cart_page');
                            //'customer_chat_screen'
                            Navigator.pushNamed(context, 'customer_chat_screen');
                            //TODO: Add product
                          } else {
                            Navigator.pushNamed(context, 'phone_in');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: DotsIndicator(
                dotsCount: 5 == 0 ? 1 : 5,
                position: currentIndex.toDouble(),
                decorator: DotsDecorator(
                  color: Colors.black.withOpacity(0.5),
                  activeColor: Colors.black.withOpacity(0.5),
                  size: const Size.square(10.0),
                  activeSize: const Size(30.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        kDivider,
        Categories(),
        kDivider,
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Recommended for you",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    child:  Row(
                      children: [
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, 'customer_search_page');
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                  stream: getFirestoreNew(),
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
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10,),
                          child: StaggeredGridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            crossAxisCount: 2,
                            //padding: const EdgeInsets.all(10),
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 10,
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
        kDivider,
        SizedBox(height: 10,),
        Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: getFirestoreBanner(),
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
                    return Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250,
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, carouselPageChangedReason) {
                              setState(() {
                                _currentIndex = index;
                                  print("${_currentIndex}");
                                },
                              );
                            },
                          ),
                          items: snapshot.data.docs.map((DocumentSnapshot document) {
                            return Builder(
                              builder: (BuildContext context, ) {
                                return GestureDetector(
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
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Image.network(
                                          document['image'][0],
                                          fit: BoxFit.fill,
                                          //height: 400,
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 20,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(left: 20),
                                      //     child: Column(
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Text(
                                      //           document['name'],
                                      //           style: TextStyle(
                                      //               fontSize: 25,
                                      //               color: Colors.white,
                                      //               fontWeight: FontWeight.bold
                                      //           ),
                                      //         ),
                                      //         SizedBox(
                                      //           height: 10,
                                      //         ),
                                      //         Row(
                                      //           children: [
                                      //             Text(
                                      //               (document['sale_price']),
                                      //               style: TextStyle(
                                      //                   fontSize: 15,
                                      //                   color: Colors.white,
                                      //                   fontWeight: FontWeight.bold
                                      //               ),
                                      //             ),
                                      //             SizedBox(
                                      //               width: 5,
                                      //             ),
                                      //             Icon(
                                      //               Icons.arrow_forward_ios,
                                      //               color: Colors.white,
                                      //               size: 18,
                                      //             )
                                      //           ],
                                      //         )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),

                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
                }),
            Positioned(
              bottom: 10,
              right: 10,
              child: DotsIndicator(
                //dotsCount: snapshot.data.docs.length == 0 ? 1 : snapshot.data.docs.length,
                dotsCount: 5 == 0 ? 1 : 5,
                position: _currentIndex.toDouble(),
                decorator: DotsDecorator(
                  color: Colors.black.withOpacity(0.5),
                  activeColor: Colors.black.withOpacity(0.5),
                  size: const Size.square(10.0),
                  activeSize: const Size(30.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            )
          ],
        ),
        kDivider,
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Recommended for you",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    child:  Row(
                      children: [
                        Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, 'customer_search_page');
                    },
                  )
                ],
              ),
            ),
            //SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
                stream: getFirestoreNew(),
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
                    return Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 10, right: 5),
                        child: StaggeredGridView.count(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 4,
                          //padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 10,
                          //childAspectRatio: 0.7,
                          // staggeredTiles: [
                          //   StaggeredTile.extent(1, 250),
                          //   StaggeredTile.extent(1, 230),
                          // ],

                          staggeredTiles: generateTile(snapshot.data.docs.length),
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
                })
          ],
        ),
      ],
    );
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
        _staggeredTiles.add(new StaggeredTile.extent(2, 190));
      }else{
        _staggeredTiles.add(new StaggeredTile.extent(2, 190));
      }
    }
    return _staggeredTiles;
  }

  List<StaggeredTile> generateTile(int count) {
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
        _staggeredTiles.add(new StaggeredTile.extent(2, 320));
      }else{
        _staggeredTiles.add(new StaggeredTile.extent(2, 320));
      }
    }
    return _staggeredTiles;
  }
}