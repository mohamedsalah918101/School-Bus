import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../Functions/functions.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';



class SendInvitation extends StatefulWidget{
  const SendInvitation({super.key});
  @override
  State<SendInvitation> createState() => _SendInvitationState();
}


class _SendInvitationState extends State<SendInvitation> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  String docid='';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  MyLocalController ControllerLang = Get.find();
  // TextEditingController _namesupervisor=TextEditingController();
  // TextEditingController _numbersupervisor=TextEditingController();
  // TextEditingController _emailsupervisor=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  void _addDataToFirestore() async {
    //if (_formKey.currentState!.validate()) {
      // Define the data to add
      Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'state':0,
        'invite':1
      };
      print('phonenum');
      print( _phoneNumberController.text);
      // Add the data to the Firestore collection
      var check =await addSupervisorCheck(_phoneNumberController.text);
      if(!check) {
        var res =await checkUpdateSupervisor(_phoneNumberController.text);
        if(!res) {
      await _firestore.collection('supervisor').add(data).then((docRef) {
        docid=docRef.id;
        print('Data added with document ID: ${docRef.id}');

        // showSnackBarFun(context);
      }).catchError((error) {
        print('Failed to add data: $error');
      });
      // Clear the text fields
      _nameController.clear();
      _phoneNumberController.clear();
      _emailController.clear();
    }else{
          await _firestore.collection('supervisor').doc(docID).update(data);
          // Clear the text fields
          _nameController.clear();
          _phoneNumberController.clear();
          _emailController.clear();
        }

      }      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('this phone already added')));

  }
 // }
  bool _validateName = false;
  bool _validatePhone = false;
  final _nameSupervisorFocus = FocusNode();
  final _numberSupervisorFocus = FocusNode();
  final _emailSupervisorFocus = FocusNode();
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
  bool _phoneNumberEntered = true;

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
    super.initState();
    // responsible
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
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: InkWell(
                          onTap: () {
                            // Navigate back to the previous page
                            Navigator.pop(context);
                          },
                          // onTap: ()=>exit(0),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 23,
                            color: Color(0xff442B72),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Supervisors".tr,
                          style: TextStyle(
                            color: Color(0xFF993D9A),
                            fontSize: 25,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            height: 0.64,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: InkWell(onTap: (){},
                          child: Row(
                            children: [
                             Image(image: AssetImage("assets/imgs/school/icons8_Add_Male_User_Group 1.png"),width: 27,height: 27,
                               color: Color(0xff442B72),),
                              SizedBox(width: 10,),
                               InkWell(onTap: (){
                                 Scaffold.of(context).openEndDrawer();
                                },
                      child: Icon(
                        Icons.menu_rounded,
                      size: 40,
                        color: Color(0xff442B72),
                            ),)

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(
                  height: 40,
                ),
                
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Stack(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top:5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              // Adjust horizontal padding
                              child: SizedBox(
                                width: constrains.maxWidth / 1.4,

                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _nameController,
                                focusNode: _nameSupervisorFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                   FocusScope.of(context).requestFocus(_numberSupervisorFocus);
                                },
                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  errorText: _validateName ? "Please Enter Your Name" : null,
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  hintText:"Your Name".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFC2C2C2),
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.w700,
                                    height: 1.33,
                                  ),
                                  enabledBorder: myInputBorder(),
                                  // focusedBorder: myFocusBorder(),
                                  // enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                              ),
                            ),

                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Name'.tr,
                            // ),



                            // Container(
                            //   width: constrains.maxWidth / 1.2,
                            //   height: 38,
                            //   child:

                              // TextFormField(
                              //
                              //   // controller: _namesupervisor,
                              //   cursorColor: const Color(0xFF442B72),
                              //   //textDirection: TextDirection.ltr,
                              //   scrollPadding: const EdgeInsets.symmetric(
                              //       vertical: 40),
                              //   decoration:  InputDecoration(
                              //     // labelText: 'Shady Ayman'.tr,
                              //     hintText:'Name'.tr ,
                              //     hintStyle: const TextStyle(
                              //       color: Color(0xFFC2C2C2),
                              //       fontSize: 12,
                              //       fontFamily: 'Inter-Bold',
                              //       fontWeight: FontWeight.w700,
                              //       height: 1.33,
                              //     ),
                              //     alignLabelWithHint: true,
                              //     counterText: "",
                              //     fillColor: const Color(0xFFF1F1F1),
                              //     filled: true,
                              //     contentPadding: const EdgeInsets.fromLTRB(
                              //         8, 30, 10, 5),
                              //     floatingLabelBehavior:  FloatingLabelBehavior.never,
                              //     enabledBorder: myInputBorder(),
                              //     focusedBorder: myFocusBorder(),
                              //   ),
                              //
                              // ),
                            //),

                            const SizedBox(
                              height:15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
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
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Phone Number'.tr,
                            // ),
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 65,
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

                                },

                              ),
                            ),
                            // Container(
                            //   width: constrains.maxWidth / 1.2,
                            //   height: 38,
                            //   child: TextField(
                            //
                            //     //controller: _namesupervisor,
                            //     cursorColor: const Color(0xFF442B72),
                            //     //textDirection: TextDirection.ltr,
                            //     scrollPadding: const EdgeInsets.symmetric(
                            //         vertical: 40),
                            //     decoration:  InputDecoration(
                            //       // labelText: 'Shady Ayman'.tr,
                            //       hintText:'01028765006'.tr ,
                            //       alignLabelWithHint: true,
                            //       counterText: "",
                            //       fillColor: const Color(0xFFF1F1F1),
                            //       filled: true,
                            //       contentPadding: const EdgeInsets.fromLTRB(
                            //           8, 30, 10, 5),
                            //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                            //       enabledBorder: myInputBorder(),
                            //       focusedBorder: myFocusBorder(),
                            //     ),
                            //     keyboardType: TextInputType.number,
                            //   ),
                            // ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Your Name'.tr,
                            // ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  'Email'.tr,
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 15,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.w700,
                                    height: 1.07,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Your Name'.tr,
                            // ),
                            // Container(
                            //   width: constrains.maxWidth / 1.2,
                            //   height: 38,
                            //   child: TextField(
                            //
                            //     //controller: _namesupervisor,
                            //     cursorColor: const Color(0xFF442B72),
                            //     //textDirection: TextDirection.ltr,
                            //     scrollPadding: const EdgeInsets.symmetric(
                            //         vertical: 40),
                            //     decoration:  InputDecoration(
                            //       //labelText: 'Shady Ayman'.tr,
                            //       hintText:'Shahd@gmail.com'.tr ,
                            //       alignLabelWithHint: true,
                            //       counterText: "",
                            //       fillColor: const Color(0xFFF1F1F1),
                            //       filled: true,
                            //       contentPadding: const EdgeInsets.fromLTRB(
                            //           8, 30, 10, 5),
                            //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                            //       enabledBorder: myInputBorder(),
                            //       focusedBorder: myFocusBorder(),
                            //     ),
                            //
                            //   ),
                            // ),
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailSupervisorFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  //FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
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
                                  hintText:"Your Email".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFC2C2C2),
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.w700,
                                    height: 1.33,
                                  ),
                                  enabledBorder: myInputBorder(),
                                  // focusedBorder: myFocusBorder(),
                                  // enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                                // onFieldSubmitted: (value) {
                                //   // move to the next field when the user presses the "Done" button
                                //   FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                // },
                              ),
                            ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Email'.tr,
                            // ),
                            SizedBox(
                              height: 50,
                            ),



                            SizedBox(
                              width: constrains.maxWidth / 1.2,
                              child: Center(
                                child: ElevatedSimpleButton(
                                  txt: "Send invitation".tr,
                                 onPress: ()
                                 //async
                                 {
                                    // Navigator.push(
                                    //     context ,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>  HomeScreen(),
                                    //         maintainState: false)
                                    // );
                                   setState(() {
                                     _nameController.text.isEmpty ? _validateName = true : _validateName = false;
                                     _phoneNumberController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
                                   });
                                   if(! _nameController.text.isEmpty &&
                                       //! _phoneNumberController.text.isEmpty
                                   _phoneNumberController.text.length == 10){
                                     _addDataToFirestore();
                                     createDynamicLink(true,docid,_phoneNumberController.text,'supervisor');
                                     showSnackBarFun(context);
                                   }
                                   else{
                                     SnackBar(content: Text('Please,enter valid number'));
                                   }
                                //   _addDataToFirestore();
                                  },
                                  width: constrains.maxWidth /1.2,
                                  hight: 48,
                                  color: const Color(0xFF442B72),
                                  fontSize: 16,
                                ),
                                // end of comment
                              ),
                            ) ,
                            SizedBox(height: 30),


                            const SizedBox(
                              height: 60,
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

          );
        }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:


        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Image.asset(
                'assets/imgs/school/busbottombar.png',
                width: 35,
                height: 35,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),


        bottomNavigationBar:Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),

            child: BottomAppBar(

              color: const Color(0xFF442B72),
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              //shape of notch
              notchMargin: 7,
              child: SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                                vertical:5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context ,
                                    MaterialPageRoute(
                                        builder: (context) =>  HomeScreen(),
                                        maintainState: false));
                              },
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Image.asset('assets/imgs/school/icons8_home_1 1.png',
                                        height: 21, width: 21),
                                    Text("Home".tr,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context ,
                                    MaterialPageRoute(
                                        builder: (context) =>  NotificationScreen(),
                                        maintainState: false));
                              },
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Image.asset('assets/imgs/school/clarity_notification-line (1).png',
                                        height: 22, width: 22),
                                    Text('Notification'.tr,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:100),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context ,
                                    MaterialPageRoute(
                                        builder: (context) =>  SupervisorScreen(),
                                        maintainState: false));
                              },
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Image.asset('assets/imgs/school/supervisor (1) 1.png',
                                        height: 22, width: 22),
                                    Text("Supervisor".tr,
                                        style: TextStyle(
                                            color: Colors.white, fontSize:10)),
                                  ]
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context ,
                                    MaterialPageRoute(
                                        builder: (context) => BusScreen(),
                                        maintainState: false));
                                // _key.currentState!.openDrawer();
                              },
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.vertical,
                                  children: [
                                    Image.asset('assets/imgs/school/ph_bus-light (1).png',
                                        height: 22, width: 22),
                                    Text("Buses".tr,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ]),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  showSnackBarFun(context) {
    SnackBar snackBar = SnackBar(

      // content: const Text('Invitation sent successfully',
      //     style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff442B72))
      // ),
      content: Row(
        children: [
          // Add your image here
          Image.asset(
            'assets/imgs/school/Vector (4).png', // Replace 'assets/image.png' with your image path
            width: 30, // Adjust width as needed
            height: 30, // Adjust height as needed
          ),
          SizedBox(width: 20), // Add some space between the image and the text
          Text(
            'Invitation sent successfully',
            style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff4CAF50)),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 165,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}




