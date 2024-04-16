import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/supervisor_parent/components/elevated_icon_button.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/map_parent.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';

class FinalAcceptInvitationSupervisor extends StatefulWidget {
  const FinalAcceptInvitationSupervisor({super.key});

  @override
  State<FinalAcceptInvitationSupervisor> createState() => _FinalAcceptInvitationSupervisorState();
}

class _FinalAcceptInvitationSupervisorState extends State<FinalAcceptInvitationSupervisor> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 500), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeForSupervisor()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFFFFF),
          body: LayoutBuilder(builder: (context, constrains) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight,
                minWidth: constrains.maxWidth,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Group 237669.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/Confirmed-rafiki 1.png',
                        width: constrains.maxWidth / 1.77,
                        height: constrains.maxWidth / 1.77,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'You have an invitation \n'.tr,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 19,
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            TextSpan(
                              text: 'from El Salam School to \n '
                                  'join the application as a bus \n '
                                  'supervisor for your school'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 19,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                            width: 138,
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF442B72),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.zero
                              ),
                              onPressed: () {
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/white_check.png',
                                    width: 18.41,
                                    height: 14.12,
                                  ),
                                  (sharedpref?.getString('lang') == 'ar')?
                                  SizedBox(width: 10,):
                                  SizedBox(width: 5,),
                                  Text('Accepted'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins-Regular',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),)
      
                                ],
                              ),),
                          ),
                        ),
                        (sharedpref?.getString('lang') == 'ar')?
                        SizedBox(width: 0,):
                        SizedBox(width: 10,),
                        SizedBox(
                            height: 38,
                            width: 109,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color(0xFF442B72),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                      'Decline'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF442B72),
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w600 ,
                                          fontSize: 16)
                                  ),
                                ), onPressed: () {  },
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
