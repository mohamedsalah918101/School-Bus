import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/parents_card.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/supervisor_parent/components/profile_card_in_supervisor.dart';
import 'package:school_account/supervisor_parent/components/parents_card_in_student.dart';
import 'package:school_account/supervisor_parent/components/student_card_in_student.dart';
import 'package:school_account/supervisor_parent/components/students_card_in_home.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import '../components/bus_component.dart';
import '../components/main_bottom_bar.dart';
import '../components/supervisor_card.dart';
import 'notification_parent.dart';
class StudentScreen extends StatefulWidget {
  final String? name;
  final String? grade;
  final String? address;
  final String phonenumber;
  final String? ParentName;

  StudentScreen({ this.name,  this.grade,  this.address , required this.phonenumber , this.ParentName});

  @override
  _StudentScreen createState() => _StudentScreen();
}
class _StudentScreen extends State<StudentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<QueryDocumentSnapshot> data = [];
  final _firestore = FirebaseFirestore.instance;
  bool dataLoading=false;

  void _makePhoneCall() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(widget.phonenumber);
    if (!res!) {
      print("Failed to make the call");
    }
  }

  getData()async{
    setState(() {
      dataLoading =true;

    });
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('parent').get();
    data.addAll(querySnapshot.docs);
    setState(() {
      dataLoading =false;

    });
  }

  @override
  void initState() {

    getData();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
              child: Row(
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
                    'Student'.tr,
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
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if(children.isEmpty)

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text('Child'.tr,
                          style: TextStyle(
                            color: Color(0xFF771F98),
                            fontSize: 19,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                          ),),
                      ),


                      // Text('Gender: ${childData['gender']}'),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                              SizedBox(
                              width: double.infinity,
                              height:  92,
                              child: Card(
                                elevation: 10,
                                color: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: Padding(
                                    padding: (sharedpref?.getString('lang') == 'ar')?
                                    EdgeInsets.only(right: 10.0 , bottom: 0):
                                    EdgeInsets.only(left: 10.0 , bottom: 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                      radius: 25,
                                                      backgroundColor: Color(0xff442B72),
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                                        radius: 25,
                                                      ),
                                                    );
                                                  }

                                                  Map<String, dynamic>? data = snapshot.data?.data();
                                                  if (data != null && data['busphoto'] != null) {
                                                    return CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Color(0xff442B72),
                                                      child: CircleAvatar(
                                                        backgroundImage: NetworkImage('${data['busphoto']}'),
                                                        radius:25,
                                                      ),
                                                    );
                                                  }
                                                }

                                                return Container();
                                              },
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    // 'Gender: ${childData['gender']}',
                                                   '${widget.name}',
                                                    style: TextStyle(
                                                      color: Color(0xff442B72),
                                                      fontSize: 17,
                                                      fontFamily: 'Poppins-SemiBold',
                                                      fontWeight: FontWeight.w600,
                                                      height: 0.94,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Grade: '.tr,
                                                        style: TextStyle(
                                                          color: Color(0xFF919191),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins-Light',
                                                          fontWeight: FontWeight.w400,
                                                          // height: 1.33,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:'${widget.grade}',
                                                        style: TextStyle(
                                                          color: Color(0xFF442B72),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins-Light',
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Address: '.tr,
                                                        style: TextStyle(
                                                          color: Color(0xFF919191),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins-Light',
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '${widget.address}',
                                                        style: TextStyle(
                                                          color: Color(0xFF442B72),
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins-Light',
                                                          fontWeight: FontWeight.w400,
                                                          height: 1.33,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),

                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                                // StudentCardInStudent(childData: {},),
                                SizedBox(height:10),
                              ],
                            );
                          },
                        )

                      ),
                      SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text('Parent'.tr,
                      style: TextStyle(
                        color: Color(0xFF771F98),
                        fontSize: 19,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.w700,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                          SizedBox(
                          width: double.infinity,
                          height:125,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Padding(
                                padding:(sharedpref?.getString('lang') == 'ar')?
                                EdgeInsets.only(right: 10.0 ):
                                EdgeInsets.only(left: 10.0 ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                                  radius: 25,
                                                  backgroundColor: Color(0xff442B72),
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                                    radius: 25,
                                                  ),
                                                );
                                              }

                                              Map<String, dynamic>? data = snapshot.data?.data();
                                              if (data != null && data['busphoto'] != null) {
                                                return CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: Color(0xff442B72),
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage('${data['busphoto']}'),
                                                    radius:25,
                                                  ),
                                                );
                                              }
                                            }

                                            return Container();
                                          },
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                '${widget.ParentName}',
                                                style: TextStyle(
                                                  color: Color(0xff442B72),
                                                  fontSize: 17,
                                                  fontFamily: 'Poppins-SemiBold',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.94,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Number: '.tr,
                                                    style: TextStyle(
                                                      color: Color(0xFF919191),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      // height: 1.33,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '${widget.phonenumber}',
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      // height: 1.33,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Address: '.tr,
                                                    style: TextStyle(
                                                      color: Color(0xFF919191),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '${widget.address}',
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: (sharedpref?.getString('lang') == 'ar')?
                                              EdgeInsets.only(top: 8.0 , right: 150):
                                              EdgeInsets.only(top: 8.0 , left: 150),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                            _makePhoneCall();
                                                       },


                                                    child: Image.asset('assets/images/icons8_phone 1 (1).png' ,
                                                      color: Color(0xff442B72),
                                                      width: 28,
                                                      height: 28,),
                                                  ),
                                                  SizedBox(width: 9),
                                                  GestureDetector(
                                                    child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
                                                      color: Color(0xff442B72),
                                                      width: 26,
                                                      height: 26,),
                                                    onTap: () {
                                                      print('object');
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) =>
                                                              ChatScreen(
                                                                receiverName: widget.ParentName!,
                                                                receiverPhone: data[index]['phoneNumber'],
                                                                receiverId : data[index].id,
                                                              )));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                            // ParentCardInStudent(),
                            SizedBox(height:10),
                          ],
                        );
                      },
                    ),),


                      const SizedBox(
                        height: 44,
                      ),

                    ],
                  )
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
