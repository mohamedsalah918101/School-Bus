import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:school_account/screens/otp_login.dart';
import 'package:school_account/screens/signUpScreen.dart';
import '../Functions/functions.dart';
import '../classes/loading.dart';
import '../components/country_phonenumber_field.dart';
import '../components/elevated_simple_button.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../supervisor_parent/screens/sign_up.dart';
import 'otpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with  WidgetsBindingObserver  {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String enteredPhoneNumber = '';
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  bool _isLoading = false;
  String phoneError='';

  String phoneNumber = '';
  MyLocalController ControllerLang = Get.find();
  bool _phoneNumberEntered = true;
  //function to move to sign up page
  void navigateToSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
  initDynamicLinks() async {
    await Future.delayed(Duration(seconds: 3));
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    // print('userDataGet${deepLink}');
    // if (deepLink != null) {
    //   Navigator.pushNamed(context, deepLink.path);
    // }
    final queryParams = deepLink!.queryParameters;
    if (queryParams.length > 0) {
      handleLinkData(queryParams);

    }
    FirebaseDynamicLinks.instance.onLink.listen(
          (pendingDynamicLinkData) async{

        // Set up the `onLink` event listener next as it may be received here
        if (pendingDynamicLinkData != null) {
          final Uri deepLink = pendingDynamicLinkData.link;
          print('dynamicLink');
          handleLinkData(pendingDynamicLinkData);

          // Example of using the dynamic link to push the user to a different screen
        }
      },
    );

  }
  Future<void> handleLinkData(queryParams) async {

    if (queryParams.length > 0) {
       print('userDataGet${queryParams["id"]!}');
       _phoneNumberController.text = queryParams["phone"]!;

    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code
     //   await _auth.signInWithCredential(credential);
     //   Navigator.push(context,MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: phoneNumber)) );
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;

        });
        // Verification failed
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Save the verification ID for future use
        String smsCode = 'xxxxxx'; // Code input by the user
        setState(() {
          _isLoading = false;

        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreenLogin(verificationId: verificationId,phoneNumer:phoneNumber)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }
  TextEditingController _phoneNumberController = TextEditingController();
  OutlineInputBorder myErrorBorder(){
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Colors.red,
          width: 0.5,
        ));
  }// Step 1

  // Function to validate phone number
  bool _validatePhoneNumber() {
    bool isValid = _phoneNumberController.text.isNotEmpty;
    setState(() {
      _phoneNumberEntered = isValid;
    });
    return isValid;
  }
// to lock in landscape view
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initDynamicLinks();
 }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if(state == AppLifecycleState.resumed)
      initDynamicLinks();

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
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFFFFF),
          body: LayoutBuilder(builder: (context, constrains) {
            return Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constrains.maxHeight,
                    minWidth: constrains.maxWidth,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/imgs/school/Frame 51.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),

                          Center(
                            child: Image.asset(
                              'assets/imgs/school/Logo (2).png',
                              width: constrains.maxWidth / 2,
                              height: 68,
                            ),
                          ),
                          const SizedBox(
                            height:65,
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
                            height: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/imgs/school/Rectangle 2.png',
                                  width: constrains.maxWidth ,
                                  // height: 780 ,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:25,vertical: 10 ),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child:   RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Phone Number".tr,
                                                  style: TextStyle(color: Color(0xFF442B72)),
                                                ),
                                                TextSpan(
                                                  text: " *".tr,
                                                  style: TextStyle(color: Color(0xFFAD1519)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Text(
                                          //   'Phone Number *'.tr,
                                          //   style: TextStyle(
                                          //     color: Color(0xFF442B72),
                                          //     fontSize: 15,
                                          //     fontFamily: 'Poppins-Bold',
                                          //     fontWeight: FontWeight.w700,
                                          //     height: 1.07,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Theme(
                                        data:
                                        ThemeData(
                                          // Override the dropdown style here
                                          // Example: change the background color and text style
                                          canvasColor: Colors.white,
                                          textTheme: Theme.of(context).textTheme.copyWith(
                                            subtitle1: TextStyle(color: Color(0xFF442B72)),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          // Adjust horizontal padding
                                          child: SizedBox(
                                            width: constrains.maxWidth / 1.4,
                                            height: 57,
                                            child:
                                            Directionality(
                                              textDirection:  TextDirection.ltr,
                                              child:
                                              IntlPhoneField(

                                                cursorColor:Color(0xFF442B72) ,
                                                controller: _phoneNumberController,
                                                dropdownIconPosition:IconPosition.trailing,
                                                invalidNumberMessage:" ",
                                                style: TextStyle(color: Color(0xFF442B72),height: 1.5),
                                                dropdownIcon:Icon(Icons.keyboard_arrow_down,color: Color(0xff442B72),),
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xffF1F1F1),
                                                  filled: true,
                                                  hintText: 'Phone Number'.tr,
                                                  hintStyle: TextStyle(color: Color(0xFFC2C2C2),fontSize: 12,fontFamily: "Poppins-Bold"),

                                                  border:
                                                  OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide:  BorderSide(
                                                      color: !_phoneNumberEntered
                                                          ? Colors.red // Red border if phone number not entered
                                                          : Color(0xFFFFC53E),
                                                    ),
                                                  ),

                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 2
                                                      )
                                                  ),
                                                  focusedBorder: OutlineInputBorder(  // Set border color when the text field is focused
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
                                                    ),
                                                  ),


                                                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),


                                                ),

                                                initialCountryCode: 'EG', // Set initial country code if needed
                                                onChanged: (phone) {
                                                  // Update the enteredPhoneNumber variable with the entered phone number
                                                  setState(() {
                                                    enteredPhoneNumber = phone.completeNumber;
                                                  });
                                                },

                                              ),
                                            ),

                                          ),


                                          //  child: SizedBox(
                                          //     width: constrains.maxWidth / 1.4,
                                          //     height: 60,
                                          //     child:
                                          //     IntlPhoneField(
                                          //       showCountryFlag: false,
                                          //       cursorColor:  Color(0xFF442B72),
                                          //       decoration: InputDecoration(
                                          //         counterStyle: TextStyle(height: double.minPositive,),
                                          //         counterText: "",
                                          //         filled: true,
                                          //         fillColor: const Color(0xFFF1F1F1),
                                          //         contentPadding: const EdgeInsets.all(3),
                                          //         alignLabelWithHint: true,
                                          //         labelText: 'Phone Number'.tr,
                                          //         labelStyle: TextStyle(
                                          //           color: Color(0xFFC2C2C2),
                                          //           fontSize: 12,
                                          //           fontFamily: 'Poppins-Bold',
                                          //           // fontFamily: 'Inter-Bold',
                                          //           fontWeight: FontWeight.w700,
                                          //           height: 1.33,
                                          //         ),
                                          //         border: OutlineInputBorder(
                                          //             borderRadius: BorderRadius.all(Radius.circular(7)),
                                          //             borderSide: BorderSide(
                                          //               color:  Color(0xFFFFC53E),
                                          //               width: 0.5,
                                          //             )
                                          //         ),
                                          //
                                          //         focusedErrorBorder: OutlineInputBorder(
                                          //           borderRadius: BorderRadius.all(Radius.circular(7)),
                                          //           borderSide: BorderSide(
                                          //             color: Color(0xFFFFC53E),
                                          //             width: 0.5,
                                          //           ),
                                          //         ),
                                          //         enabledBorder: OutlineInputBorder(
                                          //           borderRadius: BorderRadius.all(Radius.circular(7)),
                                          //           borderSide: BorderSide(
                                          //             color: Color(0xFFFFC53E),
                                          //             width: 0.5,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       languageCode: "Eg",
                                          //       onChanged: (phone) {
                                          //         // print(phone.completeNumber);
                                          //       },
                                          //       onCountryChanged: (country) {
                                          //         // print('Country changed to: ' + country.name);
                                          //       },
                                          //     ),
                                          //   ),
                                        ),
                                      ),
                                      if (!_phoneNumberEntered)
                                        Align(alignment: AlignmentDirectional.topStart,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text(
                                              phoneError,
                                              style: TextStyle(color: Colors.red),

                                            ),
                                          ),
                                        ),


                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.4,
                                      //   hintTxt: 'Your Phone'.tr,
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      // دا كان كلمه السر
                                      // Text(
                                      //   'Password'.tr,
                                      //   style: TextStyle(
                                      //     color: Color(0xFF442B72),
                                      //     fontSize: 15,
                                      //     fontFamily: 'Poppins-Bold',
                                      //     fontWeight: FontWeight.w700,
                                      //     height: 1.07,
                                      //   ),
                                      // ),
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.4,
                                      //   hintTxt: 'Your Password'.tr,
                                      // ),

                // end of comment
                                      SizedBox(
                                        height: constrains.maxWidth / 5,
                                      ),

                                      SizedBox(
                                        width: constrains.maxWidth / 1.4,
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30)
                                            ),
                                            child: ElevatedSimpleButton(
                                              txt: 'Login'.tr,

                                              onPress: () async{

                                                if(_phoneNumberController.text.length == 0){
                                                  setState(() {
                                                    phoneError ='Please enter your phone number'.tr;
                                                    _phoneNumberEntered =false;
                                                  });
                                                  // ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Please,enter valid number')));

                                                }else if(_phoneNumberController.text.length < 10){
      setState(() {
        phoneError ='Please enter valid phone number'.tr;

        _phoneNumberEntered =false;
      });
    // ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Please,enter valid number')));

    }else{
      _phoneNumberEntered =true;

      if (_validatePhoneNumber())  {
                                                  setState(() {
                                                    _isLoading = true;

                                                  });
                                              var res =   await checkIfNumberExists(enteredPhoneNumber);

                                              if(res){
                                                verifyPhoneNumber(enteredPhoneNumber);

                                              }else{
                                                setState(() {
                                                  _isLoading = false;

                                                });
                                                existDialoge();
                                             //   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('This phone not exist.')));

                                              }

                                                  // Step 3
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) =>  OtpScreen(phoneNumber: enteredPhoneNumber)),
                                                  // );
                                                } else {
                                                  setState(() {
                                                    _phoneNumberEntered = false;
                                                  });
                                                  //message error if user doesn't enter phone number
                                                  // ScaffoldMessenger.of(context).showSnackBar(
                                                  //   SnackBar(
                                                  //     content: Text('Please enter your phone number'),
                                                  //     duration: Duration(seconds: 2),
                                                  //   ),
                                                  // );
                                                }}
                                              },

                                              width: constrains.maxWidth /1.4,
                                              hight: 48,
                                              color: const Color(0xFF442B72),
                                              fontSize: 16,
                                            ),
                                          ),
                                          // end of comment
                                        ),
                                      ) ,

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Navigate to the sign-up page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SignUpScreen(),
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Don't Have an account yet?".tr,
                                                  style: TextStyle(color: Color(0xff494949)),
                                                ),
                                                TextSpan(
                                                  text: "Sign Up".tr,
                                                  style: TextStyle(color: Color(0xFF442B72)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

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
                ),(_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container(),
              ],
            );
          })),
    );
  }
  void existDialoge() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 182,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                'assets/images/Vertical container.png',
                                width: 27,
                                height: 27,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Sign up'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 18,
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w600,
                            height: 1.23,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Don\'t have an account yet'.tr,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(

                          backgroundColor: Color(0xFF442B72),
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFF442B72),
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: SizedBox(
                          height: 38,
                          width: 120,
                          child: Center(
                            child: Text(
                                'Sign up'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.w500 ,
                                    fontSize: 16)
                            ),
                          ),
                        ), onPressed: () {
                          Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                // children.isNotEmpty?
                                SignUpScreen(

                                )
                              //no data
                              // : NoInvitation( selectedImage: selectedImage)
                            ));
                      },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );


  }

}



