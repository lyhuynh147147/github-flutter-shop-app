import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';

class OrderCardPending extends StatelessWidget {
  OrderCardPending(
      {this.id = '',
        this.customerName = '',
        this.date = '',
        this.status = '',
        this.total = '',
        this.admin = '',
        this.onViewDetail,
        this.onCancel,
        this.isEnableCancel = true});
  final String id;
  final String customerName;
  final String admin;
  final String date;
  final String status;
  final String total;
  final Function onViewDetail;
  final Function onCancel;
  final bool isEnableCancel;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      text: 'Mã đặt hàng: ',
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
              //TODO: Admin
              // AutoSizeText.rich(
              //   TextSpan(
              //     style: kBoldTextStyle.copyWith(
              //       fontSize: 15,
              //     ),
              //     children: [
              //       TextSpan(
              //         text: 'Người xử lý: ',
              //       ),
              //       TextSpan(
              //         text: admin,
              //         style: kNormalTextStyle.copyWith(
              //           fontSize: 15,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              //TODO:Customer's Name
              AutoSizeText.rich(
                TextSpan(
                  style: kBoldTextStyle.copyWith(
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: 'Customer: ',
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
                        color: (status != 'Pending')
                            ? (status == 'Canceled' ? kColorRed : kColorGreen)
                            : kColorBlack,
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
                          Icons.remove_red_eye,
                          color: kColorBlue,
                          size: 15,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'XEM CHI TIẾT',
                          style: kBoldTextStyle.copyWith(
                              color: kColorBlue, fontSize: 14),
                        ),
                      ],
                    ),
                    onTap: () {
                      onViewDetail();
                    },
                  ),
                  //TODO: Cancel Order
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.close,
                          color: isEnableCancel
                              ? kColorBlue
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
                                  ? kColorBlue
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
    );
  }
}
