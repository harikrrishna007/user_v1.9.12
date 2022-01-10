import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const kBoldHeading = TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: "Brand Bold");
  static const kInputText = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "Brand Bold");
  static const kPrimaryColor = Color(0XFF11D86F);
  static const kBottomContainerHeight = 80.0;
  static const kActiveCardColor = Color(0xFF1D1E33);
  static const kInactiveCardColor = Color(0xFF111328);
  static const kBottomContainerColor = Color(0xFFEB1555);
  static const kThemeButtonColor = Color(0x00000000);
  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(27.2046, 77.4977),
    zoom: 14.4746,
  );
  static const kLabelTextStyle = TextStyle(
      fontSize: 18.0,
      color: Color(0xFF8D8E98)
  );
  static const kHeightTextStyle = TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.w900
  );
  static const kLargeButtonTextStyle = TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold
  );
  static const kTitleTextStyle = TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.bold
  );
  static const kResultTextStyle = TextStyle(
      fontSize: 22.0,
      color: Color(0xFF24D876),
      fontWeight: FontWeight.bold
  );
  static const kBMITextStyle = TextStyle(
      fontSize: 100.0,
      fontWeight: FontWeight.bold
  );
  static const kBodyTextStyle = TextStyle(
    fontSize: 22.0,
  );
}