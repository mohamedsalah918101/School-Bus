import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:school_account/screens/loginScreen.dart';
import '../components/elevated_simple_button.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'otpScreen.dart';
//import '../local/local_cotroller.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
// class _LoginScreenState extends State<LoginScreen>{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }

class _SignUpScreenState extends State<SignUpScreen> {
  String enteredPhoneNumber = '';
  int selectedImage = 0;
  String phoneNumber = '';
  bool _phoneNumberEntered = true;
  MyLocalController ControllerLang = Get.find();
  //final _phoneNumberFocusNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _validatePhoneNumber() {
    bool isValid = _phoneNumberController.text.isNotEmpty;
    setState(() {
      _phoneNumberEntered = isValid;
    });
    return isValid;
  }
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve verification code
        await _auth.signInWithCredential(credential);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: phoneNumber, selectedImage: selectedImage,)) );
      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Save the verification ID for future use
        String smsCode = 'xxxxxx'; // Code input by the user

        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: verificationId, selectedImage: selectedImage,)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }

  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
          width: 0.5,
        ));
  }
  OutlineInputBorder myErrorBorder(){
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Colors.red,
          width: 0.5,
        ));
  }
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _name = TextEditingController();
  final _phoneNumberFocusNode = FocusNode();
  bool _nameuser = true;
  bool _validatename() {
    //return _name.text.isNotEmpty;

    bool isValid = _name.text.isNotEmpty;
    setState(() {
      _nameuser = isValid;
    });
    return isValid;

  }
  Color borderColor = Color(0xFF150628).withOpacity(0.5);
  int selectedContainer = 0;
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
   // _phoneNumberFocusNode.dispose();
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
            return ConstrainedBox(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: InkWell(
                            onTap: () {
                              // Navigate back to the previous page
                              Navigator.pop(context);
                            },
                            //onTap: ()=>exit(0),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 23,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/imgs/school/Logo (2).png',
                          width: constrains.maxWidth / 2,
                          height: 68,
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      Center(
                        child: Text(
                          'Sign up'.tr,
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
                        height: 20,
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
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 Align(alignment: AlignmentDirectional.topStart,
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 25),
                                     child:
                                     RichText(
                                       text: TextSpan(
                                         style: TextStyle(
                                           //color: Colors.black, // Setting default text color to black
                                           fontSize: 15,
                                           fontFamily: 'Poppins-Bold',
                                           fontWeight: FontWeight.w700,
                                         ),
                                         children: [
                                           TextSpan(
                                             text: "Name".tr,
                                             style: TextStyle(color: Color(0xFF442B72)),
                                           ),
                                           TextSpan(
                                             text: " *".tr,
                                             style: TextStyle(color: Color(0xFFAD1519)),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: constrains.maxWidth / 1.4,
                                    height: 38,
                                    child: TextFormField(
                                      controller: _name,
                                      cursorColor: const Color(0xFF442B72),
                                      style: TextStyle(color: Color(0xFF442B72)),
                                      textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                      onFieldSubmitted: (value) {
                                        // move to the next field when the user presses the "Done" button
                                        FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                      },
                                      //textDirection: TextDirection.ltr,
                                      scrollPadding: const EdgeInsets.symmetric(
                                          vertical: 40),
                                      decoration:  InputDecoration(
                                        alignLabelWithHint: true,
                                        counterText: "",
                                        fillColor: const Color(0xFFF1F1F1),
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            8, 30, 10, 5),
                                        hintText:"Name".tr,
                                        floatingLabelBehavior:  FloatingLabelBehavior.never,
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFC2C2C2),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Bold',
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                        ),
                                        // enabledBorder: myInputBorder(),
                                        // focusedBorder: myFocusBorder(),
                                        enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                        focusedBorder: myFocusBorder(),
                                      ),
                                      // onFieldSubmitted: (value) {
                                      //   // move to the next field when the user presses the "Done" button
                                      //   FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                      // },
                                    ),
                                  ),
                                  if (!_nameuser)
                                    Align(alignment: AlignmentDirectional.topStart,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          "Please enter your name".tr,

                                          style: TextStyle(color: Colors.red),


                                        ),

                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                   Align(alignment: AlignmentDirectional.topStart,
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 25),
                                       child:
                                       RichText(
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
                                  //      Text(
                                  //       'Phone Number *'.tr,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF442B72),
                                  //         fontSize: 15,
                                  //         fontFamily: 'Poppins-Bold',
                                  //         fontWeight: FontWeight.w700,
                                  //         height: 1.07,
                                  //       ),
                                  // ),
                                     ),
                                   ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    // Adjust horizontal padding
                                    child: Container(
                                      //height: 50,
                                      // decoration: BoxDecoration(
                                      //   color: Colors.grey.withOpacity(0.2), // Grey background color
                                      //   borderRadius: BorderRadius.circular(10.0),
                                      // ),
                                      child:
                                      // SizedBox(
                                      //   width: constrains.maxWidth / 1.4,
                                      //   height: 50,
                                      //   child: IntlPhoneField(
                                      //     decoration: InputDecoration(
                                      //       hintText: 'Phone Number'.tr,
                                      //       hintStyle: TextStyle(color: Colors.grey),
                                      //       border: OutlineInputBorder(
                                      //         borderRadius: BorderRadius.circular(10.0),
                                      //         borderSide: BorderSide(color: Color(0xFFFFC53E)), // Change border color here
                                      //       ),
                                      //       contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                      //
                                      //     ),
                                      //     initialCountryCode: 'EG', // Set initial country code if needed
                                      //     onChanged: (phone) {
                                      //       // Handle phone number changes
                                      //     },
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: constrains.maxWidth / 1.4,

                                        child: Directionality(
                                          textDirection: _phoneNumberController.text.startsWith('0') ? TextDirection.rtl : TextDirection.ltr,
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              iconTheme: IconThemeData(
                                                color: Color(0xFFFFC53E), // Set the arrow color here
                                              ),
                                            ),
                                            child: Theme(
                                              data:ThemeData(
                                                // Override the dropdown style here
                                                // Example: change the background color and text style
                                                canvasColor: Colors.white,
                                                textTheme: Theme.of(context).textTheme.copyWith(
                                                  subtitle1: TextStyle(color: Color(0xFF442B72)),
                                                ),
                                              ),
                                              child:Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                                child: SizedBox(
                                                  height: 57,
                                                  child: IntlPhoneField(

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

                                                      // border:
                                                      // OutlineInputBorder(
                                                      //   borderRadius: BorderRadius.all(Radius.circular(7)),
                                                      //   borderSide:  BorderSide(
                                                      //     color: !_phoneNumberEntered
                                                      //         ? Colors.red // Red border if phone number not entered
                                                      //         : Color(0xFFFFC53E),
                                                      //   ),
                                                      // ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                            borderSide: BorderSide(color: Color(0xFFFFC53E)), // Change border color here
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
                                                      // Handle phone number changes
                                                    },

                                                  ),
                                                  // child: IntlPhoneField(
                                                  //   controller: _phoneNumberController,
                                                  //   focusNode: _phoneNumberFocusNode,
                                                  //     dropdownIconPosition:IconPosition.trailing,
                                                  //     invalidNumberMessage:" ",
                                                  //
                                                  //
                                                  //   style: TextStyle(color: Color(0xFF442B72),height: 2),
                                                  //     dropdownIcon:Icon(Icons.keyboard_arrow_down,color: Color(0xff442B72),),
                                                  //     cursorColor:Color(0xFF442B72) ,
                                                  //  cursorHeight: 25,
                                                  //  // showCountryFlag:false,
                                                  //   autovalidateMode: AutovalidateMode.disabled,
                                                  //
                                                  //   decoration: InputDecoration(
                                                  //
                                                  //     fillColor: Color(0xffF1F1F1),
                                                  //     filled: true,
                                                  //
                                                  //     hintText: 'Phone Number'.tr,
                                                  //     hintStyle: TextStyle(color: Color(0xFFC2C2C2),fontSize: 12,fontFamily: "Poppins-Bold"),
                                                  //     border: OutlineInputBorder(
                                                  //       borderRadius: BorderRadius.circular(10.0),
                                                  //       borderSide: BorderSide(color: Color(0xFFFFC53E)), // Change border color here
                                                  //     ),
                                                  //     // focusedErrorBorder: OutlineInputBorder(
                                                  //     //   borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  //     //   borderSide: BorderSide(
                                                  //     //     color: Color(0xFFFFC53E),
                                                  //     //     width: 0.5,
                                                  //     //   ),
                                                  //     // ),
                                                  //     enabledBorder: OutlineInputBorder(
                                                  //       borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  //       borderSide: BorderSide(
                                                  //         color: Color(0xFFFFC53E),
                                                  //         width: 0.5,
                                                  //       ),
                                                  //     ),
                                                  //     focusedBorder: OutlineInputBorder(  // Set border color when the text field is focused
                                                  //       borderRadius: BorderRadius.circular(10.0),
                                                  //       borderSide: BorderSide(
                                                  //         color: Color(0xFFFFC53E),
                                                  //       ),
                                                  //     ),
                                                  //
                                                  //     contentPadding: EdgeInsets.symmetric(vertical:4.0, horizontal: 16.0),
                                                  //
                                                  //   ),
                                                  //
                                                  //   initialCountryCode: 'EG', // Set initial country code if needed
                                                  //   onChanged: (phone) {
                                                  //     // Handle phone number changes
                                                  //   },
                                                  //
                                                  //
                                                  // ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:25 ),
                                    child: Align(alignment: AlignmentDirectional.topStart,
                                      child:
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            //color: Colors.black, // Setting default text color to black
                                            fontSize: 15,
                                            fontFamily: 'Poppins-Bold',
                                            fontWeight: FontWeight.w700,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Join as".tr,
                                              style: TextStyle(color: Color(0xFF442B72)),
                                            ),
                                            TextSpan(
                                              text: " *".tr,
                                              style: TextStyle(color: Color(0xFFAD1519)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Text('Join as'.tr,
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
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // TextFormFieldCustom(
                                  //   width: constrains.maxWidth / 1.4,
                                  //   hintTxt: 'Join as'.tr,
                                  //
                                  //   //isDropdown: true,
                                  // ),
// new
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(onTap:(){
                                        setState(() {
                                          selectedContainer =1;

                                        });
                                      },
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 10),
                                           child: Expanded(
                                             child: Container(
                                               width:84,
                                              // height: 87,
                                               //width: selectedContainer==1?70:84,
                                              // height: selectedContainer==1?73:87,
                                               decoration: BoxDecoration(

                                                   border: Border.all(
                                                     color: selectedContainer == 1 ? Color(0xFF442B72) : Colors.transparent,
                                                     width: selectedContainer == 1 ? 3 : 0,
                                                   ),
                                                 //border: Border.all(color: borderColor),
                                                   gradient: LinearGradient(
                                                     //transform: GradientRotation(math.pi / 4),
                                                     begin: Alignment.topLeft,
                                                     end: Alignment.bottomRight,
                                                     colors: [
                                                       Color(0xFF442B72),
                                                       Color(0xffA79FD9),
                                                     ],
                                                   )
                                               ),
                                               //   color: Color(0xff442B72),
                                               child: Padding(
                                                 padding: const EdgeInsets.symmetric(vertical: 20),
                                                 child: Column(children: [
                                                   Padding(
                                                     padding: const EdgeInsets.only(bottom: 5),
                                                     child: Image.asset('assets/imgs/school/school.png',width: 34,height: 34,),
                                                   ),
                                                   Text("School".tr,style: TextStyle(color: Colors.white,

                                                       fontSize: 10,fontWeight: FontWeight.w400),)
                                                 ],),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),

                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedContainer = 2;
                                            borderColor = Color(0xFF150628);
                                          });

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 0),
                                          child: Expanded(
                                            child: Container(
                                              width: 84,
                                             // height: 87,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: selectedContainer == 2 ? Color(0xFF442B72) : Colors.transparent,
                                                    width: selectedContainer == 2 ? 3 : 0,
                                                  ),
                                                //    border: Border.all(color: borderColor),
                                                  gradient: LinearGradient(
                                                    //transform: GradientRotation(math.pi / 4),
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xffA79FD9),
                                                      Color(0xFF442B72),

                                                    ],

                                                  )
                                              ),
                                              //   color: Color(0xff442B72),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                child: Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 5),
                                                    child: Image.asset('assets/imgs/school/icons8_manager.png',width: 34,height: 34,),
                                                  ),
                                                  Text("Supervisor".tr,style: TextStyle(color: Colors.white,

                                                      fontSize: 10,fontWeight: FontWeight.w400),)
                                                ],),
                                              ),
                                            ),
                                          ),
                                        ),),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedContainer = 3;
                                            borderColor = Color(0xFF150628);
                                          });

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Expanded(
                                            child: Container(
                                              width: 84,
                                              //height: 87,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: selectedContainer == 3 ? Color(0xFF442B72) : Colors.transparent,
                                                    width: selectedContainer == 3 ? 3 : 0,
                                                  ),
                                                // border: Border.all(color: borderColor),
                                                  gradient: LinearGradient(
                                                    //transform: GradientRotation(math.pi / 4),
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color(0xffA79FD9),
                                                      Color(0xFF442B72),

                                                    ],
                                                  )

                                               ),
                                              //   color: Color(0xff442B72),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 20),
                                                child: Column(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:2),
                                                    child: Image.asset('assets/imgs/school/father-and-son 1.png',width:38 ,height: 38,),
                                                  ),
                                                  Text("Parents".tr,style: TextStyle(color: Colors.white,
                                                      //fontFamily: 'Poppins-Medium',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  )
                                                ],
                                                ),
                                              ),

                                            ),

                                          ),

                                        ),
                                      )
                                    ],
                                  ),


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


                                  // SizedBox(
                                  //   height: constrains.maxWidth / 5,
                                  // ),

                                  // Center(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                                  //     child: SizedBox(
                                  //       width: constrains.maxWidth / 1.4,
                                  //       child: Center(
                                  //         child: ElevatedSimpleButton(
                                  //           txt: 'Create Account'.tr,
                                  //           width: constrains.maxWidth / 1.4,
                                  //           color: const Color(0xFF442B72),
                                  //           hight: 48,
                                  //           onPress: () {
                                  //           },
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedSimpleButton(
                                      txt: 'Create Account'.tr,

                                      // onPress: () {
                                      //   // Validate the name field
                                      //   bool isNameValid = _validatename();
                                      //   if (isNameValid) {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(builder: (context) => const OtpScreen()),
                                      //     );
                                      //   } else {
                                      //     // Handle error, maybe show a Snackbar or similar
                                      //   }
                                      // },
                                      onPress: () {
                                  if (_validatename()&&_validatePhoneNumber()) { // Step 3
                                    verifyPhoneNumber(enteredPhoneNumber);
                                  // Navigator.push(
                                  // context,
                                  // MaterialPageRoute(builder: (context) =>  OtpScreen(phoneNumber: enteredPhoneNumber)),
                                  // );
                                  } else {
                                    _nameuser=false;
                                    _phoneNumberEntered = false;
                                  //message error if user doesn't enter phone number

                                  }

                                  },
                                      // => Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //         const OtpScreen()))

                                      width: constrains.maxWidth /1.4,
                                      hight: 48,
                                      color: const Color(0xFF442B72),
                                      fontSize: 16,
                                    ),
                                  ) ,
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     // Navigate to the sign-up page
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => LoginScreen(),
                                  //       ),
                                  //     );
                                  //   },
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(horizontal: 70),
                                  //     child: Text(
                                  //       "Already Have an account? Sign in".tr,
                                  //       style: TextStyle(
                                  //         color: Color(0xFF442B72),
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.w400,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      // Navigate to the login page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 70),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            //color: Colors.black, // Setting default text color to black
                                            fontSize: 12,
                                           
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Already Have an account?".tr,
                                              style: TextStyle(color: Color(0xff494949)),
                                            ),
                                            TextSpan(
                                              text: "Sign in".tr,
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
                      //   height: 44,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     // Navigate to the sign-up page
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => LoginScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Text(
                      //     "Already have an account? Login",
                      //     style: TextStyle(
                      //       color: Color(0xFF442B72),
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}