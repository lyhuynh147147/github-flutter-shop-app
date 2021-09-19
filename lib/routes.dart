import 'package:flutter/material.dart';
import 'package:phone_verification/screens/Customer/SearchPage/search_view.dart';
import 'package:phone_verification/screens/Customer/chat_view.dart';
import 'package:phone_verification/screens/Register/phoneIn/phone_in.dart';
import 'package:phone_verification/screens/Register/phoneUp/phone_up.dart';
import 'package:phone_verification/screens/Register/register_view.dart';
import 'package:phone_verification/screens/admin/Coupon/admin_coupon_view.dart';
import 'package:phone_verification/screens/admin/OrderAndSold/admin_bill_history_view.dart';
import 'package:phone_verification/screens/admin/Products/product_adding_view.dart';
import 'package:phone_verification/screens/admin/Products/product_manager_view.dart';
import 'package:phone_verification/screens/admin/Users/admin_user_manager.dart';
import 'package:phone_verification/screens/admin/admin_home_view.dart';
import 'package:phone_verification/screens/customer/HomePage/cartpage/cart_view.dart';
import 'package:phone_verification/screens/customer/HomePage/cus_home_view.dart';
import 'package:phone_verification/screens/customer/HomePage/details/details_screen.dart';
import 'package:phone_verification/screens/customer/ProfilePage/ChangePassword/change_password_view.dart';
import 'package:phone_verification/screens/customer/ProfilePage/Detail/detail_user_profile_views.dart';
import 'package:phone_verification/screens/customer/ProfilePage/OrderAndBill/order_and_bill_view.dart';
import 'package:phone_verification/screens/customer/ProfilePage/OrderAndBill/order_history_view.dart';
import 'package:phone_verification/screens/customer/ProfilePage/OrderAndBill/order_info_view.dart';
import 'package:phone_verification/screens/customer/ProfilePage/profile_view.dart';
import 'package:phone_verification/screens/customer/customer_home_view.dart';
import 'package:phone_verification/screens/splash_view.dart';
import 'package:phone_verification/screens/welcome_view.dart';

const initialRoute = "welcome_screen";
var routes = {
  // PHONE
  'phone_in': (context) => PhoneIn(),
  'phone_up': (context) => PhoneUp(),

  //REGISTER
  'splash_screen': (context) => SplashView(),
  'welcome_screen': (context) => WelcomeScreen(),
  'register_screen': (context) => RegisterViews(),

  //CUSTOMER HOME VIEW
  'customer_home_screen': (context) => CustomerHomeView(),
  'customer_detail_product_screen': (context) => DetailsScreen(),
  'customer_search_page': (context) => SearchView(),
  'customer_chat_screen': (context) => ChatScreen(),

  //ADMIN HOME VIEW
  'admin_home_screen': (context) => AdminHomeView(),
  'admin_user_manager': (context) => UserManagerView(),
  'admin_home_product': (context) => ProductManager(),
  'admin_home_product_adding': (context) => ProductAddingView(),
  'customer_home_page': (context) => CustomerHomePageView(),
  'customer_cart_page': (context) => CartView(),
  'customer_profile_page': (context) => ProfileView(),
  'customer_order_history_screen': (context) => OrderHistoryView(),
  'admin_bill_history_screen': (context) => AdminBillHistoryView(),
  'admin_coupon_manager': (context) => CouponAdminView(),


  //Profile
  'customer_change_password_screen': (context) => ChangePasswordView(),
  'customer_detail_screen': (context) => DetailProfileView(),
  //'custommer_bank_account_screen': (context) => BankAccountView(),
  'customer_order_detail_screen': (context) => OrderAndBillView(),
  'customer_order_info_screen': (context) => OrderInfoView(),


/* //ADMIN HOME VIEW
  'admin_home_screen': (context) => AdminHomeView(),
  'admin_home_product': (context) => ProductManager(),
  'admin_home_product_adding': (context) => ProductAddingView(),
  'admin_user_manager': (context) => UserManagerView(),
  'admin_coupon_manager': (context) => CouponAdminView(),
  'admin_bill_history_screen': (context) => AdminBillHistoryView(),

  //CUSTOMER HOME VIEW
  'customer_home_screen': (context) => CustomerHomeView(),
  'customer_home_page': (context) => CustomerHomePageView(),
  'customer_search_page': (context) => SearchView(),
  'customer_wishlist_page': (context) => WishListView(),
  'customer_cart_page': (context) => CartView(),
  'customer_profile_page': (context) => ProfileView(),
  'customer_detail_banner_screen': (context) => ProductListView(),
  'customer_detail_product_screen': (context) => MainDetailProductView(),
  'customer_order_history_screen': (context) => OrderHistoryView(),

  // Profile
  'customer_change_password_screen': (context) => ChangePasswordView(),
  'customer_detail_screen': (context) => DetailProfileView(),
  'custommer_bank_account_screen': (context) => BankAccountView(),
  'customer_order_detail_screen': (context) => OrderAndBillView(),
  'customer_order_info_screen': (context) => OrderInfoView(),*/
};
// var routes = {
//   'register_screenss': (context) => RegisterViews(),
//   'register_screens': (context) => RegisterView(),
//   'splash_screen': (context) => SplashView(),
//   'welcome_screen': (context) => WelcomeScreen(),
//   //'admin_home_screen': (context) => CustomerHomeView(),
//   'login_screen': (context) => LoginScreens(),
//   //'register_screen': (context) => RegisterScreen(),
//   'signin_password': (context) => SignInPassword(),
//   'logge_in_screen': (context) => LoggedInScreen(),
//
//   //CUSTOMER HOME VIEW
//   'customer_home_screen': (context) => CustomerHomeView(),
//   'customer_detail_product_screen': (context) => DetailsScreen(),
//
//
//   //ADMIN HOME VIEW
//   'admin_home_screen': (context) => AdminHomeView(),
//   'admin_user_manager': (context) => UserManagerView(),
//   'admin_home_product': (context) => ProductManager(),
//   'admin_home_product_adding': (context) => ProductAddingView(),
//   'customer_home_page': (context) => CustomerHomePageView(),
//   'customer_cart_page': (context) => CartView(),
//   'customer_profile_page': (context) => ProfileView(),
//   'customer_order_history_screen': (context) => OrderHistoryView(),
//   'admin_bill_history_screen': (context) => AdminBillHistoryView(),
//   'admin_coupon_manager': (context) => CouponAdminView(),
//
//   //Profile
//   'customer_change_password_screen': (context) => ChangePasswordView(),
//   'customer_detail_screen': (context) => DetailProfileView(),
//   //'custommer_bank_account_screen': (context) => BankAccountView(),
//   'customer_order_detail_screen': (context) => OrderAndBillView(),
//   'customer_order_info_screen': (context) => OrderInfoView(),
// };