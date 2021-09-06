import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/widgets/category_item.dart';

class PriceVolatilityChart extends StatefulWidget {
  @override
  _PriceVolatilityChartState createState() => _PriceVolatilityChartState();
}

class _PriceVolatilityChartState extends State<PriceVolatilityChart> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Card(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('PriceVolatility')
                          .orderBy('timeCreate')
                          .where('product_id', isEqualTo: document.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<CategoryItem> listPriceVolatility = [];
                        Map datas = document.data();
                        if (snapshot.hasData) {
                          for (var docs in snapshot.data.docs) {
                            Map data = docs.data();
                            var widget = CategoryItem(
                              title: 'Giá: ' +
                                  Util.intToMoneyType(
                                      int.parse(data['price'])) +
                                  ' VND\nGiá khuyến mãi: ' +
                                  Util.intToMoneyType(
                                      int.parse(data['sale_price'])) +
                                  ' VND\nNgày tạo: ' +
                                  Util.convertDateToFullString(
                                      data['create_at']),
                              height: 130,
                            );
                            listPriceVolatility.add(widget);
                          }
                        }
                        return ExpansionTile(
                          title: Text(
                              'ID: ${datas['id']}\nSản phẩm: ${datas['name']}'),
                          children: listPriceVolatility.reversed.toList(),
                        );
                      }),
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        });
  }
}
