import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/admin/Users/admin_adding_account.dart';
import 'package:phone_verification/screens/admin/Users/admin_view.dart';
import 'package:phone_verification/screens/admin/Users/customer_view.dart';

class UserManagerView extends StatefulWidget {
  @override
  _UserManagerViewState createState() => _UserManagerViewState();
}

class _UserManagerViewState extends State<UserManagerView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'User List',
          style: TextStyle(
            color: kColorBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add_comment,
                size: 22,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(
                        builder: (context) => AdminAddingAccount()));
              })
        ],
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.lightBlueAccent,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: 15,
              ),
              child: Text(
                'Customer',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.userTie,
                size: 15,
              ),
              child: Text(
                'Admin',
                style: kBoldTextStyle.copyWith(fontSize: 14),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          CustomerUserListView(),
          AdminUserListView(),
        ],
        controller: _tabController,
      ),
    );
  }
}
