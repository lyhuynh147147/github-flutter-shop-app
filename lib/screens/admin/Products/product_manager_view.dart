import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/screens/admin/Products/product_comment_view.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/card_admin_product.dart';
import 'package:phone_verification/widgets/input_text_product.dart';

class ProductManager extends StatefulWidget {
  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Sản Phẩm'/*'Product Manager'*/,
            style: kBoldTextStyle.copyWith(
              fontSize: 16,
            ),
          ),
          backgroundColor: kColorWhite,
          iconTheme: IconThemeData.fallback(),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_comment,
                  size: 22,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'admin_home_product_adding');
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Products').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.docs.map((document) {
                  return AdminProductCard(
                    productName: document['name'],
                    quantity: document['quantity'],
                    productPrice: int.parse(document['price']),
                    productSalePrice: int.parse(document['sale_price']),
                    brand: document['brand'],
                    category: document['categogy'],
                    madeIn: document['made_in'],
                    createAt:
                        Util.convertDateToFullString(document['create_at']),
                    productSizeList: document['size'],
                    productColorList: document['color'],
                    productImage: document['image'][0],
                    onComment: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProductCommentView(
                                    productId: document['id'],
                                  )));
                    },
                    onClose: () {
                      FirebaseFirestore.instance
                          .collection('Products')
                          .doc(document.id)
                          .delete();
                    },
                    onEdit: () {
                      String productName = document['name'];
                      String quantity = document['quantity'];
                      String constPrice = document['price'];
                      String constSalePrice = document['sale_price'];
                      String price = document['price'];
                      String salePrice = document['sale_price'];
                      String productId = document['id'];
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: Container(
                                  height:400,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Chỉnh Sửa Sản Phẩm',
                                            style: kBoldTextStyle.copyWith(
                                                fontSize: 18,
                                                color: kColorBlack),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        //TODO: product name
                                        InputTextProduct(
                                          title: 'Tên Sản Phẩm',
                                          initValue: document['name'],
                                          inputType: TextInputType.text,
                                          onValueChange: (name) {
                                            productName = name;
                                          },
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        //TODO:quantity
                                        InputTextProduct(
                                          title: 'Số Lượng',
                                          initValue: document['quantity'],
                                          inputType: TextInputType.number,
                                          onValueChange: (qty) {
                                            quantity = qty;
                                          },
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        //TODO: Price
                                        InputTextProduct(
                                          title: 'Giá',
                                          initValue: document['price'],
                                          inputType: TextInputType.number,
                                          onValueChange: (value) {
                                            price = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        //TODO: Sale price
                                        InputTextProduct(
                                          title: 'Giá Khuyến Mãi',
                                          initValue: document['sale_price'],
                                          inputType: TextInputType.number,
                                          onValueChange: (value) {
                                            salePrice = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: CusRaisedButton(
                                                title: 'Lưu',
                                                backgroundColor: kColorBlack,
                                                onPress: () {
                                                  FirebaseFirestore.instance
                                                      .collection('Products')
                                                      .doc(document['id'])
                                                      .update({
                                                    'name': (productName != null && productName != '') ? productName : document['name'],
                                                    'quantity': (quantity != null && quantity != '') ? quantity : document['quantity'],
                                                    'price': (price != null && price != '') ? price : document['price'],
                                                    'sale_price': (salePrice != null && salePrice != '') ? salePrice : document['salePrice'],
                                                  });
                                                  // TODO: save Price volatility
                                                  if ((constPrice != price || constSalePrice != salePrice) &&
                                                      (price != '' && salePrice != '')) {
                                                    FirebaseFirestore
                                                        .instance
                                                        .collection('PriceVolatility')
                                                        .doc()
                                                        .set({
                                                      'product_id': productId,
                                                      'price': price,
                                                      'sale_price': salePrice,
                                                      'create_at': DateTime.now().toString(),
                                                      'timeCreate': DateTime.now().millisecondsSinceEpoch
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: CusRaisedButton(
                                                title: 'Thoát',
                                                backgroundColor: kColorLightGrey,
                                                onPress: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                  );
                }).toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
