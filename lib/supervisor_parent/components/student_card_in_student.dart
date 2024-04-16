import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class StudentCardInStudent extends StatefulWidget {
  StudentCardInStudent({super.key, });

  @override
  State<StudentCardInStudent> createState() => _StudentCardInStudentState();
}

class _StudentCardInStudentState extends State<StudentCardInStudent> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:  92,
      child: Card(
        elevation: 10,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')?
            EdgeInsets.only(right: 10.0 , bottom: 0):
            EdgeInsets.only(left: 10.0 , bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/Ellipse 6.png',
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
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(
                            'Shady Ayman',
                            style: TextStyle(
                              color: Color(0xff442B72),
                              fontSize: 17,
                              fontFamily: 'Poppins-SemiBold',
                              fontWeight: FontWeight.w600,
                              height: 0.94,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Grade: '.tr,
                                style: TextStyle(
                                  color: Color(0xFF919191),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  // height: 1.33,
                                ),
                              ),
                              TextSpan(
                                text: '4',
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
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Address: '.tr,
                                style: TextStyle(
                                  color: Color(0xFF919191),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                              TextSpan(
                                text: '16 Khaled st,Asyut,Egypt',
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

                  ],
                ),
              ],
            )),
      ),
    );
  }
}
