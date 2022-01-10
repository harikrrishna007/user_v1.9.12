import 'package:flutter/material.dart';
import 'package:ride_app/constants.dart';

class InputField extends StatelessWidget {
  final String inputHint;
  final TextInputType keyboardType;
  final TextEditingController textFieldContoller;
  InputField({required this.inputHint, required this.keyboardType, required this.textFieldContoller});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: textFieldContoller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: inputHint,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
        ),
        style: Constants.kInputText,
      ),
    );
  }
}
