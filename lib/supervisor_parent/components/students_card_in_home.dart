import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class StudentsCardInHome extends StatefulWidget {
  StudentsCardInHome({super.key, });

  @override
  State<StudentsCardInHome> createState() => _StudentsCardInHomeState();
}

class _StudentsCardInHomeState extends State<StudentsCardInHome> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:  92,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: (sharedpref?.getString('lang') == 'ar')?
          EdgeInsets.only(top: 15.0 , right: 12,):
          EdgeInsets.only(top: 15.0 , left: 12,),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset('assets/images/Ellipse 1.png',
                  width: 36,
                  height: 36,),
              ),
              SizedBox(width: 12,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shady Ayman',
                    style: TextStyle(
                      color: Color(0xff442B72),
                      fontSize: 15,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      // height: 1,
                    ),),
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
                            // height: 1.33,
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
              )
            ],
          ),),

      ),
    );
  }
}
