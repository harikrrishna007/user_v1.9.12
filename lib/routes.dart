import 'package:flutter/widgets.dart';
import 'package:ride_app/screens/details.dart';
import 'package:ride_app/screens/history.dart';
import 'package:ride_app/screens/home.dart';
import 'package:ride_app/screens/language.dart';
import 'package:ride_app/screens/login.dart';
import 'package:ride_app/screens/promotions.dart';
import 'package:ride_app/screens/register.dart';
import 'package:ride_app/screens/splash_screen.dart';
import 'package:ride_app/screens/support.dart';
import 'package:ride_app/screens/verification.dart';
import 'screens/search_pickup.dart';
import 'screens/search_dropoff.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  RegistrationScreen.routeName:  (context) => RegistrationScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  PickupSearchScreen.routeName: (context) => PickupSearchScreen(),
  DropoffSearchScreen.routeName: (context) => DropoffSearchScreen(),
  LanguageScreen.routeName: (context) => LanguageScreen(),
  SupportScreen.routeName: (context) => SupportScreen(),
  PromotionScreen.routeName: (context) => PromotionScreen(),
  HistoryScreen.routeName: (context) => HistoryScreen(),
  SplashScreen.routeName: (context) => SplashScreen(),
  VerificationScreen.routeName: (context) => VerificationScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen()
};