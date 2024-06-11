import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/decline_invitation_parent.dart';
import 'package:school_account/supervisor_parent/screens/final_invitation_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';

class AcceptInvitationParent extends StatefulWidget {
  const AcceptInvitationParent({super.key});

  @override
  State<AcceptInvitationParent> createState() => _AcceptInvitationParentState();
}

class _AcceptInvitationParentState extends State<AcceptInvitationParent> {
  // bool _isChecked = false;


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
                        'assets/images/Invite-amico 1.png',
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
                                        'join the application as a \n '
                                        'Parent for your child Mariam'.tr,
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
      SizedBox(height: 15,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedSimpleButton(
                            txt: 'Accept'.tr,
                            fontFamily: 'Poppins-Regular',
                            width: 117,
                            hight: 38,
                            onPress: () async {
                              await  FirebaseFirestore.instance.collection('parent').doc(sharedpref!.getString('id')).update(
                                  {'invite': 1,'state':1});
                              sharedpref!.setInt('invitstate',1);
                              sharedpref!.setInt('invit',1);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FinalAcceptInvitationParent(
                                  )));

                              setState(() {
                              });
                            },
                            color: Color(0xFF442B72),
                            fontSize: 16),
                       SizedBox(width: 15,),
                       SizedBox(
                         height: 38,
                           width: 117,
                           child: Center(
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,
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
                               ), onPressed: () async {
                               await  FirebaseFirestore.instance.collection('parent').doc(sharedpref!.getString('id')).update(
                                   {'invite': 1,'state':2});
                               sharedpref!.setInt('invitstate',0);
                               sharedpref!.setInt('invit',0);
                               Dialoge.declinedInvitationDialog(context);
                             },
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
