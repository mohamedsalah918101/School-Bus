import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/notification_item.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import '../model/chat_message_model.dart';
import '../components/custom_app_bar.dart';
import '../components/reciver_message_item.dart';
import '../components/sender_message_item.dart';
import '../model/notification_message_model.dart';

class NotificationsSupervisor extends StatefulWidget {

  @override
  _NotificationsSupervisorState createState() => _NotificationsSupervisorState();
}

class _NotificationsSupervisorState extends State<NotificationsSupervisor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChildDataItem> children = [];

  @override
  Widget build(BuildContext context) {
    List<NotificationMessage> notifications = [
      NotificationMessage(
          messageContent: "Joly’s Bus about to reach you location in 20 mins".tr,
          messageType: "Delays".tr,
          messageTime: '07:35 '.tr,
          messageTimes: 'AM'.tr
      ),
      NotificationMessage(
          messageContent:
          "Due to Accident Near El Namas St. July's Bus is delayed by 20 mins, Don't worry every one is safes".tr,
          messageType: "Cancel Absence".tr,
          messageTime: '03:35 ',
          messageTimes: 'PM'.tr
      ),
    ];
    List dates = ['Today'.tr, 'Yesterday'.tr];
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        backgroundColor:  Color(0xFFFFFFFF),
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
                  padding: (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.symmetric(horizontal: 23.0):
                  EdgeInsets.symmetric(horizontal: 17.0),
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
              title: Text('Notifications'.tr ,
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
        // Custom().customAppBar(context,'Notifications'.tr),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
          
              child:
              sharedpref!.getInt('invit') == 1 ?
              ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                      padding:
                      (sharedpref?.getString('lang') == 'ar')?
                      EdgeInsets.symmetric(horizontal: 22.0):
                      EdgeInsets.symmetric(horizontal: 17.0),
                      child:
                      Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                dates[index],
                                style: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 18,
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w600,
                                  height: 0.89,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0),
                            child: ListView.separated(
                              itemCount: notifications.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2) {
                                return NotificationItem(
                                  messageContent: notifications[index2].messageContent,
                                  time: notifications[index2].messageTime,
                                  type: notifications[index2].messageType,
                                  times: notifications[index2].messageTimes,
                                );
                              },
                              separatorBuilder: (BuildContext context, int index2) {
                                return SizedBox(
                                  height: 11,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height:0,
                          ),
                        ],
                      )
          
          
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 0,
                  );
                },
                itemCount: dates.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            //no data
                :
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),
                  Image.asset('assets/images/Group 237685.png',
                  width: 322,),
                  Text('No Notification Found'.tr,
                    style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 19,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                    ),),
                  Text('You haven’t received any \n'
                      'notification yet'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffBE7FBF),
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),),
                ]),
            )
          ),
        ),

        // extendBody: true,
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
                              Padding(
                                padding:
                                (sharedpref?.getString('lang') == 'ar')?
                                EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                EdgeInsets.only(top: 8 , bottom:4 ,left: 20),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/images/yellow_notfication.png',
                                        height: 20,
                                        width: 16.2
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
} // below is custom color class




//import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:school_account/supervisor_parent/components/child_data_item.dart';
// import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
// import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
// import 'package:school_account/supervisor_parent/components/notification_item.dart';
// import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
// import 'package:school_account/main.dart';
// import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
// import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/home_parent.dart';
// import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
// import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
// import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/track_parent.dart';
// import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
// import '../model/chat_message_model.dart';
// import '../components/custom_app_bar.dart';
// import '../components/reciver_message_item.dart';
// import '../components/sender_message_item.dart';
// import '../model/notification_message_model.dart';
//
// class NotificationsSupervisor extends StatefulWidget {
//
//   @override
//   _NotificationsSupervisorState createState() => _NotificationsSupervisorState();
// }
//
// class _NotificationsSupervisorState extends State<NotificationsSupervisor> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   List<ChildDataItem> children = [];
//   List<QueryDocumentSnapshot> data = [];
//   getData()async{
//     QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('notification').where('SupervisorId', isEqualTo:sharedpref!.getString('id')) .get();
//     data.addAll(querySnapshot.docs);
//     for(var doc in data)
//     {
//       print('Fetched item type: ${doc['item']}');
//     }
//     setState(() {
//
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }
//   String formatTimestamp(Timestamp timestamp) {
//     final DateFormat formatter = DateFormat.jm(); // 'jm' stands for 'hour minute' with AM/PM
//     return formatter.format(timestamp.toDate());
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // List<NotificationMessage> notifications = [
//     //   NotificationMessage(
//     //       messageContent: "Joly’s Bus about to reach you location in 20 mins".tr,
//     //       messageType: "Delays".tr,
//     //       messageTime: '07:35 '.tr,
//     //       messageTimes: 'AM'.tr
//     //   ),
//     //   NotificationMessage(
//     //       messageContent:
//     //       "Due to Accident Near El Namas St. July's Bus is delayed by 20 mins, Don't worry every one is safes".tr,
//     //       messageType: "Cancel Absence".tr,
//     //       messageTime: '03:35 ',
//     //       messageTimes: 'PM'.tr
//     //   ),
//     // ];
//     List dates = ['Today'.tr, 'Yesterday'.tr];
//     return Scaffold(
//         key: _scaffoldKey,
//         endDrawer: SupervisorDrawer(),
//         backgroundColor:  Color(0xFFFFFFFF),
//         appBar: PreferredSize(
//           child: Container(
//             decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color:  Color(0x3F000000),
//                     blurRadius: 12,
//                     offset: Offset(-1, 4),
//                     spreadRadius: 0,
//                   )
//                 ]),
//             child: AppBar(
//               toolbarHeight: 70,
//               centerTitle: true,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(16.49),
//                 ),
//               ),
//               elevation: 0.0,
//               leading: GestureDetector(
//                 onTap: (){
//                   Navigator.of(context).pop();
//                 },
//                 child:  Padding(
//                   padding: (sharedpref?.getString('lang') == 'ar')?
//                   EdgeInsets.symmetric(horizontal: 23.0):
//                   EdgeInsets.symmetric(horizontal: 17.0),
//                   child: Image.asset(
//                     (sharedpref?.getString('lang') == 'ar')?
//                     'assets/images/Layer 1.png':
//                     'assets/images/fi-rr-angle-left.png',
//                     width: 10,
//                     height: 22,),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child:
//                   GestureDetector(
//                     onTap: (){
//                       _scaffoldKey.currentState!.openEndDrawer();
//                     },
//                     child: const Icon(
//                       Icons.menu_rounded,
//                       color: Color(0xff442B72),
//                       size: 35,
//                     ),
//                   ),
//                 ),
//               ],
//               title: Text('Notifications'.tr ,
//                 style: const TextStyle(
//                   color: Color(0xFF993D9A),
//                   fontSize: 17,
//                   fontFamily: 'Poppins-Bold',
//                   fontWeight: FontWeight.w700,
//                   height: 1,
//                 ),),
//               backgroundColor:  Color(0xffF8F8F8),
//             ),
//           ),
//           preferredSize: Size.fromHeight(70),
//         ),
//         // Custom().customAppBar(context,'Notifications'.tr),
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: SingleChildScrollView(
//
//               child:
//               sharedpref!.getInt('invit') == 1 ?
//               ListView.separated(
//                 itemBuilder: (context, index) {
//                   return Padding(
//                       padding:
//                       (sharedpref?.getString('lang') == 'ar')?
//                       EdgeInsets.symmetric(horizontal: 22.0):
//                       EdgeInsets.symmetric(horizontal: 17.0),
//                       child:
//                       Column(
//                         children: [
//                           SizedBox(
//                             height: 25,
//                           ),
//                           Align(
//                               alignment: AlignmentDirectional.centerStart,
//                               child: Text(
//                                 dates[index],
//                                 style: const TextStyle(
//                                   color: Color(0xFF442B72),
//                                   fontSize: 18,
//                                   fontFamily: 'Poppins-SemiBold',
//                                   fontWeight: FontWeight.w600,
//                                   height: 0.89,
//                                 ),
//                               )),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 0.0, vertical: 0),
//                             child: ListView.separated(
//                               itemCount: data.length,
//                               shrinkWrap: true,
//                               padding: const EdgeInsets.only(top: 10, bottom: 10),
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index2) {
//                                 return NotificationItem(
//                                   messageContent: data[index2]['SupervisorName']+' has joined to your school',
//                                   // messageContent: notifications[index2].messageContent,
//                                   time: formatTimestamp(data[index2]['timestamp']),
//                                   type: data[index2]['item'],
//                                   times:' notifications[index2].messageTimes',
//                                 );
//                               },
//                               separatorBuilder: (BuildContext context, int index2) {
//                                 return SizedBox(
//                                   height: 11,
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height:0,
//                           ),
//                         ],
//                       )
//
//
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   return SizedBox(
//                     height: 0,
//                   );
//                 },
//                 itemCount: dates.length,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//               )
//             //no data
//                 :
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 70,),
//                   Image.asset('assets/images/Group 237685.png',
//                   width: 322,),
//                   Text('No Notification Found'.tr,
//                     style: TextStyle(
//                         color: Color(0xFF442B72),
//                         fontSize: 19,
//                         fontFamily: 'Poppins-Regular',
//                         fontWeight: FontWeight.w500,
//                     ),),
//                   Text('You haven’t received any \n'
//                       'notification yet'.tr,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Color(0xffBE7FBF),
//                       fontFamily: 'Poppins-Light',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 12,
//                     ),),
//                 ]),
//             )
//           ),
//         ),
//
//         // extendBody: true,
//         resizeToAvoidBottomInset: false,
//         floatingActionButtonLocation:
//         FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100)),
//             backgroundColor: Color(0xff442B72),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProfileSupervisorScreen(
//                     // onTapMenu: onTapMenu
//                   )));
//             },
//             child: Image.asset(
//               'assets/images/174237 1.png',
//               height: 33,
//               width: 33,
//               fit: BoxFit.cover,
//             )
//
//         ),
//         bottomNavigationBar:
//
//         // Directionality(
//         //     textDirection: Get.locale == Locale('ar')
//         //         ? TextDirection.rtl
//         //         : TextDirection.ltr,
//         //     child:
//
//             ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//                 child: BottomAppBar(
//                     padding: EdgeInsets.symmetric(vertical: 3),
//                     height: 60,
//                     color: const Color(0xFF442B72),
//                     clipBehavior: Clip.antiAlias,
//                     shape: const AutomaticNotchedShape(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(38.5),
//                                 topRight: Radius.circular(38.5))),
//                         RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(50)))),
//                     notchMargin: 7,
//                     child: SizedBox(
//                         height: 10,
//                         child: SingleChildScrollView(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               HomeForSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')?
//                                   EdgeInsets.only(top:7 , right: 15):
//                                   EdgeInsets.only(left: 15),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (7).png',
//                                           height: 20,
//                                           width: 20
//                                       ),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Home".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AttendanceSupervisorScreen()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')?
//                                   EdgeInsets.only(top: 9, left: 50):
//                                   EdgeInsets.only( right: 50, top: 2 ),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/icons8_checklist_1 1.png',
//                                           height: 19,
//                                           width: 19
//                                       ),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Attendance".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                 (sharedpref?.getString('lang') == 'ar')?
//                                 EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
//                                 EdgeInsets.only(top: 8 , bottom:4 ,left: 20),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                         'assets/images/yellow_notfication.png',
//                                         height: 20,
//                                         width: 16.2
//                                     ),
//                                     SizedBox(height: 2),
//                                     Text(
//                                       "Notifications".tr,
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins-Regular',
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white,
//                                         fontSize: 8,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               TrackSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')?
//                                   EdgeInsets.only(top: 10 , bottom: 2 ,right: 10,left: 0):
//                                   EdgeInsets.only(top: 8 , bottom: 2 ,left: 0,right: 10),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (4).png',
//                                           height: 18.36,
//                                           width: 23.5
//                                       ),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Buses".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ))))
//     // )
//     );
//   }
// } // below is custom color class