import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/components/user_details.dart';
import 'package:ride_app/constants.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:ride_app/widgets/progressDialog.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "details";
  late String userid;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Details;
    setState(() {
      widget.userid = args.userid;
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0XFF11D86F),
          child: Padding(
            padding: const EdgeInsets.only(top: 128.0),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Text(
                      "${LocalizedBolt.of(context)?.getTranslatedValue('details_title')}\n${LocalizedBolt.of(context)?.getTranslatedValue('details_sub_title')}",
                      textAlign: TextAlign.center,
                      style: Constants.kBoldHeading,
                    ),
                  ),
                  SizedBox(height: 80.0,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 56.0, bottom: 14.0, left: 24.0, right: 24.0),
                          child: TextField(
                            controller: nameTextEditingController,
                            keyboardType: TextInputType.text,
                            onTap: () {},
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('name') ?? "Name",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 24.0, right: 24.0),
                          child: TextField(
                            controller: phoneTextEditingController,
                            keyboardType: TextInputType.text,
                            onTap: () {},
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('phone') ?? "Mobile",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if(nameTextEditingController.text.length < 3) {
                                toastMessage("Enter your name", context);
                              }
                              else if(phoneTextEditingController.text.length < 10 || phoneTextEditingController.text.length > 10) {
                                toastMessage("Enter a valid phone number", context);
                              }
                              else {
                                saveDetails(context);
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
                                "Continue", //TODO: Language
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: "Brand Bold",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future saveDetails(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Please wait...",);
        }
    );
    final APIURL = "https://saisatram.in/rideapis/api/user/details.php";
    Map userDataMap = {
      "name": nameTextEditingController.text.trim(),
      "mobile": phoneTextEditingController.text.trim(),
      "userid": widget.userid
    };
    http.Response response = await http.post(Uri.parse(APIURL),body:userDataMap);

    //getting response from php code, here
    var data = jsonDecode(response.body);
    if(data['status'] == 1)
    {
      toastMessage(data['message'], context);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
    }
    else {
      toastMessage(data['message'], context);
      Navigator.pop(context);
    }
  }
}

toastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}