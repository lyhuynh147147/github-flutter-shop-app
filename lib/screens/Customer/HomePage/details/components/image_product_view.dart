import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:photo_view/photo_view.dart';

class ImageProductView extends StatefulWidget {
  ImageProductView({
    this.onlineImage = '',
  });
  final String onlineImage;
  @override
  _ImageProductViewState createState() => _ImageProductViewState();
}

class _ImageProductViewState extends State<ImageProductView> {
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: PhotoView(
                imageProvider: NetworkImage(widget.onlineImage),
              ),
            ),
            Positioned(
              child: IconButton(
                color: kColorWhite,
                iconSize: 25,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  height: 30,
                  width: 28,
                  decoration: BoxDecoration(
                    color: kColorBlack,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 10,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
