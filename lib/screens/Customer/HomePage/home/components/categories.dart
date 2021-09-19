import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/constants.dart';
import 'package:phone_verification/screens/Customer/HomePage/home/components/body.dart';
import 'package:phone_verification/screens/Customer/HomePage/homescreen/bodys.dart';
import 'package:phone_verification/widgets/background_image.dart';


class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  //TODO: Navigator link
  void navigatorTo(String link) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Body(
              search: link,
            )));
  }

  //Category category;

  List<String> categories = [
    'Teen',
    'Hoodies & áo nỉ',
    'Áo sơ mi',
    'Quần short',
    'Áo khoác',
    'Quân dai',
    'Quần jean',
    'Người chạy bộ',
    'Quần bó sát',
    'Mũ',
    'Ba lô',
    'Kính râm',
    'Thắt lưng',
    'Xem',
    'Giày thể thao',
    'Causual Shoes',
    'Sandals & Slides',
  ];

  final List<String> _images=[
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT216P5quRx1QhyonjfbtJjH8uuey0Q6Wb0N9eATxuMJ65bIw1Xs3HlPeROshlz9mWjUvY&usqp=CAU',
    'https://images.unsplash.com/photo-1485462537746-965f33f7f6a7?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjZ8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    'https://bizweb.dktcdn.net/100/218/393/files/mv39-1.png?v=1537429974907',
  ];
  //By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Category",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                child: Row(
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
                  ],),
                onTap: () {

                },
              )
            ],
          ),
          ),
          SizedBox(height: 10,),
          Container(
             height: 120,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: categories.length,
               //itemCount: category.length,
               itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ],
      )
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // if(index==0){
          //   print('ddd');
          // }else{
          //
          // }
          selectedIndex = index;
          //navigatorTo('Hoodies & áo nỉ');
          navigatorTo(categories[index]);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10,),
        child: Container(
          width: 120,
          //alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: selectedIndex == index ? kTextColor : kTextLightColor,
            ),
            image: DecorationImage(
              image: NetworkImage(_images[index]),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Color(0xFF303030), BlendMode.hardLight)
            ),
          ),
          //margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    //color: selectedIndex == index ? kTextColor : kTextLightColor,
                    color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        /*child: Container(

          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              // color: Colors.white,
              // borderRadius: BorderRadius.circular(5),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey.withOpacity(.5),
              //       offset: Offset(3, 2),
              //       blurRadius: 7)
              // ]
            image: DecorationImage(
              image: NetworkImage(_images[index]),
              fit: BoxFit.cover,

            ),
            borderRadius: BorderRadius.circular(10),
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Stack(
          //       children: [
          //         Container(
          //           padding: EdgeInsets.all(10),
          //           width: double.infinity,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: Colors.grey.withOpacity(.5)
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               // CustomText(
          //               //   text: widget.productName,
          //               //   size: 20,
          //               //   weight: FontWeight.bold,
          //               // ),
          //               PrimaryText(
          //                   text: widget.productName, fontWeight: FontWeight.w700, color: Color(
          //                   0xff231919), size: 20),
          //               // SizedBox(height: 5),
          //               // PrimaryText(
          //               //     text: 'widget.product.price', size: 18, fontWeight: FontWeight.w700),
          //               // SizedBox(height: 5),
          //               AutoSizeText(
          //                 Util.intToMoneyType(widget.price) + ' VND',
          //                 maxLines: 1,
          //                 style: TextStyle(
          //                     fontSize: 15,
          //                     color: kColorBlack,
          //                     decoration: (widget.salePrice != 0)
          //                         ? TextDecoration.lineThrough
          //                         : TextDecoration.none),
          //                 minFontSize: 5,
          //                 textAlign: TextAlign.center,
          //               ),
          //               //TODO: Sale Price
          //               (widget.salePrice != 0)
          //                   ? AutoSizeText(
          //                 Util.intToMoneyType(widget.salePrice) + ' VND',
          //                 maxLines: 1,
          //                 style: TextStyle(
          //                     fontSize: 22,
          //                     color: kColorRed,
          //                     fontWeight: FontWeight.bold
          //                 ),
          //                 minFontSize: 5,
          //                 textAlign: TextAlign.center,
          //               )
          //                   : Text(' '),
          //             ],
          //           ),
          //         ),
          //         Positioned(
          //           right: 10,
          //           bottom: 0,
          //           child: RawMaterialButton(
          //               onPressed: () {},
          //               elevation: 0,
          //               constraints: BoxConstraints(
          //                 minWidth: 0,
          //               ),
          //               shape: CircleBorder(),
          //               fillColor:  Color(0xffec6813),
          //               padding: EdgeInsets.all(5),
          //               child: Icon(Icons.add, size: 16, color: Colors.white)),
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ),*/
      ),
    );
  }
}

/*child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Icon(
            //   menuicons[index],
            //   color: selectedIndex == index ? kTextColor : kTextLightColor,
            // ),
            Text(
              categories[index],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
            //   height: 2,
            //   width: 30,
            //   color: selectedIndex == index ? Colors.black : Colors.transparent,
            // )
          ],
        ),*/
