import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:school_account/supervisor_parent/components/add_additional_data.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_children.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/added_child_card.dart';

class EditProfileParent extends StatefulWidget {
  @override
  _EditProfileParentState createState() => _EditProfileParentState();
}

class _EditProfileParentState extends State<EditProfileParent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<Widget> cards = [];
  // int cardCount = 0;
  // bool AddCard = false;

  // void addCard() {
  //   setState(() {
  //     cardCount++;
  //     cards.add(AddAditionalData(cardCount));
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: HomeDrawer(),
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 12,
                offset: Offset(-1, 4),
                spreadRadius: 0,
              )
            ]),
            child: AppBar(
              toolbarHeight: 70,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.49),
                ),
              ),
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.all( 23.0):
                  EdgeInsets.all( 17.0),
                  child: Image.asset(
                    (sharedpref?.getString('lang') == 'ar')
                        ? 'assets/images/Layer 1.png'
                        : 'assets/images/fi-rr-angle-left.png',
                    width: 10,
                    height: 22,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Color(0xff442B72),
                      size: 35,
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: (sharedpref?.getString('lang') == 'ar') ?
                EdgeInsets.only(left: 15.0):
                EdgeInsets.only(left: 0.0),
                child: Text(
                  'Edit Profile'.tr,
                  style: const TextStyle(
                    color: Color(0xFF993D9A),
                    fontSize: 17,
                    fontFamily: 'Poppins-Bold',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              backgroundColor: Color(0xffF8F8F8),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        // Custom().customAppBar(context, 'Profile'.tr),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            (sharedpref?.getString('lang') == 'ar') ?
            EdgeInsets.symmetric(horizontal: 25.0):
            EdgeInsets.symmetric(horizontal:  0.0),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                SizedBox(height: 50,),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: Padding(
                      padding:
                      (sharedpref?.getString('lang') == 'ar')?
                      EdgeInsets.only(right: 45.0):
                      EdgeInsets.only(left: 50.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                                radius: 52.5,
                                backgroundColor: Color(0xff442B72),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/Ellipse 1.png" ,
                                  ),
                                  radius: 50.5,)
                            ),
                          ),
                          (sharedpref?.getString('lang') == 'ar') ?
                          Positioned(
                            bottom: 2,
                            left: 55,
                            child:  Container(
                                width: 24,
                                height: 24,
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
                          ):
                          Positioned(
                            bottom: 2,
                            right: 48,
                            child:  Container(
                                width: 24,
                                height: 24,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text('Name'.tr
                    , style: TextStyle(
                      fontSize: 15 ,
                      // height:  0.94,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700 ,
                      color: Color(0xff442B72),),),
                ) ,
                SizedBox(height: 12,),
                Padding(
                  padding:
                  (sharedpref?.getString('lang') == 'ar') ?
                  EdgeInsets.symmetric(horizontal: 0.0):
                  EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 38,
                    child: TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
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
                        hintText:'Rania Ahmed'.tr,
                        floatingLabelBehavior:  FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
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
                  child: Text('Number'.tr
                    , style: TextStyle(
                      fontSize: 15 ,
                      // height:  0.94,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700 ,
                      color: Color(0xff442B72),),),
                ) ,
                SizedBox(height: 12,),
                Padding(
                  padding:
                  (sharedpref?.getString('lang') == 'ar') ?
                  EdgeInsets.symmetric(horizontal: 0.0):
                  EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 38,
                    child: TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
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
                        hintText:'0128361532'.tr,
                        floatingLabelBehavior:  FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
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
                  height: 25,
                ),
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
                SizedBox(height: 12,),
                Padding(
                  padding:
                  (sharedpref?.getString('lang') == 'ar') ?
                  EdgeInsets.symmetric(horizontal: 0.0):
                  EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 37,
                    child: TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      cursorColor: const Color(0xFF442B72),
                      textDirection: (sharedpref?.getString('lang') == 'ar') ?
                      TextDirection.rtl:
                      TextDirection.ltr,
                      scrollPadding: const EdgeInsets.symmetric(
                          vertical: 30),
                      decoration:  InputDecoration(
                        suffixIconColor: Color(0xFF442B72),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                        hintText:'16 Khaled st , Asyut , Egypt'.tr,
                        floatingLabelBehavior:  FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
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
                SizedBox(height: 35,),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Row(
                    children: [
                      Text(
                        'Additional Data'.tr,
                        style: TextStyle(
                          color: Color(0xFF771F98),
                          fontSize: 19,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8,),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => Dialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: SizedBox(
                                    width: 337,

                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child :Image.asset(
                                                'assets/images/closecircle.png',
                                                width: 27,
                                                height: 27,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Add Additional Data'.tr,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF432B72),
                                                fontFamily: 'Poppins-SemiBold',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Image.asset('assets/images/add_additional_data.png',
                                              width: 85,
                                              height: 89,),

                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child:
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Name'.tr,
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
                                          ) ,
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding:
                                            (sharedpref?.getString('lang') == 'ar') ?
                                            EdgeInsets.symmetric(horizontal: 0.0):
                                            EdgeInsets.symmetric(horizontal: 12.0),
                                            child: SizedBox(
                                              width: 277,
                                              height: 33,
                                              child: TextFormField(
                                                autofocus: true,
                                                textInputAction: TextInputAction.next,
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
                                                  EdgeInsets.fromLTRB(17, 0, 0, 40),
                                                  hintText:'Name'.tr,
                                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
                                                  hintStyle: const TextStyle(
                                                    color: Color(0xFFC2C2C2),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins-Bold',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.33,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
                                                      width: 0.5,
                                                    ),),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
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
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child:  Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Number'.tr,
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
                                            ),),
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding:
                                            (sharedpref?.getString('lang') == 'ar') ?
                                            EdgeInsets.symmetric(horizontal: 0.0):
                                            EdgeInsets.symmetric(horizontal: 12.0),
                                            child: SizedBox(
                                              width: 322,
                                              height: 33,
                                              child: TextFormField(
                                                autofocus: true,
                                                textInputAction: TextInputAction.done,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
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
                                                  EdgeInsets.fromLTRB(17, 0, 0, 40),
                                                  hintText:'Number'.tr,
                                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
                                                  hintStyle: const TextStyle(
                                                    color: Color(0xFFC2C2C2),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins-Bold',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.33,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
                                                      width: 0.5,
                                                    ),),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFFC53E),
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
                                            height: 25,
                                          ),
                                          Center(
                                            child: ElevatedSimpleButton(
                                              txt: 'Add'.tr,
                                              width: 222,
                                              hight: 40,
                                              onPress: () {
                                                // addCard();
                                                // SizedBox(height: 20,);
                                                Navigator.pop(context);
                                              },
                                              color: const Color(0xFF442B72),
                                              fontSize: 16,
                                              fontFamily: 'Poppins-Regular',

                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          );
                          // Dialoge.addAdditionalDataDialog(context);
                        },
                        child: Image.asset('assets/images/icons8_add 1.png',
                          width: 21.16,
                        height: 21.16,),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 45,),
                Center(
                  child: SizedBox(
                    width: 278,
                    height: 48,
                    child: ElevatedSimpleButton(
                      txt: 'Save'.tr,
                      width: 257,
                      hight: 42,
                      onPress: () {
                        DataSavedSnackBar(context, 'Data saved successfully');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileParent(
                            )));
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',

                    ),
                  ),
                ),
                SizedBox(height: 100,),

              ],
            ),
          ),
        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 7, right: 15)
                                      : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
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
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 7, left: 70)
                                      : EdgeInsets.only(right: 70),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 16.56,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
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
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(
                                      top: 12, bottom: 4, right: 10)
                                      : EdgeInsets.only(
                                      top: 10, bottom: 4, left: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (3).png',
                                          height: 18.75,
                                          width: 18.75),
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
                                          builder: (context) => TrackParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(
                                      top: 10,
                                      bottom: 2,
                                      right: 12,
                                      left: 15)
                                      : EdgeInsets.only(
                                      top: 10,
                                      bottom: 2,
                                      left: 12,
                                      right: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
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
                        ))))));
  }
}
