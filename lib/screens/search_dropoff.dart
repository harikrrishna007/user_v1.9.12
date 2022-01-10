import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/components/bottom_button.dart';
import 'package:ride_app/config.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:ride_app/helpers/request.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/models/address.dart';
import 'package:ride_app/models/predictions.dart';
import 'package:ride_app/widgets/divider.dart';
import 'package:ride_app/widgets/progressDialog.dart';

class DropoffSearchScreen extends StatefulWidget {
  static String routeName = "dsearch";

  DropoffSearchScreen({Key? key}) : super(key: key);
  @override
  _DropoffSearchScreenState createState() => _DropoffSearchScreenState();
}

class _DropoffSearchScreenState extends State<DropoffSearchScreen> {
  TextEditingController dropoffTextEditingController = TextEditingController();
  TextEditingController pickupTextEditingController = TextEditingController();
  List<Predictions> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 235.0,
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
                              LocalizedBolt.of(context)?.getTranslatedValue('drop_hint') ?? "Enter Drop Location",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 14.0,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onChanged: (val) {
                                    searchPlace(val);
                                  },
                                  controller: pickupTextEditingController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.0, style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    hintText: Provider.of<AppData>(context,
                                            listen: false)
                                        .userPickupLocation
                                        .placeName,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.0,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onChanged: (val) {
                                    searchPlace(val);
                                  },
                                  controller: dropoffTextEditingController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.0, style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
//                                    hintText: (Provider.of<AppData>(context, listen: false).userDropoffLocation == null) ? "Enter Drop Location" : Provider.of<AppData>(context, listen: false).userDropoffLocation.placeName,
                                    hintText: LocalizedBolt.of(context)?.getTranslatedValue('drop_hint') ?? "Enter Drop Location",
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
              ),
              SizedBox(height: 18.0,),
              SingleChildScrollView(
                child:
              (placePredictionList.length > 0)
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListView.separated(
                        padding: EdgeInsets.all(0.0),
                        itemBuilder: (context, index) {
                          return PredictionTile(
                            placePredictions: placePredictionList[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 24.0,
                        ),
                        itemCount: placePredictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    )
                  : SingleChildScrollView(
                    child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocalizedBolt.of(context)?.getTranslatedValue('search_home_title') ?? "Add Home"),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                LocalizedBolt.of(context)?.getTranslatedValue('search_home_sub_title') ?? "Your living Home address",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                        SizedBox(height: 12.0,),
                        DividerWidget(),
                        SizedBox(height: 12.0,),
                        Row(
                          children: [
                            Icon(
                              Icons.work,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LocalizedBolt.of(context)?.getTranslatedValue('search_work_title') ?? "Add Work"),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  LocalizedBolt.of(context)?.getTranslatedValue('search_work_sub_title') ?? "Your living Home address",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0,),
                        DividerWidget(),
                        SizedBox(height: 12.0,),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ikeja City Mall", style: TextStyle( color: Colors.black,),),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Obefemi Awolowo Way, Ikeja, Nigeria",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0,),
                        DividerWidget(),
                        SizedBox(height: 12.0,),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ikeja City Mall", style: TextStyle(
                                    color: Colors.black),),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  "Obefemi Awolowo Way, Ikeja, Nigeria",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0,),
                        DividerWidget(),
                        SizedBox(height: 12.0,),
                      ],
                    ),
                ),
              ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String autocompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&components=country:in";
      var response = await Request.getRequest(autocompleteUrl);
      if (response == "failed") {
        return;
      }
      if (response['status'] == "OK") {
        var predictions = response['predictions'];
        var placesList =
            (predictions as List).map((e) => Predictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final Predictions placePredictions;
  const PredictionTile({
    Key? key,
    required this.placePredictions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getPlaceDetails(placePredictions.placeID, context);
      },
      child: Column(
        children: [
          SizedBox(
            width: 10.0,
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 32.0,
              ),
              SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placePredictions.mainText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      placePredictions.secondaryText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  void getPlaceDetails(String placeID, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Setting Dropoff",
            ));
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey";
    var response = await Request.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (response == "Failed") {
      return;
    }
    if (response['status'] == "OK") {
      Address address = Address(
        placeName: response["result"]["name"],
        placeID: placeID,
        latitude: response["result"]["geometry"]["location"]["lat"],
        longitude: response["result"]["geometry"]["location"]["lng"],
      );
      Provider.of<AppData>(context, listen: false)
          .updateuserDropoffLocationAddress(address);
    }
    Navigator.pop(context, "getDirection");
  }
}
