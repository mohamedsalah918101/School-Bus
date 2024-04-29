import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/decline_invitation_parent.dart';
import 'package:school_account/supervisor_parent/screens/sign_up.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/signUpScreen.dart';
import '../screens/login_screen.dart';
import 'elevated_simple_button.dart';

class Dialoge {

  static addAbsentCalenderDialog(context) {
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
          child: SizedBox(
            width: 337,
            height: 521,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Column(
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
                   Text(
                    'Select Absent Day'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF432B72),
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 301,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 12,
                          offset: Offset(-1, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SfDateRangePicker(
                      headerStyle: const DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          color: Color(0xFF771F98),
                          fontSize: 19,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // onSelectionChanged: _onSelectionChanged,
                      view: DateRangePickerView.month,
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(
                            color: Color(0xFF5F5F5F),
                            fontSize: 17,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        weekendDays: [0],
                        showTrailingAndLeadingDates: false,
                      ),

                      monthCellStyle: DateRangePickerMonthCellStyle(
                        weekendDatesDecoration: BoxDecoration(
                            color: const Color(0xFFFEDF96),
                            border: Border.all(
                                color: const Color(0xFFFEDF96), width: 1),
                            shape: BoxShape.circle),
                        todayCellDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border:
                                Border.all(color: Colors.transparent, width: 1),
                            shape: BoxShape.circle),
                        todayTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                        // specialDatesDecoration: BoxDecoration(
                        //     color: const Color(0xFF7A12FF),
                        //     border: Border.all(
                        //         color: const Color(0xFF7A12FF), width: 1),
                        //     shape: BoxShape.circle),
                        disabledDatesTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                        specialDatesDecoration: BoxDecoration(
                            color: const Color(0xFF7A12FF),
                            border: Border.all(
                                color: const Color(0xFF7A12FF), width: 1),
                            shape: BoxShape.circle),
                        specialDatesTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins-SemiBold',
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      selectionMode: DateRangePickerSelectionMode.multiple,
                      selectionColor: const Color(0xFF7A12FF),
                      rangeSelectionColor: const Color(0xFF7A12FF),
                      rangeTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins-SemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                      startRangeSelectionColor: const Color(0xFF7A12FF),
                      endRangeSelectionColor: const Color(0xFF7A12FF),
                      selectionTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins-Bold',
                        // fontWeight: FontWeight.w400,
                      ),
                      // initialSelectedRange: PickerDateRange(
                      //     DateTime.now().subtract(const Duration(days: 2)),
                      //     DateTime.now().add(const Duration(days: 3))),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Save'.tr,
                      width: 200,
                      hight: 42,
                      onPress: () {},
                      color: const Color(0xFF993D9A),
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',

                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  static addAdditionalDataDialog(context) {
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
              height: 521,
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
                      child: Text('Name *'.tr
                        , style: TextStyle(
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
                      EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        width: 277,
                        height: 33,
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
                      child: Text('Number *'.tr
                        , style: TextStyle(
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
                      EdgeInsets.symmetric(horizontal: 12.0),
                      child: SizedBox(
                        width: 277,
                        height: 33,
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
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Location'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.07,
                              ),
                            ),
                            TextSpan(
                              text: '*',
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
                            hintText:'Location'.tr,
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
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedSimpleButton(
                        txt: 'Add'.tr,
                        width: 257,
                        hight: 42,
                        onPress: () {

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
  }

  static setReminderDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          // contentPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            width: 304,
            height: 295,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          'Set Reminder'.tr,
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
                  const SizedBox(
                    height: 15
                    ,
                  ),
                   Text(
                    'You Set Reminder Before Bus Arrive'.tr,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 13,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 62.56,
                        height: 76.58,
                        decoration:  BoxDecoration(
                          borderRadius:
                          (sharedpref?.getString('lang') == 'ar') ?
                          BorderRadius.only(
                              topRight: Radius.circular(13),
                              bottomRight: Radius.circular(13)) :
                          BorderRadius.only(
                              topLeft: Radius.circular(13),
                              bottomLeft: Radius.circular(13)),
                          color: Color(0xFF9889B4),
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.minimize_rounded,
                              size: 45,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 28,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 89.52,
                        height: 76.54,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: .5,
                          ),
                          color: Colors.white,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                              '15',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.22,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                                height: 1.23,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 62.56,
                        height: 76.58,
                        decoration:  BoxDecoration(
                          borderRadius:
                          (sharedpref?.getString('lang') == 'ar') ?
                          BorderRadius.only(
                              topLeft: Radius.circular(13),
                              bottomLeft: Radius.circular(13)):
                          BorderRadius.only(
                              topRight: Radius.circular(13),
                              bottomRight: Radius.circular(13)),
                          color: Color(0xFF442B72),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                   Text(
                    'Minutes'.tr,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 15,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Set'.tr,
                      width: 200,
                      hight: 42,
                      onPress: () {
                        Navigator.pop(context);
                        // Dialoge.busArrivedDialog(context);
                      },
                      color: const Color(0xFF993D9A),
                      fontSize: 17,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static logOutDialog(context) {
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
                          'Logout'.tr,
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
                    'Are You Sure Logout?'.tr,
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
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Log out'.tr,
                        width: 110,
                        hight: 38,
                        onPress: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false),
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
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
                          width: 58,
                          child: Center(
                            child: Text(
                                'Cancel'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.w500 ,
                                    fontSize: 16)
                            ),
                          ),
                        ), onPressed: () {
                        Navigator.pop(context);
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
  static DeleteAccount(context) {
    void DeletedAccountSnackBar(context, String message, {Duration? duration}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.up,
          duration: duration ?? const Duration(milliseconds: 1000),
          backgroundColor: Colors.white,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 75,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/saved.png',
                width: 30,
                height: 30,),
              SizedBox(width: 15,),
              Text(
                'Account deleted successfully'.tr,
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 16,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1.23,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
            width: 304,
            height: 182,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                              height: 25,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Delete'.tr,
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
                  Center(
                    child: Text(
                      'Are You Sure you want to \n'
                          'delete account ?'.tr,
                        textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w400,
                        height: 1.23,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedSimpleButton(
                          txt: 'Delete'.tr,
                          width: 107,
                          hight: 38,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  SignUpScreen()),);
                            DeletedAccountSnackBar(context, 'message');
                          },
                          color: const Color(0xFF442B72),
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      // const Spacer(),
                      SizedBox(width: 15,),
                      SizedBox(
                        width: 107,
                        height: 38,
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFF442B72),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: Text(
                              'Cancel'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500 ,
                                  fontSize: 16)
                          ), onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                      ),
                      // ElevatedSimpleButton(
                      //   txt: 'Cancel'.tr,
                      //   width: 110,
                      //   hight: 38,
                      //   onPress: () {
                      //     Navigator.pop(context);
                      //   },
                      //   color: const Color(0xFF993D9A),
                      //   fontSize: 16,
                      //   fontFamily: 'Poppins-Regular',
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static DeleteParent(context) {
    void DeleteParentSnackBar(context, String message, {Duration? duration}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.up,
          duration: duration ?? const Duration(milliseconds: 1000),
          backgroundColor: Colors.white,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
          ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/saved.png',
                width: 30,
                height: 30,),
              SizedBox(width: 15,),
              Text(
                'Parent deleted successfully'.tr,
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 16,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1.23,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
            width: 304,
            height: 182,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                              height: 25,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Delete'.tr,
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
                  Center(
                    child: Text(
                      'Are You Sure you want to \n'
                          'delete this parent ?'.tr,
                        textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w400,
                        height: 1.23,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedSimpleButton(
                          txt: 'Delete'.tr,
                          width:  107,
                          hight: 38,
                          onPress: () async{
                            await FirebaseFirestore.instance.collection('parent').doc('hOwOveK2VrgS4JAWnqtz').delete();
                            DeleteParentSnackBar(context, 'message');
                            Navigator.pop(context);
                          },
                          color: const Color(0xFF442B72),
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      // const Spacer(),
                      SizedBox(width: 15,),
                      SizedBox(
                        width: 107,
                        height: 38,
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFF442B72),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: Text(
                              'Cancel'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500 ,
                                  fontSize: 16)
                          ), onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                      ),
                      // ElevatedSimpleButton(
                      //   txt: 'Cancel'.tr,
                      //   width: 110,
                      //   hight: 38,
                      //   onPress: () {
                      //     Navigator.pop(context);
                      //   },
                      //   color: const Color(0xFF993D9A),
                      //   fontSize: 16,
                      //   fontFamily: 'Poppins-Regular',
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static SavedSuccessfuly(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: SizedBox(
            height: 63,
            width:360,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/saved.png',
                  width: 30,
                  height: 30,),
                  SizedBox(width: 15,),
                  Text(
                    'Data saved successfully'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      height: 1.23,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static DeletedSuccessfuly(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: SizedBox(
            height: 63,
            width:360,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/saved.png',
                    width: 30,
                    height: 30,),
                  SizedBox(width: 15,),
                  Text(
                    'Child deleted successfully'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 16,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      height: 1.23,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static declinedInvitationDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                  const SizedBox(
                    height: 15,
                  ),
                   Text(
                    'Are you sure you want to \n '
                        'decline invitation ?'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                                     ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 107,
                        child: ElevatedSimpleButton(
                          txt: 'Decline'.tr,
                          // (sharedpref?.getString('lang') == 'ar')?
                          width: (sharedpref?.getString('lang') == 'ar')? 80 : 110,
                          hight: 38,
                          onPress: () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const DeclineInvitationParent()),
                              (Route<dynamic> route) => false),
                          color: const Color(0xFF442B72),
                          fontSize: 16,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      // const Spacer(),
                      SizedBox(width: 15,),
                      SizedBox(
                        width: 107,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFF442B72),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: Text(
                              'Cancel'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500 ,
                                  fontSize: 16)
                          ), onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static RemoveChildDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Are you sure you want to \n '
                        'remove this child ?'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete'.tr,
                        width: 107,
                        hight: 38,
                        onPress: () {
                          Navigator.pop(context);
                          showTopDeletedSnackBar(context, 'Child removed successfully'.tr);
                          },
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                      ),
                      // const Spacer(),
                      SizedBox(width: 10,),
                      SizedBox(
                        height: 38,
                        width: 107,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color(0xFF442B72),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: Text(
                              'Cancel'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500 ,
                                  fontSize: 16)
                          ), onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                      ),
                      // ElevatedSimpleButton(
                      //   txt: 'Cancel'.tr,
                      //   width: 110,
                      //   hight: 38,
                      //   onPress: () {
                      //     Navigator.pop(context);
                      //   },
                      //   color: const Color(0xFF993D9A),
                      //   fontSize: 16,
                      //   fontFamily: 'Poppins-Regular',
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  static busArrivedDialog(context) {
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
            width: 267,
            height: 314,
            child: Padding(
              padding:  EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Frame.png',
                    width: 207,
                    height: 133,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                   Text(
                    'The bus has\nfinally arrived!'.tr,
                     textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 17,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                    ),
                                     ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Okay'.tr,
                      width: 213,
                      hight: 42,
                      onPress: () {
                        Navigator.pop(context);
                        // Dialoge.busArrivedDialog(context);
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 17,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

}

void showTopDeletedSnackBar(BuildContext context, String message, {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.vertical,
      duration: duration ?? const Duration(milliseconds: 2000),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(
        bottom: 585,
      ),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/Vector (13)check.png',
          width: 24.38,
          height: 24.38,),
          SizedBox(width: 15,),
          Text(
            message,
            style: const TextStyle(
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xff4CAF50)
            ),
          ),
        ],
      ),
    ),
  );
}

