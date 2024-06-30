import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'dart:math' as math;
import 'dialogs.dart';
import 'elevated_simple_button.dart';

class AddChildrenCardEdit extends StatefulWidget {
  // final int cardCount;

  // const AddChildrenCardEdit({
  //   super.key,
  //   // required this.cardCount,
  // });

  @override
  State<AddChildrenCardEdit> createState() => _AddChildrenCardEditState();
}

class _AddChildrenCardEditState extends State<AddChildrenCardEdit> {
  bool isFemale = false;
  bool isMale = false;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: double.infinity,
        height: 300,
        child: Column(
          children: [
            Container(
              // elevation: 8,
                decoration: BoxDecoration(
                  color: Color(0xff771F98).withOpacity(0.03),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: (sharedpref?.getString('lang') == 'ar')?
                        EdgeInsets.only(right: 12.0):
                        EdgeInsets.only(left: 12.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Child'.tr,
                                style: TextStyle(
                                  color: Color(0xff771F98),
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' 1',
                                style: TextStyle(
                                  color: Color(0xff771F98),
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) ,
                      SizedBox(height: 8,),
                      Padding(
                        padding: (sharedpref?.getString('lang') == 'ar')?
                        EdgeInsets.only(right: 18.0):
                        EdgeInsets.only(left: 18.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Name'.tr,
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                  height: 1.07,
                                ),
                              ),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                  height: 1.07,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) ,
                      SizedBox(height: 8,),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18.0),
                        child: SizedBox(
                          width: 277,
                          height: 38,
                          child: TextFormField(
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                            cursorColor: const Color(0xFF442B72),
                            textDirection: (sharedpref?.getString('lang') == 'ar') ?
                            TextDirection.rtl:
                            TextDirection.ltr,
                            scrollPadding:  EdgeInsets.symmetric(
                                vertical: 30),
                            decoration:  InputDecoration(
                              alignLabelWithHint: true,
                              counterText: "",
                              fillColor: const Color(0xFFF1F1F1),
                              filled: true,
                              contentPadding:
                              (sharedpref?.getString('lang') == 'ar') ?
                              EdgeInsets.fromLTRB(0, 0, 17, 20):
                              EdgeInsets.fromLTRB(17, 0, 0, 10),
                              hintText:'Mariam Atef'.tr,
                              floatingLabelBehavior:  FloatingLabelBehavior.never,
                              hintStyle: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 12,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.33,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFC53E),
                                  width: 0.5,
                                ),),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFC53E),
                                  width: 0.5,
                                ),
                              ),
                              // enabledBorder: myInputBorder(),
                              // focusedBorder: myFocusBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12,),
                      Padding(
                        padding: (sharedpref?.getString('lang') == 'ar')?
                        EdgeInsets.only(right: 18.0):
                        EdgeInsets.only(left: 18.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Grade'.tr,
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                  height: 1.07,
                                ),
                              ),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                  height: 1.07,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) ,
                      SizedBox(height: 8,),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 18.0),
                        child: SizedBox(
                          width: 277,
                          height: 38,
                          child: TextFormField(
                            style: TextStyle(color: Color(0xFF442B72),
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              fontWeight: FontWeight.w400,
                              height: 1.33, ),
                            cursorColor: const Color(0xFF442B72),
                            textDirection: (sharedpref?.getString('lang') == 'ar') ?
                            TextDirection.rtl:
                            TextDirection.ltr,
                            scrollPadding:  EdgeInsets.symmetric(
                                vertical: 30),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration:  InputDecoration(
                              alignLabelWithHint: true,
                              counterText: "",
                              fillColor: const Color(0xFFF1F1F1),
                              filled: true,
                              contentPadding:
                              (sharedpref?.getString('lang') == 'ar') ?
                              EdgeInsets.fromLTRB(0, 0, 17, 15):
                              EdgeInsets.fromLTRB(17, 0, 0, 10),
                              hintText:'4'.tr,
                              floatingLabelBehavior:  FloatingLabelBehavior.never,
                              hintStyle: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 12,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.33,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFC53E),
                                  width: 0.5,
                                ),),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFC53E),
                                  width: 0.5,
                                ),
                              ),
                              // enabledBorder: myInputBorder(),
                              // focusedBorder: myFocusBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12,),
                      Padding(
                          padding: (sharedpref?.getString('lang') == 'ar')?
                          EdgeInsets.only(right: 18.0):
                          EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Gender'.tr,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 15,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 1.07,
                            ),)
                      ) ,
                      // SizedBox(height: 12,),
                      Padding(
                        padding: (sharedpref?.getString('lang') == 'ar') ?
                        EdgeInsets.only(right: 15.0):
                        EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: isFemale,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    isFemale = value;
                                    isMale = !value;
                                  });
                                }
                              },
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Color(0xff442B72);
                                }
                                return Color(0xff442B72);
                              }),
                              activeColor: Color(0xff442B72), // Set the color of the selected radio button
                            ),
                            Text(
                              "Female".tr ,
                              style: TextStyle(
                                fontSize: 15 ,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w500 ,
                                color: Color(0xff442B72),),
                            ),
                            SizedBox(
                              width: 50, //115
                            ),
                            Radio(
                              fillColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Color(0xff442B72);
                                }
                                return Color(0xff442B72);
                              }),
                              value: true,
                              groupValue: isMale,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  setState(() {
                                    isFemale = !value;
                                    isMale = value;
                                  });
                                }
                              },
                              activeColor: Color(0xff442B72), // Set the color of the selected radio button
                            ),
                            Text("Male".tr,
                              style: TextStyle(
                                fontSize: 15 ,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w500 ,
                                color: Color(0xff442B72),),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,)


                    ])),
          ],
        ));
  }

// _createRectTween(Rect begin, Rect end) {
//   return QuadraticOffsetTween(begin: begin, end: end);
// }
}
