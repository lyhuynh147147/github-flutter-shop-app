import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/body.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/categories.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/item_card.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/bodys.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/item_cards.dart';
import 'package:phone_verification/screens/Customer/SearchPage/search.dart';
import 'package:phone_verification/widgets/card_product.dart';
import 'package:phone_verification/widgets/category_item.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  List queryResultSet = [];
  List tempSearchStore = [];
  bool isSearch = false;
  TextEditingController textController = new TextEditingController();

  //TODO: Search function
  searching(String value) {
    if (value.length == 0) {
      setState(() {
        isSearch = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      FirebaseFirestore.instance
          .collection('Products')
          .where('search_key', isEqualTo: value.substring(0, 1).toUpperCase())
          .get()
          .then((snapshot) {
        for (var document in snapshot.docs) {
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
          queryResultSet.add(product);
          setState(() {
            tempSearchStore = queryResultSet;
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element.productName.toString().startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  //TODO: List searching result
  Widget searchingResult() {
    return Padding(
      padding: EdgeInsets.all(3),
      child: GridView.count(
        // shrinkWrap: true,
        // physics: ScrollPhysics(),
        // scrollDirection: Axis.vertical,
        // crossAxisCount: 2,
        // crossAxisSpacing: 10,
        // mainAxisSpacing: 20,
        // childAspectRatio: 66 / 110,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(3),
        crossAxisSpacing: 2,
        mainAxisSpacing: 4,
        childAspectRatio: 0.7,
        children: tempSearchStore.map((product) {
          return ItemCards(
            productName: product.productName,
            image: product.imageList[0],
            isSoldOut: (product.quantityMain == '0'),
            price: int.parse(product.price),
            salePrice:
                (product.salePrice != '0') ? int.parse(product.salePrice) : 0,
            onTap: () {
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
    );
  }

  //TODO: Category
  Widget category() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        //TODO: Clothing
        ExpansionTile(
          title: Text('CLOTHING',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,),),
          children: <Widget>[
            CategoryItem(
              title: 'Tees',
              onTap: () {
                navigatorTo('Teen');
              },
            ),
            CategoryItem(
              title: 'Hoodies & Sweatshirts',
              onTap: () {
                navigatorTo('Hoodies & áo nỉ');
              },
            ),
            CategoryItem(
              title: 'Shirts',
              onTap: () {
                navigatorTo('Áo sơ mi');
              },
            ),
            CategoryItem(
              title: 'Jacket',
              onTap: () {
                navigatorTo('Áo khoác');
              },
            ),
            CategoryItem(
              title: 'Shorts',
              onTap: () {
                navigatorTo('Quần short');
              },
            ),
            CategoryItem(
              title: 'Pants',
              onTap: () {
                navigatorTo('Quân dai');
              },
            ),
            CategoryItem(
              title: 'Sweatpants',
              onTap: () {
                navigatorTo('Quần bó sát');
              },
            ),
            CategoryItem(
              title: 'Jeans',
              onTap: () {
                navigatorTo('Quần jean');
              },
            ),
            CategoryItem(
              title: 'Joggers',
              onTap: () {
                navigatorTo('Người chạy bộ');
              },
            ),
          ],
        ),
        //TODO: Shoes
        ExpansionTile(
          title: Text(
            'SHOES',
            style: TextStyle(
                fontSize: 16,
                color: kColorBlack,
                fontWeight: FontWeight.w400),
          ),
          children: <Widget>[
            CategoryItem(
              title: 'Athletic Shoes',
              onTap: () {
                navigatorTo('Giày thể thao');
              },
            ),
            CategoryItem(
              title: 'Causual Shoes',
              onTap: () {
                navigatorTo('Causual Shoes');
              },
            ),
            CategoryItem(
              title: 'Sandals & Slides',
              onTap: () {
                navigatorTo('Sandals & Slides');
              },
            )
          ],
        ),
        //TODO: Accessories
        ExpansionTile(
          title: Text(
            'ACCESSORIES',
            style: TextStyle(
                fontSize: 16,
                color: kColorBlack,
                fontWeight: FontWeight.w400),
          ),
          children: <Widget>[
            CategoryItem(
              title: 'Hats',
              onTap: () {
                navigatorTo('Mũ');
              },
            ),
            CategoryItem(
              title: 'Backpacks',
              onTap: () {
                navigatorTo('Ba lô');
              },
            ),
            CategoryItem(
              title: 'Sunglasses',
              onTap: () {
                navigatorTo('Kính râm');
              },
            ),
            CategoryItem(
              title: 'Belts',
              onTap: () {
                navigatorTo('Thắt lưng');
              },
            ),
            CategoryItem(
              title: 'Watches',
              onTap: () {
                navigatorTo('Xem');
              },
            )
          ],
        ),
      ],
    );
  }

  //TODO: Navigator link
  void navigatorTo(String link) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Search(
                  search: link,
                )));
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      //extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20,),
            // TODO: Search Bar
            Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(20),
                border: Border(
                  bottom: BorderSide(
                    color: kColorBlack.withOpacity(0.6),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                child: TextField(
                  controller: textController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: kColorBlack.withOpacity(0.6),
                      ),
                    ),
                    hintText: 'SEARCH',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        color: kColorBlack,
                        fontWeight: FontWeight.bold),
                    // TODO: Search Button
                    suffixIcon: Icon(
                      Icons.search,
                      color: kColorBlack.withOpacity(0.8),
                      size: 22,
                    ),
                  ),
                  style: TextStyle(fontSize: 18, color: kColorBlack),
                  maxLines: 1,
                  onChanged: (value) {
                    searching(value);
                    setState(() {
                      isSearch = true;
                    });
                  },
                ),
              ),
            ),
            //
            // Expanded(
            //   flex: 1,
            //   child: Categories(),
            // ),
            //TODO: Category
            Expanded(
              flex: 8,
              child: (isSearch) ? searchingResult() : category(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
