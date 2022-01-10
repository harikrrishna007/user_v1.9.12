import 'package:flutter/material.dart';
import 'package:ride_app/widgets/divider.dart';

class HistoryScreen extends StatelessWidget {
  static String routeName = "history";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                                "History",
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
                DividerWidget(),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0, left: 18.0, right: 24.0, bottom: 8.0),
                                child: Text(
                                  "Mother and Child Hospital",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, left: 18.0, right: 24.0, bottom: 2.0),
                                child: Text(
                                  "5th Aug, 2020 05:39:07 pm",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, left: 18.0, right: 24.0, bottom: 2.0),
                                child: Text(
                                  "Finished",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Brand Bold",
                                      color: Color(0XFF11D86F),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0,),
                            ],
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0, left: 18.0, right: 24.0, bottom: 8.0),
                                child: Text(
                                  "Mother and Child Hospital",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, left: 18.0, right: 24.0, bottom: 2.0),
                                child: Text(
                                  "5th Aug, 2020 05:39:07 pm",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, left: 18.0, right: 24.0, bottom: 2.0),
                                child: Text(
                                  "Cancelled",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: "Brand Bold",
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0,),
                            ],
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
