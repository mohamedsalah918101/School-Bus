import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:school_account/supervisor_parent/controllers/auth_service.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/accept_invitation_parent.dart';
import 'package:school_account/supervisor_parent/screens/login_screen.dart';
import 'package:school_account/supervisor_parent/screens/no_invitation.dart';
import 'package:school_account/supervisor_parent/screens/otp_screen.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import '../../controller/local_controller.dart';
import '../../screens/signUpScreen.dart';
import '../components/elevated_simple_button.dart';
import '../components/text_form_field_login_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  MyLocalController ControllerLang = Get.find();
  bool isPhoneValidated = false;

// to lock in landscape view
  @override
  void initState() {
    super.initState();
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
                    image: AssetImage("assets/images/Frame 51.png"),
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
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/Logo (2).png',
                        width: constrains.maxWidth / 2,
                        height: 68,
                      ),
                    ),
                    const SizedBox(
                      height: 47,
                    ),
                    Center(
                      child: Text(
                        'Login'.tr,
                        style: TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 25,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          height: 0.64,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (sharedpref?.getString('lang') == 'ar') ? 50 : 40
                    ),
                    SizedBox(
                      width: constrains.maxWidth ,
                      // height: constrains.maxHeight / 1.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/Rectangle 2.png',
                              width: constrains.maxWidth ,
                              // height: 780 ,
                            ),
                            Positioned(
                                top: 60,
                                left: 16,
                                right: 16,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Phone Number'.tr,
                                            style: TextStyle(
                                              color: Color(0xFF442B72),
                                              fontSize: 15,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.07,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.07,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: constrains.maxWidth ,
                                      height: 45,
                                      child:
                                      SizedBox(
                                        width: constrains.maxWidth /1.4,
                                        height: 36,
                                        child:
                                        Form(
                                          key: _formKey,
                                          child: IntlPhoneField(
                                            controller: _phoneController,
                                            // validator: (value){
                                            //   if(value!.lenght!=10)
                                            //     return 'Invalid Number' ;
                                            // },
                                            autofocus: true,
                                            textInputAction: TextInputAction.done,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly],
                                            textAlign:  (sharedpref?.getString('lang') == 'ar') ?
                                            TextAlign.right :
                                            TextAlign.left ,
                                            initialCountryCode: 'EG',
                                            invalidNumberMessage: '',
                                            dropdownIconPosition: IconPosition.trailing,
                                            showCountryFlag: true,
                                            cursorColor:  Color(0xFF442B72),
                                            decoration: InputDecoration(
                                              counterStyle:
                                              TextStyle(height: double.minPositive,),
                                              counterText: "",
                                              filled: true,
                                              fillColor: const Color(0xFFF1F1F1),
                                              contentPadding: const EdgeInsets.all( 22 ),
                                              alignLabelWithHint: true,
                                              hintText: 'Phone Number'.tr,
                                              hintStyle: TextStyle(
                                                color: Color(0xFFC2C2C2),
                                                fontSize: 12,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                                height: 1.33,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  borderSide: BorderSide(
                                                    color:  Color(0xFFFFC53E),
                                                    width: 1,
                                                  )
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color(0xffF44336) ,
                                                  width: 0.8,
                                                ),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFFFC53E),
                                                  width: 0.8,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFFFC53E),
                                                  width: 0.8,
                                                ),),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFFFC53E),
                                                  width: 0.8,
                                                ),
                                              ),
                                            ),
                                            languageCode: "en",
                                            autovalidateMode: AutovalidateMode.disabled,
                                            onChanged: (phone) {
                                              setState(() {});},
                                            onCountryChanged: (country) {
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('Please enter your invitation phone number'.tr,
                                    style: TextStyle(
                                      color: Color(0xff442B72),
                                      fontSize: 11,
                                      fontFamily: 'Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      height: 1.07,
                                    ),),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: constrains.maxWidth ,
                                      child: Center(
                                        child: ElevatedSimpleButton(
                                          txt: 'Login'.tr,
                                          onPress: () async {
                                            setState(() {

                                            });
                                            AuthService.sendOtp(
                                                Phone: 01270247163,
                                                errorStep: ()=> ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('error in sending otp'), backgroundColor: Colors.red,)),
                                                nextStep: ()=> ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('enter 6 digits'), backgroundColor: Colors.red,)),);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>
                                                      AcceptInvitationParent()),
                                                      // OtpScreen()),
                                                );

                                          },
                                          width: constrains.maxWidth ,
                                          hight: 48,
                                          color: const Color(0xFF442B72),
                                          fontSize: 16,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                    ) ,
                                    SizedBox( height: 30,),
                                    SizedBox(
                                      height: 16,
                                      width: constrains.maxWidth / 1.4,
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const SignUpScreen())),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Don’t have an account yet?'.tr,
                                                  style: TextStyle(
                                                      color: Color(0xff263238),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w500
                                                  ),) ,
                                                TextSpan(
                                                  text: ' Sign Up'.tr,
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
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 44,
                    // ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
