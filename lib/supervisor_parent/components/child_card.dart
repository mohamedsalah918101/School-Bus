import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/model/ParentModel.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../../Functions/functions.dart';
import 'elevated_simple_button.dart';

class ChildCard extends StatefulWidget {
  ParentModel? childrenData;
  ChildCard(this.childrenData, {super.key, });

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: widget.childrenData!.supervisors!.length > 1 ? media.height*.26 : media.height*.18,
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

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.asset(
                            'assets/images/Group 237679 (2).png',
                            height: 50,
                            width: 50,
                          ),
                        ),  const SizedBox(
                          width: 15,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.childrenData!.child_name!,
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
                              widget.childrenData!.class_name!,
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
                                    text: widget.childrenData!.bus_number!,
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
                            // Row(
                            //   children: [
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(50),
                            //         color: const Color(0xFF13DC64),
                            //         boxShadow: const [
                            //           BoxShadow(
                            //             color: Color(0xFF13DC64),
                            //             spreadRadius: 2,
                            //             blurRadius: 2,
                            //             // offset: Offset(0, 3), // changes position of shadow
                            //           ),
                            //         ],
                            //       ),
                            //       width: 5,
                            //       height: 5,
                            //     ),
                            //     const SizedBox(
                            //       width: 9,
                            //     ),
                            //     Text(
                            //       'Available Today'.tr,
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline6!
                            //           .copyWith(
                            //             color: Color(0xFF919191),
                            //             fontSize: 12,
                            //             fontFamily: 'Poppins-Light',
                            //             fontWeight: FontWeight.w400,
                            //             height: 1.33,
                            //           ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),

                      Align(
                        alignment:
                        (sharedpref?.getString('lang') == 'ar') ?
                        Alignment.topRight:
                        Alignment.topLeft ,
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
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
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
                ),
                widget.childrenData!.supervisors!.length == 1 ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        widget.childrenData!.supervisors![0].name!,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins-Poppins-Light',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff929292)
                        ),
                      ),
                    ),
                   Row(
                     children: [
                       InkWell(onTap: (){
                         makePhoneCall(  widget.childrenData!.supervisors![0].phone!);
                       },
                         child: Image.asset('assets/images/icons8_phone 1.png' ,
                         width: 28,
                         height: 28,),
                       ),  SizedBox(width: 7),
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

                  ],
                ): Padding(
                  padding: const EdgeInsets.only(right: 10.0,left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xff7269AD),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xff7269AD),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        // offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  width: 5,
                                  height: 5,
                                ),                        SizedBox(width: media.width * .02),
                                Text(
                                  widget.childrenData!.supervisors![0].name!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff929292)
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: media.height*0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(onTap: (){
                                makePhoneCall(  widget.childrenData!.supervisors![0].phone!);
                              },
                                child: Image.asset('assets/images/icons8_phone 1.png' ,
                                  width: 28,
                                  height: 28,),
                              ),
                              SizedBox(width: media.width*0.03),
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
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: media.height*.09,
                        child: VerticalDivider(
                          color: Color(0xff929292),
                          thickness: .6,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xff7269AD),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xff7269AD),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        // offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  width: 5,
                                  height: 5,
                                ),
                                SizedBox(width: media.width * .02),
                                Text(
                                  widget.childrenData!.supervisors![1].name!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff929292)
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: media.height*0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(onTap: (){
                                makePhoneCall(  widget.childrenData!.supervisors![1].phone!);
                              },
                                child: Image.asset('assets/images/icons8_phone 1.png' ,
                                  width: 28,
                                  height: 28,),
                              ),
                              SizedBox(width: media.width*0.03),
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
