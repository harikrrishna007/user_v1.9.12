import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:ride_app/components/otp_mail.dart';
import 'package:ride_app/components/user_details.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:http/http.dart' as http;
import 'package:ride_app/screens/details.dart';
import 'package:ride_app/widgets/progressDialog.dart';

import '../constants.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen({Key? key}) : super(key: key);
  late String mail;
  late String userid;
  late String password;
  static String routeName = "/otp";
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color(0XFFEFEFEF),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Color(0XFFCACACA),
        blurRadius: 2.0,
        spreadRadius: 0.2,
        offset: Offset(0.7, 0.7),
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Mail;
    setState(() {
      widget.mail = args.mail;
      widget.userid = args.userid;
      widget.password = args.password;
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
                      "${LocalizedBolt.of(context)?.getTranslatedValue('registration_title')}\n${LocalizedBolt.of(context)?.getTranslatedValue('registration_sub_title')}",
                      textAlign: TextAlign.center,
                      style: Constants.kBoldHeading,
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(45.0),
                          child: PinPut(
                            fieldsCount: 6,
                            textStyle: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                            eachFieldWidth: 40.0,
                            eachFieldHeight: 40.0,
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            submittedFieldDecoration: pinPutDecoration,
                            selectedFieldDecoration: pinPutDecoration,
                            followingFieldDecoration: pinPutDecoration,
                            pinAnimationType: PinAnimationType.fade,
                            onSubmit: (pin) async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context)
                                  {
                                    return ProgressDialog(message: "Registering, Please wait...",);
                                  }
                              );
                              final APIURL = "https://saisatram.in/rideapis/api/user/register.php";
                              Map userDataMap = {
                                "mail": widget.mail,
                                "password": widget.password,
                                "userid": widget.userid,
                                "otp": pin
                              };
                              http.Response response = await http.post(Uri.parse(APIURL),body:userDataMap );

                              //getting response from php code, here
                              var data = jsonDecode(response.body);
                              if(data['status'] == 1)
                              {
                                toastMessage(data['message'], context);
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  DetailsScreen.routeName,
                                  arguments: Details(widget.userid),
                                );
                              }
                              else {
                                toastMessage(data['message'], context);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        )
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
}

toastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
