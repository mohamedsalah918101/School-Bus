import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';


import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../classes/classDay.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import '../components/elevated_icon_button.dart';
import '../components/elevated_simple_button.dart';
import '../components/home_drawer.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'notificationsScreen.dart';

class VacationsScreen extends StatefulWidget {
  @override
  _VacationsScreenState createState() => _VacationsScreenState();
}

class _VacationsScreenState extends State<VacationsScreen> {

  //function to add holiday in firestore
  String docid='';
  final _firestore = FirebaseFirestore.instance;
  // void _addDataToFirestore() async {
  //   //if (_formKey.currentState!.validate()) {
  //   // Define the data to add
  //   Map<String, dynamic> data = {
  //     'nameholiday': _nameController.text,
  //     'fromdate': _emailController.text,
  //     'todate': _phoneNumberController.text,
  //
  //   };
  //   // Add the data to the Firestore collection
  //   await _firestore.collection('holiday').add(data).then((docRef) {
  //     docid=docRef.id;
  //     print('Data added with document ID: ${docRef.id}');
  //
  //     // showSnackBarFun(context);
  //   }).catchError((error) {
  //     print('Failed to add data: $error');
  //   });
  //   // Clear the text fields
  //   // _nameController.clear();
  //   // _phoneNumberController.clear();
  //   // _emailController.clear();
  // }



  bool tracking = true;
  bool AddAbsentDay = false;
  bool addAbsentDay = false;
  bool isAddingHoliday = false;
  List<DateTime> _selectedDates = [];
  List<Day> days = [
    Day(name: 'S', isChecked: false),
    Day(name: 'M', isChecked: false),
    Day(name: 'T', isChecked: false),
    Day(name: 'W', isChecked: false),
    Day(name: 'T', isChecked: false),
    Day(name: 'F', isChecked: false),
    Day(name: 'S', isChecked: false),
  ];
  bool color = false;
  bool isVisible = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 23,
                color: Color(0xff442B72),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
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
            title: Text(
              'Vacations'.tr,
              style: const TextStyle(
                color: Color(0xFF993D9A),
                fontSize: 17,
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            backgroundColor: Color(0xffF8F8F8),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        preferredSize: Size.fromHeight(70),
      ),
      // Custom().customAppBar(context, 'Attendance'.tr),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF442B72),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF442B72),
                                spreadRadius: 2,
                                blurRadius: 0,
                                // offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: 4,
                          height: 4,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Holidays'.tr,
                          style: TextStyle(
                            color: Color(0xFF919191),
                            fontSize: 14.64,
                            fontFamily: 'Poppins-Light',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //SizedBox(width: 80,),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFFEDF96),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFFEDF96),
                              spreadRadius: 1,
                              blurRadius: 1,
                              // offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 6,
                        height: 6,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        'weekend'.tr,
                        style: TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 14.64,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                      //New code
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible; // Toggle visibility
                      });
                    },
                    child: RotationTransition(
                      turns: isVisible
                          ? AlwaysStoppedAnimation(0.5)
                          : AlwaysStoppedAnimation(0),
                      child: Icon(Icons.keyboard_arrow_down_outlined,color: Color(0xFF442B72),),
                    ),
                  ),
                ],
                  ),
                Column(
                  children: [

                    Visibility(
                      visible: isVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Container(
                            width: 330,
                            height: 132,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 3, // Blur radius
                                  offset: Offset(0, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Choose your two days weekend",
                                      style: TextStyle(
                                        color: Color(0xff442B72),
                                        fontSize: 14,
                                        fontFamily: "Poppins-Light",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Container(
                                      height: 41,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: days.map((day) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                day.toggleCheck();
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                              child: Container(
                                                width: 26,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: day.isChecked
                                                      ? Color(0xFF442B72)
                                                      : Color(0xFFECEFF1),
                                                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                                                ),
                                                padding: EdgeInsets.all(5.0),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Center(
                                                  child: Text(
                                                    day.name,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: 'Poppins-SemiBold',
                                                      color: day.isChecked
                                                          ? Colors.white
                                                          : Color(0xFF442B72),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisible = false;
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                            Color(0xff442B72),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Poppins-Medium'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                if (AddAbsentDay)

                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 13, vertical: 9),
                  //               decoration: const BoxDecoration(
                  //                 color: Colors.white,
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Color(0x3F000000),
                  //                     blurRadius: 12,
                  //                     offset: Offset(-1, 4),
                  //                     spreadRadius: 0,
                  //                   )
                  //                 ],
                  //               ),

                  //calender without colored day
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  //   child: Center(
                  //     child:Container(
                  //       // elevation: 5,
                  //       width: 301,
                  //       height: 339,
                  //       // width: double.infinity,
                  //       // height: 339,
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 13, vertical: 9),
                  //       decoration: const BoxDecoration(
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color(0x3F000000),
                  //             blurRadius: 12,
                  //             offset: Offset(-1, 4),
                  //             spreadRadius: 0,
                  //           )
                  //         ],
                  //       ),
                  //       child: SfDateRangePicker(
                  //         headerStyle: const DateRangePickerHeaderStyle(
                  //           textStyle: TextStyle(
                  //             color: Color(0xFF771F98),
                  //             fontSize: 19,
                  //             fontFamily: 'Poppins-Bold',
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //         // onSelectionChanged: _onSelectionChanged,
                  //         view: DateRangePickerView.month,
                  //         monthViewSettings: const DateRangePickerMonthViewSettings(
                  //           viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  //             textStyle: TextStyle(
                  //               color: Color(0xFF5F5F5F),
                  //               fontSize: 17,
                  //               fontFamily: 'Poppins-Bold',
                  //               fontWeight: FontWeight.w700,
                  //             ),
                  //           ),
                  //           weekendDays: [0],
                  //           showTrailingAndLeadingDates: false,
                  //         ),
                  //
                  //         monthCellStyle: DateRangePickerMonthCellStyle(
                  //           weekendDatesDecoration: BoxDecoration(
                  //               color: const Color(0xFFFEDF96),
                  //               border: Border.all(
                  //                   color: const Color(0xFFFEDF96), width: 1),
                  //               shape: BoxShape.circle),
                  //           todayCellDecoration: BoxDecoration(
                  //               color: Colors.transparent,
                  //               border:
                  //               Border.all(color: Colors.transparent, width: 1),
                  //               shape: BoxShape.circle),
                  //           todayTextStyle: const TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //             fontFamily: 'Poppins-Regular',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //           textStyle: const TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //             fontFamily: 'Poppins-Regular',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //           // specialDatesDecoration: BoxDecoration(
                  //           //     color: const Color(0xFF7A12FF),
                  //           //     border: Border.all(
                  //           //         color: const Color(0xFF7A12FF), width: 1),
                  //           //     shape: BoxShape.circle),
                  //           disabledDatesTextStyle: const TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //             fontFamily: 'Poppins-Regular',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //           specialDatesDecoration: BoxDecoration(
                  //               color: const Color(0xFF7A12FF),
                  //               border: Border.all(
                  //                   color: const Color(0xFF7A12FF), width: 1),
                  //               shape: BoxShape.circle),
                  //           specialDatesTextStyle: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontFamily: 'Poppins-SemiBold',
                  //             fontWeight: FontWeight.w400,
                  //           ),
                  //         ),
                  //
                  //         selectionMode: DateRangePickerSelectionMode.multiple,
                  //         selectionColor: const Color(0xFF7A12FF),
                  //         rangeSelectionColor: const Color(0xFF7A12FF),
                  //         rangeTextStyle: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'Poppins-SemiBold',
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //         startRangeSelectionColor: const Color(0xFF7A12FF),
                  //         endRangeSelectionColor: const Color(0xFF7A12FF),
                  //         selectionTextStyle: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'Poppins-Bold',
                  //           // fontWeight: FontWeight.w400,
                  //         ),
                  //         // initialSelectedRange: PickerDateRange(
                  //         //     DateTime.now().subtract(const Duration(days: 2)),
                  //         //     DateTime.now().add(const Duration(days: 3))),
                  //       ),
                  //     ),
                  //   ),
                  // )
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33.0),
                    child: Center(
                      child: Container(
                        // elevation: 5,
                        width: 301,
                        height: 339,
                        // width: double.infinity,
                        // height: 339,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 9),
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
                        child: IgnorePointer(
                          //ignoring: !AddAbsentDay,
                          ignoring: !isAddingHoliday,
                          child: SfDateRangePicker(
                            //navigationMode: DateRangePickerNavigationMode.none,
                            showNavigationArrow: true,
                            headerStyle: DateRangePickerHeaderStyle(
                              textStyle: TextStyle(
                                color: Color(0xFF771F98),
                                fontSize: 19,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            view: DateRangePickerView.month,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              //showTrailingAndLeadingDates: false,
                              viewHeaderStyle:
                                  const DateRangePickerViewHeaderStyle(
                                textStyle: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 17,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              weekendDays: const [5, 6],
                              showTrailingAndLeadingDates: false,
                              // specialDates: [
                              //   DateTime(2024, 03, 3),
                              //   DateTime(2023, 08, 16),
                              //   DateTime(2023, 08, 17),
                              //   DateTime(2023, 09, 17)
                              // ],
                            ),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              weekendDatesDecoration: BoxDecoration(
                                  color: const Color(0xFFFEDF96),
                                  border: Border.all(
                                      color: const Color(0xFFFEDF96), width: 1),
                                  shape: BoxShape.circle),
                              weekendTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w400,
                              ),
                              disabledDatesTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w400,
                              ),
                              todayCellDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.transparent, width: 1),
                                  shape: BoxShape.circle),
                              todayTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.w400,
                              ),
                             // todayTextStyle:
                              // const TextStyle(color: Color(0xFF5F5F5F)),
                              // specialDatesDecoration: addAbsentDay
                              //     ? BoxDecoration(
                              //   color: const Color(0xFF7A12FF),
                              //   border: Border.all(color: const Color(0xFF7A12FF), width: 1),
                              //   shape: BoxShape.circle,
                              // )
                              //     : null,
                              // specialDatesTextStyle: addAbsentDay
                              //     ? const TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 16,
                              //   fontFamily: 'Poppins-Bold',
                              // )
                              //     : null,
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
                            // monthCellStyle: DateRangePickerMonthCellStyle(
                            //   weekendDatesDecoration: BoxDecoration(
                            //       color: const Color(0xFFFEDF96),
                            //       border: Border.all(
                            //           color: const Color(0xFFFEDF96), width: 1),
                            //       shape: BoxShape.circle),
                            //   weekendTextStyle: const TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 16,
                            //     fontFamily: 'Poppins-Bold',
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            //   disabledDatesTextStyle: const TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 15,
                            //     fontFamily: 'Poppins-Regular',
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            //   todayCellDecoration: BoxDecoration(
                            //       color: Colors.transparent,
                            //       border: Border.all(
                            //           color: Colors.transparent, width: 1),
                            //       shape: BoxShape.circle),
                            //   todayTextStyle:
                            //       const TextStyle(color: Color(0xFF5F5F5F)),
                            //   specialDatesDecoration: BoxDecoration(
                            //       color: const Color(0xFF7A12FF),
                            //       border: Border.all(
                            //           color: const Color(0xFF7A12FF), width: 1),
                            //       shape: BoxShape.circle),
                            //   specialDatesTextStyle: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 16,
                            //     fontFamily: 'Poppins-Bold',
                            //     // fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            // selectableDayPredicate: (val) {
                            //   return false;
                            // },

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


                            initialSelectedRange: PickerDateRange(
                                DateTime.now().subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33.0),
                    child: Center(
                      child: Container(
                        // elevation: 5,
                        width: 301,
                        height: 339,
                        // width: double.infinity,
                        // height: 339,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 9),
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
                        child: IgnorePointer(
                          ignoring: !isAddingHoliday,
                          child: SfDateRangePicker(
                            navigationMode: DateRangePickerNavigationMode.none,
                            showNavigationArrow: true,
                            headerStyle: DateRangePickerHeaderStyle(
                              textStyle: TextStyle(
                                color: Color(0xFF771F98),
                                fontSize: 19,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            view: DateRangePickerView.month,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              showTrailingAndLeadingDates: false,
                              viewHeaderStyle:
                                  const DateRangePickerViewHeaderStyle(
                                textStyle: TextStyle(
                                  color: Color(0xFF5F5F5F),
                                  fontSize: 17,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              weekendDays: const [5, 6],
                              specialDates: [
                                DateTime(2024, 03, 3),
                                DateTime(2023, 08, 16),
                                DateTime(2023, 08, 17),
                                DateTime(2023, 09, 17)
                              ],
                            ),
                            // monthCellStyle: DateRangePickerMonthCellStyle(
                            //   weekendDatesDecoration: BoxDecoration(
                            //       color: const Color(0xFFFEDF96),
                            //       border: Border.all(
                            //           color: const Color(0xFFFEDF96), width: 1),
                            //       shape: BoxShape.circle),
                            //   weekendTextStyle: const TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 16,
                            //     fontFamily: 'Poppins-Bold',
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            //   disabledDatesTextStyle: const TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 15,
                            //     fontFamily: 'Poppins-Regular',
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            //   todayCellDecoration: BoxDecoration(
                            //       color: Colors.transparent,
                            //       border: Border.all(
                            //           color: Colors.transparent, width: 1),
                            //       shape: BoxShape.circle),
                            //   todayTextStyle:
                            //       const TextStyle(color: Color(0xFF5F5F5F)),
                            //   specialDatesDecoration: BoxDecoration(
                            //       color: const Color(0xFF7A12FF),
                            //       border: Border.all(
                            //           color: const Color(0xFF7A12FF), width: 1),
                            //       shape: BoxShape.circle),
                            //   specialDatesTextStyle: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 16,
                            //     fontFamily: 'Poppins-Bold',
                            //     // fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                            // selectableDayPredicate: (val) {
                            //   return false;
                            // },
                            monthCellStyle: DateRangePickerMonthCellStyle(
                                weekendDatesDecoration: BoxDecoration(
                                    color: const Color(0xFFFEDF96),
                                    border: Border.all(
                                        color: const Color(0xFFFEDF96), width: 1),
                                    shape: BoxShape.circle),
                                weekendTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w400,
                                ),
                                disabledDatesTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w400,
                                ),
                                todayCellDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.transparent, width: 1),
                                    shape: BoxShape.circle),
                                todayTextStyle:
                                    const TextStyle(color: Color(0xFF5F5F5F)),
                              // specialDatesDecoration: addAbsentDay
                              //     ? BoxDecoration(
                              //   color: const Color(0xFF7A12FF),
                              //   border: Border.all(color: const Color(0xFF7A12FF), width: 1),
                              //   shape: BoxShape.circle,
                              // )
                              //     : null,
                              // specialDatesTextStyle: addAbsentDay
                              //     ? const TextStyle(
                              //   color: Colors.white,
                              //   fontSize: 16,
                              //   fontFamily: 'Poppins-Bold',
                              // )
                              //     : null,
                            ),

                            selectionMode: DateRangePickerSelectionMode.multiple,
                            initialSelectedRange: PickerDateRange(
                                DateTime.now().subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (AddAbsentDay)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: SizedBox(
                        width: 400,
                        height: 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                AddAbsentDay = false;
                                setState(() {});
                              },
                              child: SizedBox(
                                  height: 45,
                                  width: 170,
                                  child: Center(
                                    child:
                                        // TextField(
                                        //
                                        //   //textAlign: TextAlign.center,
                                        //   // style: TextStyle(
                                        //   //     color: Color(0xFF442B72),
                                        //   //     fontFamily: 'Poppins-Regular',
                                        //   //     fontWeight: FontWeight.w600 ,
                                        //   //     fontSize: 16
                                        //   // ),
                                        //   textAlign: TextAlign.start,
                                        //   style: TextStyle(
                                        //     color: Color(0xFF442B72),
                                        //     fontFamily: 'Poppins-Regular',
                                        //     fontWeight: FontWeight.w600,
                                        //     fontSize: 16,
                                        //   ),
                                        //   decoration: InputDecoration(
                                        //     hintText: 'Holiday name',
                                        //     hintStyle: TextStyle(
                                        //       color: Color(0xff9E9E9E), // Change the color of the hint text if needed
                                        //     ),
                                        //     border: OutlineInputBorder(
                                        //       borderSide: BorderSide(color: Color(0xFFFEDF96),width: 1), // Border color
                                        //     ),
                                        //
                                        //     filled: true,
                                        //     fillColor: Color(0xffF1F1F1), // Background color
                                        //   ),
                                        // ),
                                        TextField(
                                      style:
                                          TextStyle(color: Color(0xFF442B72)),
                                      // controller: _namesupervisor,
                                      cursorColor: const Color(0xFF442B72),
                                      //textDirection: TextDirection.ltr,
                                      scrollPadding: const EdgeInsets.symmetric(
                                          vertical: 40),
                                      decoration: InputDecoration(
                                        labelText: 'Holiday name',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFC2C2C2),
                                            fontSize: 12,
                                            fontFamily: "Poppins-Bold"),
                                        //hintText:'Shady Ayman'.tr ,
                                        alignLabelWithHint: true,
                                        counterText: "",
                                        fillColor: const Color(0xFFF1F1F1),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                8, 5, 10, 5),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        enabledBorder: myInputBorder(),
                                        focusedBorder: myFocusBorder(),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: ElevatedSimpleButton(
                                  txt: 'Add'.tr,
                                  // fontFamily: 'Poppins-Regular',
                                  width: 100,
                                  hight: 50,
                                  onPress: () {
                                    AddAbsentDay = false;
                                    setState(() {});
                                  },
                                  color: Color(0xFF442B72),
                                  fontSize: 16),
                            ),
                          ],
                        )),
                  )
                else
                  Center(
                    child: ElevatedIconButton(
                        txt: 'Add Holiday'.tr,
                        width: 200,
                        hight: 42,
                        onPress: () {
                          AddAbsentDay = true;
                          //addAbsentDay=true;
                          setState(() {
                            isAddingHoliday = true;
                            //isAddingHoliday = !isAddingHoliday;
                            //_selectedDates = [];

                          });
                          // Dialoge.addAbsentCalenderDialog(context);
                        },
                        icon: Row(
                          children: [
                            Image.asset(
                              'assets/imgs/school/add.png',
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        txtSize: 13,
                        color: const Color(0xFF442B72)),
                  ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 55,
                            color: const Color(0xFF442B72),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '16 Aug. 2023'.tr,
                                style: TextStyle(
                                  color: Color(0xFF4F4F4F),
                                  fontSize: 25,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500,
                                  height: 1.53,
                                ),
                              ),
                              Text(
                                'Ramadan Kareem'.tr,
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 14,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 2.38,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 55,
                            color: const Color(0xFFFEDF96),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '4 Aug. 2023'.tr,
                                style: TextStyle(
                                  color: Color(0xFF4F4F4F),
                                  fontSize: 25,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.w500,
                                  height: 1.53,
                                ),
                              ),
                              Text(
                                'Holiday'.tr,
                                style: TextStyle(
                                  color: Color(0xFFFFC53D),
                                  fontSize: 14,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 2.38,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
              ]),
        ),
      ),
      // extendBody: true,
      // resizeToAvoidBottomInset: false,
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(100)),
      //   backgroundColor: Colors.transparent,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => ProfileScreen(
      //           // onTapMenu: onTapMenu
      //         )));
      //   },
      //   child: Image.asset(
      //     'assets/images/Ellipse 1.png',
      //     height: 50,
      //     width: 50,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // bottomNavigationBar: Directionality(
      //     textDirection: Get.locale == Locale('ar')
      //         ? TextDirection.rtl
      //         : TextDirection.ltr,
      //     child: ClipRRect(
      //         borderRadius: const BorderRadius.only(
      //           topLeft: Radius.circular(25),
      //           topRight: Radius.circular(25),
      //         ),
      //         child: BottomAppBar(
      //             padding: EdgeInsets.symmetric(vertical: 3),
      //             height: 60,
      //             color: const Color(0xFF442B72),
      //             clipBehavior: Clip.antiAlias,
      //             shape: const AutomaticNotchedShape(
      //                 RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.only(
      //                         topLeft: Radius.circular(38.5),
      //                         topRight: Radius.circular(38.5))),
      //                 RoundedRectangleBorder(
      //                     borderRadius:
      //                     BorderRadius.all(Radius.circular(50)))),
      //             notchMargin: 7,
      //             child: SizedBox(
      //                 height: 10,
      //                 child: SingleChildScrollView(
      //                   child: Row(
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                     children: [
      //                       InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       NewHomeScreen()),
      //                             );
      //                           });
      //                         },
      //                         child: Padding(
      //                           padding:
      //                           (sharedpref?.getString('lang') == 'ar')?
      //                           EdgeInsets.only(top:7 , right: 15):
      //                           EdgeInsets.only(left: 15),
      //                           child: Column(
      //                             children: [
      //                               Image.asset(
      //                                   'assets/images/Vector (6).png',
      //                                   height: 20,
      //                                   width: 20
      //                               ),
      //                               SizedBox(height: 3),
      //                               Text(
      //                                 "Home".tr,
      //                                 style: TextStyle(
      //                                   fontFamily: 'Poppins-Regular',
      //                                   fontWeight: FontWeight.w500,
      //                                   color: Colors.white,
      //                                   fontSize: 8,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                       InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       NotificationsScreen()),
      //                             );
      //                           });
      //                         },
      //                         child: Padding(
      //                           padding:
      //                           (sharedpref?.getString('lang') == 'ar')?
      //                           EdgeInsets.only(top: 7, left: 70):
      //                           EdgeInsets.only( right: 70 ),
      //                           child: Column(
      //                             children: [
      //                               Image.asset(
      //                                   'assets/images/Vector (2).png',
      //                                   height: 16.56,
      //                                   width: 16.2
      //                               ),
      //                               Image.asset(
      //                                   'assets/images/Vector (5).png',
      //                                   height: 4,
      //                                   width: 6
      //                               ),
      //                               SizedBox(height: 2),
      //                               Text(
      //                                 "Notifications".tr,
      //                                 style: TextStyle(
      //                                   fontFamily: 'Poppins-Regular',
      //                                   fontWeight: FontWeight.w500,
      //                                   color: Colors.white,
      //                                   fontSize: 8,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                       Padding(
      //                         padding:
      //                         (sharedpref?.getString('lang') == 'ar')?
      //                         EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
      //                         EdgeInsets.only(top: 10 , bottom:4 ,left: 10),
      //                         child: Column(
      //                           children: [
      //                             Image.asset(
      //                                 'assets/images/Vector (3).png',
      //                                 height: 18.75,
      //                                 width: 18.75
      //                             ),
      //                             SizedBox(height: 3),
      //                             Text(
      //                               "Calendar".tr,
      //                               style: TextStyle(
      //                                 fontFamily: 'Poppins-Regular',
      //                                 fontWeight: FontWeight.w500,
      //                                 color: Colors.white,
      //                                 fontSize: 8,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //
      //                     ],
      //                   ),
      //                 )
      //             )
      //         )
      //     )
      // )

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          //height: 100,
          child: FloatingActionButton(
            backgroundColor: Color(0xff442B72),
            onPressed: () async {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ProfileScreen()));
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

      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomAppBar(
            color: const Color(0xFF442B72),
            clipBehavior: Clip.antiAlias,
            shape: const AutomaticNotchedShape( RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38.5),
                    topRight: Radius.circular(38.5))),
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(50)))),
            //CircularNotchedRectangle(),
            //shape of notch
            notchMargin: 7,
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                  maintainState: false),
                            );
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
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset(
                                    'assets/imgs/school/clarity_notification-line (1).png',
                                    height: 22,
                                    width: 22),
                                Text('Notification'.tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SupervisorScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/empty_supervisor.png',
                                    height: 22, width: 22),
                                Text("Supervisor".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
