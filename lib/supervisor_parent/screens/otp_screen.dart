import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/screens/homeScreen.dart';
import 'package:school_account/supervisor_parent/controllers/auth_service.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/accept_invitation_parent.dart';
import 'package:school_account/supervisor_parent/screens/accept_invitation_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/no_invitation.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';

class OtpScreen extends StatefulWidget {
  // const OtpScreen({super.key,});
  late final int selectedImage;
  OtpScreen({required this.selectedImage});

  @override
  State<OtpScreen> createState() => _OtpScreenState(selectedImage:  selectedImage);
}

class _OtpScreenState extends State<OtpScreen> {
  late final int selectedImage;
  _OtpScreenState({required this.selectedImage});
  TextEditingController _OtpController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              (sharedpref?.getString('lang') == 'ar')
                                  ? 'assets/images/Layer 1.png'
                                  : 'assets/images/fi-rr-angle-left.png',
                              width: 22,
                              height: 22,
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: (sharedpref?.getString('lang') == 'ar')
                                ? EdgeInsets.only(left: 20)
                                : EdgeInsets.only(right: 20),
                            child: Center(
                              child: SizedBox(
                                // height: 16,
                                // width: 51,
                                child: Text(
                                  'OTP'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 25,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.w700,
                                    height: 0.64,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container())
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/Rating 1.png',
                      width: constrains.maxWidth / 1.77,
                      height: constrains.maxWidth / 1.77,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Enter Verification Code'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 19,
                        fontFamily: 'Poppins-SemiBold',
                        fontWeight: FontWeight.w600,
                        height: 0.84,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      'You Receive SMS have Code'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 11,
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Container(
                    height: 56,
                    child: Directionality(
                        textDirection: (sharedpref?.getString('lang') == 'ar') ?
                        TextDirection.rtl:
                        TextDirection.ltr,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                            horizontal: 30.0,
                          ),
                          child: PinCodeTextField(
                            controller: _OtpController,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'Inter-SemiBold',
                            ),
                            hintCharacter: '0',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                                fontFamily: 'Inter-SemiBold',
                                color: Color(0xff8198A5)),
                            appContext: context,
                            length: 6,
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveColor: const Color(0xff8198A5),
                                selectedColor: const Color(0xff001D4A),
                                activeColor: const Color(0xff8198A5),
                                selectedFillColor: Colors.white),
                            cursorColor: const Color(0xff001D4A),
                            animationDuration: Duration(milliseconds: 300),
                            keyboardType: TextInputType.number,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Didn’t receive the OTP'.tr,
                                    style: TextStyle(
                                        color: Color(0xff263238),
                                        fontSize: 12,
                                        fontFamily: 'Poppins-Light',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: '  Resend OTP ? '.tr,
                                    style: TextStyle(
                                      color: Color(0xff858585),
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Text('1s'.tr,
                          style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff263238)
                          ),),
                        ],
                      ),
                    ),
                  ),
                  Flexible(child: Container()),
                  Center(
                    child: SizedBox(
                      width: constrains.maxWidth / 1.4,
                      child: Center(
                        child: ElevatedSimpleButton(
                          txt: 'Verify'.tr,
                          width: constrains.maxWidth / 1.5,
                          color: const Color(0xFF442B72),
                          hight: 48,
                          onPress: () {
                            if (selectedImage == 3){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AcceptInvitationParent(
                                  )));
                            }else if (selectedImage == 2){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AcceptInvitationSupervisor(
                                  )));
                            }else if (selectedImage == 1){
                            Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(
                            )));
                            };
                                  // if(_formKey1.currentState!.validate()) {
                                  //   AuthService.loginWithOtp(Otp: _OtpController.text).
                                  //   then((value) {
                                  //     if(value == 'Success'){
                                  //       //navigitor
                                  //     }
                                  //     else {
                                  //       ScaffoldMessenger.of(context).showSnackBar(
                                  //                   SnackBar(content: Text(value), backgroundColor: Colors.red,));
                                  //     }
                                  //   });
                                  //
                                  // }
                          },
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => AcceptInvitation(
                  //           )));
                  //     },
                  //     child: Text('go to accept invitation')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => NoInvitation(
                  //           )));
                  //     },
                  //     child: Text('go to no invitation')),
                ],
              ),
            ),
          );
        }));
  }
}
