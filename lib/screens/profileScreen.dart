import 'dart:async';

//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_account/screens/editeProfile.dart';
import 'package:school_account/screens/supervisorScreen.dart';
//import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import '../components/home_drawer.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'notificationsScreen.dart';
import 'dart:math' as math;
//import '../components/profile_child_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
        key: _scaffoldKey,
      endDrawer: HomeDrawer(),
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
            leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 23,
                color: Color(0xff442B72),
              ),

            ),
            //menu icon and drawer
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child:
            //     InkWell(
            //       onTap: (){
            //         _scaffoldKey.currentState!.openEndDrawer();
            //       },
            //       child: const Icon(
            //         Icons.menu_rounded,
            //         color: Color(0xff442B72),
            //         size: 35,
            //       ),
            //     ),
            //   ),
            // ],
            title: Text('Profile'.tr ,
              style: const TextStyle(
                color: Color(0xFF993D9A),
                fontSize: 17,
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.w700,
                height: 1,
              ),),
            backgroundColor:  Color(0xffF8F8F8),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
        //Custom().customAppBar(context, 'Profile'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //
                //     Center(
                //       child: Stack(
                //         children: [
                //
                //           Center(
                //             child: Padding(
                //               padding: const EdgeInsets.only(top: 20),
                //               child: CircleAvatar(
                //                 backgroundColor: Colors.white, // Set background color to white
                //                 radius:50, // Set the radius according to your preference
                //                 child: Image.asset(
                //                   'assets/imgs/school/Ellipse 2 (2).png',
                //                   fit: BoxFit.cover,
                //                   width: 100, // Set width of the image
                //                   height: 100, // Set height of the image
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Center(
                //             child: Padding(
                //               padding: const EdgeInsets.only(top: 95,left: 55),
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   border: Border.all(width: 3,color: Color(0xff432B72))
                //                 ),
                //                 child: CircleAvatar(
                //                   backgroundColor: Colors.white,
                //                   // Set background color to white
                //                   radius:10, // Set the radius according to your preference
                //                   child: Image.asset(
                //                     'assets/imgs/school/edite.png',
                //                     fit: BoxFit.cover,
                //                     width: 15, // Set width of the image
                //                     height: 15, // Set height of the image
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ]
                //       ),
                //     ),
                //     SizedBox(width: 55,),
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=>EditeProfile()));
                //       },
                //       style: ElevatedButton.styleFrom(
                //         primary: Colors.white,
                //         //elevation: 4, // Change the elevation to adjust the shadow
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8.0),
                //             side: BorderSide(color: Color(0xff432B72))
                //
                //         ),
                //       ),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           // Icon(Icons.,color: Color(0xff432B72),),
                //           Transform(
                //               alignment: Alignment.center,
                //               transform: Matrix4.rotationY(math.pi),
                //               child: Icon(Icons.edit_outlined, color: Color(0xFF442B72),size: 20,)
                //           ),
                //           SizedBox(width: 8), // Adjust the spacing between icon and text
                //           Text('Edite',style: TextStyle(color: Color(0xff432B72),fontSize: 16,fontFamily: "Poppins-Regular"),), // Replace 'Button Text' with your desired text
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                //
                Stack(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                child: Image.asset(
                                  'assets/imgs/school/Ellipse 2 (2).png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 95, left: 55),
                              child: GestureDetector(
                                onTap: (){
                                  Dialoge.changePhotoDialog(context);
                                },
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3, color: Color(0xff432B72)),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,

                                    child: Image.asset(
                                      'assets/imgs/school/edite.png',
                                      fit: BoxFit.cover,
                                      width: 15,
                                      height: 15,

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top:15,
                      right: 5,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditeProfile()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Color(0xff432B72)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset("assets/imgs/school/icons8_edit_1 1 (1).png",width: 17,height: 17,),
                            // Transform(
                            //   alignment: Alignment.center,
                            //   transform: Matrix4.rotationY(math.pi),
                            //   child:
                            //   Icon(Icons.edit_outlined, color: Color(0xFF442B72), size: 20),
                            // ),
                            SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: TextStyle(color: Color(0xff432B72), fontSize: 16, fontFamily: "Poppins-Regular"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                Center(child: Text("Salam School",style: TextStyle(color: Color(0xff432B72),fontSize: 20,fontFamily: "Poppins-SemiBold"),)
                ),
                SizedBox(height: 20,),
                Text("School information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                    color: Color(0xff771F98)),),
                SizedBox(height: 15,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('School name in English'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text("Salam School",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                  ),
                ),
                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('School name in Arabic'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text("مدرسة السلام الاعدادية الثانويه المشتركة",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                  ),
                ),
                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/icons8_Location.png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Address'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text("16 Khaled st, Asyut,Egypt",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                  ),
                ),
                SizedBox(height: 10,),
                Text("Personal information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                    color: Color(0xff771F98)),),
                SizedBox(height: 15,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Coordinator Name'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text("Shady Ayman",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                  ),
                ),
                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector24.png',width: 18,height: 18,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Support Number'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    child: Text("01028765006",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                  ),
                ),
              ],
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton:
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          //height: 100,
          child: FloatingActionButton(
            backgroundColor: Color(0xff442B72),
            onPressed: () async {
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
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


      bottomNavigationBar:
      Directionality(
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
                            horizontal: 2.0,
                            vertical:5),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                              context ,
                              MaterialPageRoute(
                                  builder: (context) =>  HomeScreen(),
                                  maintainState: false),
                            );
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/icons8_home_1 1.png',
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
