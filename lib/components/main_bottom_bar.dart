
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';

import 'bottom_bar_item.dart';
import '../screens/homeScreen.dart';



class MainBottomNavigationBar extends StatelessWidget {
  int pageNum = 0;

  MainBottomNavigationBar({super.key, required this.pageNum});

  PageController myPage = PageController(initialPage: 0);

  // var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    myPage = PageController(initialPage: pageNum);
    return WillPopScope(
      onWillPop: () async {
        // print("_currentIndex${myPage.page}");
        if (myPage.page != 0) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => MainBottomNavigationBar(pageNum: 0)),
                  (Route<dynamic> route) => false);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        //drawer: HomeDrawer(),
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //if (myPage.page != 2) {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => MainBottomNavigationBar(pageNum: 2),
              //         maintainState: false));
              Navigator.push(
                  context,
                  MaterialPageRoute(

                      builder: (context) => HomeScreen(),
                      maintainState: false)
                  // PageRouteBuilder(
                  //     transitionDuration:  Duration(milliseconds: (await DiskSpace
                  //         .getTotalDiskSpace)! >=
                  //         60000
                  //         ? 600
                  //         : 700),
                  //     pageBuilder: (_, __, ___) =>
                  //         MainBottomNavigationBar(pageNum: 2))
              );
           // }
          },
          child: Image.asset(
            'assets/imgs/school/Ellipse 2.png',
            fit: BoxFit.fill,
          ),
        ),
        body: PageView(
          controller: myPage,
          onPageChanged: (c) {
            //print('Page Changes to index $c');
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(
              // onTapMenu: () {
              //   _scaffoldKey.currentState?.openDrawer();
              // },
            ),
            // TrackScreen(),
            // ProfileScreen(),
            // ChatScreen(),
            // AttendanceScreen(),
            // NotificationsScreen(),
            // const FAQScreen(),
            // SettingsScreen(),
          ], // Comment this if you need to use Swipe.
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: BottomAppBar(
              color: const Color(0xFF442B72),
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              notchMargin: 7,
              child: SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: BottomBarItem(
                            function: () async {
                             // if (myPage.page != 0) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             MainBottomNavigationBar(pageNum: 0),
                                //         maintainState: false));

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(

                                        builder: (context) => HomeScreen(),
                                        maintainState: false)
                                    // PageRouteBuilder(
                                    //     transitionDuration:  Duration(milliseconds: (await DiskSpace
                                    //         .getTotalDiskSpace)! >=
                                    //         60000
                                    //         ? 600
                                    //         : 700),
                                    //     pageBuilder: (_, __, ___) => MainBottomNavigationBar(pageNum: 0))
                                );}
                            //}
                            ,
                            pageNum: pageNum,
                            image: Image.asset('assets/imgs/school/Vector.png',
                                color: pageNum == 0.0
                                    ? const Color(0xffFEDF96)
                                    : const Color(0xffFFC53E),
                                height: 20,
                                width: 20),
                            lable: 'Home',
                          )),
                      Flexible(
                        flex: 2,
                        child: BottomBarItem(
                          function: () {
                            if (myPage.page != 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(

                                      builder: (context) => NotificationScreen(),
                            maintainState: false)
                                      );
                            }
                          },
                          pageNum: pageNum,
                          image: Image.asset('assets/imgs/school/clarity_notification-line (1).png',
                              color: pageNum == 1.0
                                  ? const Color(0xffFEDF96)
                                  : const Color(0xffFFC53E),
                              height: 20,
                              width: 20),
                          lable: 'Notification'.tr,
                        ),
                      ),
                      Flexible(
                        child: BottomBarItem(
                          function: () {
                            //if (myPage.page != 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupervisorScreen(),
                                      maintainState: false));
                            }
                          //}
                          ,
                          pageNum: pageNum,
                          image: Image.asset('assets/imgs/school/icons8_manager 1.png',
                              color: pageNum == 3.0
                                  ? const Color(0xffFEDF96)
                                  : const Color(0xffFFC53E),
                              height: 20,
                              width: 20),
                          lable: 'Supervisor',
                        ),
                      ),
                      Flexible(
                        child: BottomBarItem(
                          function: () async {
                            //if (myPage.page != 4) {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             MainBottomNavigationBar(
                              //               pageNum: 4,
                              //             ),
                              //         maintainState: false));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(

                                      builder: (context) => BusScreen(),
                                      maintainState: false)
                                  // PageRouteBuilder(
                                  //     transitionDuration:
                                  //     Duration(milliseconds:( await DiskSpace
                                  //         .getTotalDiskSpace)! >=
                                  //         60000
                                  //         ? 600
                                  //         : 700),
                                  //     pageBuilder: (_, __, ___) =>
                                  //         MainBottomNavigationBar(pageNum: 4))
                              );
                            }
                          //}
                          ,
                          pageNum: pageNum,
                          image: Image.asset('assets/imgs/school/ph_bus-light.png',
                              color: pageNum == 4.0
                                  ? const Color(0xffFEDF96)
                                  : const Color(0xffFFC53E),
                              height: 20,
                              width: 20),
                          lable: 'Buses',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
