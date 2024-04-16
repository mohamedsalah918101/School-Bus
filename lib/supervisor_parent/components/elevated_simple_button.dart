import 'package:flutter/material.dart';

class ElevatedSimpleButton extends StatelessWidget {
  String txt;
  // Widget fontWeight;
  String fontFamily;
  double width, hight;
  Function() onPress;
  Color color;
  Color txtColor;
  double fontSize;


  ElevatedSimpleButton({
    super.key,
    required this.txt,
    required this.fontFamily,
    // required this.fontWeight,
    required this.width,
    required this.hight,
    required this.onPress,
    required this.color,
    this.txtColor=Colors.white,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, hight),
            padding:  EdgeInsets.all(0),
            primary: color,
            surfaceTintColor: Colors.transparent,
            onPrimary: Colors.transparent, // Background color
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        )
            ),
        child: Text(
          txt,
          style:  TextStyle(
              color: txtColor,
              fontSize: fontSize,height: 1.23,
              // fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.w600
          ),
        ));
  }
}
