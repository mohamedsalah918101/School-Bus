import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_app_bar.dart';

class FAQSupervisor extends StatefulWidget {
  const FAQSupervisor({super.key});

  @override
  State<FAQSupervisor> createState() => _FAQSupervisorState();
}

class _FAQSupervisorState extends State<FAQSupervisor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChildDataItem> children = [];
  final List quotes = [
    {
      "answer":
      "The School Bus App is a mobile application designed to provide parents, students, and schools with real-time information about school bus routes, schedules, and safety updates.".tr,
      "question": "What is the School Bus App?".tr,
      "expanded": false,
    },
    {
      "answer":
      "You can download the School Bus App from the Apple App Store or Google Play Store. Simply search for \"School Bus App\" and look for our official logo.".tr,
      "question": "How can I download the School Bus App?".tr,
      "expanded": false,
    },
    {
      "answer":
      "The app provides real-time updates on school bus locations, estimated arrival times, route changes, delays, and safety notifications. It helps parents and students stay informed about bus movements.".tr,
      "question": "What information does the app provide?".tr,
      "expanded": false,
    },
    {
      "answer":
      "The app uses GPS technology to track the location of school buses. When parents or students log in, they can see the real-time location of their bus, its route, and any delays.".tr,
      "question": "How does the app work?".tr,
      "expanded": false,
    },
    {
      "answer":
      "The app is generally free to download and use, but some advanced features may require a subscription or in-app purchase.".tr,
      "question": "Is the app free to use?".tr,
      "expanded": false,
    },
    {
      "answer":
      "You can typically select your child's school within the app and add your child to the system using their student ID. This will allow you to receive accurate information about their bus route and schedule.".tr,
      "question": "How do I set up the app for my child's school?".tr,
      "expanded": false,
    },
    {
      "answer":
      "The estimated arrival times are based on real-time GPS data and traffic conditions. They are generally accurate, but factors like traffic jams or weather conditions might occasionally cause deviations.".tr,
      "question": "How accurate are the estimated arrival times?".tr,
      "expanded": false,
    },
    {
      "answer":
      "Yes, the app can send push notifications to alert you about delays, route changes, or other important updates related to your child's school bus.".tr,
      "question": "Can I receive notifications for delays or changes?".tr,
      "expanded": false,
    },
    {
      "answer":
      "We prioritize the security of your child's information. The app typically uses secure login methods, and personal data is encrypted to protect privacy.".tr,
      "question": "Is the app secure? How is my child's information protected?".tr,
      "expanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
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
                onTap: (){
                  Navigator.of(context).pop();
                },
                child:  Padding(
                  padding: const EdgeInsets.all( 17.0),
                  child: Image.asset(
                    (sharedpref?.getString('lang') == 'ar')?
                    'assets/images/Layer 1.png':
                    'assets/images/fi-rr-angle-left.png',
                    width: 10,
                    height: 22,),
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
              title: Text('FAQ'.tr ,
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
        // appBar: Custom().customAppBar(context, 'FAQ'.tr),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: quotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildExpandableTile(quotes[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
              const SizedBox(
                height:120,
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

  Widget _buildExpandableTile(Map item) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          item['question'],
          style: const TextStyle(
            color: Color(0xBF091C3F),
            fontSize: 16,
            overflow: TextOverflow.visible,
            fontFamily: 'Cairo-Regular',
            fontWeight: FontWeight.w400,
            height: 1.33,
            letterSpacing: -0.24,
          ),
        ),
        trailing: Icon(
          sharedpref?.getString('lang') == 'ar' ?
          item['expanded']
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_left
              :
          item['expanded']
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_right,
          color: const Color(0xff091C3F),
          size: 18,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() => item['expanded'] = expanded);
        },
        children: [
          ListTile(
            title: Text(
              item['answer'],
              style: const TextStyle(
                color: Color(0xBF091C3F),
                fontSize: 16,
                fontFamily: 'Cairo-Regular',
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: -0.24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
