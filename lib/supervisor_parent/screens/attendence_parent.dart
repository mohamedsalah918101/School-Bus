import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/calendar_card.dart';
import 'package:school_account/supervisor_parent/components/children_card.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/child_card.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/home_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_children.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import '../components/elevated_icon_button.dart';

class AttendanceParent extends StatefulWidget {

  @override
  _AttendanceParentState createState() => _AttendanceParentState();
}

class _AttendanceParentState extends State<AttendanceParent> {
  // List<ChildDataItem> children = [];
  bool tracking = true;
  bool AddAbsentDay = false;
  bool ShowCalendar = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HomeDrawer(),
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
              BoxShadow(
                color:  Color(0x3F000000),
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
                onTap: (){
                  Navigator.of(context).pop();
                },
                child:  Padding(
                  padding:
                  (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.symmetric(horizontal: 23.0):
                  EdgeInsets.symmetric(horizontal: 17.0),
                  child: Image.asset(
                    (sharedpref?.getString('lang') == 'ar')?
                    'assets/images/Layer 1.png':
                    'assets/images/fi-rr-angle-left.png',
                    width: 10,
                    height: 22,),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                  GestureDetector(
                    onTap: (){
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
              title: Text('Calendar'.tr ,
                style: const TextStyle(
                  color: Color(0xFF993D9A),
                  fontSize: 17,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),),
              backgroundColor:  Color(0xffF8F8F8),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        // Custom().customAppBar(context, 'Attendance'.tr),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child:
                // children.isNotEmpty?
            Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 18.0 , vertical: 15),
                  child: GestureDetector(
                      onTap: (){
                        ShowCalendar= !ShowCalendar;
                        setState(() {
                        });
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return
                            Column(
                              children: [
                                CalendarCard(),
                                SizedBox(height: 10,)
                              ],
                            );
                        },
                      ), ),
                ),
                if(ShowCalendar)
                  SizedBox(
                    width: 322,
                    height: 660,
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (ShowCalendar)
                          SizedBox(
                            height: 10,
                          ),
                          // if (ShowCalendar)
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                      (sharedpref?.getString('lang') == 'ar')?
                                      EdgeInsets.only(right: 0.0):
                                      EdgeInsets.only(left: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: const Color(0xFF7A12FF),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0xFF7A12FF),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              // offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        width: 6,
                                        height: 6,
                                      ),
                                    ),
                                     SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Absent'.tr,
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
                                Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(left: 0, right: 5):
                                  EdgeInsets.only(right: 8, left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: const Color(0xFFFEDF96),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0xFFFEDF96),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              // offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        width: 6,
                                        height: 6,
                                      ),
                                      const SizedBox(
                                        width: 12,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // if (ShowCalendar)
                          SizedBox(
                            height: 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                      (sharedpref?.getString('lang') == 'ar')?
                                      EdgeInsets.only(right: 47.0 , top: 3):
                                      EdgeInsets.only(left: 47.0 , top: 3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
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
                                        width: 6,
                                        height: 6,
                                      ),
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
                              ],
                            ),
                          ),
                          // if (ShowCalendar)
                          const SizedBox(
                            height: 20,
                          ),if
                          (AddAbsentDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child:Container(
                                  // elevation: 5,
                                  width: double.infinity,
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
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Container(
                                  // elevation: 5,
                                  width: double.infinity,
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
                                      viewHeaderStyle: const DateRangePickerViewHeaderStyle(
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
                                      specialDatesDecoration: BoxDecoration(
                                          color: const Color(0xFF7A12FF),
                                          border: Border.all(
                                              color: const Color(0xFF7A12FF), width: 1),
                                          shape: BoxShape.circle),
                                      specialDatesTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Poppins-Bold',
                                        // fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    selectableDayPredicate: (val) {
                                      return false;
                                    },
                                    selectionMode: DateRangePickerSelectionMode.multiple,
                                    initialSelectedRange: PickerDateRange(
                                        DateTime.now().subtract(const Duration(days: 4)),
                                        DateTime.now().add(const Duration(days: 3))),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(AddAbsentDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedSimpleButton(
                                      txt: 'Save'.tr,
                                      fontFamily: 'Poppins-Regular',
                                      width: 107,
                                      hight: 38,
                                      onPress: (){
                                        AddAbsentDay=false;
                                        DataSavedSnackBar(context, 'Data saved successfully');
                                        setState(() {
                                        });
                                      },
                                      color: Color(0xFF442B72),
                                      fontSize: 16),
                                  SizedBox(width: 15,),
                                  GestureDetector(
                                    onTap: (){
                                      AddAbsentDay=false;
                                      setState(() {
                                      });
                                    },
                                    child: Center(
                                      child: ElevatedButton(
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
                                          width: 58,
                                          height: 38,
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
                                    ),
                                  )
                                ],
                              ),
                            )
                          else
                          // if (ShowCalendar)
                            Center(
                              child: ElevatedIconButton(
                                  txt: 'Add Absent Days'.tr,
                                  width: 200,
                                  hight: 42,
                                  onPress: () {
                                    AddAbsentDay = true;
                                    setState(() {
                                    });
                                    // Dialoge.addAbsentCalenderDialog(context);
                                  },
                                  icon: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/add.png',
                                        width: 18,
                                        height: 18,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      )
                                    ],
                                  ),
                                  txtSize: 13,
                                  color: const Color(0xFF442B72)),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          // if (ShowCalendar)
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
                                          '16 Aug. 2023',
                                          style: TextStyle(
                                            color: Color(0xFF4F4F4F),
                                            fontSize: 25,
                                            fontFamily: 'Poppins-Regular',
                                            fontWeight: FontWeight.w500,
                                            // height: 1.53,
                                          ),
                                        ),
                                        Text(
                                          'Absent'.tr,
                                          style: TextStyle(
                                            color: Color(0xFF442B72),
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Light',
                                            fontWeight: FontWeight.w400,
                                            // height: 2.38,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
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
                                          '4 Aug. 2023',
                                          style: TextStyle(
                                            color: Color(0xFF4F4F4F),
                                            fontSize: 25,
                                            fontFamily: 'Poppins-Regular',
                                            fontWeight: FontWeight.w500,
                                            // height: 1.53,
                                          ),
                                        ),
                                        Text(
                                          'Holiday'.tr,
                                          style: TextStyle(
                                            color: Color(0xFFFFC53D),
                                            fontSize: 14,
                                            fontFamily: 'Poppins-Light',
                                            fontWeight: FontWeight.w400,
                                            // height: 2.38,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               SizedBox(height: 44,)
              ],
            )
                //     :
                // Column(
                //   children: [
                //     SizedBox(height: 150,),
                //     Image.asset('assets/images/Group 237682.png',
                //     ),
                //     Text('No Assigned dates Found'.tr,
                //       style: TextStyle(
                //         color: Color(0xff442B72),
                //         fontFamily: 'Poppins-Regular',
                //         fontWeight: FontWeight.w500,
                //         fontSize: 19,
                //       ),
                //     ),
                //     Text('You haven’t added any \n '
                //         'dates yet'.tr,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Color(0xffBE7FBF),
                //         fontFamily: 'Poppins-Light',
                //         fontWeight: FontWeight.w400,
                //         fontSize: 12,
                //       ),)
                //   ],
                // ),
          ),
        ),
        // extendBody: true,
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
          )

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
                              Padding(
                                padding:
                                (sharedpref?.getString('lang') == 'ar')?
                                EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                EdgeInsets.only(top: 10 , bottom:4 ,left: 10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/images/Vector (8).png',
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
