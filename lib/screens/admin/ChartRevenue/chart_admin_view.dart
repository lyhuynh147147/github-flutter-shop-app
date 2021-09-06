import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/admin/ChartRevenue/OrderChart.dart';
import 'package:phone_verification/screens/admin/ChartRevenue/priceVolatilityChart.dart';
import 'package:phone_verification/screens/admin/ChartRevenue/revenue_chart.dart';

class AdminChartView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminChartView();
}

class _AdminChartView extends State with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Biểu đổ',
          style: kBoldTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.lightBlueAccent,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.insert_chart,
                size: 15,
              ),
              child: Text(
                'Doanh thu',
                style: kBoldTextStyle.copyWith(fontSize:14),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.pie_chart,
                size: 15,
              ),
              child: Text(
                'Đặt hàng & Hóa đơn',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.monetization_on,
                size: 15,
              ),
              child: Text(
                'Biến động giá',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          //TODO: Revenue
          RevenueChart(),
          //TODO: Order Analysis
          OrderChart(),
          //TODO: Price Volatility
          PriceVolatilityChart(),
        ],
        controller: _tabController,
      ),
    );
  }
}
