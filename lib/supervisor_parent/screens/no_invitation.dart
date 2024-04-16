import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_icon_button.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';

class NoInvitation extends StatefulWidget {
  // const NoInvitation({super.key});
  late final int selectedImage;
  NoInvitation({required this.selectedImage});

  @override
  State<NoInvitation> createState() => _NoInvitationState(selectedImage:selectedImage);
}

class _NoInvitationState extends State<NoInvitation> {
  late final int selectedImage;
  _NoInvitationState({required this.selectedImage});

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
                      height: 35,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/no_invitation.png',
                        width: 289,
                        height:289,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'You haven’t received any \n'
                        ' invitation. \n'.tr,
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
                              text: 'suggest you to get in touch \n'
                                  'with your school. \n'.tr,
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: GestureDetector(
                        onTap: (){
          if (selectedImage == 3){
          Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeParent(
          )));
          }else if (selectedImage == 2){
          Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeForSupervisor(
          )));
          };},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Skip'.tr,
                            style: TextStyle(
                              fontFamily: 'Poppins-SemiBold',
                              fontSize: 16,
                                color: Color(0xFF442B72),
                                fontWeight: FontWeight.w600
                            ),),
                            SizedBox(width: 5,),
                            (sharedpref?.getString('lang') == 'ar')?
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Image.asset(
                                'assets/images/icons8_Down_Right_Arrow 1.png',
                              width: 18.81,
                              height: 20,),
                            ):
                            Image.asset(
                              'assets/images/skip.png',
                              width: 18.81,
                              height: 15.81,)
                          ],
                        ),
                      ),
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
