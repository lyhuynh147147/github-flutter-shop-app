import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';


class OrderAdminCard extends StatelessWidget {
  OrderAdminCard(
      {this.id = '',
      this.customerName = '',
      this.date = '',
      this.status = '',
      this.total = '',
      this.onAccept,
      this.onCancel,
      this.onViewDetail,
      this.isEnableCancel = true});
  final String id;
  final String customerName;
  final String date;
  final String status;
  final String total;
  final Function onAccept;
  final Function onCancel;
  final Function onViewDetail;
  final bool isEnableCancel;

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Card(
      child: GestureDetector(
        onTap: () {
          onViewDetail();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kColorLightGrey),
            color: kColorWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // TODO: Order id
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Mã đăt hàng: ',
                      ),
                      TextSpan(
                        text: id,
                        style: kNormalTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                //TODO: Order date
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Ngày đặt hàng: ',
                      ),
                      TextSpan(
                        text: date,
                        style: kNormalTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                //TODO:Customer's Name
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Khách hàng: ',
                      ),
                      TextSpan(
                        text: customerName,
                        style: kNormalTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // TODO: Status
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tình trạng: ',
                      ),
                      TextSpan(
                        text: status,
                        style: kNormalTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                //TODO: Total price
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Tổng giá: ',
                      ),
                      TextSpan(
                        text: '$total VND',
                        style: kNormalTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: ViewDetail and CancelOrder
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // TODO: View detail
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: kColorGreen,
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'XÁC NHẬN',
                            style: kBoldTextStyle.copyWith(
                                color: kColorGreen, fontSize:14),
                          ),
                        ],
                      ),
                      onTap: () {
                        onAccept();
                      },
                    ),
                    //TODO: Cancel Order
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            color: isEnableCancel
                                ? kColorRed
                                : kColorBlack.withOpacity(0.7),
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'HỦY ĐƠN',
                            style: kBoldTextStyle.copyWith(
                                color: isEnableCancel
                                    ? kColorRed
                                    : kColorBlack.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (isEnableCancel) {
                          onCancel();
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
