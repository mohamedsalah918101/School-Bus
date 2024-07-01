// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget{
//   @override
//   State<HomeScreen> createState() {
//    return HomeScreenSate();
//   }
//
// }
// class HomeScreenSate extends State<HomeScreen>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Container(),);
//   }
//
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/addBus.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/parentsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/sendInvitationScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'homeScreen.dart';



class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DocumentSnapshot>> _parentData = Future.value([]);
  MyLocalController ControllerLang = Get.find();
  //final colorC = Color.alphaBlend(Color(0xffBE7FBF), Color(0xffFFFFFF));
  Color color1 = Color(0xFFBE7FBF);
  Color color2 = Colors.white;
  Color color4=Color(0xffA79FD9);
 //code disable button
  int _counter = 0;
  // هنا تقوم بتعريف الحالة
  bool _isButtonDisabled= true;
  final _firestore = FirebaseFirestore.instance;
  void _incrementCounter() {
    setState(() {
      _isButtonDisabled = true;
      _counter++;
    });
  }
  List<Widget> Parent = [];
  List<QueryDocumentSnapshot> data = [];

  Future<void> getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('parent').where('state', isEqualTo:1).where('schoolid',isEqualTo:sharedpref!.getString('id') ).get();
    data.addAll(querySnapshot.docs);
    if (mounted) {
      setState(() {});
    }
  }
  String? _schoolId;
  Future<void> getSchoolId() async {
    try {
      _schoolId = sharedpref!.getString('id');
      print("SCHOOLID$_schoolId");
      // If the school ID is not found in SharedPreferences, you can handle this case
      if (_schoolId == null) {
        // You can either throw an exception or set a default value
        throw Exception('School ID not found in SharedPreferences');
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error retrieving school ID: $e');
    }
  }

  int numberbuses=0;
  // Future<int> getNumberOfBuses(String schoolId) async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('busdata')
  //         .where('schoolid', isEqualTo: schoolId)
  //         .get();
  //
  //     return querySnapshot.docs.length;
  //   } catch (e) {
  //     print("Error getting number of buses: $e");
  //     return 0; // Return 0 or handle error as needed
  //   }
  // }
  Future<int> getNumberOfBuses(String schoolId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('busdata')
          .where('schoolid', isEqualTo: schoolId)
          .get();

      print('Number of buses: ${querySnapshot.docs.length}');

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting number of buses: $e");
      return 0; // Return 0 or handle error as needed
    }
  }

  int numbersupervisors=0;
  // Future<int> getNumberOfSupervisors(String schoolId) async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('supervisor')
  //         .where('schoolid', isEqualTo: schoolId)
  //         .get();
  //
  //     return querySnapshot.docs.length;
  //   } catch (e) {
  //     print("Error getting number of supervisors: $e");
  //     return 0; // Return 0 or handle error as needed
  //   }
  // }
  Future<int> getNumberOfSupervisors(String schoolId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('supervisor')
          .where('schoolid', isEqualTo: schoolId)
          .get();

      print('Number of supervisors: ${querySnapshot.docs.length}');

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error getting number of supervisors: $e");
      return 0; // Return 0 or handle error as needed
    }
  }

//  late Future<List<DocumentSnapshot>> _parentData;
//   Future<List<DocumentSnapshot>> _getParentData() async {
//     QuerySnapshot querySnapshot =
//     await FirebaseFirestore.instance.collection('parent').get();
//     return querySnapshot.docs;
//   }

// to lock in landscape view
  Future<int>? _numberOfBuses;
  Future<int>? _numberOfSupervisors;
  @override
  void initState() {
    super.initState();
    // responsible
    getData();
    getSchoolId().then((_) {
      if (_schoolId!= null) {
        _numberOfBuses = getNumberOfBuses(_schoolId!);
        _numberOfSupervisors = getNumberOfSupervisors(_schoolId!);
      } else {
        print('School ID is null');
      }
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color blendedColor = Color.lerp(color1, color2, 0.5) ?? Colors.transparent;
    Color blendedColorTwo = Color.lerp(color4, color2, 0.5) ?? Colors.transparent;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child:Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child:
                        FutureBuilder(
                          future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.done) {
                              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                data['nameEnglish'],
                                style: TextStyle(
                                  color: Color(0xFF993D9A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins-Bold',
                                ),
                              );
                            }

                            return CircularProgressIndicator();
                          },
                        ),

                        // Text(
                        //                   "Salam Language School".tr,
                        //                   style: TextStyle(
                        //                     color: Color(0xFF993D9A),
                        //                     fontSize: 16,
                        //                     fontFamily: 'Poppins-Bold',
                        //                     fontWeight: FontWeight.w700,
                        //                     height: 0.64,
                        //                   ),
                        //                 ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: InkWell(onTap: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: const Icon(
                          Icons.menu_rounded,
                          size: 40,
                          color: Color(0xff442B72),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      

                      // const SizedBox(
                      //   height: 30,
                      // ),

                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Stack(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top:5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileScreen(),
                                          maintainState: false,
                                        ),
                                      );
                                    },
                                    child: Container(

                                      decoration: BoxDecoration(
                                          color: Colors.white, // Your desired background color
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8),
                                          ]
                                      ),
                                      child:

                                      // ListTile(
                                      //   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      //   leading: GestureDetector(
                                      //       onTap: (){
                                      //         Navigator.push(
                                      //             context ,
                                      //             MaterialPageRoute(
                                      //                 builder: (context) =>  ProfileScreen(),
                                      //                 maintainState: false));
                                      //       },
                                      //       child: Image.asset('assets/imgs/school/Ellipse 2 (2).png',width: 61,height: 61,)),
                                      //   //title: Text('Supervisors'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',),),
                                      //   title: Text(
                                      //     'Salam Language School'.tr,
                                      //     style: TextStyle(
                                      //       color: Color(0xFF442B72),
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.bold,
                                      //       fontFamily: 'Poppins-Bold',
                                      //     ),
                                      //   ),
                                      //   subtitle: Text("16 Khaled st , Asyut , Egypt",style: TextStyle(fontSize: 12,fontFamily: "Poppins-Regular",color: Color(0xff442B72)),),
                                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                      //     tileColor: Colors.white,
                                      // ),
                                      FutureBuilder(
                                        future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Something went wrong');
                                          }

                                          if (snapshot.connectionState == ConnectionState.done) {
                                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                            return ListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              leading: data['photo'] != null ? ClipOval(
                                                child: Image.network(data['photo'], width: 61, height: 61,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/school (2) 1.png', width: 61, height: 61); // Display a default image if loading fails
                                                  },
                                                ),
                                              ):Image.asset('assets/images/school (2) 1.png', width: 61, height: 61),
                                              title: Text(
                                                data['nameEnglish'],
                                                style: TextStyle(
                                                  color: Color(0xFF442B72),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins-Bold',
                                                ),
                                              ),
                                              subtitle: Text(
                                                data['address'],
                                                style: TextStyle(fontSize: 12, fontFamily: "Poppins-Regular", color: Color(0xff442B72)),
                                              ),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                              tileColor: Colors.white,
                                            );
                                          }

                                          return CircularProgressIndicator();
                                        },
                                      )
                                    ),
                                  ),
                                  SizedBox(height: 30,),

                                  Container(
                                    width:320,
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 0.20,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                          color: Color(0xffA79FD9),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 135,
                                        height: 129,
                                        decoration: BoxDecoration(
                                          color:blendedColor, // Your desired background color
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Align(alignment: AlignmentDirectional.topStart,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Image.asset("assets/imgs/school/bus 2.png",width: 50,height: 50,),
                                                  ),
                                                SizedBox(width: 28,),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBus()));
                                                    },
                                                    child: Container(width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                      color:Color(0xff442B72), // Your desired background color
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),child: Icon(Icons.add,color:blendedColor,size: 19,),),
                                                  )
                                                ],
                                              ),
                                              Align(alignment: AlignmentDirectional.bottomStart,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text("Buses".tr,style: TextStyle(fontSize: 14,fontFamily:"Poppins-SemiBold",color: Color(0xff442B72) ),),
                                                  )),
                                              Align(alignment: AlignmentDirectional.bottomStart,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child:  FutureBuilder<int>(
                                                      future: _numberOfBuses,
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Text('# ${snapshot.data}',style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),);
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          return Text('Loading...');
                                                        }
                                                      },
                                                    ),
                                                    //Text("#15",style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),),
                                                  )),
                                              Align(
                                                alignment: AlignmentDirectional.bottomEnd,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BusScreen()));
                                                  },
                                                  child: Align(alignment: AlignmentDirectional.bottomEnd,
                                                    child: Container(
                                                      width: 57,
                                                      height: 29,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xff442B72),
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                        bottomRight: Radius.circular(7)),

                                                      ),
                                                      child: Align(
                                                          alignment: AlignmentDirectional.bottomCenter,
                                                        child: Icon(Icons.arrow_right_alt_outlined,color: Colors.white,size: 30,)
                                                    //     FaIcon(
                                                    //     FontAwesomeIcons.arrowRight,
                                                    //     color: Colors.white,
                                                    //     size: 20,
                                                    // ),
                                                      ),),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      //SizedBox(width: 10,),
                                      Container(
                                        width: 135,
                                        height: 129,
                                        decoration: BoxDecoration(
                                          color:blendedColorTwo, // Your desired background color
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Align(alignment: AlignmentDirectional.topStart,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Image.asset("assets/imgs/school/supervisorH.png",width: 50,height: 50,),
                                                  ),
                                                  SizedBox(width: 28,),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SendInvitation()));
                                                    },
                                                    child: Container(width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color:Color(0xff442B72), // Your desired background color
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),child: Icon(Icons.add,color:blendedColorTwo,size: 19,),),
                                                  )
                                                ],
                                              ),
                                              Align(alignment: AlignmentDirectional.bottomStart,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text("Supervisors".tr,style: TextStyle(fontSize: 14,fontFamily:"Poppins-SemiBold",color: Color(0xff442B72) ),),
                                                  )),
                                              Align(alignment: AlignmentDirectional.bottomStart,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child:
                                                    FutureBuilder<int>(
                                                      future: _numberOfSupervisors,
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Text('# ${snapshot.data}',style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),);
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          return Text('Loading...');
                                                        }
                                                      },
                                                    ),
                                                    //Text("#15",style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),),
                                                  )),
                                              Align(alignment: AlignmentDirectional.bottomEnd,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SupervisorScreen()));
                                                  },
                                                  child: Container(
                                                    width: 57,
                                                    height: 29,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff442B72),
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(15),
                                                          bottomRight: Radius.circular(7)),

                                                    ),
                                                    child: Align(alignment: AlignmentDirectional.bottomCenter,
                                                        child: Icon(Icons.arrow_right_alt_outlined,color: Colors.white,size: 30,)
                                                      //     FaIcon(
                                                      //     FontAwesomeIcons.arrowRight,
                                                      //     color: Colors.white,
                                                      //     size: 20,
                                                      // ),
                                                    ),),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),

                                  Container(
                                    width:320,
                                    decoration: const ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 0.20,
                                          strokeAlign: BorderSide.strokeAlignCenter,
                                          color: Color(0xffA79FD9),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(alignment: AlignmentDirectional.centerStart,
                                            child: Text("Parents".tr,style: TextStyle(color: Color(0xff442B72)
                                                ,fontSize: 16,fontFamily:"Poppins-SemiBold" ),)),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ParentsScreen()));
                                        },
                                        child: Align(alignment: AlignmentDirectional.centerEnd,
                                            child: Text("Show all".tr, style: TextStyle(
                                              fontFamily: "Poppins-Regular",
                                              fontSize: 15,
                                              color: Color(0xff442B72),
                                              decoration: TextDecoration.underline,
                                              decorationColor: Color(0xff442B72), // Optional: Set color of underline
                                              decorationStyle: TextDecorationStyle.solid, // Optional: Set style of underline
                                            ),)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  // right code
                                  // SizedBox(
                                  //   height: 500,
                                  //   child: ListView.builder(
                                  //      // shrinkWrap: true,
                                  //       itemCount: data.length,
                                  //       itemBuilder: (context, index) {
                                  //         return
                                  //          Column(
                                  //           children: [
                                  //             Row(
                                  //               children: [
                                  //                 Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                  //            SizedBox(width: 10,),
                                  //             Text(
                                  //             '${data[index]['name'] }',
                                  //             style: TextStyle(
                                  //             color: Color(0xFF442B72),
                                  //             fontSize: 15,
                                  //             fontWeight: FontWeight.bold,
                                  //             fontFamily: 'Poppins-SemiBold',
                                  //             ),
                                  //             )
                                  //               ],
                                  //             ),
                                  //         Text(
                                  //         '${data[index]['phoneNumber'] }',
                                  //         style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),)
                                  //
                                  //         ],
                                  //         );
                                  //
                                  //   }),
                                  // ),
                                  if (data.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Text('No Parents',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  if (data.isNotEmpty)
                                  SizedBox(
                                    height: 400,
                                    // height: Parent.length*325,
                                    // width: double.infinity,
                                    child: ListView.builder(
                                     physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Container(height: 16,),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white, // Your desired background color
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                                    ]
                                                ),
                                              child:
                                              Column(
                                                children: [
                                                  ListTile(
                                                    leading:Container(
                                                      width:40,
                                                        height:40,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Color(0xffCCCCCC),
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top:10,bottom: 3),
                                                          child: Image.asset("assets/imgs/school/Vector (16).png",width: 15,height: 15,),
                                                        ))

                                                    // Image.asset(
                                                    //   'assets/imgs/school/imgparent.png',
                                                    //   width: 40,
                                                    //   height: 40,
                                                    // ),
                                                    ,title: Text(
                                                      '${data[index]['name']}',
                                                      style: TextStyle(
                                                        color: Color(0xFF442B72),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Poppins-SemiBold',
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      '${data[index]['phoneNumber']}',
                                                      style: TextStyle(
                                                        color: Color(0xff442B72),
                                                        fontSize: 14,
                                                        fontFamily: "Poppins-Regular",
                                                      ),
                                                    ),
                                                    // You can add trailing icons or other widgets here if needed
                                                    // trailing: Icon(Icons.arrow_forward),
                                                    // onTap: () {
                                                    //   // Add onTap functionality if required
                                                    // },
                                                  ),


                                                ],
                                              ),

                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  // FutureBuilder<List<DocumentSnapshot>>(
                                  //   future: _parentData,
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                                  //       return Center(child: CircularProgressIndicator());
                                  //     }
                                  //
                                  //     if (snapshot.hasError) {
                                  //       return Center(child: Text('Error: ${snapshot.error}'));
                                  //     }
                                  //
                                  //     List<DocumentSnapshot>? parentDocs = snapshot.data;
                                  //     if (parentDocs == null || parentDocs.isEmpty) {
                                  //       return Center(child: Text('No data available'));
                                  //     }
                                  //
                                  //     return ListView.builder(
                                  //       itemCount: parentDocs.length,
                                  //       itemBuilder: (context, index) {
                                  //         Map<String, dynamic> data =
                                  //         parentDocs[index].data() as Map<String, dynamic>;
                                  //         String name = data['name'] ?? '';
                                  //         String phoneNumber = data['phoneNumber'] ?? '';
                                  //
                                  //         return ListTile(
                                  //           title: Text(name),
                                  //           subtitle: Text(phoneNumber),
                                  //           leading: Icon(Icons.person),
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white, // Your desired background color
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       boxShadow: [
                                  //         BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  //       ]
                                  //   ),
                                  //   child:
                                  //   ListTile(
                                  //     leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                  //     //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                  //     title: Text(
                                  //       'Shady Aymen'.tr,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF442B72),
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.bold,
                                  //         fontFamily: 'Poppins-SemiBold',
                                  //       ),
                                  //     ),
                                  //     subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white, // Your desired background color
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       boxShadow: [
                                  //         BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  //       ]
                                  //   ),
                                  //   child:
                                  //   ListTile(
                                  //     leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                  //     //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                  //     title: Text(
                                  //       'Shady Aymen'.tr,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF442B72),
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.bold,
                                  //         fontFamily: 'Poppins-SemiBold',
                                  //       ),
                                  //     ),
                                  //     subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white, // Your desired background color
                                  //       borderRadius: BorderRadius.circular(10),
                                  //       boxShadow: [
                                  //         BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  //       ]
                                  //   ),
                                  //   child:
                                  //   ListTile(
                                  //     leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                  //     //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                  //     title: Text(
                                  //       'Shady Aymen'.tr,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF442B72),
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.bold,
                                  //         fontFamily: 'Poppins-SemiBold',
                                  //       ),
                                  //     ),
                                  //     subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height:50,
                                  ),
                                  // SizedBox(height: 40,),
                                  // Container( decoration: BoxDecoration(
                                  //     color: Colors.white, // Your desired background color
                                  //     borderRadius: BorderRadius.circular(5),
                                  //     boxShadow: [
                                  //       BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  //     ]
                                  // ),
                                  //   child: ListTile(
                                  //     onTap:(){
                                  //       Navigator.push(
                                  //           context ,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>  ParentsScreen(),
                                  //               maintainState: false));
                                  //       // _key.currentState!.openDrawer();
                                  //     } ,
                                  //     //leading: Image.asset('assets/imgs/school/mdi_account-supervisor-outline (2).png',color: Color(0xFF442B72),width: 24,height: 24,),
                                  //     //title: Text('Parents'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                  //     title: Padding(
                                  //       padding: const EdgeInsets.only(left: 4.0), // Adjust the left padding as needed
                                  //       child: Row(
                                  //
                                  //         children: [
                                  //           Image.asset(
                                  //             'assets/imgs/school/mdi_account-supervisor-outline (2).png',
                                  //             color: Color(0xFF442B72),
                                  //             width: 26,
                                  //             height: 26,
                                  //           ),
                                  //           SizedBox(width: 8), // Add some space between the leading and title
                                  //           Expanded(
                                  //             child: Text(
                                  //               'Parents'.tr,
                                  //               style: TextStyle(
                                  //                 color: Color(0xFF442B72),
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.bold,
                                  //                 fontFamily: 'Poppins-Bold',
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )


                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),

                    ],
                  ),
                ),
              ),
            ],
          );
        }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:


        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Image.asset(

                //'assets/imgs/school/Ellipse 2 (2).png',
           'assets/imgs/school/busbottombar.png',
                width: 35,
                height: 35,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),


        bottomNavigationBar:Directionality(
          textDirection: TextDirection.ltr,
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
              shape: const AutomaticNotchedShape( RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.5),
                      topRight: Radius.circular(38.5))),
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(100)))),
              //CircularNotchedRectangle(),
              //shape of notch
              notchMargin: 7,
              child: SizedBox(
                height: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical:5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context ,
                                  MaterialPageRoute(
                                      builder: (context) =>  HomeScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset('assets/imgs/school/fillhome.png',
                                      height: 21, width: 21),
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
                              _isButtonDisabled ? _incrementCounter():null;
                              Navigator.push(
                                  context ,
                                  MaterialPageRoute(

                                      builder: (context) =>  NotificationScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset('assets/imgs/school/clarity_notification-line (1).png',
                                      height: 22, width: 22),
                                  Text('Notification'.tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:100),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context ,
                                  MaterialPageRoute(
                                      builder: (context) =>  SupervisorScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset('assets/imgs/school/empty_supervisor.png',
                                      height: 22, width: 22),
                                  Text("Supervisor".tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize:10)),
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context ,
                                  MaterialPageRoute(
                                      builder: (context) => BusScreen(),
                                      maintainState: false));
                              // _key.currentState!.openDrawer();
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset('assets/imgs/school/ph_bus-light (1).png',
                                      height: 22, width: 22),
                                  Text("Buses".tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ]),
                          ),
                        ),
                      ]
                    ),
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




