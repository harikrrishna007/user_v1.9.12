import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:ride_app/languages.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/main.dart';
import 'package:ride_app/screens/login.dart';

import 'home.dart';

class LanguageScreen extends StatefulWidget {
  static String routeName = "language";

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late final String dropdownval;
  void _changeLanguage(Language language) {
    Locale _temp;
    switch(language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, "US");
        break;
      case 'de':
        _temp = Locale(language.languageCode, "");
        break;
      default:
        _temp = Locale(language.languageCode, "US");
    }
    MyApp.setLocale(context, _temp);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFF11D86F),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                    color: Color(0XFF11D86F),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.language, size: 72.0, color: Colors.white,),
                      SizedBox(height: 24.0,),
                      Text(
                        "Please Select Language",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontFamily: "Brand Bold",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Center(
                          child: DropdownButton(
                            hint: Text("Language", style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Brand Bold",
                              color: Colors.white,
                            ),),
                            onChanged: (Language? language) {
                              _changeLanguage(language!);
                              dropdownval = language.name;
                            },
                            items: Language.languageList()
                                .map<DropdownMenuItem<Language>>(
                                    (lang) => DropdownMenuItem(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget> [
                                              Text(lang.flag, style: TextStyle(
                                                fontSize: 18.0,
                                              ),),
                                              Text(lang.name, style: TextStyle(
                                                fontSize: 18.0,
                                              ),),
                                            ],
                                          ),
                                          value: lang,
                                        ))
                                .toList(),
                            underline: SizedBox(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0,),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 24.0,),
                    Text(
                      "Selected Language: ${LocalizedBolt.of(context)?.locale.languageCode == "en" ? "English 🇺🇸" : "German 🇩🇪"}",
                      style:  TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11D86F),
                      ),),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (Provider.of<AppData>(context, listen: false).userId == null) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.routeName, (route) => false);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.routeName, (route) => false);
                        }
                      },
                      child: Container(
                        height: 48.0,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0XFF11D86F),
                            borderRadius: BorderRadius.circular(64.0)),
                        margin: EdgeInsets.symmetric(
                          horizontal: 64.0,
                          vertical: 24.0,
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
