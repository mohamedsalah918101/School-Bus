// 
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_account/supervisor_parent/components/bottom_bar_item.dart';
// 
// import 'package:school_account/supervisor_parent/screens/home_screen.dart';
// import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
// import 'package:school_account/supervisor_parent/screens/home_parent.dart';
// import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
// import 'package:school_account/supervisor_parent/screens/otp_screen.dart';
// import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
// import 'package:school_account/supervisor_parent/screens/track_parent.dart';
//
// import '../screens/attendence_parent.dart';
// import '../screens/chat_screen.dart';
// import '../screens/faq_parent.dart';
// import '../screens/settings_parent.dart';
// import 'parent_drawer.dart';
//
// class MainBottomNavigationBar extends StatelessWidget {
//   int pageNum = 0;
//
//   MainBottomNavigationBar({super.key, required this.pageNum});
//
//   PageController myPage = PageController(initialPage: 0);
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//         myPage = PageController(initialPage: pageNum);
//         return WillPopScope(
//             onWillPop: () async {
//               if (myPage.page != 0) {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => MainBottomNavigationBar(pageNum: 0)),
//                         (Route<dynamic> route) => false);
//                 return false;
//               } else {
//                 return true;
//               }
//             },
//       child: Scaffold(
//         drawer: HomeDrawer(),
//         key: _scaffoldKey,
//         // backgroundColor: Colors.transparent,
//         extendBody: true,
//         resizeToAvoidBottomInset: false,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(100)
//           ),
//           backgroundColor: Colors.transparent,
//           onPressed: () async {
//             if (myPage.page != 2) {
//               Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                       transitionDuration:  Duration(milliseconds: (await DiskSpace
//                           .getTotalDiskSpace)! >=
//                           60000
//                           ? 600
//                           : 700),
//                       pageBuilder: (_, __, ___) =>
//                           MainBottomNavigationBar(pageNum: 2)));
//             }
//           },
//           child: Image.asset(
//             'assets/images/Ellipse 1.png', height: 50, width: 50,
//             fit: BoxFit.cover,
//           ),
//         ),
//         body: PageView(
//           controller: myPage,
//           onPageChanged: (c) {
//           },
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             NewHomeScreen(
//               onTapMenu: () {
//                 _scaffoldKey.currentState?.openDrawer();
//               },
//             ),
//             HomeScreenWithOneSupervisor(
//               onTapMenu: () {
//                 _scaffoldKey.currentState?.openDrawer();
//               },
//             ),
//             TrackScreen(),
//             ProfileScreen(),
//             ChatScreen(),
//             AttendanceScreen(),
//             NotificationsScreen(),
//             const FAQScreen(),
//             SettingsScreen(),
//           ], // Comment this if you need to use Swipe.
//         ),
//         bottomNavigationBar:
//         // Directionality(
//         //   textDirection:
//         //   Get.locale == Locale( 'ar' )
//         //       ? TextDirection.rtl
//         //       : TextDirection.ltr,
//         //   child: ClipRRect(
//         //     borderRadius: const BorderRadius.only(
//         //       topLeft: Radius.circular(25),
//         //       topRight: Radius.circular(25),
//         //     ),
//         //     child: BottomAppBar(
//         //       padding: EdgeInsets.symmetric(vertical: 3),
//         //       height: 50,
//         //       color: const Color(0xFF442B72),
//         //       clipBehavior: Clip.antiAlias,
//         //       shape: const AutomaticNotchedShape(
//         //           RoundedRectangleBorder(
//         //               borderRadius: BorderRadius.only(
//         //                   topLeft: Radius.circular(38.5),
//         //                   topRight: Radius.circular(38.5))),
//         //           RoundedRectangleBorder(
//         //               borderRadius: BorderRadius.all(Radius.circular(50)))),
//         //       notchMargin: 7,
//         //       child: SizedBox(
//         //         height: 10,
//         //         child: SingleChildScrollView(
//         //           child: Row(
//         //             mainAxisSize: MainAxisSize.max,
//         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //             children: [
//         //               Flexible(
//         //                   child: Padding(
//         //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //                     child: BottomBarItem(
//         //                                             function: () async {
//         //                     if (myPage.page != 0) {
//         //                       Navigator.push(
//         //                           context,
//         //                           PageRouteBuilder(
//         //                               transitionDuration:  Duration(milliseconds: (await DiskSpace
//         //                                   .getTotalDiskSpace)! >=
//         //                                   60000
//         //                                   ? 600
//         //                                   : 700),
//         //                               pageBuilder: (_, __, ___) => MainBottomNavigationBar(pageNum: 0)));}
//         //                                             },
//         //                                             pageNum: pageNum,
//         //                                             image: Image.asset('assets/images/Vector (13).png',
//         //                       color: pageNum == 0.0
//         //                           ? const Color(0xffFEDF96)
//         //                           : const Color(0xffFFC53E),
//         //                       height: 17,
//         //                       width: 20),
//         //                                             lable: 'Home'.tr,
//         //                                           ),
//         //                   )),
//         //               Flexible(
//         //                 flex: 2,
//         //                 child: Padding(
//         //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         //                   child: BottomBarItem(
//         //                     function: () {
//         //                       if (myPage.page != 1) {
//         //                         Navigator.push(
//         //                             context,
//         //                             MaterialPageRoute(
//         //                                 builder: (context) =>
//         //                                     MainBottomNavigationBar(
//         //                                       pageNum: 1,
//         //                                     ),
//         //                                 maintainState: false));
//         //                       }
//         //                     },
//         //                     pageNum: pageNum,
//         //                     image: Column(
//         //                       children: [
//         //                         Image.asset('assets/images/Vector (2).png',
//         //                             color: pageNum == 1.0
//         //                                 ? const Color(0xffFEDF96)
//         //                                 : const Color(0xffFFC53E),
//         //                             height: 16,
//         //                             width: 16),
//         //                         Image.asset('assets/images/Vector (5).png',
//         //                             height: 5,
//         //                             width: 5),
//         //                       ],
//         //                     ),
//         //                     lable: 'Notifications'.tr,
//         //                   ),
//         //                 ),
//         //               ),
//         //               Flexible(
//         //                 // flex: 1,
//         //                 child: BottomBarItem(
//         //                   function: () {
//         //                     if (myPage.page != 3) {
//         //                       Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                               builder: (context) => ChatScreen(),
//         //                               maintainState: false));
//         //                     }
//         //                   },
//         //                   pageNum: pageNum,
//         //                   image: Image.asset('assets/images/Vector (3).png',
//         //                       color: pageNum == 3.0
//         //                           ? const Color(0xffFEDF96)
//         //                           : const Color(0xffFFC53E),
//         //                       height: 18,
//         //                       width: 18),
//         //                   lable: 'Calendar'.tr,
//         //                 ),
//         //               ),
//         //
//         //               Flexible(
//         //                 // flex: 2,
//         //                 child: BottomBarItem(
//         //                   function: () async {
//         //                     if (myPage.page != 4) {
//         //                       Navigator.push(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                               builder: (context) => MainBottomNavigationBar(
//         //                                 pageNum: 4,
//         //                               ),
//         //                                   // AttendanceScreen(),
//         //                               maintainState: false));
//         //                     }
//         //                   },
//         //                   pageNum: pageNum,
//         //                   image: Image.asset('assets/images/Vector (4).png',
//         //                       color: pageNum == 4.0
//         //                           ? const Color(0xffFEDF96)
//         //                           : const Color(0xffFFC53E),
//         //                       height: 16,
//         //                       width: 20),
//         //                   lable: 'Track'.tr,
//         //                 ),
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }}
// //bottomNavigationBar: Container(
// //           width: 359,
// //           height: 66.22,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.only(
// //               topLeft: Radius.circular(20),
// //               topRight: Radius.circular(20),
// //             ),
// //
// //             color: Colors.white,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.5),
// //                 spreadRadius: 3,
// //                 blurRadius: 7,
// //                 offset: Offset(0, 3),
// //               ),
// //             ],
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => menu()),
// //                     );
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: 5),
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         width: 25,
// //                         height: 25,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.rectangle,
// //                         ),
// //                         child: Image.asset(
// //                           'assets/images/user.png',
// //                           color: Color(0xFF6C6A6A),
// //
// //                         ),
// //                       ),
// //                       SizedBox(height: 3),
// //                       Text(
// //                         "ملفى",
// //                         style: TextStyle(
// //                           fontFamily: 'Cairo',
// //                           fontWeight: FontWeight.normal,
// //                           color: Colors.black,
// //                           fontSize: 10.90,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => Live()),
// //                     );
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: 5),
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         width: 25,
// //                         height: 25,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.rectangle,
// //                         ),
// //                         child:Icon(Icons.online_prediction_outlined,
// //                           // size: 22, // Adjust the size of the icon as needed
// //                           color:Color(0xFF6C6A6A),
// //                         ),
// //                       ),
// //                       SizedBox(height: 3),
// //                       Text(
// //                         "مباشر",
// //                         style: TextStyle(
// //                           color: Colors.black,
// //                           fontSize: 10.90,
// //                           fontFamily: 'Cairo',
// //                           fontWeight: FontWeight.normal,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => Lessons()),
// //                     );
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: 5),
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         width: 25,
// //                         height: 25,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.rectangle,
// //                         ),
// //                         child: Icon(Icons.collections_bookmark_outlined,
// //                           // size: 22, // Adjust the size of the icon as needed
// //                           color:Color(0xFF6C6A6A),
// //                         ),
// //                       ),
// //                       SizedBox(height: 3),
// //                       Text(
// //                         "الوحدات",
// //                         style: TextStyle(
// //                           color: Colors.black,
// //                           fontSize: 10.90,
// //                           fontFamily: 'Cairo',
// //                           fontWeight: FontWeight.normal,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => Home()),
// //                     );
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(vertical: 5),
// //                   child: Column(
// //                     children: [
// //                       Container(
// //                         width: 25,
// //                         height: 25,
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.rectangle,
// //                         ),
// //                         child: Image.asset(
// //                           'assets/images/HouseSimple.png',
// //                         ),
// //                       ),
// //                       SizedBox(height: 3),
// //                       Text(
// //                         "الرئيسية",
// //                         style: TextStyle(
// //                           color: Colors.black,
// //                           fontSize: 10.90,
// //                           fontFamily: 'Cairo',
// //                           fontWeight: FontWeight.normal,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         )
