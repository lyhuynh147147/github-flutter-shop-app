import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/admin/Coupon/global_coupon_view.dart';
import 'package:phone_verification/screens/admin/Coupon/private_coupon_view.dart';

class CouponAdminView extends StatefulWidget {
  @override
  _CouponAdminViewState createState() => _CouponAdminViewState();
}

class _CouponAdminViewState extends State<CouponAdminView>
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
          'Danh Sách Phiếu Giảm Giá',
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
                FontAwesomeIcons.ticketAlt,
                size: 15,
              ),
              child: Text(
                'Cá Nhân',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.ticketAlt,
                size: 15,
              ),
              child: Text(
                'Toàn Bộ',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          //TODO: private coupon
          PrivateCouponView(),
          //TODO: global coupon
          GlobalCouponView()
        ],
        controller: _tabController,
      ),
    );
  }
}
