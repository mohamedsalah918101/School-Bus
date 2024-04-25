import 'package:flutter/material.dart';

class ElevatedSimpleButton extends StatelessWidget {
  String txt;
  double width, hight;
  Function() onPress;
  Color color;
  Color txtColor;
  double fontSize;


  ElevatedSimpleButton({
    super.key,
    required this.txt,
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
            padding: const EdgeInsets.all(0),
            // primary: color,
            // onPrimary: Colors.transparent, // Background color
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Color(0xFF442B72)),


            )
        ),
        child: Text(
          txt,
          style:  TextStyle(
              color: txtColor,
              fontSize: fontSize,height: 1.23,fontFamily: 'Poppins-Medium',
              fontWeight: FontWeight.w500),
        ));
  }
}
