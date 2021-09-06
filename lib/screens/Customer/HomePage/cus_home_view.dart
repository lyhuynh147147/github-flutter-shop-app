import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:phone_verification/widgets/banner.dart';
import 'package:phone_verification/widgets/icon_instacop.dart';

class CustomerHomePageView extends StatefulWidget {
  @override
  _CustomerHomePageViewState createState() => _CustomerHomePageViewState();
}

class _CustomerHomePageViewState extends State<CustomerHomePageView>
    with AutomaticKeepAliveClientMixin {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Banner Slider
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            scrollDirection: Axis.vertical,
            initialPage: 0,
          ),
          items: <Widget>[
            CustomBanner(
              title: 'NEW IN',
              description:
                  'Discover this season\'s new collection built around',
              image: 'giphy_1.gif',
              onPress: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ProductListView(
                //               search: '',
                //             )));
              },
            ),
            CustomBanner(
              title: 'SALE',
              description:
                  'Discover this season\'s new collection built around',
              image: 'banner_10.jpg',
              onPress: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListView(
                              search: 'sale',
                            )));*/
              },
            ),
          ],
        ),
        // Logo
        Positioned(
          top: 0,
          left: 127,
          child: IconInstacop(
            textSize: 30,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
