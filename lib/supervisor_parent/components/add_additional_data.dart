import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'dart:math' as math;
import 'dialogs.dart';
import 'elevated_simple_button.dart';

class AddAditionalData extends StatelessWidget {
  const AddAditionalData(int cardCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 500,
        child: Column(
          children: [
            Container(
                // elevation: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      width: 1,
                      color: Color(0xFF432B72),
                    )),
                child: Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.symmetric(vertical: 22, horizontal: 10.0):
                  EdgeInsets.all(22.0),
                  child:
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 180,
                            child: Padding(
                              padding: (sharedpref?.getString('lang') == 'ar')?
                              EdgeInsets.only(right: 45.0):
                              EdgeInsets.only(left: 50.0),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    child: CircleAvatar(
                                        radius: 46.5,
                                        backgroundColor: Color(0xff442B72),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/images/Ellipse 1.png",
                                          ),
                                          radius: 44.5,
                                        )),
                                  ),
                                  (sharedpref?.getString('lang') == 'ar')?
                                  Positioned(
                                    bottom: 2,
                                    left: 44,
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xff442B72),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset(
                                            'assets/images/image-editing 1.png',
                                          ),
                                        )),
                                  ):
                                  Positioned(
                                    bottom: 2,
                                    right: 40,
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xff442B72),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset(
                                            'assets/images/image-editing 1.png',
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Name'.tr,
                          style: TextStyle(
                            fontSize: 15,
                            // height:  0.94,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            color: Color(0xff442B72),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: (sharedpref?.getString('lang') == 'ar')
                              ? EdgeInsets.symmetric(horizontal: 0.0)
                              : EdgeInsets.symmetric(horizontal: 0.0),
                          child: SizedBox(
                            height: 38,
                            child: TextFormField(
                              cursorColor: const Color(0xFF442B72),
                              textDirection:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              scrollPadding: EdgeInsets.symmetric(vertical: 30),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                    (sharedpref?.getString('lang') == 'ar')
                                        ? EdgeInsets.fromLTRB(166, 0, 17, 40)
                                        : EdgeInsets.fromLTRB(17, 0, 166, 40),
                                hintText: 'Ahmed Atef'.tr,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                // enabledBorder: myInputBorder(),
                                // focusedBorder: myFocusBorder(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Number'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              // height:  0.94,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: (sharedpref?.getString('lang') == 'ar')
                              ? EdgeInsets.symmetric(horizontal: 0.0)
                              : EdgeInsets.symmetric(horizontal: 0.0),
                          child: SizedBox(
                            width: 322,
                            height: 38,
                            child: TextFormField(
                              cursorColor: const Color(0xFF442B72),
                              textDirection:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              scrollPadding: EdgeInsets.symmetric(vertical: 30),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                    (sharedpref?.getString('lang') == 'ar')
                                        ? EdgeInsets.fromLTRB(166, 0, 17, 40)
                                        : EdgeInsets.fromLTRB(17, 0, 166, 40),
                                hintText: '0128361532'.tr,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                // enabledBorder: myInputBorder(),
                                // focusedBorder: myFocusBorder(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Location'.tr,
                            style: TextStyle(
                              fontSize: 15,
                              // height:  0.94,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: (sharedpref?.getString('lang') == 'ar')
                              ? EdgeInsets.symmetric(horizontal: 0.0)
                              : EdgeInsets.symmetric(horizontal: 0.0),
                          child: SizedBox(
                            width: 322,
                            height: 37,
                            child: TextFormField(
                              cursorColor: const Color(0xFF442B72),
                              textDirection:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              scrollPadding:
                                  const EdgeInsets.symmetric(vertical: 30),
                              decoration: InputDecoration(
                                suffixIconColor: Color(0xFF442B72),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/images/locations.png',
                                  ),
                                ),
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                    (sharedpref?.getString('lang') == 'ar')
                                        ? EdgeInsets.fromLTRB(166, 0, 17, 40)
                                        : EdgeInsets.fromLTRB(17, 0, 166, 40),
                                hintText: '16 Khaled st , Asyut , Egypt'.tr,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                                // enabledBorder: myInputBorder(),
                                // focusedBorder: myFocusBorder(),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ]),
                )),
            // SizedBox(height: 25,),

          ],
        ));
  }

// _createRectTween(Rect begin, Rect end) {
//   return QuadraticOffsetTween(begin: begin, end: end);
// }
}
