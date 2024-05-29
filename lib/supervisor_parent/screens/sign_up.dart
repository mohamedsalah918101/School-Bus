// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:school_account/screens/otpScreen.dart';
// import 'package:school_account/supervisor_parent/components/child_data_item.dart';
// import 'package:school_account/main.dart';
// import 'package:school_account/supervisor_parent/screens/login_screen.dart';
// import 'package:school_account/supervisor_parent/screens/otp_screen.dart';
// import '../../controller/local_controller.dart';
// import '../../screens/loginScreen.dart';
// import '../components/elevated_simple_button.dart';
// import '../components/text_form_field_login_custom.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   int selectedImage = 0;
//   late String verificationId;
//   int selectedContainer = 0;
//   bool _isChecked = false;
//   MyLocalController ControllerLang = Get.find();
//   List<ChildDataItem> children = [];
//   TextEditingController PhoneNumberController = TextEditingController();
//   bool isPhoneExiting = false;
//
//
//   Future<bool> checkIfNumberExists(String enteredNumber) async {
//     CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
//     Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: enteredNumber);
//     try {
//       QuerySnapshot snapshot = await queryOfNumber.get();
//       print(snapshot.docs);
//       return snapshot.size > 0;
//     } catch (error) {
//       print('Error: $error');
//       return false;
//     }
//   }
//
// // to lock in landscape view
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }
//
//   @override
//   dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return false;
//       },
//       child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           backgroundColor: const Color(0xFFFFFFFF),
//           body: LayoutBuilder(builder: (context, constrains) {
//             return ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constrains.maxHeight,
//                 minWidth: constrains.maxWidth,
//               ),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/Frame 51.png"),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       height: 35,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Image.asset(
//                           (sharedpref?.getString('lang') == 'ar')?
//                           'assets/images/Layer 1.png':
//                           'assets/images/fi-rr-angle-left.png',
//                           width: 22,
//                           height: 22,),
//                       ),
//                     ),
//                     Center(
//                       child: Image.asset(
//                         'assets/images/Logo (2).png',
//                         width: constrains.maxWidth / 2,
//                         height: 68,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 35,
//                     ),
//                     Center(
//                       child: Text(
//                         'Sign up'.tr,
//                         style: TextStyle(
//                           color: Color(0xFF442B72),
//                           fontSize: 25,
//                           fontFamily: 'Poppins-Bold',
//                           fontWeight: FontWeight.w700,
//                           height: 0.64,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 43,
//                     ),
//                     SizedBox(
//                       width: constrains.maxWidth,
//                       // height: constrains.maxHeight / 1.2,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                         child: Stack(
//                           children: [
//                             Image.asset(
//                               'assets/images/Rectangle 2.png',
//                               width: constrains.maxWidth ,
//                               // height: 780 ,
//                             ),
//                             Positioned(
//                                 top: 60,
//                                 left: 16,
//                                 right: 16,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text.rich(
//                                       TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: 'Name'.tr,
//                                             style: TextStyle(
//                                               color: Color(0xFF442B72),
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text: ' *',
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Center(
//                                       child: Directionality(
//                                         textDirection:
//                                         (sharedpref?.getString('lang') == 'ar') ?
//                                         TextDirection.rtl :
//                                         TextDirection.ltr ,
//                                         child: SizedBox(
//                                           height: 60,
//                                           child: TextFormFieldCustom(
//                                             width: constrains.maxWidth ,
//                                             hintTxt: 'Name'.tr,
//                                             keyboardType: TextInputType.text,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 15,
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: 'Phone Number'.tr,
//                                             style: TextStyle(
//                                               color: Color(0xFF442B72),
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text: ' *',
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     SizedBox(
//                                       width: constrains.maxWidth ,
//                                       height: 45,
//                                       child:
//                                       SizedBox(
//                                         width: constrains.maxWidth /1.4,
//                                         height: 36,
//                                         child:
//                                         IntlPhoneField(
//                                           controller: PhoneNumberController,
//                                           textAlign:  (sharedpref?.getString('lang') == 'ar') ?
//                                           TextAlign.right :
//                                           TextAlign.left ,
//                                           initialCountryCode: 'EG',
//                                           invalidNumberMessage: '',
//                                           autofocus: true,
//                                           textInputAction: TextInputAction.done,
//                                           keyboardType: TextInputType.phone,
//                                           inputFormatters: <TextInputFormatter>[
//                                             FilteringTextInputFormatter.digitsOnly],
//                                           dropdownIconPosition: IconPosition.trailing,
//                                           showCountryFlag: true,
//                                           cursorColor:  Color(0xFF442B72),
//                                           decoration: InputDecoration(
//                                             counterStyle:
//                                             TextStyle(height: double.minPositive,),
//                                             counterText: "",
//                                             filled: true,
//                                             fillColor: const Color(0xFFF1F1F1),
//                                             contentPadding: const EdgeInsets.all( 18 ),
//                                             alignLabelWithHint: true,
//                                             hintText: 'Phone Number'.tr,
//                                             hintStyle: TextStyle(
//                                               color: Color(0xFFC2C2C2),
//                                               fontSize: 12,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.33,
//                                             ),
//                                             border: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.all(Radius.circular(7)),
//                                                 borderSide: BorderSide(
//                                                   color:  Color(0xFFFFC53E),
//                                                   width: 1,
//                                                 )
//                                             ),
//                                             errorBorder: OutlineInputBorder(
//                                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                                               borderSide: BorderSide(
//                                                 color: Color(0xffF44336) ,
//                                                 width: 0.8,
//                                               ),
//                                             ),
//                                             focusedErrorBorder: OutlineInputBorder(
//                                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                                               borderSide: BorderSide(
//                                                 color: Color(0xFFFFC53E),
//                                                 width: 0.8,
//                                               ),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                                               borderSide: BorderSide(
//                                                 color: Color(0xFFFFC53E),
//                                                 width: 0.8,
//                                               ),),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                                               borderSide: BorderSide(
//                                                 color: Color(0xFFFFC53E),
//                                                 width: 0.8,
//                                               ),
//                                             ),
//                                           ),
//                                           languageCode: "en",
//                                           autovalidateMode: AutovalidateMode.disabled,
//                                           onChanged: (phone) {
//                                             setState(() {
//                                             });
//                                           },
//                                           onCountryChanged: (country) {
//                                             // print('Country changed to: ' + country.name);
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 40,
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: 'Join as'.tr,
//                                             style: TextStyle(
//                                               color: Color(0xFF442B72),
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text: ' *',
//                                             style: TextStyle(
//                                               color: Colors.red,
//                                               fontSize: 15,
//                                               fontFamily: 'Poppins-Bold',
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 15,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         GestureDetector(
//                                           child: Container(
//                                             child:
//                                             SizedBox(
//                                                 width: 84,
//                                                 height: 87,
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Image.asset('assets/images/school (1) 1.png' ,
//                                                     width: 32,
//                                                     height: 32,),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Text('School'.tr ,
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         fontFamily: 'Poppins-Regular',
//                                                         fontWeight: FontWeight.w500,
//                                                         color: Colors.white),),
//                                                   ],
//                                                 )),
//                                             decoration: BoxDecoration(
//                                                 // border: Border.all(
//                                                 //   color: selectedContainer == 1 ? Color(0xFF442B72) : Colors.transparent,
//                                                 //   width: selectedContainer == 1 ? 3 : 0,
//                                                 // ),
//                                               gradient: LinearGradient(
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                                   colors: [ Color(0xff442B72) ,
//                                                     Color(0xffA79FD9)
//                                                   ]
//                                               )
//                                             ),
//                                           ),
//                                           onTap: (){
//                                             setState(() {
//                                               selectedImage = 1;
//                                             });
//                                           },
//                                         ),
//                                         GestureDetector(
//                                           onTap: (){
//                                             setState(() {
//                                               selectedImage = 2;
//                                             });
//                                           },
//                                           child: Container(
//                                             child:
//                                             SizedBox(
//                                                 width: 84,
//                                                 height: 87,
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Image.asset('assets/images/supervisor 1 (1).png',
//                                                       width: 43,
//                                                       height: 43),
//                                                     SizedBox(
//                                                       height: 0,
//                                                     ),
//                                                     Text('Supervisor'.tr ,
//                                                       style: TextStyle(
//                                                         fontSize: 10,
//                                                           fontFamily: 'Poppins-Regular',
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.white),),
//                                                   ],
//                                                 )),
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                                   colors: [ Color(0xffA79FD9) ,
//                                                     Color(0xff442B72)
//                                                   ]
//                                               )
//                                             ),
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           child: Container(
//                                             child:
//                                             SizedBox(
//                                                 width: 84,
//                                                 height: 87,
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Image.asset(
//                                                       'assets/images/father-and-son 1.png',
//                                                       width: 40,
//                                                       height: 40,),
//                                                     SizedBox(
//                                                       height: 3,
//                                                     ),
//                                                     Text('Parent'.tr ,
//                                                       style: TextStyle(
//                                                           fontSize: 10,
//                                                           fontFamily: 'Poppins-Regular',
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.white),),
//                                                   ],
//                                                 )),
//
//                                             decoration: BoxDecoration(
//                                               // border:  Border.all(
//                                                 // width: _isChecked?3 : 0,
//                                                 //   color: _isChecked? Color(0xff442B72).withOpacity(0.5) : Colors.transparent),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Color(0xff442B72).withOpacity(0.5),
//                                                     blurRadius: 10,
//                                                     offset: Offset(0, 5),
//                                                   ),
//                                                 ],
//                                                 gradient:
//                                                 LinearGradient(
//                                                     begin: Alignment.topLeft,
//                                                     end: Alignment.bottomRight,
//                                                     colors: [ Color(0xffA79FD9) ,
//                                                       Color(0xff442B72)
//                                                     ]
//                                                 )
//                                             ),
//                                           ),
//                                           onTap: (){
//                                             setState(() {
//                                               _isChecked = !_isChecked;
//                                               selectedImage = 3;
//                                             });
//                                           },
//                                         ),
//
//                                       ],
//                                     ),
//
//                                     SizedBox(
//                                       height: constrains.maxWidth / 13,
//                                     ),
//                                     SizedBox(
//                                       width: constrains.maxWidth ,
//                                       child: Center(
// // <<<<<<< HEAD
//                                         child: ElevatedSimpleButton(
//                                           txt: 'Create Account'.tr,
//                                           onPress: () async {
//                                               String EnteredPhoneNumber = PhoneNumberController.text;
//                                               bool isNumberExits = await checkIfNumberExists(EnteredPhoneNumber);
//                                               setState(() {
//                                                 isPhoneExiting = isNumberExits ;
//                                               });
//                                               if(isNumberExits){
//                                                 print('object');
//                                               Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                   // children.isNotEmpty?
//                                                   LoginScreen(
//
//                                                     )
//                                                   //no data
//                                                 // : NoInvitation( selectedImage: selectedImage)
//                                               ));
//                                               }
//                                               else {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                         // children.isNotEmpty?
//                                                         OtpScreen(verificationId: '',
//
//                                                         )
//                                                       //no data
//                                                       // : NoInvitation( selectedImage: selectedImage)
//                                                     ));
//                                                 print('no');
//                                                 SnackBar(
//                                                   content: Text('Name does not exist in the document.'),
//                                                 );
//                                               }},
//                                                     // NoInvitation())),
//                                           width: constrains.maxWidth ,
//                                           hight: 48,
//                                           color: const Color(0xFF442B72),
//                                           fontSize: 16,
//                                           fontFamily: 'Poppins-Regular',
//                                         ),
// // =======
//                                         // child: ElevatedSimpleButton(
//                                         //   txt: 'Create Account'.tr,
//                                         //   onPress: () =>
//                                         //       Navigator.push(
//                                         //       context,
//                                         //       MaterialPageRoute(
//                                         //           builder: (context) =>
//                                         //           // children.isNotEmpty?
//                                         //             OtpScreen(
//                                         //               selectedImage: selectedImage,
//                                         //             )
//                                         //           //no data
//                                         //         // : NoInvitation( selectedImage: selectedImage)
//                                         //       )
//                                         //   ),
//                                         //             // NoInvitation())),
//                                         //   width: constrains.maxWidth ,
//                                         //   hight: 48,
//                                         //   color: const Color(0xFF442B72),
//                                         //   fontSize: 16,
//                                         //   fontFamily: 'Poppins-Regular',
//                                         // ),
// // >>>>>>> 075f556c54a2b6bff59c5d34717861a72a7ae1eb
//                                       ),
//                                     ) ,
//                                     SizedBox( height:2),
//                                     SizedBox(
//                                       height: 16,
//                                       width: constrains.maxWidth / 1.4,
//                                       child: GestureDetector(
//                                         onTap: () => Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                 const LoginScreen())),
//                                         child: Align(
//                                           alignment: Alignment.center,
//                                           child: Text.rich(
//                                             TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: 'Already Have an account?'.tr,
//                                                   style: TextStyle(
//                                                       color: Color(0xff263238),
//                                                       fontSize: 12,
//                                                       fontFamily: 'Poppins-Light',
//                                                       fontWeight: FontWeight.w500
//                                                   ),) ,
//                                                 TextSpan(
//                                                   text: ' Sign in'.tr,
//                                                   style: TextStyle(
//                                                     color: Color(0xFF442B72),
//                                                     fontSize: 12,
//                                                     fontFamily: 'Poppins-Light',
//                                                     fontWeight: FontWeight.w500,
//                                                     height: 1.33,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ))
//                           ],
//                         ),
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             );
//           })),
//     );
//   }
// }
//
