import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/model/Incator.dart';

class OrderChart extends StatefulWidget {
  @override
  _OrderChartState createState() => _OrderChartState();
}

class _OrderChartState extends State<OrderChart>
    with AutomaticKeepAliveClientMixin {
  StreamController _controller = new StreamController.broadcast();
  DateTime yearPick;
  int pending = 0;
  int cancelled = 0;
  int completed = 0;
  int totalOrder = 0;
  int touchedIndex;

  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yearPick = DateTime.now();
    getOrderState(yearPick.year).then((result) {
      _controller.sink.add(result);
    });
  }

  //TODO: get Total order
  Future<OrderState> getOrderState(int year) async {
    var pending = await FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Pending')
        .where('year', isEqualTo: year)
        .get();
    var cancelled = await FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Canceled')
        .where('year', isEqualTo: year)
        .get();
    var completed = await FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Completed')
        .where('year', isEqualTo: year)
        .get();
    setState(() {
      totalOrder = pending.docs.length + cancelled.docs.length + completed.docs.length;
      this.pending = pending.docs.length;
      this.cancelled = cancelled.docs.length;
      this.completed = completed.docs.length;
    });
    return OrderState(
      pending: pending.docs.length,
      cancelled: cancelled.docs.length,
      completed: completed.docs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          //TODO: Chart
          Card(
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  //flex: 5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: StreamBuilder(
                        stream: _controller.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse){
                                  setState(() {
                                    final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                        pieTouchResponse.touchInput is! PointerUpEvent;
                                    if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                      touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                    } else {
                                      touchedIndex = -1;
                                    }
                                  });
                                }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 80,
                                  sections: showingSections(snapshot.data)),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          //TODO: Intro order
          Card(
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tổng đơn hàng: $totalOrder',
                  style: kBoldTextStyle.copyWith(fontSize: 15),
                ),
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Đang xử lý',
                  isSquare: true,
                  value: pending,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.redAccent,
                  text: 'Đã hủy',
                  isSquare: true,
                  value: cancelled,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff13d38e),
                  text: 'Đã hoàn thành',
                  isSquare: true,
                  value: completed,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          
          Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Năm:',
                  style: kBoldTextStyle.copyWith(fontSize: 18),
                ),
                //TODO: Year picker
                Container(
                  height: 200,
                  width: 200,
                  child: YearPicker(
                    dragStartBehavior: DragStartBehavior.start,
                    firstDate: DateTime.utc(2016),
                    lastDate: DateTime.now(),
                    selectedDate: yearPick,
                    onChanged: (date) {
                      setState(() {
                        yearPick = date;
                        getOrderState(yearPick.year).then((result) {
                          _controller.sink.add(result);
                        });
                      });
                    },
                  ),
                ),
                Text(
                  'HIỆN HÀNH \n ${yearPick.year}',
                  style: kBoldTextStyle.copyWith(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //TODO: value Order
  List<PieChartSectionData> showingSections(OrderState orderState) {
    double total = (orderState.pending + orderState.completed + orderState.cancelled).toDouble();
    print(orderState.pending);
    print(orderState.completed);
    print(orderState.cancelled);
    double pending = (orderState.pending.toDouble() / total) * 100;
    double completed = (orderState.completed.toDouble() / total) * 100;
    double cancelled = (orderState.cancelled.toDouble() / total) * 100;
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          //TODO: Completed
          return PieChartSectionData(
            color: Color(0xff13d38e),
            value: completed,
            title: '${completed.toStringAsFixed(2)} Hoàn thành%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff100f0f)),
          );
        //TODO: Cancel
        case 1:
          return PieChartSectionData(
            color: Colors.redAccent.shade400,
            value: cancelled,
            title: '${cancelled.toStringAsFixed(2)} Đã hủy%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1f1d1d)),
          );
        //TODO: Pending
        case 2:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: pending,
            title: '${pending.toStringAsFixed(2)} Đang Xử lý%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xff151414)),
          );
        default:
          return null;
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class OrderState {
  final int pending;
  final int cancelled;
  final int completed;

  OrderState({this.pending, this.completed, this.cancelled});
}
