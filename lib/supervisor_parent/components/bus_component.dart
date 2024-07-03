import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';

import '../../main.dart';
import 'elevated_icon_button.dart';

class BusComponent extends StatelessWidget {
   const BusComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // List<ChildDataItem> children = [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/bus-school 1.png',
          width: 83,
          height: 75,
        ),
          // children.isNotEmpty?
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( sharedpref!.getInt('invit') == 1 ? ' '.tr:'',
              style: TextStyle(
                color: Color(0xff442B72),
                  fontSize: 12 ,
                  fontFamily: 'Poppins-SemiBold' ,
                  fontWeight: FontWeight.w600,
                  height: 1.04
              ),
            ),
            SizedBox(height: 7,),
            RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 26 ,
                    fontFamily: 'Poppins-SemiBold' ,
                    fontWeight: FontWeight.w700,
                    height: 1.04
                  ),
                  children: [
                    TextSpan(
                        text: '15',
                        style: TextStyle(
                            color: Color(0xFF993D9A)
                        )
                    ),
                    TextSpan(
                      text: 'Min'.tr,
                      style: TextStyle(
                        color: Color(0xFF993D9A)
                      )
                    ),
                    TextSpan(
                      text: '.'.tr,
                      style: TextStyle(
                        color: Color(0xFFFEDF96)
                      )
                    )
                  ]
                )),
            RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 17,
                    height: 0
                  ),
                  children: [
                    TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color(0xFF442B72),
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w300,
                        )
                    ),
                    TextSpan(
                        text: ' '.tr,
                        style: TextStyle(
                          color: Color(0xFF442B72),
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w300,
                        )
                    ),
                    TextSpan(
                        text: '.'.tr,
                        style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFEDF96)
                        )
                    )
                  ]
                ),

            ),
          ],
        ),
          //     :
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 30.0),
          //   child: RichText(
          //       text: TextSpan(
          //           style: TextStyle(
          //               fontSize: 26 ,
          //               fontFamily: 'Poppins-SemiBold' ,
          //               fontWeight: FontWeight.w700,
          //               height: 1.04
          //           ),
          //           children: [
          //             TextSpan(
          //                 text: '0 ',
          //                 style: TextStyle(
          //                     color: Color(0xFF993D9A)
          //                 )
          //             ),
          //             TextSpan(
          //                 text: 'Min'.tr,
          //                 style: TextStyle(
          //                     color: Color(0xFF993D9A)
          //                 )
          //             ),
          //             TextSpan(
          //                 text: '.',
          //                 style: TextStyle(
          //                     color: Color(0xFFFEDF96)
          //                 )
          //             )
          //           ]
          //       )),
          // ),
        Spacer(),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedIconButton(
            icon: Row(
              children: [
                Image.asset(
                  'assets/images/fi-rr-location-alt.png',
                  width: 12,
                  height: 12,
                ),
                SizedBox(width: 5),
              ],
            ),
            txt: 'Track Bus'.tr,
            width: 104,
            hight: 40,
            onPress: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>
                      TrackParent()));},
            txtSize: 13,
            color: const Color(0xFF993D9A),
          ),
        )
      ],
    );
  }
}
