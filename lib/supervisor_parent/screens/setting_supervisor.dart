import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';

import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../controller/local_controller.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_switch.dart';
import '../components/dialogs.dart';
import '../components/elevated_icon_button.dart';

class SettingsSupervisor extends StatefulWidget {
  @override
  _SettingsSupervisorState createState() => _SettingsSupervisorState();
}

class _SettingsSupervisorState extends State<SettingsSupervisor> {
  List<ChildDataItem> children = [];
  bool tracking = true;
  bool isExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyLocalController ControllerLang = Get.find();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color:  Color(0x3F000000),
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
                onTap: () => Navigator.of(context).pop(),
                // pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (context) => MainBottomNavigationBar(pageNum: 0)),
                //         (Route<dynamic> route) => false),
                child:  Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 23,
                  color: Color(0xff442B72),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                  GestureDetector(
                    onTap: (){
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
              title: Text('Settings'.tr ,
                style: const TextStyle(
                  color: Color(0xFF993D9A),
                  fontSize: 17,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),),
              backgroundColor:  Color(0xffF8F8F8),
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'General'.tr,
                  style: TextStyle(
                    color: Color(0xFF442B72),
                    fontSize: 18,
                    fontFamily: 'Poppins-SemiBold',
                    fontWeight: FontWeight.w600,
                    height: 0.89,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title:  Text(
                  'Notifications'.tr,
                  style: TextStyle(
                    color: Color(0xFF771F98),
                    fontSize: 15,
                    fontFamily: 'Poppins-SemiBold',
                    fontWeight: FontWeight.w600,
                    height: 1.07,
                  ),
                ),
                trailing: CustomSwitch(),
              ),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title:  Text(
                    'Language'.tr,
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      height: 1.54,
                    ),
                  ),
                  trailing: Icon(
                    sharedpref?.getString('lang') == 'ar' ?
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_left
                        :
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Color(0xffC8C8C8),
                    size: 24,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() => isExpanded = expanded);
                  },
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            'assets/images/icons8_egypt 1.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            'عربي',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 15,
                              fontFamily: 'Cairo-Regular',
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        ControllerLang.ChangeLang('ar');
                      },
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.47,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0x14091C3F),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            'assets/images/icons8_usa_1 1.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            'English',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 15,
                              fontFamily: 'Cairo-Regular',
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        ControllerLang.ChangeLang('en');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFFFC53D),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                child: Text(
                  'Advanced'.tr,
                  style: TextStyle(
                    color: Color(0xFF442B72),
                    fontSize: 18,
                    fontFamily: 'Poppins-SemiBold',
                    fontWeight: FontWeight.w600,
                    height: 0.89,
                  ),
                ),
              ),
              ListTile(
                title:  Text(
                  'Fingerprint and Face ID'.tr,
                  style: TextStyle(
                    color: Color(0xFF771F98),
                    fontSize: 15,
                    fontFamily: 'Poppins-SemiBold',
                    fontWeight: FontWeight.w600,
                    height: 1.07,
                  ),
                ),
                trailing: CustomSwitch(),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title:  Text(
                  'Alarm'.tr,
                  style: TextStyle(
                    color: Color(0xFF771F98),
                    fontSize: 15,
                    fontFamily: 'Poppins-SemiBold',
                    fontWeight: FontWeight.w600,
                    height: 1.07,
                  ),
                ),
                trailing: CustomSwitch(),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 400,
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    Dialoge.DeleteAccount(context);
                  },
                  child:
                  Row(
                    children: [
                      Image.asset('assets/images/delete (2).png',
                        width: 12.86,
                        height: 14.89,),
                      SizedBox(width: 10,),
                      Text('Delete Account'.tr,
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFF13939),
                        ),),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xffA79FD9).withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero
                    ),
                  ),
                ),),
              const SizedBox(
                height: 90,
              )
            ],
          ),
        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Color(0xff442B72),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileSupervisorScreen(
                    // onTapMenu: onTapMenu
                  )));
            },
            child: Image.asset(
              'assets/images/174237 1.png',
              height: 33,
              width: 33,
              fit: BoxFit.cover,
            )

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
                                              HomeForSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top:7 , right: 15):
                                  EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20
                                      ),
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
                                              AttendanceSupervisorScreen()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 9, left: 50):
                                  EdgeInsets.only( right: 50, top: 2 ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Attendance".tr,
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
                                              NotificationsSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                  EdgeInsets.only(top: 8 , bottom:4 ,left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
                                          width: 16.2
                                      ),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6
                                      ),
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
                                              TrackSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 10 , bottom: 2 ,right: 10,left: 0):
                                  EdgeInsets.only(top: 8 , bottom: 2 ,left: 0,right: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Buses".tr,
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
                        )))))
    );
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      // print('Switch Button is OFF');
    }
  }
}
