import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/details/components/body.dart';

import 'RatingPage/rating_product_page.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({Key key, this.product}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  Product product;
  List<Widget> pages = [];
  final pageController = PageController();
  int indexPage = 0;
  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            indexPage = index;
          });
        },
        children: <Widget>[
          Body(product: widget.product,),
          RatingProductPage(
            productId: widget.product.id,
            isAdmin: false,
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 57,
        child: BottomNavigationBar(
          onTap: onTap,
          currentIndex: indexPage,
          unselectedFontSize: 12,
          selectedFontSize: 14,
          selectedItemColor: kColorBlack,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          iconSize: 0.05,
          items: const [
            BottomNavigationBarItem(
              title: Text('Sản Phẩm'),
              icon: Icon(
                Icons.rate_review,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('Đánh Giá'),
              icon: Icon(
                Icons.rate_review,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: product.color,
      backgroundColor: Colors.white10,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black87,
          size: 25,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: Colors.black87,
            size: 30,
          ),
          onPressed: () {},
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
            Navigator.pushNamed(context, 'customer_cart_page');
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}