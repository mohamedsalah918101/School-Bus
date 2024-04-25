import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:school_account/components/main_bottom_bar.dart';
import 'package:school_account/screens/homeScreen.dart';
import 'package:school_account/screens/schoolData.dart';
import '../classes/loading.dart';
import '../components/elevated_simple_button.dart';
import '../main.dart';
import '../supervisor_parent/screens/no_invitation.dart';
//import '../components/main_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OtpScreen extends StatefulWidget {
  // const OtpScreen({super.key});
  //new code
  final String verificationId;
  int? type = 0;
  String? name;
  String? phone;
  String? typeName;


  OtpScreen({Key? key, required this.verificationId,this.type,this.name,this.phone,this.typeName}) : super(key: key);
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _timer;  // Variable to store the timer
  int _seconds = 60;
  String verificationId = '';
  TextEditingController _pinCodeController=TextEditingController();
  String enteredPhoneNumber = '';
  bool _isLoading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to start the timer
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;  // Decrement the seconds remaining
        } else {
          timer.cancel();  // Cancel the timer when countdown ends
          // You can perform any additional actions here when the timer ends
        }
      });
    });
  }
  final _firestore = FirebaseFirestore.instance;

  // void _addDataToSupervisorFirestore() async {
  //   //if (_formKey.currentState!.validate()) {
  //   // Define the data to add
  //   Map<String, dynamic> data = {
  //     'name': widget.name,
  //     'phoneNumber': widget.phone,
  //   };
  //
  //   // Add the data to the Firestore collection
  //   await _firestore.collection('supervisor').add(data).then((docRef) {
  //     print('Data added with document ID: ${docRef.id}');
  //     // showSnackBarFun(context);
  //   }).catchError((error) {
  //     print('Failed to add data: $error');
  //   });
  // }

  void _addDataToFirestore() async {
    //if (_formKey.currentState!.validate()) {
    // Define the data to add
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      'name': widget.name,
      'phoneNumber': widget.phone,
    'state':0,
    'invite':0
    };

    // Add the data to the Firestore collection
    await _firestore.collection(widget.typeName!).add(data).then((docRef) async {
      if(widget.type == 1){
        await sharedpref!.setInt('allData',0);
        await sharedpref!.setString('type', widget.typeName!);
        await sharedpref!.setString('id', docRef.id);
        Navigator.push(
            context ,
            MaterialPageRoute(
                builder: (context) =>  SchoolData(),
                maintainState: false));
      }else
      {
        await sharedpref!.setString('type', widget.typeName!);
        await sharedpref!.setString('id', docRef.id);
        await sharedpref!.setInt('invitstate',0);
        await sharedpref!.setInt('invit',0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoInvitation(selectedImage: widget.type!,),
                maintainState: false));

      }


      print('Data added with document ID: ${docRef.id}');
    }).catchError((error) {
      print('Failed to add data: $error');
      setState(() {
        _isLoading = false;
      });
    });

  }
  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    startTimer();
  }
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // Auto-retrieve verification code
  //       await _auth.signInWithCredential(credential);
  //
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Verification failed
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       // Save the verification ID for future use
  //       String smsCode ='_pinCodeController' ; // Code input by the user
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId,
  //         smsCode: smsCode,
  //       );
  //       // Sign the user in with the credential
  //       await _auth.signInWithCredential(credential);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolData()));
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //     timeout: Duration(seconds: 60),
  //   );
  // }
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
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/imgs/school/Group 237669.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topStart,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 23,
                                    color: Color(0xff442B72),
                                  ),
                                ),
                              ),

                              //Expanded(child: Container()),
                              Align(
                                alignment: Alignment.center,
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
                              //Expanded(child: Container())
                            ],
                          ),

                        ),
                        // Center(
                        //   child: Text(
                        //    'OTP'.tr,
                        //    style: TextStyle(
                        //      color: Color(0xFF442B72),
                        //      fontSize: 25,
                        //      fontFamily: 'Poppins-Bold',
                        //      fontWeight: FontWeight.w700,
                        //      height: 0.64,
                        //    ),
                        //                     ),
                        // ),
                        const SizedBox(
                          height: 35,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/imgs/school/Rating 1.png',
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
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                ),
                                child:
                                //start
                                PinCodeTextField(
                                  controller: _pinCodeController,
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
                                  animationDuration: const Duration(milliseconds: 300),
                                  keyboardType: TextInputType.number,
                                ),

                                //end
                              ),

                            ),
                            Align(alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal:30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          //color: Colors.black, // Setting default text color to black
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),

                                        children: [
                                          TextSpan(
                                            text: "Didn't receive the OTP".tr,
                                            style: TextStyle(color: Color(0xff263238)),
                                          ),
                                          TextSpan(
                                            text: " Resend OTP?".tr,
                                            style: TextStyle(color: Color(0xff442B72)),
                                          ),


                                        ],
                                      ),
                                    ),
                                    //Text("1 s".tr,style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: Color(0xff263238)),)
                                    Text(
                                      '$_seconds s',
                                      style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: Color(0xff263238)),
                                    ),
                                    // SizedBox(width: 55,),
                                    // Text("1 s".tr,style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.bold),
                                    // )
                                  ],
                                ),
                              ),
                              // Container(child: Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20),
                              //   child: Text("Didn't receive the Otp".tr),
                              // ),
                              // ),
                            ),


                          ],
                        ),
                        Flexible(child: Container()),
                        Center(
                          child: SizedBox(
                            width: constrains.maxWidth / 1.4,
                            child: Center(
                              child: ClipRect(

                                child: ElevatedSimpleButton(
                                  txt: 'Verify'.tr,
                                  width: constrains.maxWidth / 1.4,
                                  color: const Color(0xFF442B72),

                                  hight: 48,
                                  onPress: () async {
                                    setState(() {
                                      _isLoading =true;
                                    });

                                    //erifyPhoneNumber(enteredPhoneNumber);
                                    //my code
                                    try{
                                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode:_pinCodeController.text ,
                                      );
                                      // Sign the user in with the credential
                                      await _auth.signInWithCredential(credential);
                                      _addDataToFirestore();
                                      // final prefs = await SharedPreferences.getInstance();
                                      // prefs.setString('name', widget.name!);
                                      // prefs.setString('phoneNumber', widget.phone!);

                                    }catch(e){
                                      setState(() {
                                        _isLoading =false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Invalid code.')));

                                      print('lllll'+e.toString());
                                    }


                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => MainBottomNavigationBar(
                                    //           pageNum: 0,
                                    //         )));
                                  },
                                  fontSize: 16,

                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                      ],
                    ),
                  ),
                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),
                ],
              ),
            );
          })),
    );
  }
}