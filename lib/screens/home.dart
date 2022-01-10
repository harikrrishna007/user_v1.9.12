import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/components/input_field.dart';
import 'package:ride_app/config.dart';
import 'package:ride_app/constants.dart';
import 'package:ride_app/handlers/app_data.dart';
import 'package:http/http.dart' as http;
import 'package:ride_app/helpers/request_methods.dart';
import 'package:ride_app/localization/localize_bolt.dart';
import 'package:ride_app/models/directions.dart';
import 'package:ride_app/screens/history.dart';
import 'package:ride_app/screens/promotions.dart';
import 'package:ride_app/screens/support.dart';
import 'package:ride_app/widgets/progressDialog.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'search_pickup.dart';
import 'search_dropoff.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "home";
  final WebSocketChannel channel = new IOWebSocketChannel.connect("ws://192.168.102.223:8080");

  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late StreamController _userController;
  late String responseStatus = "Requesting Ride...";
  late String bookingId = "";
  late bool rideStatus = true;

  loadStatus() async {
    String statusUrl = "https://saisatram.in/rideapis/api/booking/status.php";
    Map userId = {
      "id": bookingId,
    };
    http.Response status = await http.post(Uri.parse(statusUrl), body: userId);
    var stat = jsonDecode(status.body);
    if(stat['status'] == 1) {
      setState(() {
        responseStatus = stat['message'];
      });
    }
    if(responseStatus == "BOOKED") {
      setState(() {
        requestContainerHeight = 0.0;
        confirmedContainerHeight = 250.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userController = StreamController();
    Timer.periodic(Duration(seconds: 10), (_) => loadStatus());
  }

  Completer<GoogleMapController> _googleMapController = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails? rideDetails;
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController dropTextEditingController = TextEditingController();
  double bottomPaddingMap = 0;
  List<LatLng> routeCoordinates = [];
  Set<Polyline> polylineSet = {};
  late Position currentPosition;
  var geoLocator = Geolocator();
  var onTap;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  double rideDetailsContainer = 0;
  double searchContainerHeight = 350.0;
  double requestContainerHeight = 0;
  double confirmedContainerHeight = 0;
  bool showSearchContainer = true;

  Future<void> requestRide() async {
    var pickup =
        Provider.of<AppData>(context, listen: false).userPickupLocation;
    var dropoff =
        Provider.of<AppData>(context, listen: false).userDropoffLocation;
    Map pickupCoords = {
      "latitude": pickup.latitude.toString(),
      "longitude": pickup.longitude.toString(),
    };

    Map dropoffCoords = {
      "latitude": dropoff.latitude.toString(),
      "longitude": dropoff.longitude.toString(),
    };

    Map rideInfo = {
      "did": "WAITING",
      "uid": Provider.of<AppData>(context, listen: false).userId,
      "method": "CASH",
      "amount": "25",
      "coupon": "GET10",
      "cpickup": pickupCoords.toString(),
      "cdropoff": dropoffCoords.toString(),
      "username": Provider.of<AppData>(context, listen: false).userName,
      "usermobile": Provider.of<AppData>(context, listen: false).userMobile,
      "apickup": pickup.placeName,
      "adropoff": dropoff.placeName
    };
    widget.channel.sink.add(jsonEncode(rideInfo));
    String rideUrl = "https://saisatram.in/rideapis/api/booking/book.php";
    http.Response response =
        await http.post(Uri.parse(rideUrl), body: rideInfo);
    print(response.body);
    var data = jsonDecode(response.body);
    setState(() {
      rideStatus = data['status'] == 1 ? true : false;
    });
    if(data['status'] == 1) {
      bookingId = data['id'];
      print("Success");
    } else {
      print("Nil");
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  resetApp() {
    setState(() {
      showSearchContainer = false;
      searchContainerHeight = 350.0;
      rideDetailsContainer = 0.0;
      confirmedContainerHeight = 0.0;
      requestContainerHeight = 0.0;
      bottomPaddingMap = 265.0;
      bookingId = "";
      polylineSet.clear();
      circlesSet.clear();
      markersSet.clear();
      routeCoordinates.clear();
      showSearchContainer = true;
    });
    locatePosition();
  }

  void displayrideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainer = 265.0;
      bottomPaddingMap = 265.0;
      showSearchContainer = false;
    });
  }

  void cancelRideRequest() async {
    setState(() {
      requestContainerHeight = 200;
      rideDetailsContainer = 0.0;
      bottomPaddingMap = 265.0;
      showSearchContainer = true;
    });
    requestRide();
  }
  // TODO: Call Cancel & Reset

  void displayRequestRideContainer() async {
    setState(() {
      requestContainerHeight = 200;
      rideDetailsContainer = 0.0;
      bottomPaddingMap = 265.0;
      showSearchContainer = true;
    });
    requestRide();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng coords = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: coords, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await RequestMethods.searchCoordinateAddress(position, context);
    print("Your Address is :: " + address);
    pickupTextEditingController.text = address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/user_icon.png",
                        height: 65.0,
                        width: 65.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hari Krishna",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Brand-Bold",
                            ),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(LocalizedBolt.of(context)?.getTranslatedValue('profile') ?? "View Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.heart, size: 24.0,),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_1') ?? "Free rides",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_2') ?? "Payments",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, HistoryScreen.routeName);
                },
                leading: Icon(Icons.history),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_3') ?? "History",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, PromotionScreen.routeName);
                },
                leading: Icon(Icons.card_giftcard),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_4') ?? "Promotions",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, SupportScreen.routeName);
                },
                leading: Icon(Icons.chat),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_5') ?? "Support",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_6') ?? "About",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_7') ?? "Work Rides",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_1') ?? "View Profile",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  resetApp();
                },
                child: Container(
                  height: 48.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(64.0)),
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Text(
                    LocalizedBolt.of(context)?.getTranslatedValue('home_drawer_button') ?? "Signup to Drive",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Brand Bold",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              initialCameraPosition: Constants.kGooglePlex,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController.complete(controller);
                newGoogleMapController = controller;
                setState(() {
                  bottomPaddingMap = 265.0;
                });
                locatePosition();
              },
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        LocalizedBolt.of(context)?.getTranslatedValue('home_title') ?? "Nice to see you!",
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        LocalizedBolt.of(context)?.getTranslatedValue('home_sub_title') ?? "Where are you going?",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brand-Bold",
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 8,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: TextField(
                            focusNode: AlwaysDisabledFocusNode(),
                            readOnly: true,
                            controller: dropTextEditingController,
                            keyboardType: TextInputType.text,
                            onTap: () async {
                              var response = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new DropoffSearchScreen()));
                              if (response == "getDirection") {
                                dropTextEditingController.text =
                                    Provider.of<AppData>(context, listen: false)
                                        .userDropoffLocation
                                        .placeName;
                                displayrideDetailsContainer();
                              }
                            },
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.none, width: 0.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.green,
                                size: 18.0,
                              ),
                              hintText: LocalizedBolt.of(context)?.getTranslatedValue('drop_hint') ?? "Enter Drop Location",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
//                      Row(
//                        children: [
//                          Icon(Icons.home, color: Colors.black,),
//                          SizedBox(width: 12.0,),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              Text(
//                                "Add Home"
//                              ),
//                              SizedBox(height: 4.0,),
//                              Text(
//                                "Your living Home address",
//                                style: TextStyle(
//                                  color: Colors.black54,
//                                  fontSize: 12.0,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                      SizedBox(height: 24.0,),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[300],
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            "Subhadra Arcade, Kakinada.",
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.black54, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey[300],
                            size: 32.0,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ikeja City Mall", style: TextStyle(
                                  fontSize: 20.0, color: Colors.black54, fontWeight: FontWeight.bold),),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Obefemi Awolowo Way, Ikeja, Nigeria",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey[300],
                            size: 32.0,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ikeja City Mall", style: TextStyle(
                                  fontSize: 20.0, color: Colors.black54, fontWeight: FontWeight.bold),),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Obefemi Awolowo Way, Ikeja, Nigeria",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 32.0,
              top: 45.0,
              child: GestureDetector(
                onTap: () {
                  if (showSearchContainer)
                    scaffoldKey.currentState?.openDrawer();
                  else
                    resetApp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                        (showSearchContainer) ? Icons.menu : Icons.arrow_back),
                    radius: 24.0,
                  ),
                ),
              ),
            ),
//            Positioned(
//              left: 0.0,
//              right: 0.0,
//              bottom: 0.0,
//              child: AnimatedSize(
//                vsync: this,
//                curve: Curves.bounceIn,
//                duration: new Duration(milliseconds: 160),
//                child: Container(
//                  height: searchContainerHeight,
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(16.0),
//                      topRight: Radius.circular(16.0),
//                    ),
//                  ),
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: [
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: [
//                          Padding(
//                            padding: EdgeInsets.only(
//                                top: 24.0, left: 24.0, right: 24.0),
//                            child: TextField(
//                              controller: pickupTextEditingController,
//                              keyboardType: TextInputType.text,
//                              onTap: () {
//                                Navigator.pushNamed(
//                                    context, PickupSearchScreen.routeName);
//                              },
//                              style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 14.0,
//                                fontWeight: FontWeight.bold,
//                              ),
//                              decoration: InputDecoration(
//                                border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(64.0),
//                                ),
//                                prefixIcon: Icon(
//                                  Icons.location_on,
//                                  color: Colors.green,
//                                  size: 18.0,
//                                ),
//                                hintText: "Enter Pickup Location",
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding: EdgeInsets.only(
//                                top: 24.0, left: 24.0, right: 24.0),
//                            child: TextField(
//                              readOnly: true,
//                              controller: dropTextEditingController,
//                              keyboardType: TextInputType.text,
//                              onTap: () async {
//                                var response = await Navigator.push(
//                                    context,
//                                    new MaterialPageRoute(
//                                        builder: (context) =>
//                                            new DropoffSearchScreen()));
//                                if (response == "getDirection") {
//                                  dropTextEditingController.text =
//                                      Provider.of<AppData>(context,
//                                              listen: false)
//                                          .userDropoffLocation
//                                          .placeName;
//                                  displayrideDetailsContainer();
//                                }
//                              },
//                              style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 14.0,
//                                fontWeight: FontWeight.bold,
//                              ),
//                              decoration: InputDecoration(
//                                border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(64.0),
//                                ),
//                                prefixIcon: Icon(
//                                  Icons.location_on,
//                                  color: Colors.red,
//                                  size: 18.0,
//                                ),
//                                hintText: "Enter Drop Location",
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                      Text("Hi"),
//                    ],
//                  ),
//                ),
//              ),
//            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: rideDetailsContainer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.tealAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/taxi.png",
                                  height: 70.0,
                                  width: 80.0,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Car",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold",
                                      ),
                                    ),
                                    Text(
                                      ((rideDetails != null)
                                          ? rideDetails!.distanceString
                                          : ''),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  '₦ 3100 - ₦ 3400',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Brand-Bold"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 18.0,
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Text("Cash"),
                              SizedBox(
                                width: 6.0,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: RaisedButton(
                            onPressed: () {
                              displayRequestRideContainer();
                            },
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.directions_car,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7)),
                  ],
                ),
                height: requestContainerHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 24.0),
                        child: FadingText(
                          responseStatus,
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        )),
                    SizedBox(
                      height: 12.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        resetApp();
                      },
                      child: Container(
                        height: 48.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.red, width: 2.0),
                            borderRadius: BorderRadius.circular(64.0)),
                        margin: EdgeInsets.symmetric(
                          horizontal: 128.0,
                          vertical: 24.0,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: confirmedContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Driver Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              fontFamily: "PTSerif"),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        child: Text(
                          "8328484639",
                          style:
                          TextStyle(fontSize: 16.0, fontFamily: "OpenSans"),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        child: Text(
                          "Skoda Rapid - AP 05 BS 0162",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Container(
                        child: Text(
                          "7 Min",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Brand Bold",
                              color: Colors.green),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 44.0,
                                width: 128.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(64.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Call",
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
                            GestureDetector(
                              onTap: () {
                                resetApp();
                              },
                              child: Container(
                                height: 44.0,
                                width: 128.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border:
                                    Border.all(color: Colors.red, width: 2.0),
                                    borderRadius: BorderRadius.circular(64.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Cancel Ride",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
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
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var startPosition =
        Provider.of<AppData>(context, listen: false).userPickupLocation;
    var finalPosition =
        Provider.of<AppData>(context, listen: false).userDropoffLocation;
    var pickupCoords = LatLng(startPosition.latitude, startPosition.longitude);
    var dropoffCoords = LatLng(finalPosition.latitude, finalPosition.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait...",
            ));
    var details =
        await RequestMethods.getPlaceDirections(pickupCoords, dropoffCoords);
    setState(() {
      rideDetails = details!;
    });
    Navigator.pop(context);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details!.encodedpoints);
    routeCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        routeCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: routeCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickupCoords.latitude > dropoffCoords.latitude &&
        pickupCoords.longitude > dropoffCoords.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropoffCoords, northeast: pickupCoords);
    } else if (pickupCoords.longitude > dropoffCoords.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupCoords.latitude, dropoffCoords.longitude),
          northeast: LatLng(dropoffCoords.latitude, pickupCoords.longitude));
    } else if (pickupCoords.latitude > dropoffCoords.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropoffCoords.latitude, pickupCoords.longitude),
          northeast: LatLng(pickupCoords.latitude, dropoffCoords.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickupCoords, northeast: dropoffCoords);
    }
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    Marker pickupMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: startPosition.placeName, snippet: "Current Location"),
      position: pickupCoords,
      markerId: MarkerId("pickupID"),
    );
    Marker dropoffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPosition.placeName, snippet: "Destination"),
      position: dropoffCoords,
      markerId: MarkerId("dropoffID"),
    );
    setState(() {
      markersSet.add(pickupMarker);
      markersSet.add(dropoffMarker);
    });
    Circle pickupCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickupCoords,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickupID"),
    );
    Circle dropoffCircle = Circle(
      fillColor: Colors.red,
      center: dropoffCoords,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropoffID"),
    );
    setState(() {
      circlesSet.add(pickupCircle);
      circlesSet.add(dropoffCircle);
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
