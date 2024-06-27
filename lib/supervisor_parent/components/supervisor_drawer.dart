import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/children.dart';
import 'package:school_account/supervisor_parent/screens/faq_parent.dart';
import 'package:school_account/supervisor_parent/screens/faq_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/setting_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/settings_parent.dart';
import 'package:school_account/supervisor_parent/screens/supervisor_screen.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:school_account/supervisor_parent/screens/your_bus.dart';
import 'dialogs.dart';
import 'main_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupervisorDrawer extends StatefulWidget {


  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<SupervisorDrawer> {
  late final int selectedImage;
  final _firestore = FirebaseFirestore.instance;


  // List<ChildDataItem> children = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 198,
        height: 799,
        decoration: ShapeDecoration(
            color: Color(0xFF442B72),
            shape: (sharedpref?.getString('lang') == 'ar')
                ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ))
                : RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
            )),
        child: LayoutBuilder(builder: (context, constrains) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constrains.maxHeight,
              minWidth: constrains.maxWidth,
            ),
            child: Drawer(
              backgroundColor: Colors.transparent,
              child: Container(
                // padding: const EdgeInsets.only(top: 61),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70,),
                      Center(
                        child: SizedBox(
                          width: 133.82,
                          height: 56.03,
                          child: Image.asset(
                            "assets/images/Logo (4).png",
                          ),
                        ),
                      ),
                      // const Spacer(),
                      SizedBox(height: 75,),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/home2.png",
                          width: 21.90,
                          height: 21.90,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Home".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  HomeForSupervisor()));},
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/icons8_user_1 1.png",
                          width: 21.90,
                          height: 21.90,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Profile".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (sharedpref?.getString('lang') == 'ar')?
                                14 : 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  ProfileSupervisorScreen()));},
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/Vector (13)white attendance.png",
                          width: 18,
                          height: 18,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Attendance".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  AttendanceSupervisorScreen()));},
                      ),
                      ListTile(
                        visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 27,
                        leading: Image.asset(
                          "assets/images/driving.png",
                          width: 21.90,
                          height: 21.90,
                          color: Colors.white,
                        ),
                        title: Text(
                          "My Bus".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (sharedpref?.getString('lang') == 'ar')?
                                13.2 : 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  YourBus()));},
                      ),
                      ListTile(
                        visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 27,
                        leading: Image.asset(
                          "assets/images/notificationbing.png",
                          width: 21.90,
                          height: 21.90,
                        ),
                        title: Text(
                          "Notifications".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  NotificationsSupervisor()));},
                      ),
                      ListTile(
                        visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset(
                          "assets/images/setting2.png",
                          width: 21.90,
                          height: 21.90,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Settings".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  SettingsSupervisor()));},
                      ),
                      ListTile(
                        visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset(
                          "assets/images/messagequestion.png",
                          width: 21.90,
                          height: 21.90,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "FAQ".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  FAQSupervisor()));},
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/images/logoutcurve.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: Text(
                            "Logout".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Dialoge.logOutDialog(context);
                            // userData.write('userIsLoggedIn', null);
                            // userData.write('language', null);
                            // Get.offAll(() => const LoginScreen());
                          }),
                      SizedBox( height:  70 ),
                      Container(
                        width: 172.65,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
                                      return CircleAvatar(
                                        radius: 31,
                                        backgroundColor: Color(0xff442B72),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                          radius: 31,
                                        ),
                                      );
                                    }

                                    Map<String, dynamic>? data = snapshot.data?.data();
                                    if (data != null && data['busphoto'] != null) {
                                      return CircleAvatar(
                                        radius: 31,
                                        backgroundColor: Color(0xff442B72),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage('${data['busphoto']}'),
                                          radius:31,
                                        ),
                                      );
                                    }
                                  }

                                  return Container();
                                },
                              ),
                              // children.isNotEmpty?
                              // Image.asset(
                              //   'assets/images/Ellipse 1.png',
                              //   fit: BoxFit.fill,
                              //   height: 62,
                              //   width: 62,
                              // ),
                              //     :
                              // Image.asset(
                              //   'assets/images/Group 237679.png',
                              //   fit: BoxFit.fill,
                              //   height: 52,
                              //   width: 52,
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              FutureBuilder(
                                future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.data?.data() == null) {
                                      return Text(
                                        'No data available',
                                        style: TextStyle(
                                          color: Color(0xff442B72),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      );
                                    }

                                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                    return Text(
                                      '${data['name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                            fontSize: 18.74,
                                            fontFamily: 'Poppins-SemiBold',
                                            fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }

                                  return Container();
                                },
                              ),
                              // Text(
                              //   'Shady Ayman'.tr,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 18,
                              //     fontFamily: 'Poppins-SemiBold',
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                              SizedBox(
                                height: 0,
                              ),
                            ],
                          )

                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
