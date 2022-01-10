import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/screens/details.dart';
import 'package:ride_app/screens/home.dart';
import 'package:ride_app/screens/language.dart';
import 'package:ride_app/screens/login.dart';
import 'package:ride_app/screens/register.dart';
import 'package:ride_app/routes.dart';
import 'package:ride_app/screens/splash_screen.dart';
import 'package:ride_app/screens/verification.dart';
import 'screens/search_dropoff.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ride App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: _locale,
        supportedLocales: [
          Locale('en','US'),
          Locale('de',''),
        ],
        localizationsDelegates: [
          LocalizedBolt.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for(var locale in supportedLocales) {
            if(locale.languageCode == deviceLocale?.languageCode && locale.countryCode == deviceLocale?.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        initialRoute: SplashScreen.routeName,
//        initialRoute: LoginScreen.routeName,
        routes: routes,
      ),
    );
  }
}
SomethingWentWrong() {
  return Container(
    child: Text(
      "Error",
    ),
  );
}
Loading() {
  return Container(
    child: Text(
      "Loading",
    ),
  );
}