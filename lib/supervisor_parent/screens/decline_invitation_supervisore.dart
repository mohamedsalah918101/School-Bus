import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_icon_button.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/login_screen.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';

class DeclineInvitationForSupervisor extends StatefulWidget {
  const DeclineInvitationForSupervisor({super.key});

  @override
  State<DeclineInvitationForSupervisor> createState() => _DeclineInvitationForSupervisorState();
}

class _DeclineInvitationForSupervisorState extends State<DeclineInvitationForSupervisor> {


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
                        'assets/images/decline.png',
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
                              text: 'You have declined \n'.tr,
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
                              text: 'or cancelled your invitation. \n'
                                        'If this was unintentional,\n'
                                        'please contact your school \n'
                                        'to request another invitation \n'
                                        'to use the application'.tr,
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
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       SizedBox(
                         width: (sharedpref?.getString('lang') == 'ar')?
                         137 : 117,
                         height: 38,
                         child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Color(0xFF442B72),
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10)
                             ),
                           ),
                           onPressed: (){
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) => LoginScreen(
                                 )));
                           },
                           child: Text('log out'.tr,
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 16,
                                 fontFamily: 'Poppins-SemiBold',
                                 fontWeight: FontWeight.w600  ,)),),
                       ),
                        SizedBox(width: 20,),
                        SizedBox(
                          width: 117,
                            height: 38,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xFF442B72),
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/check_purple.png' ,
                                  width: 18.41,
                                  height: 14.12,),
                                  SizedBox(width: 5,),
                                  Text(
                                      'Declined'.tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF442B72),
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500 ,
                                          fontSize: 16)
                                  ),
                                ],
                              ), onPressed: () {  },
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
