import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_switch.dart';
import '../components/dialogs.dart';
import '../components/elevated_icon_button.dart';
import '../components/elevated_simple_button.dart';
import '../components/home_drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Completer<GoogleMapController> _controller = Completer();
  bool tracking = true;
  bool isExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: HomeDrawer(),
          key: _scaffoldKey,
          appBar:PreferredSize(
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
      actions: [
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child:
      InkWell(
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
      title: Text('Settings'.tr ,
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
          //Custom().customAppBar(context, 'Settings'),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      height: 0.89,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  trailing: CustomSwitch(),
                ),
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text(
                      'Language',
                      style: TextStyle(
                        color: Color(0xFF771F98),
                        fontSize: 15,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        height: 1.54,
                      ),
                    ),
                    trailing: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Color(0xffC8C8C8),
                      size: 24,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() => isExpanded = expanded);
                    },
                    children: [
                      ListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/imgs/school/icons8_egypt 1.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              const Text(
                                'عربى',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 15,
                                  fontFamily: 'Cairo-Regular',
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
                                  letterSpacing: -0.22,
                                ),
                              ),
                            ],
                          )),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.47,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0x14091C3F),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/imgs/school/icons8_usa_1 1.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              const Text(
                                'English',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 15,
                                  fontFamily: 'Cairo-Regular',
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
                                  letterSpacing: -0.22,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFFFC53D),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                  child: Text(
                    'Advanced',
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      height: 0.89,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Fingerprint and Face ID',
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  trailing: CustomSwitch(),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    'Alarm',
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  trailing: CustomSwitch(),
                ),
                const SizedBox(
                  height: 40,
                ),

                // Center(
                //   child: ElevatedButton(onPressed: (){},
                //     style: ElevatedButton.styleFrom(
                //         primary: Color(0xff442B72), // Background color
                //         onPrimary: Colors.white, // Text color
                //
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10), // Rounded corners
                //         ),),
                //       child: Text("Delete Account",style: TextStyle(fontSize: 16,fontFamily:"Poppins-Medium" ),)),
                // )
                Container(
                  height: 50,
               color: Color(0xFFcfcfcf),
                    child: GestureDetector(
                      onTap: (){
                        Dialoge.deleteAccoubtDialog(context);
                      },
                      child: Row(
                  children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Image.asset('assets/imgs/school/icons8_Delete 1.png',width: 20,height: 20,),
                      ),
                      Text("Delete Account",style: TextStyle(fontSize: 16,fontFamily:"Poppins-Medium",color: Color(0xffF13939) ),),
                  ],
                ),
                    ))

              ],

            ),
          )),
    );
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      // print('Switch Button is OFF');
    }
  }

}
