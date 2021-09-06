import 'package:flutter/material.dart';

class Products{
  final String id;
  final String name;
  final String image;
  final String description;
  final String size;
  final String price;
  final String color;
  Products( {
    @required this.color,
    @required this.id,
    @required this.description,
    @required this.size,
    @required this.name,
    @required this.image,
    @required this.price,
  });
}