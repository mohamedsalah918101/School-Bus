import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class ChildCard extends StatefulWidget {
  ChildCard({super.key, });

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 147,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: const EdgeInsets.only(top: 12.0 , left: 12, right: 7 , bottom: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Mariam Tarek'.tr,
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Color(0xFF432B72),
                              fontSize: 15,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 0.94,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
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
                          height: 0,
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
                                text: '1458 ى ر س',
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
                        const SizedBox(
                          height: 0,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFF13DC64),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF13DC64),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    // offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: 5,
                              height: 5,
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Text(
                              'Available Today'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Color(0xFF919191),
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                      Align(
                        alignment:
                        (sharedpref?.getString('lang') == 'ar') ?
                        Alignment.bottomLeft :
                        Alignment.bottomRight ,
                        child: ElevatedSimpleButton(
                          txt: 'Take Bus'.tr,
                          width: 86,
                          hight: 40,
                          onPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => HomeParentTakeBus(
                                              )));
                            setState(() {});
                          },
                          txtColor: const Color(0xFF442B72),
                          color: const Color(0xFFFEDF96),
                          fontSize: 14,
                          fontFamily: 'Poppins-Bold',
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 5
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 9.0, vertical: 2),
                      child: Text(
                        'Supervisor'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins-SemiBold',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff7269AD)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        'Sara Essam'.tr,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins-Poppins-Light',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff929292)
                        ),
                      ),
                    ),
                   Spacer(),
                   Image.asset('assets/images/icons8_phone 1.png' ,
                   width: 28,
                   height: 28,),
                    SizedBox(width: 7),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  ChatScreen()));},
                        child: Image.asset('assets/images/icons8_chat 1.png' ,
                          width: 26,
                          height: 26,),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                // Spacer(),


              ],
            )),

      ),
    );
  }
}
