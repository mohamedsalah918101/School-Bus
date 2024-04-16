import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/children_card.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
import 'package:school_account/supervisor_parent/components/text_form_field_login_custom.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent_takebus.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../components/bus_component.dart';
import '../components/child_card.dart';
import '../components/main_bottom_bar.dart';
import '../components/supervisor_card.dart';
import 'notification_parent.dart';

class EditChildren extends StatefulWidget {
  // Function() onTapMenu;

  EditChildren({
    Key? key,
    // required this.onTapMenu,
  }) : super(key: key);

  @override
  _EditChildrenState createState() => _EditChildrenState();
}

class _EditChildrenState extends State<EditChildren> {
  bool isMale = false;
  bool isFemale = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: HomeDrawer(),
        key: _scaffoldKey,
        body: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child:  Image.asset(
                        (sharedpref?.getString('lang') == 'ar')?
                        'assets/images/Layer 1.png':
                        'assets/images/fi-rr-angle-left.png',
                        width: 22,
                        height: 22,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'My Children'.tr,
                      style: TextStyle(
                        color: Color(0xFF993D9A),
                        fontSize: 16,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:(){
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    // onTapMenu,
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xff442B72),
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                   Padding(
                     padding:
                     (sharedpref?.getString('lang') == 'ar') ?
                     EdgeInsets.symmetric(horizontal: 25.0):
                     EdgeInsets.symmetric(horizontal: 0.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Center(
                           child: SizedBox(
                             width: 110,
                             child: Padding(
                               padding: const EdgeInsets.only(left: 12.0),
                               child: Stack(
                                 children: [
                                   GestureDetector(
                                     child: CircleAvatar(
                                         radius: 47,
                                         backgroundColor: Color(0xff442B72),
                                         child: CircleAvatar(
                                           backgroundImage: AssetImage("assets/images/Ellipse 1.png" ,
                                           ),
                                           radius: 45,)
                                     ),
                                   ),
                                   Positioned(
                                     bottom: 2,
                                     right: 10,
                                     child:  Container(
                                         width: 20,
                                         height: 20,
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           // shape: BoxShape.circle,
                                           border: Border.all(
                                             color: Color(0xff442B72),
                                             width: 2.0,
                                           ),
                                           borderRadius: BorderRadius.all(Radius.circular(50.0),),),
                                         child: Padding(
                                           padding: const EdgeInsets.all(3.0),
                                           child: Image.asset(
                                             'assets/images/image-editing 1.png' ,),
                                         )
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           ),
                         ),
                         SizedBox(
                           height: 12,
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left: 25.0),
                           child: Text.rich(
                             TextSpan(
                               children: [
                                 TextSpan(
                                   text: 'Name'.tr,
                                   style: TextStyle(
                                     color: Color(0xFF442B72),
                                     fontSize: 15,
                                     fontFamily: 'Poppins-Bold',
                                     fontWeight: FontWeight.w700,
                                     height: 0.94,
                                   ),
                                 ),
                                 TextSpan(
                                   text: ' *',
                                   style: TextStyle(
                                     color: Colors.red,
                                     fontSize: 15,
                                     fontFamily: 'Poppins-Bold',
                                     fontWeight: FontWeight.w700,
                                     height: 0.94,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ) ,
                         SizedBox(height: 10,),
                         Padding(
                           padding:
                           (sharedpref?.getString('lang') == 'ar') ?
                           EdgeInsets.symmetric(horizontal: 0.0):
                           EdgeInsets.symmetric(horizontal: 26.0),
                           child: SizedBox(
                             width: 322,
                             height: 38,
                             child: TextFormField(
                               cursorColor: const Color(0xFF442B72),
                               textDirection: (sharedpref?.getString('lang') == 'ar') ?
                               TextDirection.rtl:
                               TextDirection.ltr,
                               scrollPadding:  EdgeInsets.symmetric(
                                   vertical: 30),
                               decoration:  InputDecoration(
                                 alignLabelWithHint: true,
                                 counterText: "",
                                 fillColor: const Color(0xFFF1F1F1),
                                 filled: true,
                                 contentPadding:
                                 (sharedpref?.getString('lang') == 'ar') ?
                                 EdgeInsets.fromLTRB(166, 0, 17, 40):
                                 EdgeInsets.fromLTRB(17, 0, 166, 40),
                                 hintText:'Mariam Atef'.tr,
                                 floatingLabelBehavior:  FloatingLabelBehavior.never,
                                 hintStyle: const TextStyle(
                                   color: Color(0xFF442B72),
                                   fontSize: 12,
                                   fontFamily: 'Poppins-Bold',
                                   fontWeight: FontWeight.w700,
                                   height: 1.33,
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),
                                 ),
                                 // enabledBorder: myInputBorder(),
                                 // focusedBorder: myFocusBorder(),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(
                           height: 18,
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left: 25.0),
                           child: Text.rich(
                             TextSpan(
                               children: [
                                 TextSpan(
                                   text: 'Grade'.tr,
                                   style: TextStyle(
                                     color: Color(0xFF442B72),
                                     fontSize: 15,
                                     fontFamily: 'Poppins-Bold',
                                     fontWeight: FontWeight.w700,
                                     height: 0.94,
                                   ),
                                 ),
                                 TextSpan(
                                   text: ' *',
                                   style: TextStyle(
                                     color: Colors.red,
                                     fontSize: 15,
                                     fontFamily: 'Poppins-Bold',
                                     fontWeight: FontWeight.w700,
                                     height: 0.94,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ) ,
                         SizedBox(height: 10,),
                         Padding(
                           padding:
                           (sharedpref?.getString('lang') == 'ar') ?
                           EdgeInsets.symmetric(horizontal: 0.0):
                           EdgeInsets.symmetric(horizontal: 26.0),
                           child: SizedBox(
                             width: 322,
                             height: 36,
                             child: TextFormField(
                               cursorColor: const Color(0xFF442B72),
                               textDirection: (sharedpref?.getString('lang') == 'ar') ?
                               TextDirection.rtl:
                               TextDirection.ltr,
                               scrollPadding: const EdgeInsets.symmetric(
                                   vertical: 30),
                               decoration:  InputDecoration(
                                 alignLabelWithHint: true,
                                 counterText: "",
                                 fillColor: const Color(0xFFF1F1F1),
                                 filled: true,
                                 contentPadding:
                                 (sharedpref?.getString('lang') == 'ar') ?
                                 EdgeInsets.fromLTRB(166, 0, 17, 40):
                                 EdgeInsets.fromLTRB(17, 0, 166, 40),
                                 hintText:'4',
                                 floatingLabelBehavior:  FloatingLabelBehavior.never,
                                 hintStyle: const TextStyle(
                                   color: Color(0xFF442B72),
                                   fontSize: 12,
                                   fontFamily: 'Poppins-Bold',
                                   fontWeight: FontWeight.w700,
                                   height: 1.33,
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),
                                 ),
                                 // enabledBorder: myInputBorder(),
                                 // focusedBorder: myFocusBorder(),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(
                           height: 30,
                         ),
                         Padding(
                           padding:
                           (sharedpref?.getString('lang') == 'ar') ?
                           EdgeInsets.symmetric(horizontal: 0.0):
                           EdgeInsets.symmetric(horizontal: 25.0),
                           child: Text('Gender'.tr,
                             style: TextStyle(
                               fontSize: 15 ,
                               // height:  0.94,
                               fontFamily: 'Poppins-Bold',
                               fontWeight: FontWeight.w700 ,
                               color: Color(0xff442B72),),),
                         ) ,
                         SizedBox(
                           height: 10,
                         ),
                         Padding(
                           padding: (sharedpref?.getString('lang') == 'ar') ?
                           EdgeInsets.only(left: 0.0):
                           EdgeInsets.only(left: 15.0),
                           child: Row(
                             children: [
                               Radio(
                                 value: true,
                                 groupValue: isFemale,
                                 onChanged: (bool? value) {
                                   if (value != null) {
                                     setState(() {
                                       isFemale = value;
                                       isMale = !value;
                                     });
                                   }
                                 },
                                 activeColor: Color(0xff442B72), // Set the color of the selected radio button
                               ),
                               Text(
                                 "Female".tr ,
                                 style: TextStyle(
                                   fontSize: 15 ,
                                   fontFamily: 'Poppins-Regular',
                                   fontWeight: FontWeight.w500 ,
                                   color: Color(0xff442B72),),
                               ),
                               SizedBox(
                                 width: 110,
                               ),
                               Radio(
                                 value: true,
                                 groupValue: isMale,
                                 onChanged: (bool? value) {
                                   if (value != null) {
                                     setState(() {
                                       isFemale = !value;
                                       isMale = value;
                                     });
                                   }
                                 },
                                 activeColor: Color(0xff442B72), // Set the color of the selected radio button
                               ),
                               Text("Male".tr,
                                 style: TextStyle(
                                   fontSize: 15 ,
                                   fontFamily: 'Poppins-Regular',
                                   fontWeight: FontWeight.w500 ,
                                   color: Color(0xff442B72),),),
                             ],
                           ),
                         ),
                         SizedBox(height: 30,),
                         Padding(
                           padding: const EdgeInsets.only(left: 25.0),
                           child: Text('Location *'.tr,
                             style: TextStyle(
                               fontSize: 15 ,
                               // height:  0.94,
                               fontFamily: 'Poppins-Bold',
                               fontWeight: FontWeight.w700 ,
                               color: Color(0xff442B72),),),
                         ) ,
                         SizedBox(height: 10,),
                         Padding(
                           padding:
                           (sharedpref?.getString('lang') == 'ar') ?
                           EdgeInsets.symmetric(horizontal: 0.0):
                           EdgeInsets.symmetric(horizontal: 26.0),
                           child: SizedBox(
                             width: 322,
                             height: 37,
                             child: TextFormField(
                               cursorColor: const Color(0xFF442B72),
                               textDirection: (sharedpref?.getString('lang') == 'ar') ?
                               TextDirection.rtl:
                               TextDirection.ltr,
                               scrollPadding: const EdgeInsets.symmetric(
                                   vertical: 30),
                               decoration:  InputDecoration(
                                 suffixIconColor: Color(0xFF442B72),
                                 suffixIcon: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Image.asset('assets/images/locations.png',
                                   ),
                                 ),
                                 alignLabelWithHint: true,
                                 counterText: "",
                                 fillColor: const Color(0xFFF1F1F1),
                                 filled: true,
                                 contentPadding:
                                 (sharedpref?.getString('lang') == 'ar') ?
                                 EdgeInsets.fromLTRB(166, 0, 17, 40):
                                 EdgeInsets.fromLTRB(17, 0, 166, 40),
                                 hintText:'16 Khaled st,Asyut,Egypt'.tr,
                                 floatingLabelBehavior:  FloatingLabelBehavior.never,
                                 hintStyle: const TextStyle(
                                   color: Color(0xFF442B72),
                                   fontSize: 12,
                                   fontFamily: 'Poppins-Bold',
                                   fontWeight: FontWeight.w700,
                                   height: 1.33,
                                 ),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(7)),
                                   borderSide: BorderSide(
                                     color: Color(0xFF442B72),
                                     width: 0.5,
                                   ),
                                 ),
                                 // enabledBorder: myInputBorder(),
                                 // focusedBorder: myFocusBorder(),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(height: 40,),
                         Center(
                           child: ElevatedSimpleButton(
                               txt: 'Save'.tr,
                               fontFamily: 'Poppins-Regular',
                               width: 117,
                               hight: 38,
                               onPress: (){

              DataSavedSnackBar(context, 'Data saved successfully');
                               },
                               color: Color(0xFF442B72),
                               fontSize: 16),
                         ),
                       ],
                     ),
                   )
                    // SizedBox(height: 15,)
                  ],
                ),
              ),
            ),
          ],
        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)),
          backgroundColor: Color(0xff442B72),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileParent(
                  // onTapMenu: onTapMenu
                )));
          },
          child: Image.asset(
            'assets/images/174237 1.png',
            height: 33,
            width: 33,
            fit: BoxFit.cover,
          ),
        ),
        bottomNavigationBar: Directionality(
            textDirection: Get.locale == Locale('ar')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomAppBar(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    height: 60,
                    color: const Color(0xFF442B72),
                    clipBehavior: Clip.antiAlias,
                    shape: const AutomaticNotchedShape(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38.5),
                                topRight: Radius.circular(38.5))),
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)))),
                    notchMargin: 7,
                    child: SizedBox(
                        height: 10,
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top:7 , right: 15):
                                  EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Home".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 7, left: 70):
                                  EdgeInsets.only( right: 70 ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 16.56,
                                          width: 16.2
                                      ),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Notifications".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                  EdgeInsets.only(top: 10 , bottom:4 ,left: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (3).png',
                                          height: 18.75,
                                          width: 18.75
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Calendar".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrackParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 10 , bottom: 2 ,right: 12,left: 15):
                                  EdgeInsets.only(top: 10 , bottom: 2 ,left: 12,right: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Track".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))))
    );
  }
}


