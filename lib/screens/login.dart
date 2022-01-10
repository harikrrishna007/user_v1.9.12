import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/components/bottom_button.dart';
import 'package:ride_app/components/input_field.dart';
import 'package:ride_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/screens/home.dart';
import 'package:ride_app/screens/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ride_app/widgets/progressDialog.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "login";
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
                      "${LocalizedBolt.of(context)?.getTranslatedValue('login_title')}\n${LocalizedBolt.of(context)?.getTranslatedValue('login_sub_title')}",
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
                        MediaQuery.of(context).size.height / 4.5,
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
                                Icons.mail,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('mail') ?? "Email",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
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
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('password') ?? "Password",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              loginUser(context);
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
                                LocalizedBolt.of(context)?.getTranslatedValue('login') ?? " Login",
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
                              text: LocalizedBolt.of(context)?.getTranslatedValue('register_hint') ?? "Create a new Account? ",
                              children:[
                                TextSpan(
                                    text: LocalizedBolt.of(context)?.getTranslatedValue('register') ?? "Register",
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.routeName, (route) => false)
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

  Future loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });
    final APIURL = "https://saisatram.in/rideapis/api/user/login.php";
    Map userDataMap = {
      "mail": emailTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim()
    };
    http.Response response =
        await http.post(Uri.parse(APIURL), body: userDataMap);

    //getting response from php code, here
    var data = jsonDecode(response.body);
    if (data['status'] == 1) {
      Provider.of<AppData>(context, listen: false).updateUserData(response);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } else {
      toastMessage(data['message'], context);
      Navigator.pop(context);
    }
  }
}

toastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
