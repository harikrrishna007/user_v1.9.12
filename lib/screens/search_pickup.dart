import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/handlers/app_data.dart';

class PickupSearchScreen extends StatefulWidget {
  static String routeName = "/psearch";
  @override
  _PickupSearchScreenState createState() => _PickupSearchScreenState();
}

class _PickupSearchScreenState extends State<PickupSearchScreen> {
  TextEditingController pickupTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String pickupAddress = Provider.of<AppData>(context).userPickupLocation.placeName ?? "";
    pickupTextEditingController.text = pickupAddress;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 150.0,
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
                    SizedBox(height: 5.0,),
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
                            "Enter Drop Location",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickupTextEditingController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(64.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 24.0,
                                  ),
                                  hintText: "Enter Pickup",
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
