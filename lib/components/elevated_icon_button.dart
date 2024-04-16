import 'package:flutter/material.dart';

class ElevatedIconButton extends StatelessWidget {
  String txt;
  double width, hight, txtSize;
  Function() onPress;
  Widget icon;
  Color color;
  Color txtColor;

  ElevatedIconButton(
      {super.key,
        required this.txt,
        required this.width,
        required this.hight,
        required this.onPress,
        required this.icon,
        required this.color,
        this.txtSize = 16,
        this.txtColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, hight),
            padding: const EdgeInsets.all(0),
            primary: color,
            onPrimary: Colors.transparent // Background color
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 3,
            ),
            Text(
              txt,
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
                color: txtColor,
                fontSize: txtSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ));
  }
}
