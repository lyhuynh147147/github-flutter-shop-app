import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/model/product.dart';

import 'image_product_view.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Stack(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 400,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,
                ),
                carouselController: buttonCarouselController,
                items: product.imageList.map((image) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageProductView(
                                onlineImage: image,
                              )));
                    },
                    child: CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: image,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }).toList(),
              ),
              //TODO: Close Button
             /* Positioned(
                child: IconButton(
                  color: kColorBlack,
                  iconSize: 27,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: 20),
                ),
              ),*/
              //TODO: Wistlist IconButton
            ],
          ),
          /*Text(
            "Aristocratic Hand Bag",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            product.productName,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              /*AutoSizeText(
                Util.intToMoneyType(product.salePrice) +'VND',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 12,
                    color: kColorBlack,
                    decoration: (salePrice != 0)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
                maxFontSize: 5,
                textAlign: TextAlign.center,
              ),*/
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Price\n"),
                    TextSpan(
                      text: "\$${product.price}",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*TextSpan(
                      text: "\$${product.salePrice}",
                      style: TextStyle(
                          fontSize: 12,
                          color: kColorBlack,
                          decoration: (product.salePrice != 0)
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),*/
                  ],
                ),
              ),
              SizedBox(width: kDefaultPaddin),
              /*Expanded(
                child: Hero(
                  tag: "${product.id}",
                  child: Image.network(
                    product.imageList[0],
                    fit: BoxFit.fill,
                  ),
                ),
              ),*/

            ],
          )*/
        ],
      ),
    );
  }
}

/* Stack(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: 400,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,
                ),
                carouselController: buttonCarouselController,
                items: product.imageList.map((image) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageProductView(
                                onlineImage: image,
                              )));
                    },
                    child: CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: image,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }).toList(),
              ),
              //TODO: Close Button
              Positioned(
                child: IconButton(
                  color: kColorBlack,
                  iconSize: 27,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: 20),
                ),
              ),
              //TODO: Wistlist IconButton
            ],
          ),*/