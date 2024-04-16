import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:school_account/main.dart';

class TextFormFieldCustom extends StatelessWidget {
  String hintTxt;
  double width;
   TextFormFieldCustom({super.key,required this.hintTxt,required this.width, required TextInputType keyboardType,  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,height: 65,
        padding: const EdgeInsets.symmetric(
            vertical: 11),
        child:
        TextFormField(
          autofocus: true,
          textInputAction: TextInputAction.next,
          cursorColor:  Color(0xFF442B72),
          textDirection: (sharedpref?.getString('lang') == 'ar') ?
          TextDirection.rtl:
          TextDirection.ltr,
          textAlign:  (sharedpref?.getString('lang') == 'ar') ?
          TextAlign.right :
          TextAlign.left ,
          scrollPadding:  EdgeInsets.symmetric(
              vertical: 30),
          decoration:  InputDecoration(
            alignLabelWithHint: true,
            counterText: "",
            fillColor:  Color(0xFFF1F1F1),
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(
                8, 5, 10, 5),
            hintText:hintTxt,
            floatingLabelBehavior:  FloatingLabelBehavior.never,
            hintStyle: const TextStyle(
              color: Color(0xFFC2C2C2),
              fontSize: 12,
              fontFamily: 'Poppins-Bold',
              fontWeight: FontWeight.w700,
              height: 1.33,
            ),
            enabledBorder: myInputBorder(),
            focusedBorder: myFocusBorder(),
          ),
        ));

  }
  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
          width: 0.8,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

}
