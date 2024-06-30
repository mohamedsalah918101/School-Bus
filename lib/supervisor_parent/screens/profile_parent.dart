import 'dart:async';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/added_child_card.dart';

class ProfileParent extends StatefulWidget {
  @override
  _ProfileParentState createState() => _ProfileParentState();
}

class _ProfileParentState extends State<ProfileParent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<ChildDataItem> children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: ParentDrawer(),
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 12,
                offset: Offset(-1, 4),
                spreadRadius: 0,
              )
            ]),
            child: AppBar(
              toolbarHeight: 70,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.49),
                ),
              ),
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')?
              EdgeInsets.all( 23.0):
              EdgeInsets.all( 17.0),
                  child: Image.asset(
                    (sharedpref?.getString('lang') == 'ar')
                        ? 'assets/images/Layer 1.png'
                        : 'assets/images/fi-rr-angle-left.png',
                    width: 10,
                    height: 22,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xff442B72),
                      size: 35,
                    ),
                  ),
                ),
              ],
              title: Text(
                'Profile'.tr,
                style: const TextStyle(
                  color: Color(0xFF993D9A),
                  fontSize: 17,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              backgroundColor: Color(0xffF8F8F8),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        // Custom().customAppBar(context, 'Profile'.tr),
        body: SingleChildScrollView(
          child: 
              // children.isNotEmpty?
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: (sharedpref?.getString('lang') == 'ar') ?
                EdgeInsets.only(left: 23.0):
                EdgeInsets.only(right: 23.0),
                child: Align(
                  alignment: (sharedpref?.getString('lang') == 'ar') ?
                  Alignment.topLeft:
                  Alignment.topRight,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileParent()),
                          );
                        });
                      },
                      child: SizedBox(
                        width: 70,
                        height: 27,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFF432B72),
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                (sharedpref?.getString('lang') == 'ar')
                                    ? 'assets/images/edittt_white_translate.png'
                                    : 'assets/images/edittt_white.png',
                              width: 13.45,
                              height: 13.45,),
                              SizedBox(width: 7,),
                              Text('Edit'.tr,
                              style: TextStyle(
                                color: Color(0xff442B72),
                                fontSize: 16,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              Padding(
                padding:
                (sharedpref?.getString('lang') == 'ar') ?
                EdgeInsets.symmetric(horizontal: 25.0):
                EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: Padding(
                          padding:  (sharedpref?.getString('lang') == 'ar') ?
                          EdgeInsets.only(right: 50.0):
                          EdgeInsets.only(left: 50.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                    radius: 52.5,
                                    backgroundColor: Color(0xff442B72),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage("assets/images/Ellipse 1.png" ,
                                      ),
                                      radius: 50.5,)
                                ),
                              ),
                              (sharedpref?.getString('lang') == 'ar') ?
                              Positioned(
                                bottom: 2,
                                left: 48,
                                child:  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff442B72),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0),),),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(
                                        'assets/images/image-editing 1.png' ,),
                                    )
                                ),
                              ):
                              Positioned(
                                bottom: 2,
                                right: 48,
                                child:  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff442B72),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0),),),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(
                                        'assets/images/image-editing 1.png' ,),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: (sharedpref?.getString('lang') == 'ar') ?
                        EdgeInsets.only(right: 0.0):
                        EdgeInsets.only(left: 25.0),
                        child: Text('Rania Ahmed'.tr
                          , style: TextStyle(
                            fontSize: 20 ,
                            // height:  0.94,
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w600 ,
                            color: Color(0xff442B72),),),
                      ),
                    ) ,
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/call_icon.png',
                          width: 12,
                          height: 12,),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text('Number'.tr
                                , style: TextStyle(
                                  fontSize: 17 ,
                                  // height:  0.94,
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w600 ,
                                  color: Color(0xff442B72),),),
                            ],
                          ),
                        ],
                      ),
                    ) ,
                    Padding(
                      padding: (sharedpref?.getString('lang') == 'ar') ?
                      EdgeInsets.only(right: 23.0):
                      EdgeInsets.only(left: 48.0),
                      child: Text('0128061532'.tr
                        , style: TextStyle(
                          fontSize: 12 ,
                          // height:  0.94,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400 ,
                          color: Color(0xff442B72),),),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/locations.png',
                            width: 15,
                            height: 15,),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text('Location'.tr
                                , style: TextStyle(
                                  fontSize: 17 ,
                                  // height:  0.94,
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w600 ,
                                  color: Color(0xff442B72),),),
                            ],
                          ),
                        ],
                      ),
                    ) ,
                    Padding(
                      padding: (sharedpref?.getString('lang') == 'ar') ?
                      EdgeInsets.only(right: 20.0):
                      EdgeInsets.only(left: 48.0),
                      child: Text('16 Khaled st , Asyut , Egypt'.tr
                        , style: TextStyle(
                          fontSize: 12 ,
                          // height:  0.94,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400 ,
                          color: Color(0xff442B72),),),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Additional Data'.tr,
                        style: TextStyle(
                          color: Color(0xFF771F98),
                          fontSize: 19,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: (sharedpref?.getString('lang') == 'ar') ?
                      EdgeInsets.symmetric(horizontal: 0.0):
                      EdgeInsets.symmetric(horizontal: 25.0),
                      child: AddedChildCard(),
                    ),

                    const SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ],
          )
              //     :
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(height: 25,),
              //     Center(
              //       child: Image.asset('assets/images/Group 237679.png',
              //         width: 97,
              //         height: 97,),
              //     ),
              //     SizedBox(height: 10,),
              //     Center(
              //       child: Text('Atef Latif',
              //         style: TextStyle(
              //             color: Color(0xff442B72),
              //             fontSize: 20,
              //             fontFamily: 'Poppins-SemiBold',
              //             fontWeight: FontWeight.w600
              //         ),),
              //     ),
              //     SizedBox(height: 30,),
              //     Padding(
              //       padding: (sharedpref?.getString('lang') == 'ar')?
              //         EdgeInsets.only(right: 25.0):
              //         EdgeInsets.only(left: 25.0),
              //       child: Row(
              //         children: [
              //           Image.asset('assets/images/call_icon.png',
              //             width: 12,
              //             height: 12,),
              //           SizedBox(width: 10,),
              //           Column(
              //             children: [
              //               Text('Number'.tr
              //                 , style: TextStyle(
              //                   fontSize: 17 ,
              //                   // height:  0.94,
              //                   fontFamily: 'Poppins-SemiBold',
              //                   fontWeight: FontWeight.w600 ,
              //                   color: Color(0xff442B72),),),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ) ,
              //     Padding(
              //       padding: (sharedpref?.getString('lang') == 'ar')?
              //       EdgeInsets.only(right: 47.0):
              //       EdgeInsets.only(left: 47.0),
              //       child: Text('0128361532',
              //         style: TextStyle(
              //             color: Color(0xff442B72),
              //             fontSize: 12,
              //             fontFamily: 'Poppins-Light',
              //             fontWeight: FontWeight.w400
              //         ),
              //       ),
              //     )
              //   ],
              // )


        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Color(0xff442B72),
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ProfileParent(
            //       // onTapMenu: onTapMenu
            //     )));
          },
          child: Image.asset(
            'assets/images/174237 1.png',
            height: 33,
            width: 33,
            fit: BoxFit.cover,
          ),
        ),
        bottomNavigationBar: Directionality(
            textDirection: Get.locale == Locale('ar')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomAppBar(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    height: 60,
                    color: const Color(0xFF442B72),
                    clipBehavior: Clip.antiAlias,
                    shape: const AutomaticNotchedShape(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38.5),
                                topRight: Radius.circular(38.5))),
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50)))),
                    notchMargin: 7,
                    child: SizedBox(
                        height: 10,
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 7, right: 15)
                                          : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
                                      SizedBox(height: 3),
                                      Text(
                                        "Home".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 7, left: 70)
                                          : EdgeInsets.only(right: 70),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 16.56,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
                                      SizedBox(height: 2),
                                      Text(
                                        "Notifications".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 12, bottom: 4, right: 10)
                                          : EdgeInsets.only(
                                              top: 10, bottom: 4, left: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (3).png',
                                          height: 18.75,
                                          width: 18.75),
                                      SizedBox(height: 3),
                                      Text(
                                        "Calendar".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TrackParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              right: 12,
                                              left: 15)
                                          : EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              left: 12,
                                              right: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
                                      SizedBox(height: 3),
                                      Text(
                                        "Track".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))))));
  }
}
