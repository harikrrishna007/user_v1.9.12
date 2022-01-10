import 'package:flutter/material.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/widgets/divider.dart';

class SupportScreen extends StatelessWidget {
  static String routeName = "support";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 25.0,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.arrow_back,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Center(
                            child: Text(
                              "Support",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Color(0XFFDDDDDD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            "Help with Journey",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand Bold",
                                color: Colors.black38
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: Colors.black38,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Your Conversations",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Issue with the recent trip",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand Bold",
                            color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Issue with the another trip",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                  Container(
                    color: Color(0XFFDDDDDD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            "Support",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand Bold",
                                color: Colors.black38
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.black38,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Payments and Pricing",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                  Container(
                    color: Color(0XFFDDDDDD),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            "Conversations",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Brand Bold",
                                color: Colors.black38
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.black38,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Your Conversations",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black54
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black38,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                  DividerWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}