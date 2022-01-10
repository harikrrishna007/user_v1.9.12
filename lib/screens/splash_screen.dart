import 'package:flutter/material.dart';
import 'package:ride_app/screens/language.dart';
import 'package:ride_app/screens/login.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Bolt!",
      "image": "assets/images/taxig.png"
    },
    {
      "text":
      "Travel without limits \naround Germany",
      "image": "assets/images/car.png"
    },
    {
      "text": "Let's Bolt!",
      "image": "assets/images/ride.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0XFFFFFFFF),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]['text'],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                                (index) => buildDot(index: index),
                          ),
                        ),
                        Spacer(flex: 3),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, LanguageScreen.routeName);
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
                                "Continue",
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
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Color(0XFF11D86F) : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "BOLT",
          style: TextStyle(
            fontSize: 36,
            color: Color(0XFF11D86F),
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            text!,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: 320,
          width: 300,
        ),
      ],
    );
  }
}