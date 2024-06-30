import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/edit_children.dart';
import 'elevated_simple_button.dart';

class CalendarCard extends StatefulWidget {
  CalendarCard({super.key, });
  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  bool takeBus = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 89,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding:  (sharedpref?.getString('lang') == 'ar')?
            EdgeInsets.only(top: 10.0 , right: 12,):
            EdgeInsets.only(top: 10.0 , left: 12,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Image.asset(
                    'assets/images/Ellipse 1.png',
                    height: 50,
                    width: 50,
                  ),
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
                    SizedBox(height: 5,),
                    Text(
                      'Class: 1A'.tr,
                      style:
                      Theme.of(context).textTheme.headline6!.copyWith(
                        color: Color(0xFF919191),
                        fontSize: 12,
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Today’s Bus : '.tr,
                            style: TextStyle(
                              color: Color(0xFF919191),
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                          TextSpan(
                            text: ' 1458 ى ر س',
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 12,
                              fontFamily: 'Poppins-Light',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:  (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.only(top: 10, right: 50):
                  EdgeInsets.only(top: 10, left: 30),
                  child: Stack(
                    children: [
                      Image.asset('assets/images/circle_pink.png',
                        height: 37,
                        width: 37,),
                      Positioned(
                        top: 2,
                        left: 1,
                          child: Image.asset('assets/images/iconamoon_arrow-up-2-thin.png',
                          width: 34,
                          height: 34,))
                    ],
                  ),
                )
              ],
            )),

      ),
    );
  }
}
