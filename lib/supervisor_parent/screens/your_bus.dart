import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:school_account/classes/loading.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import '../components/child_data_item.dart';


class YourBus extends StatefulWidget {
  @override
  _YourBusState createState() => _YourBusState();
}

class _YourBusState extends State<YourBus> {
  List<QueryDocumentSnapshot> data = [];
  String _namedriverText = ' ';
  String _photodriver = ' ';
  String _photobus = ' ';
  String _phonedriver = ' ';
  String _busnumber = ' ';
  String firstChildName = '';
  bool dataLoading=false;


  // Future<void> getDataForBus() async {
  //   setState(() {
  //     dataLoading = true;
  //   });
  //
  //   DocumentSnapshot supervisorDoc = await FirebaseFirestore.instance
  //       .collection('supervisor')
  //       .doc(sharedpref?.getString('id'))
  //       .get();
  //
  //   if (supervisorDoc.exists) {
  //     String busId = supervisorDoc['bus_id'];
  //
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('busdata')
  //         .where(FieldPath.documentId, isEqualTo: busId)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       var busData = querySnapshot.docs.first;
  //       String namedriver = busData['namedriver'];
  //       String photodriver = busData['imagedriver'];
  //       String photobus = busData['busphoto'];
  //       String phonedriver = busData['phonedriver'];
  //       String busnumber = busData['busnumber'];
  //
  //       setState(() {
  //         _namedriverText = namedriver;
  //         _photodriver = photodriver;
  //         _photobus = photobus;
  //         _phonedriver = phonedriver;
  //         _busnumber = busnumber;
  //       });
  //
  //       // جلب قائمة المشرفين
  //       List supervisors = busData['supervisors'];
  //
  //       if (supervisors.isNotEmpty) {
  //         setState(() {
  //           firstChildName = supervisors.first['name'];
  //         });
  //       } else {
  //         print('No supervisors found');
  //       }
  //     } else {
  //       print('No bus data found');
  //     }
  //   } else {
  //     print('Supervisor document does not exist');
  //   }
  //
  //   setState(() {
  //     dataLoading = false;
  //   });
  // }



  Future<void> getDataForBus() async {
    setState(() {
      dataLoading = true;
    });

    DocumentSnapshot supervisorDoc = await FirebaseFirestore.instance
        .collection('supervisor')
        .doc(sharedpref?.getString('id'))
        .get();

    if (supervisorDoc.exists) {
      String busId = supervisorDoc['bus_id'];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('busdata')
          .where(FieldPath.documentId, isEqualTo: busId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var busData = querySnapshot.docs.first;
        String namedriver = busData['namedriver'];
        String photodriver = busData['imagedriver'];
        String photobus = busData['busphoto'];
        String phonedriver = busData['phonedriver'];
        String busnumber = busData['busnumber'];

        setState(() {
          _namedriverText = namedriver;
          _photodriver = photodriver;
          _photobus = photobus;
          _phonedriver = phonedriver;
          _busnumber = busnumber;
        });

        List supervisors = busData['supervisors'];

        if (supervisors.length > 1) {
          setState(() {
            firstChildName = supervisors[1]['name'];
          });
        } else {
          setState(() {
            firstChildName = 'No second supervisor found';
          });
          print('No second supervisor found');
        }
      } else {
        print('No bus data found');
      }
    } else {
      print('Supervisor document does not exist');
    }

    setState(() {
      dataLoading = false;
    });
  }
  @override
  void initState() {
    getDataForBus();
    super.initState();
    setState(() {

    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<ChildDataItem> children = [];

  @override
  Widget build(BuildContext context) {
    if (dataLoading) {
      return Center(
        child: sharedpref!.getInt('invit') == 1 ?

        Loading(): Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child:  Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 17.0),
                      child: Image.asset(
                        (sharedpref?.getString('lang') == 'ar')?
                        'assets/images/Layer 1.png':
                        'assets/images/fi-rr-angle-left.png',
                        width: 20,
                        height: 22,),
                    ),
                  ),
                  Text(
                    'My Bus'.tr,
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
              SizedBox(height: 200,),
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
                  'buses yet'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffBE7FBF),
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),)
            ],
          ),
        ),
      );
    }
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child:  Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 17.0),
                          child: Image.asset(
                            (sharedpref?.getString('lang') == 'ar')?
                            'assets/images/Layer 1.png':
                            'assets/images/fi-rr-angle-left.png',
                            width: 20,
                            height: 22,),
                        ),
                      ),
                      Text(
                        'My Bus'.tr,
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
                  // children.isNotEmpty?
                  Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 31.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.5,
                              backgroundColor: Colors.cyan,
                              child: _photodriver != null && _photodriver.isNotEmpty
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(_photodriver),
                                radius: 25.5,
                              )
                                  : CircleAvatar(
                                backgroundImage: AssetImage('ssets/images/Group 237679 (2).png'), // Replace with your default image path
                                radius: 25.5,
                              ),
                            ),
          
          
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage( _photodriver ?? 'no data'),
                            //   radius: 25.5,
                            // ),
                            // NetworkImage(
                            //   _photodriver ?? 'no data',
                            //   // 'assets/images/Ellipse 1.png',
                            //   width: 50,
                            //   height: 50,),
                            SizedBox(width: 10,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text('Driver photo'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Driver Name'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                _namedriverText ?? 'no data',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                ),),
                            ),
                            SizedBox(height: 20,),
                            Text('Driver Number'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                  _phonedriver ?? 'no data',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                ),),
                            ),
                            SizedBox(height: 20,),
                            Text('Bus Photos'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Row(
                                children: [
                                  InteractiveViewer(
                                    // transformationController: _imagebuscontroller,
                                      child:(_photobus == null || _photobus == '') ?
                                      //Image.network(widget.oldphotobus),
                                      Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                      Image.network(_photobus!,width: 82,height: 80,fit: BoxFit.cover,)
                                  ),
                                  SizedBox(width: 10,),
                                  // InteractiveViewer(
                                  //   // transformationController: _imagebuscontroller,
                                  //     child:(_photobus == null || _photobus == '') ?
                                  //     //Image.network(widget.oldphotobus),
                                  //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                  //     Image.network(_photobus!,width: 82,height: 80,fit: BoxFit.cover,)
                                  // ),
                                  SizedBox(width: 10,),
                                  // InteractiveViewer(
                                  //   // transformationController: _imagebuscontroller,
                                  //     child:(_photobus == null || _photobus == '') ?
                                  //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                  //     Image.network(_photobus!,width: 82,height: 80,fit: BoxFit.cover,)
                                  // ),
          
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text('Bus Number'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(_busnumber,
                                textDirection: _getTextDirection(" 1458ى ر س "),
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                ),),
                            ),
                            SizedBox(height: 20,),
                            Text('Second Supervisor'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                firstChildName.isNotEmpty ? firstChildName : 'No second supervisor found',
                                // 'reham',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                ),),
                            ),
          
                          ],
                        ),
                      ),
                    ],
                  ),
                  //no data
                  //     :
                  // Column(
                  //   children: [
                  //     SizedBox(height: 200,),
                  //     Image.asset('assets/images/Group 237684.png',
                  //     ),
                  //     Text('No Data Found'.tr,
                  //       style: TextStyle(
                  //         color: Color(0xff442B72),
                  //         fontFamily: 'Poppins-Regular',
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 19,
                  //       ),
                  //     ),
                  //     Text('You haven’t added any \n '
                  //         'buses yet'.tr,
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         color: Color(0xffBE7FBF),
                  //         fontFamily: 'Poppins-Light',
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 12,
                  //       ),)
                  //   ],
                  // ),
                  const SizedBox(
                    height: 44,
                  ),
          
                ],
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
}

TextDirection _getTextDirection(String text) {
  // Determine the text direction based on text content
  if (text.contains(RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF\uFE70-\uFEFF\uFB50-\uFDFF\u2000-\u206F\u202A-\u202E\u2070-\u209F\u20A0-\u20CF\u2100-\u214F\u2150-\u218F]'))) {
    // RTL language detected
    return TextDirection.rtl;
  } else {
    // LTR language detected
    return TextDirection.ltr;
  }
}
