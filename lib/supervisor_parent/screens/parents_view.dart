import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:school_account/supervisor_parent/components/add_children_card.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/profile_card_in_supervisor.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/added_child_card.dart';

class ParentsView extends StatefulWidget {
  @override
  _ParentsViewState createState() => _ParentsViewState();
}

class _ParentsViewState extends State<ParentsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool Accepted = false;
  bool Declined = false;
  bool Waiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        body: Stack(
          children: [
            (sharedpref?.getString('lang') == 'ar')
                ? Positioned(
                    bottom: 20,
                    left: 25,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddParents()));
                      },
                      backgroundColor: Color(0xFF442B72),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 20,
                    right: 25,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddParents()));
                      },
                      backgroundColor: Color(0xFF442B72),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17.0),
                          child: Image.asset(
                            (sharedpref?.getString('lang') == 'ar')
                                ? 'assets/images/Layer 1.png'
                                : 'assets/images/fi-rr-angle-left.png',
                            width: 20,
                            height: 22,
                          ),
                        ),
                      ),
                      Text(
                        'Parents'.tr,
                        style: TextStyle(
                          color: Color(0xFF993D9A),
                          fontSize: 16,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: const Icon(
                            Icons.menu_rounded,
                            color: Color(0xff442B72),
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 271,
                                height: 42,
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: "Search Name".tr,
                                    hintStyle: TextStyle(
                                      color: const Color(0xffC2C2C2),
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    prefixIcon: Padding(
                                      padding: (sharedpref?.getString('lang') ==
                                              'ar')
                                          ? EdgeInsets.only(
                                              right: 6, top: 14.0, bottom: 9)
                                          : EdgeInsets.only(
                                              left: 3, top: 14.0, bottom: 9),
                                      child: Image.asset(
                                        'assets/images/Vector (12)search.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 21,
                              ),
                              PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                  ),
                                  constraints: BoxConstraints.tightFor(
                                      width: 216, height: 300),
                                  color: Colors.white,
                                  surfaceTintColor: Colors.transparent,
                                  offset: Offset(0, 30),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'item1',
                                          child: Text(
                                            'Filter'.tr,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Color(0xFF993D9A),
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                            value: 'item2',
                                            child: Container(
                                              width: 150,
                                              height: 1,
                                              color: Color(0xff442B72)
                                                  .withOpacity(0.37),
                                            )),
                                        PopupMenuItem<String>(
                                          value: 'item3',
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: Accepted,
                                                onChanged: (bool? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      Accepted = value;
                                                      Declined = false;
                                                      Waiting = false;
                                                    });
                                                  }
                                                },
                                                fillColor:
                                                    MaterialStateProperty
                                                        .resolveWith(
                                                            (states) {
                                                  if (states.contains(
                                                      MaterialState
                                                          .selected)) {
                                                    return Color(0xff442B72);
                                                  }
                                                  return Color(0xff442B72);
                                                }), // Set the color of the selected radio button
                                              ),
                                              Text(
                                                "Accepted".tr,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'Poppins-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff442B72),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'item4',
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: Declined,
                                                onChanged: (bool? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      Accepted = false;
                                                      Declined = value;
                                                      Waiting = false;
                                                    });
                                                  }
                                                },
                                                fillColor:
                                                    MaterialStateProperty
                                                        .resolveWith(
                                                            (states) {
                                                  if (states.contains(
                                                      MaterialState
                                                          .selected)) {
                                                    return Color(0xff442B72);
                                                  }
                                                  return Color(0xff442B72);
                                                }), // Set the color of the selected radio button
                                              ),
                                              Text(
                                                "Declined".tr,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'Poppins-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff442B72),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'item5',
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue: Waiting,
                                                onChanged: (bool? value) {
                                                  if (value != null) {
                                                    setState(() {
                                                      Accepted = false;
                                                      Declined = false;
                                                      Waiting = value;
                                                    });
                                                  }
                                                },
                                                fillColor:
                                                    MaterialStateProperty
                                                        .resolveWith(
                                                            (states) {
                                                  if (states.contains(
                                                      MaterialState
                                                          .selected)) {
                                                    return Color(0xff442B72);
                                                  }
                                                  return Color(0xff442B72);
                                                }),
                                              ),
                                              Text(
                                                "Waiting".tr,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'Poppins-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff442B72),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'item6',
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 104,
                                                height: 38,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xff442B72),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10))),
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Apply'.tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                width: 88,
                                                height: 38,
                                                child: Center(
                                                  child: Text(
                                                    'Reset'.tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                      color: Color(0xFF432B72),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                  onSelected: (String value) {},
                                  child: Image.asset(
                                    'assets/images/Vector (13)sliders.png',
                                    width: 27.62,
                                    height: 21.6,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 8,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Image.asset(
                                          'assets/images/Ellipse 6.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Shady Ayman',
                                            style: TextStyle(
                                              color: Color(0xFF442B72),
                                              fontSize: 17,
                                              fontFamily: 'Poppins-SemiBold',
                                              fontWeight: FontWeight.w600,
                                              height: 1.07,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: (sharedpref
                                                        ?.getString('lang') ==
                                                    'ar')
                                                ? EdgeInsets.only(right: 3.0)
                                                : EdgeInsets.all(0.0),
                                            child: Text(
                                              'Joined yesterday'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF0E8113),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,),),),],),
                                      SizedBox(width: 103,),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            width: 111, height: 100),
                                        color: Colors.white,
                                        surfaceTintColor: Colors.transparent,
                                        offset: Offset(0, 30),
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'item1',
                                            child: Row(
                                              children: [Image.asset((sharedpref?.getString('lang') == 'ar')
                                                      ? 'assets/images/edittt_white_translate.png'
                                                      : 'assets/images/edittt_white.png', width: 12.81,
                                                  height: 12.76,),
                                                SizedBox(width: 7,),
                                                Text('Edit'.tr, style: TextStyle(fontFamily: 'Poppins-Light', fontWeight: FontWeight.w400,
                                                    fontSize: 17, color: Color(0xFF432B72),),),],),),
                                          PopupMenuItem<String>(
                                            value: 'item2', child: Row(
                                              children: [Image.asset('assets/images/delete.png',
                                                  width: 12.77, height: 13.81,),
                                                SizedBox(width: 7,),
                                                Text('Delete'.tr, style: TextStyle(fontFamily: 'Poppins-Light',
                                                    fontWeight: FontWeight.w400, fontSize: 15, color: Color(0xFF432B72),)),],)),],
                                        onSelected: (String value) {
                                          if (value == 'item1') {Navigator.push(context, MaterialPageRoute(builder: (context) => EditAddParents()),);
                                          } else if (value == 'item2') {Dialoge.DeleteParent(context);}},
                                        child: Image.asset('assets/images/more.png', width: 20.8, height: 20.8,),),],),
                                  SizedBox(height: 25,)],);},),),
                        SizedBox(height: 44,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            )),
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
                                              AttendanceSupervisorScreen()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 9, left: 50)
                                          : EdgeInsets.only(right: 50, top: 2),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19),
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 12, bottom: 4, right: 10)
                                          : EdgeInsets.only(
                                              top: 8, bottom: 4, left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
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
                                              TrackSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              right: 10,
                                              left: 0)
                                          : EdgeInsets.only(
                                              top: 8,
                                              bottom: 2,
                                              left: 0,
                                              right: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
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
                        ))))));
  }
}
