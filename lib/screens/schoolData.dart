import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';



class SchoolData extends StatefulWidget{
  const SchoolData({super.key});
  @override
  State<SchoolData> createState() => _SchoolDataState();
}


class _SchoolDataState extends State<SchoolData> {

  MyLocalController ControllerLang = Get.find();
  TextEditingController _nameEnglish = TextEditingController();
  TextEditingController _nameArabic = TextEditingController();
  TextEditingController _Address = TextEditingController();
  TextEditingController _coordinatorName = TextEditingController();
  TextEditingController _supportNumber = TextEditingController();
  final _NameArabicFocus = FocusNode();
  final _AddressFocus = FocusNode();
  final _CoordinatorFocus = FocusNode();
  final _SupporterFocus = FocusNode();

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
        //غيرت resizeToAvoidBottomInset من false ل true علشان لما اكتب ال تيكست فيلد يظهر
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: InkWell(onTap: (){},
                //     child: const Icon(
                //       Icons.menu_rounded,
                //       size: 40,
                //       color: Color(0xff442B72),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Text(
                    "Welcome".tr,
                    style: TextStyle(
                      color: Color(0xFF993D9A),
                      fontSize: 25,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.bold,
                      height: 0.64,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            //   child: InkWell(
                            //     onTap: ()
                            //     {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   MainBottomNavigationBar(pageNum: 5),
                            //               maintainState: false));
                            //     },
                            //     // child: Image.asset(
                            //     //   'assets/imgs/school/Vector (11).png',
                            //     //   width: 22,
                            //     //   height: 22,
                            //     // ),
                            //   ),
                            // ),
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School logo".tr,
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


                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.4,
                            //   hintTxt: 'Your Phone'.tr,
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(alignment: AlignmentDirectional.center,
                              child: Container(
                                width: 100, // Adjust width as needed
                                height: 100, // Adjust height as needed
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                  image: DecorationImage(
                                    image: AssetImage('assets/imgs/school/Frame 61.png'), // Provide the path to your image
                                    fit: BoxFit.fill, // Adjust the fit as needed
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School name in English".tr,
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
                                //   'School name in English'.tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _nameEnglish,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_NameArabicFocus);
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
                            //   hintTxt: 'Your Name'.tr,
                            //
                            // ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School name in Arabic".tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _nameArabic,
                                focusNode: _NameArabicFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_AddressFocus);
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
                            //   hintTxt: 'Your Name'.tr,
                            // ),
                            const SizedBox(
                              height: 25,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Address".tr,
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
                            // textform field without icon location
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: ''.tr,
                            //
                            //
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 45,
                              child: TextFormField(
                                controller: _Address,
                                focusNode: _AddressFocus,
                                cursorColor: const Color(0xFF442B72),
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_CoordinatorFocus);
                                },
                                style: TextStyle(color: Color(0xFF442B72)),
                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  suffixIcon: Image.asset("assets/imgs/school/icons8_Location.png",width: 23,height: 23,),
                                  //Icon(Icons.location_on,color: Color(0xFF442B72),size: 23,),
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  //  hintText:"".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFC2C2C2),
                                    fontSize: 12,
                                    fontFamily: 'Inter-Bold',
                                    fontWeight: FontWeight.w700,
                                    height: 1.33,
                                  ),
                                  enabledBorder: myInputBorder(),
                                  focusedBorder: myFocusBorder(),

                                ),
                              ),
                            ),


                            const SizedBox(
                              height: 25,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Coordinator Name".tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,

                              height: 44,
                              child: TextFormField(
                                controller: _coordinatorName,
                                focusNode: _CoordinatorFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_SupporterFocus);
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
                                  enabledBorder: myInputBorder(),
                                  // focusedBorder: myFocusBorder(),
                                  // enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),

                              ),
                            ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: "Name".tr,
                            // ),
                            const SizedBox(
                              height: 25,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Support Number".tr,
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
                                //   "Support Number".tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _supportNumber,
                                focusNode: _SupporterFocus,
                                keyboardType: TextInputType.number,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  // FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
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
                                  hintText:"Number".tr,
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
                            //   hintTxt: "Number".tr,
                            // ),

                            SizedBox(
                              //height: constrains.maxWidth /13,
                              height: 40,
                            ),

                            SizedBox(
                              width: constrains.maxWidth / 1.2,
                              child: Center(
                                child: ElevatedSimpleButton(
                                  txt: "Submit".tr,
                                  onPress: (){
                                    Navigator.push(
                                        context ,
                                        MaterialPageRoute(
                                            builder: (context) =>  HomeScreen(),
                                            maintainState: false));
                                  },
                                  width: constrains.maxWidth /1.2,
                                  hight: 48,
                                  color: const Color(0xFF442B72),
                                  fontSize: 16,


                                ),
                                // end of comment
                              ),
                            ) ,

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
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //
        // floatingActionButton:


        //   Padding(
        //     padding: const EdgeInsets.all(2.0),
        //     child: SizedBox(
        //       //height: 100,
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //
        //         },
        //         child: Image.asset(
        //           'assets/imgs/school/Ellipse 2.png',
        //           fit: BoxFit.fill,
        //         ),
        // ),
        //     ),
        //   ),


        // bottomNavigationBar:Directionality(
        //   textDirection: TextDirection.ltr,
        //   child: ClipRRect(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(25),
        //       topRight: Radius.circular(25),
        //     ),
        //
        //     child: BottomAppBar(
        //
        //       color: const Color(0xFF442B72),
        //       clipBehavior: Clip.antiAlias,
        //       shape: const CircularNotchedRectangle(),
        //       //shape of notch
        //       notchMargin: 7,
        //       child: SizedBox(
        //         height: 50,
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 0.0),
        //           child: SingleChildScrollView(
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: <Widget>[
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(
        //                       horizontal: 2.0,
        //                       vertical:5),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  HomeScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/icons8_home_1 1.png',
        //                               height: 21, width: 21),
        //                           Text("Home".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 8),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  NotificationScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/clarity_notification-line (1).png',
        //                               height: 22, width: 22),
        //                           Text('Notification'.tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left:100),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  SupervisorScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/empty_supervisor.png',
        //                               height: 22, width: 22),
        //                           Text("Supervisor".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize:10)),
        //                         ]
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding:
        //                   const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) => BusScreen(),
        //                               maintainState: false));
        //                       // _key.currentState!.openDrawer();
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/ph_bus-light (1).png',
        //                               height: 22, width: 22),
        //                           Text("Buses".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //               ]
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}



