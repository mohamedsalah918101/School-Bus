
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/children.dart';
import 'package:school_account/supervisor_parent/screens/faq_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/settings_parent.dart';
import 'package:school_account/supervisor_parent/screens/supervisor_screen.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'dialogs.dart';
import 'main_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<HomeDrawer> {
  late final int selectedImage;
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
            ),
          )
              : RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
        ),
        child: LayoutBuilder(builder: (context, constrains) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constrains.maxHeight,
              minWidth: constrains.maxWidth,
            ),
            child: Drawer(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 133.82,
                          height: 56.03,
                          child: Image.asset(
                            "assets/images/Logo (4).png",
                          ),
                        ),
                      ),
                     SizedBox(height: 40 ,),
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
                                    HomeParent()));},
                          ),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/icons8_user_1 1.png",
                          width: 21.90,
                          height: 23.90,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Profile".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (sharedpref?.getString('lang') == 'ar') ? 14 : 15.52,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  ProfileParent()));},
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/calendar.png",
                          width: 18.75,
                          height: 18.75,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Calendar".tr,
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
                                  AttendanceParent()));},
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
                            "Track Bus".tr,
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
                                    TrackParent()));},
                          ),
                      ListTile(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        leading: Image.asset(
                          "assets/images/icons8_children 1.png",
                          width: 25,
                          height: 25,
                        ),
                        minLeadingWidth: 27,
                        title: Text(
                          "Children".tr,
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
                                  children()));},
                      ),
                      ListTile(
                        visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                        minLeadingWidth: 27,
                        leading: Image.asset(
                          "assets/images/icons8_manager 1.png",
                          width: 21.90,
                          height: 21.90,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Supervisors".tr,
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
                                  SupervisorScreen()));},
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
                                  NotificationsParent()));},
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
                                  SettingsParent()));},
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
                                  FAQParent()));},
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
                    SizedBox(height: 10,),
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
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:
                            // children.isNotEmpty?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // children.isNotEmpty?
                            Image.asset(
                              'assets/images/Ellipse 1.png',
                              fit: BoxFit.fill,
                              height: 62,
                              width: 62,
                            ),
                            //     : Image.asset(
                            //   'assets/images/Group 237679.png',
                            //   fit: BoxFit.fill,
                            //   height: 52,
                            //   width: 52,
                            // ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Shady Ayman'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        )
                          //   :
                          //   SizedBox(
                          //   height: 150,
                          // )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
