import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ride_app/models/address.dart';
import 'package:http/http.dart' as http;

class AppData extends ChangeNotifier {
  late Address userPickupLocation, userDropoffLocation;
  String? userId, userName, userMobile, userMail;

  void updateuserPickupLocationAddress(Address pickupAddress) {
    userPickupLocation = pickupAddress;
    notifyListeners();
  }
  void updateuserDropoffLocationAddress(Address dropoffAddress) {
    userDropoffLocation = dropoffAddress;
    notifyListeners();
  }
  void updateUserData(Response response) {
    var data = jsonDecode(response.body);
    data = data['data'];
    userId = data['userid'];
    userMail = data['mail'];
    userName = data['name'];
    userMobile = data['mobile'];
    notifyListeners();
  }
}