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
import 'homeScreen.dart';



class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  MyLocalController ControllerLang = Get.find();
  //final colorC = Color.alphaBlend(Color(0xffBE7FBF), Color(0xffFFFFFF));
  Color color1 = Color(0xFFBE7FBF);
  Color color2 = Colors.white;
  Color color4=Color(0xffA79FD9);
 //code disable button
  int _counter = 0;
  // هنا تقوم بتعريف الحالة
  bool _isButtonDisabled= true;

  //هنا بتعريق الدالة التي ستفوم بعمل الزيادة

  void _incrementCounter() {
    setState(() {
      _isButtonDisabled = true;
      _counter++;
    });
  }

// to lock in landscape view
  @override
  void initState() {
    super.initState();
    // responsible
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Text(
                            "Salam Language School".tr,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 16,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 0.64,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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

                // const SizedBox(
                //   height: 30,
                // ),

                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Stack(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top:5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(

                              decoration: BoxDecoration(
                                  color: Colors.white, // Your desired background color
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8),
                                  ]
                              ),
                              child:

                              ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                          context ,
                                          MaterialPageRoute(
                                              builder: (context) =>  ProfileScreen(),
                                              maintainState: false));
                                    },
                                    child: Image.asset('assets/imgs/school/Ellipse 2 (2).png',width: 61,height: 61,)),
                                //title: Text('Supervisors'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',),),
                                title: Text(
                                  'Salam Language School'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins-Bold',
                                  ),
                                ),
                                subtitle: Text("16 Khaled st , Asyut , Egypt",style: TextStyle(fontSize: 12,fontFamily: "Poppins-Regular",color: Color(0xff442B72)),),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  tileColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30,),

                            Container(
                              width:290,
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
                                              child: Text("Buses",style: TextStyle(fontSize: 16,fontFamily:"Poppins-SemiBold",color: Color(0xff442B72) ),),
                                            )),
                                        Align(alignment: AlignmentDirectional.bottomStart,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text("#15",style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),),
                                            )),
                                        Align(alignment: AlignmentDirectional.bottomEnd,
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BusScreen()));
                                            },
                                            child: Container(
                                              width: 57,
                                              height: 27,
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
                                              child: Text("Supervisors",style: TextStyle(fontSize: 16,fontFamily:"Poppins-SemiBold",color: Color(0xff442B72) ),),
                                            )),
                                        Align(alignment: AlignmentDirectional.bottomStart,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text("#15",style: TextStyle(fontSize: 12,fontFamily:"Poppins-Regular",color: Color(0xff442B72) ),),
                                            )),
                                        Align(alignment: AlignmentDirectional.bottomEnd,
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SupervisorScreen()));
                                            },
                                            child: Container(
                                              width: 57,
                                              height: 27,
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
                              width:290,
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
                                      child: Text("Parents",style: TextStyle(color: Color(0xff442B72)
                                          ,fontSize: 16,fontFamily:"Poppins-SemiBold" ),)),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ParentsScreen()));
                                  },
                                  child: Align(alignment: AlignmentDirectional.centerEnd,
                                      child: Text("Show all", style: TextStyle(
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
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, // Your desired background color
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  ]
                              ),
                              child:
                              ListTile(
                                leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                title: Text(
                                  'Shady Aymen'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins-SemiBold',
                                  ),
                                ),
                                subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, // Your desired background color
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  ]
                              ),
                              child:
                              ListTile(
                                leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                title: Text(
                                  'Shady Aymen'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins-SemiBold',
                                  ),
                                ),
                                subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, // Your desired background color
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                  ]
                              ),
                              child:
                              ListTile(
                                leading: Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                                //title: Text('Buses'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                title: Text(
                                  'Shady Aymen'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins-SemiBold',
                                  ),
                                ),
                                subtitle: Text("01028765006",style: TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily: "Poppins-Regular"),),
                              ),
                            ),
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
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Image.asset(

                //'assets/imgs/school/Ellipse 2 (2).png',
           'assets/imgs/school/Layer_1 3.png',
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

              color: const Color(0xFF442B72),
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              //shape of notch
              notchMargin: 7,
              child: SizedBox(
                height: 55,
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




