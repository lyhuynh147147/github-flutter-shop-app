import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/helpers/utils.dart';
import 'package:phone_verification/widgets/widget_title.dart';

class ProductOrderDetail extends StatelessWidget {
  ProductOrderDetail(
      {this.name = '',
      this.price = '',
      this.quantity = '',
      this.size = '',
      this.color = kColorWhite});

  final String name;
  final String price;
  final String quantity;
  final String size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    int subTotal = int.parse(quantity) * int.parse(price);
    String subPriceMoneyType = Util.intToMoneyType(subTotal);
    String priceMoneyType = Util.intToMoneyType(int.parse(price));

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kColorBlack.withOpacity(0.2),
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: 7,
            left: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: Product name
            TitleWidget(
              title: 'Tên sản phẩm: ',
              content: name,
              isSpaceBetween: false,
            ),
            //TODO: Size
            TitleWidget(
              title: 'Kích thước: ',
              content: size,
              isSpaceBetween: false,
            ),
            //TODO: Color
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 12),
              child: Row(
                mainAxisAlignment: false
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: AutoSizeText(
                      'Màu sắc:',
                      maxLines: 1,
                      minFontSize: 10,
                      style: kBoldTextStyle.copyWith(
                          fontSize: 15,
                          color: kColorBlack.withOpacity(0.5)),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: color, border: Border.all(color: kColorBlack)),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(),
                  ),
                ],
              ),
            ),
            //TODO: Price
            TitleWidget(
              title: 'Giá: ',
              content: '$priceMoneyType VND',
              isSpaceBetween: false,
            ),
            //TODO: Quantity
            TitleWidget(
              title: 'Số lượng: ',
              content: quantity,
              isSpaceBetween: false,
            ),
            //TODO: SubTotal
            TitleWidget(
              title: 'Tổng: ',
              content: '$subPriceMoneyType VND',
              isSpaceBetween: false,
            ),
          ],
        ),
      ),
    );
  }
}
