import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
//import '../model/chat_message_model.dart';
import '../components/custom_app_bar.dart';
//import '../components/reciver_message_item.dart';
//import '../components/sender_message_item.dart';
import '../components/notification_item.dart';
import '../main.dart';
import '../model/notification_message_model.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<QueryDocumentSnapshot> data = [];
  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('notification').where('SchoolId', isEqualTo:sharedpref!.getString('id')) .get();
    data.addAll(querySnapshot.docs);
    for(var doc in data)
      {
        print('Fetched item type: ${doc['item']}');
      }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    // List<NotificationMessage> notifications = [
    //   NotificationMessage(
    //       messageContent: "Joly’s Bus about to reach you location in 20 mins",
    //       messageType: "Arrival Reminder",
    //       messageTime: '07:35 AM'),
    //   NotificationMessage(
    //       messageContent:
    //           "Joly’s Bus has left from school, it will reach location in 35 mins",
    //       messageType: "Taken From School",
    //       messageTime: '02:45 PM'),
    //   NotificationMessage(
    //       messageContent:
    //           "Due to Accident Near El Namas St. July's Bus is delayed by 20 mins, Don't worry every one is safes",
    //       messageType: "Alarm",
    //       messageTime: '03:35 PM'),
    // ];
    List dates = ['Today'.tr
      //,'Yesterday'.tr
    ];
    // String formatTimestamp(Timestamp timestamp) {
    //   return
    //     //'${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
    //       ' ${timestamp.toDate().hour}:${timestamp.toDate().minute}';
    // }
    String formatTimestamp(Timestamp timestamp) {
      final DateFormat formatter = DateFormat.jm(); // 'jm' stands for 'hour minute' with AM/PM
      return formatter.format(timestamp.toDate());
    }
    return SafeArea(
      child: Scaffold(
        endDrawer: HomeDrawer(),
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFFFFFFF),
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
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 23,
                  color: Color(0xff442B72),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
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
                'Notifications'.tr,
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
        //Custom().customAppBar(context,'Notifications'),
        //endDrawer: HomeDrawer(),
        body: SingleChildScrollView(
          child: ListView.separated(

            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: Column(
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
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w600,
                            height: 0.89,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0),
                      child: ListView.separated(
                        itemCount: data.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index2) {
                          return NotificationItem(
                            messageContent: data[index2]['SupervisorName']+' has joined to your school',
                            time: formatTimestamp(data[index2]['timestamp']),
                            type: data[index2]['item'],

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
                      height: 20,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 5,
              );
            },
            itemCount: dates.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Image.asset(
                'assets/imgs/school/busbottombar.png',
                width: 35,
                height: 35,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
// انا شيلت من هنا directionality ltr
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomAppBar(
            color: const Color(0xFF442B72),
            clipBehavior: Clip.antiAlias,
            shape: const AutomaticNotchedShape(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(38.5),
                        topRight: Radius.circular(38.5))),
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)))),
            //CircularNotchedRectangle(),
            //shape of notch
            notchMargin: 7,
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                  maintainState: false),
                            );
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset(
                                    'assets/imgs/school/icons8_home_1 1.png',
                                    height: 21,
                                    width: 21),
                                Text("Home".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset(
                                    'assets/imgs/school/icons8_notification 1.png',
                                    height: 22,
                                    width: 22),
                                Text('Notification'.tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SupervisorScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset(
                                    'assets/imgs/school/empty_supervisor.png',
                                    height: 22,
                                    width: 22),
                                Text("Supervisor".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusScreen(),
                                    maintainState: false));
                            // _key.currentState!.openDrawer();
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset(
                                    'assets/imgs/school/ph_bus-light (1).png',
                                    height: 22,
                                    width: 22),
                                Text("Buses".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
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
} // below is custom color class
