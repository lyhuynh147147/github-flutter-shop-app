import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/customer/ProfilePage/OrderAndBill/order_and_bill_view.dart';
//import 'package:shop_appflutter/views/HomePage/Customer/ProfilePage/OrderAndBill/order_and_bill_view.dart';

class AdminBillHistoryView extends StatefulWidget {
  @override
  _AdminBillHistoryViewState createState() => _AdminBillHistoryViewState();
}

class _AdminBillHistoryViewState extends State<AdminBillHistoryView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Lịch sử hóa đơn',
          style: TextStyle(
              color: kColorBlack,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.lightBlueAccent,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.check_circle,
                size: 15,
              ),
              child: Text(
                'Completed',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.cancel,
                size: 15,
              ),
              child: Text(
                'Canceled',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          OrderAndBillView(
            status: 'Completed',
            isAdmin: true,
          ),
          OrderAndBillView(
            status: 'Canceled',
            isAdmin: true,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
