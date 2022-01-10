import 'package:flutter/material.dart';
import 'package:ride_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonTitle;
  final bool outlineButton;
  BottomButton({required this.onTap, required this.buttonTitle, required this.outlineButton});
  @override
  Widget build(BuildContext context) {
    bool _outlineButton = outlineButton ? true : false;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlineButton ? Colors.transparent : Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 2.0
          ),
          borderRadius: BorderRadius.circular(12.0)
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24.0,
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: _outlineButton ? Colors.black : Colors.white,
              fontFamily: "Brand Bold",
          ),
        ),
      ),
    );
  }
}

toastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}