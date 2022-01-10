import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/components/bottom_button.dart';
import 'package:ride_app/components/input_field.dart';
import 'package:ride_app/components/otp_mail.dart';
import 'package:ride_app/constants.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/main.dart';
import 'package:ride_app/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:ride_app/screens/verification.dart';
import 'package:ride_app/widgets/progressDialog.dart';
import 'package:ride_app/constants.dart';

class RegistrationScreen extends StatelessWidget {
  static String routeName = "register";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                            controller: emailTextEditingController,
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
                                Icons.mail_rounded,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('mail') ?? "Email",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0, bottom: 14.0, left: 24.0, right: 24.0),
                          child: TextField(
                            controller: passwordTextEditingController,
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
                                Icons.lock,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('password') ?? "password",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if(!emailTextEditingController.text.contains("@")) {
                                toastMessage("Enter a valid mail", context);
                              }
                              else if(passwordTextEditingController.text.length < 8) {
                                toastMessage("Password should be minimum 8 characters", context);
                              }
                              else {
                                registerNewUser(context);
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
                                LocalizedBolt.of(context)?.getTranslatedValue('register') ?? "Register",
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
                        RichText(
                          text: TextSpan(
                              text: LocalizedBolt.of(context)?.getTranslatedValue('login_hint') ?? "Already having an account? ",
                              children:[
                                TextSpan(
                                    text: LocalizedBolt.of(context)?.getTranslatedValue('login') ?? "Login",
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false)
                                ),
                              ],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13
                              )
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
  Future registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Please wait...",);
        }
    );
    final APIURL = "https://saisatram.in/rideapis/api/user/verify.php";
    Map userDataMap = {
      "mail": emailTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim()
    };
    http.Response response = await http.post(Uri.parse(APIURL),body:userDataMap);

    //getting response from php code, here
    var data = jsonDecode(response.body);
    if(data['status'] == 1)
    {
      toastMessage(data['message'], context);
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        VerificationScreen.routeName,
        arguments: Mail(
          emailTextEditingController.text,
          passwordTextEditingController.text,
          data['message'],
        ),
      );
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