import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phone_verification/helpers/shared_preferrence.dart';
import 'package:phone_verification/screens/Customer/SearchPage/search_view.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'HomePage/cartpage/cart_view.dart';
import 'HomePage/cus_home_view.dart';
import 'HomePage/home_screen.dart';
import 'ProfilePage/profile_view.dart';
import 'WishlistPage/wishlist_view.dart';
import 'chat_view.dart';

class CustomerHomeView extends StatefulWidget {
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {

  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(
      icon: Icons.home,
      title: Text(
        'Home',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
      ),
    ),
    // TitledNavigationBarItem(
    //   icon: Icons.search,
    //   title: Text(
    //     'Search',
    //     style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: 16
    //     ),
    //   ),
    // ),
    TitledNavigationBarItem(
      icon: Icons.favorite,
      title: Text(
        'Favorite',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    ),
    // TitledNavigationBarItem(
    //   icon: Icons.shopping_cart_outlined,
    //   title: Text('Cart'),
    //),
    TitledNavigationBarItem(
      icon: Icons.chat,
      title: Text(
        'Chat',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    ),
    TitledNavigationBarItem(
      icon: Icons.person_outline,
      title: Text(
        'Profile',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    ),
  ];
  final tabsScreen = [
    HomeScreen(),
    //SearchView(),

    WishListView(),
    //CartView(),
    /*SearchView(),
    WishListView(),*/
    ChatScreen(),
    ProfileView(),


  ];
  final tabsTitle = ['Home', /*'Search',*/'Favorite' /*,'Wishlist'*/, 'Chat', 'Profile'];
  int indexScreen = 0;
  bool _isLogging;
  final pageController = PageController();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  initState() {
    // TODO: implement initState

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: (indexScreen < 1)
      //     ? AppBar(
      //         automaticallyImplyLeading: false,
      //         backgroundColor: kColorWhite,
      //         iconTheme: IconThemeData.fallback(),
      //         leading: Row(
      //           children: [
      //             IconButton(
      //               icon: Icon(
      //                 Icons.arrow_back_ios_outlined,
      //                 color: Colors.black87,
      //                 size: 30,
      //               ),
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //             ),
      //           ],
      //         ),
      //         title: Text(
      //           tabsTitle[indexScreen],
      //           style:
      //               kBoldTextStyle.copyWith(fontSize: 16),
      //         ),
      //         centerTitle: true,
      //         actions: <Widget>[
      //           IconButton(
      //             icon: Icon(
      //               Icons.search_rounded,
      //               color: Colors.black87,
      //               size: 30,
      //             ),
      //             onPressed: () {
      //               Navigator.of(context).pushReplacement(
      //           MaterialPageRoute(
      //               builder: (ctx) => HomePage()));
      //             },
      //           ),
      //           IconButton(
      //             icon: Icon(
      //               Icons.shopping_cart_outlined,
      //               color: Colors.black87,
      //               //color: Color(0xfff4cce8),
      //               size: 30,
      //             ),
      //             onPressed: () {
      //
      //               if (_isLogging) {
      //                 setState(() {
      //                   _isAddBtnPress = false;
      //                 });
      //                 Navigator.pushNamed(context, 'customer_cart_page');
      //                 //TODO: Add product
      //                 } else {
      //                 Navigator.pushNamed(context, 'register_screen');
      //               }},
      //           ),
      //           SizedBox(width: kDefaultPaddin / 2),
      //         ],
      //       )
      //     : null,
      body: PageStorage(
        bucket: bucket,
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            if (!_isLogging && index > 1) {
              pageController.jumpToPage(--index);
            } else {
              setState(() {
                indexScreen = index;
              });
            }},
          children: tabsScreen,
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 1,
        unselectedFontSize: 1,
        selectedItemColor: kColorBlack,
        currentIndex: indexScreen,
        onTap: (index) {
          print('onTap ' + _isLogging.toString());
          if (_isLogging == false && index > 1) {
            Navigator.pushNamed(context, 'register_screen');
          } else {
            setState(() {
              pageController.jumpToPage(index);
              indexScreen = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 40,
              ),
              title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.search,
                size: 35,
              ),
              title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 35,
              ),
              title: Text('Wishlist')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 35,
              ),
              title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: 35,
              ),
              title: Text('Profile')),
        ],
        type: BottomNavigationBarType.fixed,
      ),*/
      bottomNavigationBar: TitledBottomNavigationBar(
        onTap: (index) {
          print('onTap ' + _isLogging.toString());
          if (_isLogging == false && index >= 1) {
            Navigator.pushNamed(context, 'phone_in');
          } else {
            setState(() {
              pageController.jumpToPage(index);
              indexScreen = index;
            });
          }
          /*setState(() {
            //pageController.jumpToPage(index);
            indexScreen = index;
          });*/

        },
        currentIndex: indexScreen,
        //currentIndex: 2,
        reverse: true,
        curve: Curves.easeInBack,
        activeColor: Colors.red,
        inactiveColor: Colors.black87,
        items: items,
      ),
    );
  }
}
