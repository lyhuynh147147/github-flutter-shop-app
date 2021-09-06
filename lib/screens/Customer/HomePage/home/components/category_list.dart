import 'package:flutter/material.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/item_category.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

int selectedIndex = 0;
class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ItemCategory(
            title: "Combo Meal",
            isActive: true,
            press: () {},
          ),
          ItemCategory(
            title: "Chicken",
            press: () {},
          ),
          ItemCategory(
            title: "Beverages",
            press: () {},
          ),
          ItemCategory(
            title: "Snacks & Sides",
            press: () {},
          ),
        ],
      ),
    );
  }
}
