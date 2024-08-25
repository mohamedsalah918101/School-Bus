import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_account/model/ParentModel.dart';
import 'package:school_account/model/SupervisorsModel.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../../Functions/functions.dart';
import '../components/bus_component.dart';
import '../components/child_card.dart';
import 'notification_parent.dart';

class HomeParent extends StatefulWidget {
  // Function() onTapMenu;

  HomeParent({
    Key? key,
    // required this.onTapMenu,
  }) : super(key: key);

  @override
  HomeParentState createState() => HomeParentState();
}

class HomeParentState extends State<HomeParent> {
  final _firestore = FirebaseFirestore.instance;
  int minutes = 15;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // List<ChildDataItem> children = [];
  String parentName = '';

  // late Function() onTapMenu;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          parentName = documentSnapshot.get('name');
        });
        List<dynamic> children = documentSnapshot.get('children');
        for (int i = 0; i < children.length; i++) {
          DocumentSnapshot busSnapshot = await _firestore
              .collection('busdata')
              .doc(children[i]['bus_id'])
              .get();
          if (busSnapshot.exists) {
            List<dynamic> supervisors = busSnapshot.get('supervisors');
            List<SupervisorsModel> supervisorsData = [];
            String busNumber = '';
            busNumber = busSnapshot.get('busnumber');

            for (int x = 0; x < supervisors.length; x++) {
              supervisorsData.add(SupervisorsModel(
                  name: supervisors[x]['name'],
                  phone: supervisors[x]['phone'],
                  id: supervisors[x]['id'],
                  lat: supervisors[x]['lat'],
                  lang: supervisors[x]['lang']));
            }
            childrenData.add(ParentModel(
                child_name: children[i]['name'],
                class_name: children[i]['grade'],
                bus_number: busNumber,
                supervisors: supervisorsData));
          } else {
            childrenData.add(ParentModel(
                child_name: children[i]['name'],
                class_name: children[i]['grade'],
                bus_number: '',
                supervisors: []));
          }
        }
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          endDrawer: ParentDrawer(),
          body: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => Dialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                // contentPadding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return SizedBox(
                                      width: 304,
                                      height: 295,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Image.asset(
                                                          'assets/images/Vertical container.png',
                                                          width: 27,
                                                          height: 27,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    'Set Reminder'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'Poppins-SemiBold',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.23,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'You Set Reminder Before Bus Arrive'
                                                  .tr,
                                              style: TextStyle(
                                                color: Color(0xFF442B72),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (minutes > 0) {
                                                        minutes -= 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 62.56,
                                                    height: 76.58,
                                                    decoration: BoxDecoration(
                                                      borderRadius: (sharedpref
                                                                  ?.getString(
                                                                      'lang') ==
                                                              'ar')
                                                          ? BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(13),
                                                              bottomRight: Radius
                                                                  .circular(13))
                                                          : BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(13),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      13)),
                                                      color: Color(0xFF9889B4),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .minimize_rounded,
                                                          size: 45,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 28,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 89.52,
                                                  height: 76.54,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: .5,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '$minutes',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 40.22,
                                                          fontFamily:
                                                              'Poppins-Light',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.23,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      minutes += 1;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 62.56,
                                                    height: 76.58,
                                                    decoration: BoxDecoration(
                                                      borderRadius: (sharedpref
                                                                  ?.getString(
                                                                      'lang') ==
                                                              'ar')
                                                          ? BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(13),
                                                              bottomLeft: Radius
                                                                  .circular(13))
                                                          : BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(13),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          13)),
                                                      color: Color(0xFF442B72),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 35,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 11,
                                            ),
                                            Text(
                                              'Minutes'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF442B72),
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            Center(
                                              child: ElevatedSimpleButton(
                                                txt: 'Set'.tr,
                                                width: 200,
                                                hight: 42,
                                                onPress: () {
                                                  Navigator.pop(context);
                                                  // Dialoge.busArrivedDialog(context);
                                                },
                                                color: const Color(0xFF993D9A),
                                                fontSize: 17,
                                                fontFamily: 'Poppins-Regular',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          );
                        },
                        child: Image.asset(
                          'assets/images/clock.png',
                          width: 27.47,
                          height: 27.5,
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome, '.tr,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 16,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          TextSpan(
                            text: parentName,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 16,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Color(0xff442B72),
                        size: 35,
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
                      // if(children.isEmpty)
                      const SizedBox(
                        height: 25,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 20),
                        child: BusComponent(),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Your Children'.tr,
                          style: TextStyle(
                            color: Color(0xFF616161),
                            fontSize: 17,
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w600,
                            height: 0.94,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),

                      sharedpref!.getInt('invit') == 1 ?

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child:  ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: childrenData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return
                                Column(
                                  children: [
                                    ChildCard(childrenData[index]),
                                    SizedBox(height: 15,)
                                  ],
                                );
                            },
                          ),)
                          :
                          Column(
                            children: [
                              SizedBox(height: 45,),
                              Image.asset('assets/images/Group 237684.png',
                              ),
                              Text('No Data Found'.tr,
                                style: TextStyle(
                                  color: Color(0xff442B72),
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                ),
                              ),
                              Text('You haven’t added any \n '
                                  'data yet'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffBE7FBF),
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),)
                            ],
                          ),
                      const SizedBox(
                        height: 44,
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                  builder: (context) => ProfileParent(
                      // onTapMenu: onTapMenu
                      )));
            },
            child: Image.asset(
              'assets/images/174237 1.png',
              height: 33,
              width: 33,
              fit: BoxFit.cover,
            ),
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
                                Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 7, right: 15)
                                          : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (6).png',
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationsParent()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        (sharedpref?.getString('lang') == 'ar')
                                            ? EdgeInsets.only(top: 7, left: 70)
                                            : EdgeInsets.only(right: 70),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/Vector (2).png',
                                            height: 16.56,
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
                                                AttendanceParent()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        (sharedpref?.getString('lang') == 'ar')
                                            ? EdgeInsets.only(
                                                top: 12, bottom: 4, right: 10)
                                            : EdgeInsets.only(
                                                top: 10, bottom: 4, left: 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/Vector (3).png',
                                            height: 18.75,
                                            width: 18.75),
                                        SizedBox(height: 3),
                                        Text(
                                          "Calendar".tr,
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
                                                TrackParent()),
                                      );
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        (sharedpref?.getString('lang') == 'ar')
                                            ? EdgeInsets.only(
                                                top: 10,
                                                bottom: 2,
                                                right: 12,
                                                left: 15)
                                            : EdgeInsets.only(
                                                top: 10,
                                                bottom: 2,
                                                left: 12,
                                                right: 15),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/Vector (4).png',
                                            height: 18.36,
                                            width: 23.5),
                                        SizedBox(height: 3),
                                        Text(
                                          "Track".tr,
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
                          )))))),
    );
  }
}
