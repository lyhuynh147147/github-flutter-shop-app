import 'package:flutter/material.dart';
import 'package:phone_verification/model/product.dart';
import 'package:phone_verification/screens/Customer/HomePage/details/components/color_and_size.dart';


class Body extends StatefulWidget {
  final Product product;

  const Body({Key key, this.product}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            ColorAndSize(product: widget.product,),
            // SizedBox(height: kDefaultPaddin / 2),
          ],
        ),
      ),
    );
  }
}
/*return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          //Divider(height: 2,color: Colors.grey[500], thickness: 10.0,),
                          Container(
                            padding: EdgeInsets.only(
                              top: size.height * 0.001,
                              //left: kDefaultPaddin,
                              //right: kDefaultPaddin,
                              bottom: 100,
                            ),
                            child: Column(
                              children: <Widget>[
                                ColorAndSize(product: widget.product,),
                                // SizedBox(height: kDefaultPaddin / 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );*/