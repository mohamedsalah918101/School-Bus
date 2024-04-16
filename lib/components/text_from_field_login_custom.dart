 import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFormFieldCustom extends StatelessWidget {
  String hintTxt;
  double width;
  TextFormFieldCustom({super.key,required this.hintTxt,required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,height: 75,
        padding: const EdgeInsets.symmetric(
            vertical: 15),
        child: TextFormField(

          style: TextStyle(color: Color(0xFF442B72)),
          cursorColor: const Color(0xFF442B72),
          textDirection: TextDirection.ltr,
          scrollPadding: const EdgeInsets.symmetric(
              vertical: 40),
          decoration:  InputDecoration(
            alignLabelWithHint: true,
            counterText: "",
            fillColor: const Color(0xFFF1F1F1),
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(
                8, 30, 10, 5),
            hintText:hintTxt,
            floatingLabelBehavior:  FloatingLabelBehavior.never,
            hintStyle: const TextStyle(
              color: Color(0xFFC2C2C2),
              fontSize: 12,
              fontFamily: 'Inter-Bold',
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
          width: 0.5,
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

//black box
//  class TextFormFieldCustom extends StatelessWidget {
//    final String hintTxt;
//    final double width;
//    final bool isDropdown;
//
//    const TextFormFieldCustom({
//      Key? key,
//      required this.hintTxt,
//      required this.width,
//      this.isDropdown = false,
//    }) : super(key: key);
//
//    @override
//    Widget build(BuildContext context) {
//      return Container(
//        width: width,
//        height: 50, // Adjust height as needed
//        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(10.0),
//          border: Border.all(
//            color: const Color(0xFFD9D9D9),
//            width: 1.0,
//          ),
//          color: Colors.white,
//        ),
//        child: isDropdown
//            ? DropdownButtonHideUnderline(
//          child: DropdownButton<String>(
//            isExpanded: true,
//            hint: Text(
//              hintTxt,
//              style: const TextStyle(
//                color: Color(0xFFB2B2B2),
//                fontSize: 14,
//                fontWeight: FontWeight.w400,
//                height: 1.43,
//              ),
//            ),
//            onChanged: (String? newValue) {},
//            items: [
//              DropdownMenuItem<String>(
//                value: 'School account',
//                child: Text('School account'.tr),
//              ),
//              DropdownMenuItem<String>(
//                value: 'Supervisor',
//                child: Text('Supervisor'.tr),
//              ),
//              DropdownMenuItem<String>(
//                value: 'Parents',
//                child: Text('Parents'.tr),
//              ),
//            ],
//          ),
//        )
//            : TextFormField(
//          cursorColor: const Color(0xFF442B72),
//          textDirection: TextDirection.ltr,
//          scrollPadding: const EdgeInsets.symmetric(vertical: 40),
//          decoration: InputDecoration(
//            alignLabelWithHint: true,
//            counterText: "",
//            fillColor: Colors.white,
//            filled: true,
//            contentPadding: const EdgeInsets.fromLTRB(12, 16, 10, 5),
//            hintText: hintTxt,
//            floatingLabelBehavior: FloatingLabelBehavior.never,
//            hintStyle: const TextStyle(
//              color: Color(0xFFB2B2B2),
//              fontSize: 14,
//              fontWeight: FontWeight.w400,
//              height: 1.43,
//            ),
//            enabledBorder: myInputBorder(),
//            focusedBorder: myFocusBorder(),
//          ),
//        ),
//      );
//    }
//
//    OutlineInputBorder myInputBorder() {
//      return OutlineInputBorder(
//        borderRadius: BorderRadius.circular(10),
//        borderSide: const BorderSide(
//          color: Color(0xFFD9D9D9),
//          width: 1.0,
//        ),
//      );
//    }
//
//    OutlineInputBorder myFocusBorder() {
//      return OutlineInputBorder(
//        borderRadius: BorderRadius.circular(10),
//        borderSide: const BorderSide(
//          color: Color(0xFF442B72),
//          width: 1.5,
//        ),
//      );
//    }
//  }
//chat gpt
//  class TextFormFieldCustom extends StatelessWidget {
//    final String hintTxt;
//    final double width;
//    final bool isDropdown;
//
//    const TextFormFieldCustom({
//      Key? key,
//      required this.hintTxt,
//      required this.width,
//      this.isDropdown = false,
//    }) : super(key: key);
//
//    @override
//    Widget build(BuildContext context) {
//      return Container(
//        width: width,
//        height: 75, // Adjust height as needed
//        padding: const EdgeInsets.symmetric(vertical: 15),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(7.0),
//          border: Border.all(
//            color: const Color(0xFFFFC53E),
//            width: 0.5,
//          ),
//          color: const Color(0xFFF1F1F1),
//        ),
//        child: isDropdown
//            ? DropdownButtonHideUnderline(
//          child: DropdownButton<String>(
//            isExpanded: true,
//            hint: Text(
//              hintTxt,
//              style: const TextStyle(
//                color: Color(0xFFC2C2C2),
//                fontSize: 12,
//                fontFamily: 'Inter-Bold',
//                fontWeight: FontWeight.w700,
//                height: 1.33,
//              ),
//            ),
//            onChanged: (String? newValue) {},
//            items: [
//              DropdownMenuItem<String>(
//                value: 'School account',
//                child: Text('School account'.tr),
//              ),
//              DropdownMenuItem<String>(
//                value: 'Supervisor',
//                child: Text('Supervisor'.tr),
//              ),
//              DropdownMenuItem<String>(
//                value: 'Parents',
//                child: Text('Parents'.tr),
//              ),
//            ],
//          ),
//        )
//            : TextFormField(
//          cursorColor: const Color(0xFF442B72),
//          textDirection: TextDirection.ltr,
//          scrollPadding: const EdgeInsets.symmetric(vertical: 40),
//          decoration: InputDecoration(
//            alignLabelWithHint: true,
//            counterText: "",
//            fillColor: const Color(0xFFF1F1F1),
//            filled: true,
//            contentPadding: const EdgeInsets.fromLTRB(8, 30, 10, 5),
//            hintText: hintTxt,
//            floatingLabelBehavior: FloatingLabelBehavior.never,
//            hintStyle: const TextStyle(
//              color: Color(0xFFC2C2C2),
//              fontSize: 12,
//              fontFamily: 'Inter-Bold',
//              fontWeight: FontWeight.w700,
//              height: 1.33,
//            ),
//            enabledBorder: myInputBorder(),
//            focusedBorder: myFocusBorder(),
//          ),
//        ),
//      );
//    }
//
//    OutlineInputBorder myInputBorder() {
//      return const OutlineInputBorder(
//        borderRadius: BorderRadius.all(Radius.circular(7)),
//        borderSide: BorderSide(
//          color: Color(0xFFFFC53E),
//          width: 0.5,
//        ),
//      );
//    }
//
//    OutlineInputBorder myFocusBorder() {
//      return const OutlineInputBorder(
//        borderRadius: BorderRadius.all(Radius.circular(7)),
//        borderSide: BorderSide(
//          color: Color(0xFFFFC53E),
//          width: 0.5,
//        ),
//      );
//    }
//  }
