import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bh/feature-admin/view/homepageadmin.dart';
import 'package:my_bh/features/consiel/consielDetails.dart';
import 'package:my_bh/features/profile/view/UserInformation.dart';
import 'package:my_bh/features/report/view/reportView.dart';
import 'package:my_bh/features/transactions/view/transactionsView.dart';
import '../features/actualité/actualiteBhView.dart';
import '../features/exchange/view/exchangeView.dart';
import '../features/notification/view/notificationView.dart';
import '../features/settings/view/profileScreen.dart';
import '/../features/onboarding/splashScreen.dart';
import '../features/auth/presentation/auth_main.dart';
import '../features/home/view/homePage.dart';

class AppRoutes {
  static const home = '/';
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgetPassword = '/forgetPassword';
  static const newpassword = '/newpassword';
  static const onboardingScreen = '/OnboardingScreen';
  static const homepage = '/HomePage';
  static const profile = '/profile';
  static const personalInformation = '/personalInformation';
  static const privacyandpolicy = '/privacyandpolicy';
  static const bookingScreen = '/BookingScreen';
  static const Exchange = '/Exchange';
  static const report = '/report';
  static const notification = '/notification';
  static const settings = '/settings';
  static const transactions = '/transactions';
  static const transactionDetails = '/transactionDetails';
  static const consielDetails = '/consielDetails';
  static const homeadmine = '/homeadmine';

  // the page routes
  List<GetPage> appRoutes = [
    GetPage(
      name: splash,
      page: () => const Splashscreen(),
      transition: Transition.rightToLeft,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500), // Add this line
    ),
    GetPage(
      name: homepage,
      page: () => HomePage(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: home,
      page: () => const AuthentifactionPage(),
      transition: Transition.rightToLeft,
      curve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 1500),
    ),
    GetPage(
      name: report,
      page: () => Reportview(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: personalInformation,
      page: () => PersonalInformationView(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: Exchange,
      page: () => const ExchangeView(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: transactions,
      page: () => const TransactionsView(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: consielDetails,
      page: () => ConseilDetails(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),
    GetPage(
      name: homeadmine,
      page: () => const HomePageAdmin(),
      transition: Transition.rightToLeft,
      curve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 1500),
    ),
    GetPage(
      name: notification,
      page: () => const ActualitesBHView(),
      transition: Transition.rightToLeft,
      curve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 1500),
    ),
  ];

  // Routing method to navigate
  void goTo(String pagename, {dynamic requiredVariable}) {
    Get.toNamed(pagename,
        arguments: requiredVariable); // Pass the required variable as arguments
  }

// Routing method and remove all previous pages
  void goToEnd(String pagename) {
    Get.offAllNamed(
      pagename,
    );
  }

  void goTowithvarbiable(String pagename, dynamic requiredVariable) {
    Get.toNamed(
      pagename,
      arguments: requiredVariable,
    ); // Pass the required variable as arguments
  }
}
