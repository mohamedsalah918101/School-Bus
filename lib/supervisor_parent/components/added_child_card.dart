import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'dart:math' as math;
import 'dialogs.dart';
import 'elevated_simple_button.dart';

class AddedChildCard extends StatelessWidget {
  const AddedChildCard({super.key, });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Container(
        // elevation: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color: Color(0xFF432B72),
            )
          ),
        child: Padding(
            padding: (
                sharedpref?.getString('lang') == 'ar')?
            EdgeInsets.only(top: 17.0, right: 12):
            EdgeInsets.only(top: 17.0, left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/Ellipse 1.png',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                           'Shady Ayman'.tr,
                           style: Theme.of(context).textTheme.headline6!.copyWith(
                             color: Color(0xFF432B72),
                             fontSize: 17,
                             fontFamily: 'Poppins-SemiBold',
                             fontWeight: FontWeight.w600,
                             height: 0.94,
                           ),
                         ),
                        const SizedBox(
                          height: 10,
                        ),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 2.0),
                           child: Row(
                             children: [
                               Image.asset('assets/images/call_icon.png',
                               width: 12,
                               height: 12,),
                               SizedBox(width: 5,),
                               Text(
                                 '0128061532'.tr,
                                 style: Theme.of(context).textTheme.headline6!.copyWith(
                                   color: Color(0xFF919191),
                                   fontSize: 12,
                                   fontFamily: 'PPoppins-Light',
                                   fontWeight: FontWeight.w400,
                                   height: 1.33,
                                 ),
                               ),
                             ],
                           ),
                         ),
                      ],
                    )
                  ],
                ),
              ],
            )
        ),

      ),
    );
  }

// _createRectTween(Rect begin, Rect end) {
//   return QuadraticOffsetTween(begin: begin, end: end);
// }
}

// class CustomRectTween extends RectTween {
//
//   final Rect begin;
//   final Rect end;
//
//   CustomRectTween({required this.begin,required this.end}) : super(begin: begin, end: end);
//
//   @override
//   Rect lerp(double t) {
//     double x = Curves.easeOutCirc.transform(t);
//
//     return Rect.fromLTRB  (
//       lerpDouble(begin.left, end.left, t),
//       lerpDouble(begin.left, end.left, t),
//       lerpDouble(begin.right, end.right, t) ,
//       lerpDouble(begin.right, end.right, t) ,
//     );
//   }
//
//   double lerpDouble(num begin, num end, double t) {
//     return begin + (end - begin) * t;
//   }
// }
