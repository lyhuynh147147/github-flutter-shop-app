import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/model/categogy.dart';
import 'package:phone_verification/model/clothingSize.dart';
import 'package:phone_verification/screens/admin/Products/product_manager_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/input_text.dart';


class ProductAddingView extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _ProductAddingViewState createState() => _ProductAddingViewState();
}

class _ProductAddingViewState extends State<ProductAddingView> {
  ProductManagerController _controller = new ProductManagerController();
  List<String> category = ['Quần áo', 'Giày dép', 'Phụ kiện'];
  List<String> sizeType = ['None', 'Top', 'Bottom', 'Shoes'];
  int indexSubCategory = 1;
  int indexSizeType = 0;
  String mainCategory = 'Quần áo';

  final _nameController = new TextEditingController();
  final _priceController = new TextEditingController();
  final _salePriceController = new TextEditingController();
  final _brandController = new TextEditingController();
  final _madeInController = new TextEditingController();
  final _quantityController = new TextEditingController();
  final _descriptionController = new TextEditingController();
  List<Asset> images = List<Asset>();
  String subCategory = 'Chọn danh mục';
  String sizeTypeValue = 'Chọn loại';
  List<String> sizeList = [];
  List<String> colorList = [];

  //TODO: renew value
  void renewValue() {
    _nameController.clear();
    _priceController.clear();
    _salePriceController.clear();
    _brandController.clear();
    _madeInController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    images.clear();
    sizeList.clear();
    colorList.clear();
    String subCategory = 'Choosing Category';
    String sizeTypeValue = 'Choosing type';
  }

  //TODO: Image product holder
  Widget imageGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(8),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  //List<Asset> images = <Asset>[];
  String _error = 'Không phát hiện lỗi';
  //TODO: load multi image
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'Không phát hiện lỗi';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Chọn hình ảnh sản phẩm",
          allViewTitle: "Tất cả ảnh",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

/*  Future<List<File>> convertListAssetToListFile() async {
    List<File> files = List<File>();

    for(int i = 0; i <images.length; i++) {
      String imagePath = await FlutterAbsolutePath.getAbsolutePath(
        images[i].identifier,
      );
      File file = File(imagePath);
      files.add(file);
    }
    return files;
  }*/

  //TODO: get sub category
  List getSubCategory(int index) {
    List subCategoryList = [];
    switch (index) {
      case 0:
        break;
      case 1:
        subCategoryList = Category.Clothing;
        break;
      case 2:
        subCategoryList = Category.Shoes;
        break;
      case 3:
        subCategoryList = Category.Accessories;
        break;
    }
    return subCategoryList.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: kNormalTextStyle.copyWith(fontSize: 28),
        ),
      );
    }).toList();
  }

  //TODO: get size type
  List<String> getSizeType(int index) {
    List<String> sizeTypeList = [];
    switch (index) {
      case 0:
        break;
      case 1:
        sizeTypeList = ClothingPickingList.TeeSize;
        break;
      case 2:
        sizeTypeList = ClothingPickingList.PantSize;
        break;
      case 3:
        sizeTypeList = ClothingPickingList.ShoesSize;
        break;
    }
    return sizeTypeList;
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Thêm sản phẩm',
          style: kBoldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            //TODO: Product name
            StreamBuilder(
              stream: _controller.productNameStream,
              builder: (context, snapshot) => InputText(
                title: 'Tên sản phẩm',
                controller: _nameController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //TODO: Product name
            /*StreamBuilder(
              stream: _controller.productNameStream,
              builder: (context, snapshot) => TextInputField(
               // title: 'Product Name',
                controller: _nameController,
                //errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 15,
            ),*/
            //TODO: Image product
            Text(
              'Hình ảnh sản phẩm:',
              style:
                  kBoldTextStyle.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 15,
            ),
            imageGridView(),
            ElevatedButton(
              child: Text(
                "Chọn hình ",
                style: kBoldTextStyle.copyWith(fontSize: 12),
              ),
              onPressed: loadAssets,
            ),
            //TODO: Image Error
            StreamBuilder(
              stream: _controller.productImageStream,
              builder: (context, snapshot) => Center(
                  child: Text(
                snapshot.hasError ? 'Error: ' + snapshot.error : '',
                style: kBoldTextStyle.copyWith(
                    fontSize: 14, color: kColorRed),
              )),
            ),
            //TODO: Category
            Row(
              children: <Widget>[
                //TODO: main category
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      mainCategory,
                      style: kBoldTextStyle.copyWith(fontSize: 14),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: category.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style:
                          kNormalTextStyle.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        mainCategory = value;
                        subCategory = 'Chọn danh mục';
                        switch (mainCategory) {
                          /*'Quần áo', 'Giày dép', 'Phụ kiện'*/
                          case 'Main Category':
                            indexSubCategory = 0;
                            break;
                          case 'Quần áo':
                            indexSubCategory = 1;
                            break;
                          case 'Giày dép':
                            indexSubCategory = 2;
                            break;
                          case 'Phụ kiện':
                            indexSubCategory = 3;
                            break;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                //TODO: sub category
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      subCategory,
                      style: kBoldTextStyle.copyWith(fontSize: 14),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: getSubCategory(indexSubCategory),
                    onChanged: (value) {
                      setState(() {
                        subCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            //TODO: Category Error
            StreamBuilder(
              stream: _controller.categoryStream,
              builder: (context, snapshot) => Center(
                  child: Text(
                snapshot.hasError ? 'Error: ' + snapshot.error : '',
                style: kBoldTextStyle.copyWith(
                    fontSize: 14, color: kColorRed),
              )),
            ),
            //TODO: Size type
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'Chọn loại kích thước:',
                    style: kBoldTextStyle.copyWith(fontSize: 15),
                  ),
                ),
                //TODO: picker size type
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      sizeTypeValue,
                      style: kBoldTextStyle.copyWith(fontSize: 14),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: sizeType.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style:
                              kNormalTextStyle.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sizeTypeValue = value;
                        switch (sizeTypeValue) {
                          case 'None':
                            indexSizeType = 0;
                            break;
                          case 'Top':
                            indexSizeType = 1;
                            break;
                          case 'Bottom':
                            indexSizeType = 2;
                            break;
                          case 'Shoes':
                            indexSizeType = 3;
                            break;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
//            TODO Size & Color Group check
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO: Size
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Chọn nhiều kích thước',
                        style: kBoldTextStyle.copyWith(fontSize: 14),
                      ),
                      CheckboxGroup(
                          labelStyle:
                              kNormalTextStyle.copyWith(fontSize: 14),
                          labels: getSizeType(indexSizeType),
                          onSelected: (List<String> checked) {
                            sizeList = checked;
                          }),
                      //TODO: Size Error
                      StreamBuilder(
                        stream: _controller.sizeListStream,
                        builder: (context, snapshot) => Center(
                            child: Text(
                          snapshot.hasError ? 'Error: ' + snapshot.error : '',
                          style: kBoldTextStyle.copyWith(
                              fontSize: 12, color: kColorRed),
                        )),
                      ),
                    ],
                  ),
                ),
                // TODO: Color
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Chọn nhiều màu',
                        style: kBoldTextStyle.copyWith(fontSize: 15),
                      ),
                      CheckboxGroup(
                          labelStyle:
                              kNormalTextStyle.copyWith(fontSize: 14),
                          labels: ClothingPickingList.ColorList,
                          onSelected: (List<String> checked) {
                            colorList = checked;
                          }),
                      //TODO: Color Error
                      StreamBuilder(
                        stream: _controller.colorListStream,
                        builder: (context, snapshot) => Center(
                            child: Text(
                          snapshot.hasError ? 'Error: ' + snapshot.error : '',
                          style: kBoldTextStyle.copyWith(
                              fontSize: 12, color: kColorRed),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            //TODO: Price and Sale Price
            Row(
              children: <Widget>[
                //TODO: Price
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: _controller.priceStream,
                    builder: (context, snapshot) => InputText(
                      title: 'Giá ',
                      controller: _priceController,
                      errorText: snapshot.hasError ? snapshot.error : '',
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                //TODO: Sale Price
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: _controller.salePriceStream,
                    builder: (context, snapshot) => InputText(
                      title: 'Giá khuyến mãi',
                      controller: _salePriceController,
                      errorText: snapshot.hasError ? snapshot.error : '',
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // TODO: Brand
            StreamBuilder(
              stream: _controller.brandStream,
              builder: (context, snapshot) => InputText(
                title: 'Nhãn hiệu',
                controller: _brandController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //TODO: Made In
            StreamBuilder(
              stream: _controller.madeInStream,
              builder: (context, snapshot) => InputText(
                title: 'Made In',
                controller: _madeInController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //TODO: Quantity
            StreamBuilder(
              stream: _controller.quantityStream,
              builder: (context, snapshot) => InputText(
                title: 'Số lượng',
                controller: _quantityController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //TODO: Description
            StreamBuilder(
              stream: _controller.descriptionStream,
              builder: (context, snapshot) => TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Chi tiết sản phẩm',
                  focusColor: Colors.black,
                  labelStyle: kBoldTextStyle.copyWith(fontSize: 15),
                  errorText: snapshot.hasError ? snapshot.error : null,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      //TODO Add product
      bottomNavigationBar: StreamBuilder(
          stream: _controller.btnLoadingStream,
          builder: (context, snapshot) {
            return CusRaisedButton(
              title: 'Thêm sản phẩm',
              backgroundColor: kColorBlack,
              height: 100,
              isDisablePress: snapshot.hasData ? snapshot.data : true,
              onPress: () async {
                bool result = await _controller.onAddProduct(
                    productName: _nameController.text,
                    imageList: images,
                    category: subCategory,
                    sizeList: sizeList,
                    colorList: colorList,
                    price: _priceController.text,
                    salePrice: _salePriceController.text,
                    brand: _brandController.text,
                    madeIn: _madeInController.text,
                    quantity: _quantityController.text,
                    description: _descriptionController.text,
                    sizeType: sizeTypeValue,
                );
                if (result) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: kColorWhite,
                    content: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: kColorGreen,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Sản phẩm đã được thêm thành công.',
                            style:
                                kBoldTextStyle.copyWith(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ));
                  //TODO: renew Value
                  setState(() {
                    renewValue();
                  });
                } else {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: kColorWhite,
                    content: Row(
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          color: kColorRed,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Lỗi thêm sản phẩm',
                            style:
                                kBoldTextStyle.copyWith(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ));
                }
              },
            );
          }),
    );
  }
}
