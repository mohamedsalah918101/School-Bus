import 'package:flutter/material.dart';
import 'package:school_account/screens/signUpScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


import '../screens/loginScreen.dart';
import 'elevated_simple_button.dart';

class Dialoge {
  static addAbsentCalenderDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 426,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Color(0xff442B72),
                          size: 25,
                        )),
                  ),
                  const Text(
                    'Select Absent Day',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF432B72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 260,
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

                      selectionMode: DateRangePickerSelectionMode.range,
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
                        fontFamily: 'Poppins-SemiBold',
                        fontWeight: FontWeight.w400,
                      ),
                      // initialSelectedRange: PickerDateRange(
                      //     DateTime.now().subtract(const Duration(days: 2)),
                      //     DateTime.now().add(const Duration(days: 3))),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Save',
                      width: 200,
                      hight: 42,
                      onPress: () {},
                      color: const Color(0xFF993D9A),
                      fontSize: 16,
                    ),
                  ),
                ],
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
        // contentPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
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
                            InkWell(
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
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Set Reminder',
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
                    height: 15,
                  ),
                  const Text(
                    'You Set Reminder Before Bus Arrive',
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 13,
                      fontFamily: 'Poppins-Regular',
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              bottomLeft: Radius.circular(13)),
                          color: Color(0xFF9889B4),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.minimize_rounded,
                              size: 27,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15,
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '15',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.22,
                                fontFamily: 'Poppins-Regular',
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(13),
                              bottomRight: Radius.circular(13)),
                          color: Color(0xFF442B72),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  const Text(
                    'Minutes',
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 15,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Set',
                      width: 200,
                      hight: 42,
                      onPress: () {
                        Dialoge.busArrivedDialog(context);
                      },
                      color: const Color(0xFF993D9A),
                      fontSize: 17,
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
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 210,
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
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                'assets/imgs/school/Vertical container (1).png',
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
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Logout',
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
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(
                  //         Icons.cancel_outlined,
                  //         color: Color(0xff442B72),
                  //         size: 25,
                  //       )),
                  // ),
                  // const Text(
                  //   'Logout',
                  //   style: TextStyle(
                  //     color: Color(0xFF442B72),
                  //     fontSize: 18,
                  //     fontFamily: 'Poppins-SemiBold',
                  //     fontWeight: FontWeight.w600,
                  //     height: 1.23,
                  //   ),
                  // ),
                  //
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Are You Sure Logout?',
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w400,
                      height: 1.23,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Log out',
                        width: 120,
                        hight: 38,

                        onPress: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false),
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                      ),
                      const Spacer(),
                      ElevatedSimpleButton(
                        txt: 'Cancel',
                        width: 120,
                        hight: 38,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        color: const Color(0xffffffff),
                        fontSize: 16,
                        txtColor: Color(0xFF442B72),
                      ),
                      // ElevatedSimpleButton(
                      //   txt: 'Cancel',
                      //   width: 110,
                      //   hight: 38,
                      //   onPress: () {
                      //     Navigator.pop(context);
                      //   },
                      //   color: const Color(0xFF993D9A),
                      //   fontSize: 16,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  //change photo dialog
  static changePhotoDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30,),
          ),
          child: Container(
            height: 280,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
               // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Change profile picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF771F98),
                            fontSize: 19,
                            fontFamily: 'Poppins-Medium',
                            fontWeight: FontWeight.w600,
                            height: 1.23,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CircleAvatar(
                          backgroundColor:Color(0xffE2E1EE),
                  child: Image.asset("assets/imgs/school/Vectorphoto.png",width: 21,height: 16,)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Select profile picture',
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 15,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w400,
                            height: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Save',
                      width: 250,
                      hight: 45,
                      onPress: () {
                        Navigator.pop(context);

                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }



  // when add supervisor that already add
  static SupervisorAlreadyAdded(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30,),
          ),
          child: Container(
            height: 220,
            width: 430,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Align(alignment:AlignmentDirectional.topStart,
              child: Image.asset("assets/imgs/school/Vertical container (2).png",width: 25,height: 25,)
            ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Alert',
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
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'This number already exists',
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w400,
                        height: 3,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Go to supervisors',
                      width: 180,
                      hight: 45,
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SupervisorScreen()));

                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                    ),
                  ),

                ],
              ),
            ),
          )),
    );
  }
  static SupervisorAlreadyAddedInOtherSchool(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30,),
          ),
          child: Container(
            height: 220,
            width: 430,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Align(alignment:AlignmentDirectional.topStart,
                        child: Image.asset("assets/imgs/school/Vertical container (2).png",width: 25,height: 25,)
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Alert',
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
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'This number already exists ',
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w400,
                        height: 2,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'in other school',
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w400,
                        height: 2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Center(
                  //   child: ElevatedSimpleButton(
                  //     txt: 'Go to supervisors',
                  //     width: 180,
                  //     hight: 45,
                  //     onPress: () {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>SupervisorScreen()));
                  //
                  //     },
                  //     color: const Color(0xFF442B72),
                  //     fontSize: 16,
                  //   ),
                  // ),

                ],
              ),
            ),
          )),
    );
  }
  static deleteBusDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 210,
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

                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Are you sure you want to delete this  bus?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 20,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w600,
                            height: 1.23,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete',
                        width: 120,
                        hight: 38,
                        onPress: (){},
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                      ),
                      const Spacer(),
                      ElevatedButton(style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set background color to white
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Adjust border radius as needed
                            side: BorderSide(
                              color: Color(0xFF442B72), // Set border color
                              width: 1.0, // Set border width
                            ),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(120, 38), // Set the desired width and height
                        ),
                      ),
                          onPressed: (){Navigator.pop(context);}, child: Text("Cancel",style: TextStyle(color:Color(0xFF442B72),fontSize: 16),))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  static deleteAccoubtDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 210,
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
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                'assets/imgs/school/Vertical container (1).png',
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
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Delete',
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
                    height: 10,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const
                      // Text(
                      //   'Are You Sure you want to delete account?',
                      //   style: TextStyle(
                      //     color: Color(0xFF442B72),
                      //     fontSize: 16,
                      //     fontFamily: 'Poppins-Regular',
                      //     fontWeight: FontWeight.w400,
                      //     height: 1.23,
                      //   ),
                      // ),
                      Center(
                        child: Align(alignment: AlignmentDirectional.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Are you sure you want to',
                                  style: TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 16,
                                    fontFamily: 'Poppins-Regular',
                                    //fontWeight: FontWeight.w400,
                                    height: 1.23,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'delete account?',
                                    style: TextStyle(
                                      color: Color(0xFF442B72),
                                      fontSize: 16,
                                      fontFamily: 'Poppins-Regular',
                                      // fontWeight: FontWeight.w400,
                                      height: 1.23,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete',
                        width: 120,
                        hight: 38,
                        onPress: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                                (Route<dynamic> route) => false),
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                      ),
                      const Spacer(),
                      ElevatedSimpleButton(
                        txt: 'Cancel',
                        width: 120,
                        hight: 38,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        color: const Color(0xffffffff),
                        fontSize: 16,
                        txtColor: Color(0xFF442B72),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  // static deletePhotoDialog(context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (ctx) => Dialog(
  //       // contentPadding: const EdgeInsets.all(20),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //             30,
  //           ),
  //         ),
  //         child: SizedBox(
  //           height: 210,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     const SizedBox(
  //                       width: 8,
  //                     ),
  //                     // Flexible(
  //                     //   child: Column(
  //                     //     children: [
  //                     //
  //                     //       const SizedBox(
  //                     //         height: 20,
  //                     //       )
  //                     //     ],
  //                     //   ),
  //                     // ),
  //                     // const Expanded(
  //                     //   flex: 3,
  //                     //   child:
  //                     //   Text(
  //                     //     'Delete',
  //                     //     textAlign: TextAlign.center,
  //                     //     style: TextStyle(
  //                     //       color: Color(0xFF442B72),
  //                     //       fontSize: 18,
  //                     //       fontFamily: 'Poppins-SemiBold',
  //                     //       fontWeight: FontWeight.w600,
  //                     //       height: 1.23,
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 50),
  //                     child: const Text(
  //                       'Are You Sure you want to delete photo?',
  //                       style: TextStyle(
  //                         color: Color(0xFF442B72),
  //                         fontSize: 16,
  //                         fontFamily: 'Poppins-Regular',
  //                         fontWeight: FontWeight.w400,
  //                         height: 1.23,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 30,
  //                 ),
  //                 Row(
  //                   children: [
  //                     ElevatedSimpleButton(
  //                       txt: 'Delete',
  //                       width: 120,
  //                       hight: 38,
  //                       onPress: () => {
  //
  //                       }
  //
  //                           // Navigator.of(context).pushAndRemoveUntil(
  //                           // MaterialPageRoute(
  //                           //     builder: (context) => const SignUpScreen()),
  //                           //     (Route<dynamic> route) => false)
  //                       ,
  //                       color: const Color(0xFF442B72),
  //                       fontSize: 16,
  //                     ),
  //                     const Spacer(),
  //                     ElevatedSimpleButton(
  //                       txt: 'Cancel',
  //                       width: 120,
  //                       hight: 38,
  //                       onPress: () {
  //                         Navigator.pop(context);
  //                       },
  //                       color: const Color(0xFF993D9A),
  //                       fontSize: 16,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )),
  //   );
  // }

  static busArrivedDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: SizedBox(
            height: 320,
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                  const Text(
                    'The bus has\nfinally arrived!',
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
                      txt: 'Okay',
                      width: 200,
                      hight: 42,
                      onPress: () {
                        Navigator.pop(context);
                        // Dialoge.busArrivedDialog(context);
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          )),
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
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
