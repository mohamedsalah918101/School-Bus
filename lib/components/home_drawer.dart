//
import 'package:flutter/material.dart';
import 'package:school_account/main.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/faqScreen.dart';
import 'package:school_account/screens/homeScreen.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/settingScreen.dart';

import '../screens/profileScreen.dart';
import '../screens/vocationsScreen.dart';
import 'dialogs.dart';
//import 'main_bottom_bar.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 198,
        decoration: const ShapeDecoration(
          color: Color(0xFF442B72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(80),
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
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 133.82,
                          height: 56.03,
                          child: Image.asset(
                            "assets/imgs/school/Logo.png",
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                          )),
                      ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                          leading: Image.asset(
                            "assets/imgs/school/home2.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: const Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 0)),
                            //         (Route<dynamic> route) => false
                            //
                            // );
                            //old
                            // Get.offAll(() => const HomeScreen());
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                          leading: Image.asset(
                            "assets/imgs/school/school (3) 1.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: const Text(
                            "School Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 0)),
                            //         (Route<dynamic> route) => false
                            //
                            // );
                            //old
                            // Get.offAll(() => const HomeScreen());
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          minLeadingWidth: 27,
                          leading: Image.asset(
                            "assets/imgs/school/icons8_calendar 1.png",
                            width: 21.90,
                            height: 21.90,
                            color: Colors.white,
                          ),
                          title: const Text(
                            "Vacations",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>VacationsScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 1)),
                            //         (Route<dynamic> route) => false);
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          minLeadingWidth: 27,
                          leading: Image.asset(
                            "assets/imgs/school/driving.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          title: const Text(
                            "Buses",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: ()
                          //async
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BusScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     PageRouteBuilder(
                            //         transitionDuration: Duration(
                            //             milliseconds: (await DiskSpace
                            //                 .getTotalDiskSpace)! >=
                            //                 60000
                            //                 ? 600
                            //                 : 700),
                            //         pageBuilder: (_, __, ___) =>
                            //             MainBottomNavigationBar(pageNum: 4)),
                            //         (Route<dynamic> route) => false);
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     PageRouteBuilder(
                            //         transitionDuration: const Duration(milliseconds: 600),
                            //         pageBuilder: (_, __, ___) => MainBottomNavigationBar(pageNum: 4),));
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          minLeadingWidth: 27,
                          leading: Image.asset(
                            "assets/imgs/school/notificationbing.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          title: const Text(
                            "Notifications",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: ()
                          //async
                          { Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 5)),
                            //         (Route<dynamic> route) => false);
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/imgs/school/setting2.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: const Text(
                            "Settings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 7)),
                            //         (Route<dynamic> route) => false);
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/imgs/school/messagequestion.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: const Text(
                            "FAQ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQScreen()));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             MainBottomNavigationBar(pageNum: 6)),
                            //         (Route<dynamic> route) => false);
                          }),
                      const SizedBox(
                        height: 18,
                      ),
                      ListTile(
                          visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                          leading: Image.asset(
                            "assets/imgs/school/logoutcurve.png",
                            width: 21.90,
                            height: 21.90,
                          ),
                          minLeadingWidth: 27,
                          title: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.52,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () async {
                            await sharedpref!.setString('id', '');
                            Dialoge.logOutDialog(context);
                            // userData.write('userIsLoggedIn', null);
                            // userData.write('language', null);
                            // Get.offAll(() => const LoginScreen());
                          }),
                      const Spacer(),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                              // Image.asset(
                              //   'assets/imgs/school/Ellipse 2 (2).png',
                              //   fit: BoxFit.fill,
                              //   height: 62,
                              //   width: 62,
                              // ),
                            CircleAvatar(
                              backgroundColor: Colors.white, // Set background color to white
                              radius: 31, // Set the radius according to your preference
                              child: Image.asset(
                                'assets/imgs/school/Ellipse 2 (2).png',
                                fit: BoxFit.cover,
                                width: 62, // Set width of the image
                                height: 62, // Set height of the image
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Salam School',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.74,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 9,
                            ),

                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
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
