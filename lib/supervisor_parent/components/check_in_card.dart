import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class CheckInCard extends StatefulWidget {
  CheckInCard({super.key, });

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard> {
 bool Checkin = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:122,
      child: Card(
        elevation: 10,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')?
            EdgeInsets.only(right: 10.0 , top: 15) :
            EdgeInsets.only(left: 10.0 , top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shady Ayman'.tr,
                            style: TextStyle(
                              color: Color(0xff442B72),
                              fontSize: 17,
                              fontFamily: 'Poppins-SemiBold',
                              fontWeight: FontWeight.w600,
                              height: 0.94,
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
                                    // height: 1.33,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 27,),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        width: 80,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:  EdgeInsets.all(0),
                              backgroundColor: Color(0xFF442B72),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              )
                          ),
                          onPressed: (){
                            Checkin = !Checkin;
                            setState(() {
                            });
                          },
                          child: Text( Checkin? 'Check out'.tr : 'Check in'.tr,
                            style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 13
                            ),),


                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.only(top: 12, right:220 ):
                  EdgeInsets.only(top: 12, left:220 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/icons8_phone 1 (1).png' ,
                        color: Color(0xff442B72),
                        width: 28,
                        height: 28,),
                      SizedBox(width: 9),
                      GestureDetector(
                        child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
                          color: Color(0xff442B72),
                          width: 26,
                          height: 26,),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  ChatScreen()));
                        },
                      ),
                    ],
                  ),
                ),

              ],
            )),
      ),
    );
  }
}
