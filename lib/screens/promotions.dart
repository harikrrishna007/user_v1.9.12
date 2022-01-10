import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'login.dart';

class PromotionScreen extends StatelessWidget {
  static String routeName = "promotion";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                color: Color(0XFF11D86F),
                child: Row(
                  children: [
                    Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    color: Color(0XFF11D86F),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/cogs.png", height: 216.0,),
                    SizedBox(height: 24.0,),
                    Text(
                      "Ride Together!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      child: Text(
                        "Bolt is a great way to move in the city with friends",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 24.0,),
                  Container(
                    width: 275.0,
                    color: Colors.black26,
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: "EMKKSBMSO5"));
                        toastMessage("Code Copied", context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Tap to copy code",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "EMKKSBMSO5",
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 20.0
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
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
                        "SHARE CODE",
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
    );
  }
}