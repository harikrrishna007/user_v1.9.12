import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/config.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:ride_app/helpers/request.dart';
import 'package:ride_app/models/address.dart';
import 'package:ride_app/models/directions.dart';
import 'package:http/http.dart' as http;

class RequestMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String currentAddress = "";
    String pickupAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await Request.getRequest(url);
    if(response != "Failed") {
      currentAddress = response['results'][0]["formatted_address"];
      pickupAddress = response['results'][0]["address_components"][1]["long_name"] + ", " +
          response['results'][0]["address_components"][2]["long_name"] + ", " +
          response['results'][0]["address_components"][3]["long_name"] + ", " +
          response['results'][0]["address_components"][4]["long_name"] + ".";
      Address userPickupAddress = new Address(
          placeName: currentAddress,
          latitude: position.latitude,
          longitude: position.longitude
      );
      Provider.of<AppData>(context, listen: false).updateuserPickupLocationAddress(userPickupAddress);
    }

    return pickupAddress;
  }

  static Future<DirectionDetails?> getPlaceDirections(LatLng startPosition, LatLng finalPosition) async {
    String directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    var response = await Request.getRequest(directionsUrl);
    if(response == "Failed") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails(
        distance: response['routes'][0]['legs'][0]['distance']['value'],
        duration: response['routes'][0]['legs'][0]['duration']['value'],
        distanceString: response['routes'][0]['legs'][0]['distance']['text'],
        durationString: response['routes'][0]['legs'][0]['duration']['text'],
        encodedpoints: response['routes'][0]['overview_polyline']['points'],
    );
    return directionDetails;
  }
}