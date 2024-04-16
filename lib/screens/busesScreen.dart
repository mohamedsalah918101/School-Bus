// import 'package:flutter/material.dart';
//
// class BusScreen extends StatefulWidget{
//   @override
//   State<BusScreen> createState() {
//     return BusScreenSate();
//   }
//
// }
// class BusScreenSate extends State<BusScreen>{
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Container(),);
//   }
//
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/addBus.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/editeSupervisor.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/sendInvitationScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../classes/dropdownRadiobutton.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/dialogs.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'editeBus.dart';
import 'homeScreen.dart';
import 'dart:math' as math;



class BusScreen extends StatefulWidget{
  const BusScreen({super.key});
  @override
  State<BusScreen> createState() => BusScreenSate();
}


class BusScreenSate extends State<BusScreen> {

  MyLocalController ControllerLang = Get.find();
  final TextEditingController searchController=TextEditingController();
  int? _selectedOption=1 ;
  int selectedIconIndex = 0;
  bool isEditingSupervisor = false;
  int _counter = 0;
  // هنا تقوم بتعريف الحالة
  bool _isButtonDisabled= true;

  //هنا بتعريق الدالة التي ستفوم بعمل الزيادة
  void _incrementCounter() {
    setState(() {
      _isButtonDisabled = true;
      _counter++;
    });
  }
  //new
  List<DropdownCheckboxItem> selectedItems = [];

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
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //   print("object1"+_selectedOption.toString());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InkWell(onTap: (){},
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: InkWell(
                                      // onTap: ()=>exit(0),
                                      onTap: () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        // Navigate back to the previous page
                                        Navigator.pop(context);

                                      },
                                      child: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 23,
                                        color: Color(0xff442B72),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Buses".tr,
                                        style: TextStyle(
                                          color: Color(0xFF993D9A),
                                          fontSize: 20,
                                          fontFamily: 'Poppins-Bold',
                                          fontWeight: FontWeight.w700,
                                          height: 0.64,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: InkWell(onTap: (){
                                      Scaffold.of(context).openEndDrawer();
                                    },
                                      child: Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: const Icon(
                                          Icons.menu_rounded,
                                          size: 40,
                                          color: Color(0xff442B72),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Stack(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(top:5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 1),
                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                //width: constrains.maxWidth / 1.0,
                                                height: 50,
                                                child: Theme(
                                                  data: ThemeData(
                                                    textSelectionTheme: TextSelectionThemeData(
                                                      cursorColor: Color(0xFF442B72),
                                                      // Set the desired cursor color here
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: SearchBar(
                                                      leading: Padding(
                                                        padding: const EdgeInsets.only(left: 4.0),
                                                        child: Image.asset("assets/imgs/school/icons8_search 1.png",width: 22,height: 22,),
                                                      ),
                                                      //Icon(Icons.search,color: Color(0xFFC2C2C2),),
                                                      controller: searchController,
                                                      textStyle:MaterialStateProperty.all<TextStyle?>(TextStyle(color: Color(0xFF442B72),)) ,
                                                      hintText: "Search Name".tr,
                                                      hintStyle: MaterialStateProperty.all<TextStyle?>(TextStyle(color: Color(0xFFC2C2C2),fontSize: 12,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold')) ,
                                                      backgroundColor: MaterialStateProperty.all<Color?>(Color(0xFFF1F1F1)),
                                                      elevation: MaterialStateProperty.all<double?>(0.0),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:15,
                                            ),
                                            // Image(image: AssetImage("assets/imgs/school/icons8_slider 2.png"),
                                            // width: 27.62,
                                            // height: 21.6,),
                                            PopupMenuButton<String>(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 15),
                                                child: Image(
                                                  image: AssetImage("assets/imgs/school/icons8_slider 2.png"),
                                                  width: 29,
                                                  height: 29,
                                                  color: Color(0xFF442B72), // Optionally, you can set the color of the image
                                                ),
                                              ),
                                              // icon: FaIcon(
                                              //   FontAwesomeIcons.sliders,
                                              //   size: 20, // Adjust the size as needed
                                              //   color: Color(0xFF442B72), // Set the color of the icon
                                              // ),
                                              itemBuilder: (BuildContext context) {
                                                return [
                                                  PopupMenuItem<String>(
                                                    value: 'custom',
                                                    child:
                                                    Column(
                                                      children: [
                                                        Container(
                                                          child:  DropdownRadiobutton(
                                                            items: [
                                                              DropdownCheckboxItem(label: 'Bus Number'),
                                                              DropdownCheckboxItem(label: 'Driver Name'),
                                                              DropdownCheckboxItem(label: 'Supervisor'),
                                                            ],
                                                            selectedItems: selectedItems,
                                                            onSelectionChanged: (items) {
                                                              setState(() {
                                                                selectedItems = items;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width:100,
                                                              child: ElevatedButton(

                                                                onPressed: () {
                                                                  // Handle cancel action
                                                                  Navigator.pop(context);
                                                                },
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF442B72)),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Text('Apply',style: TextStyle(fontSize:18),),
                                                              ),
                                                            ),
                                                            SizedBox(width: 3,),
                                                            // ElevatedButton(
                                                            //   onPressed: () {
                                                            //     setState(() {
                                                            //      // resetRadioButtons();
                                                            //     });
                                                            //
                                                            //   },
                                                            //   style: ButtonStyle(
                                                            //     backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                                            //     // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            //     //   RoundedRectangleBorder(
                                                            //     //     borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                                            //     //   ),
                                                            //     // ),
                                                            //   ),//
                                                            //   child: Text('Reset',style: TextStyle(color: Color(0xFF442B72)),),
                                                            // ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Text("Reset",style: TextStyle(color: Color(0xFF442B72),fontSize: 20),),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ];
                                              },
                                              // onSelected: (String value) {
                                              //   // Handle selection here
                                              //   print('Selected: $value');
                                              // },
                                              // onSelected: ( value) {
                                              //   setState(() {
                                              //     _selectedOption = value; // Update selected option
                                              //   });
                                              //   // Handle any additional actions based on the selected option
                                              //   print('Selected: $value');
                                              // },
                                            ),


                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),

                                      ListTile(
                                        leading: Image.asset('assets/imgs/school/Ellipse 1 (2).png'),
                                        title: Text('Ahmed Latif'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',),),
                             subtitle: Text("Bus number : 1458 ى ر س",style:
                                   TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                        trailing:
                                            //old pop up  bigger in width
                                        // PopupMenuButton<String>(
                                        //   enabled: !isEditingSupervisor,
                                        //   shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
                                        //   //constraints: const BoxConstraints.expand(width: 110, height: 95),
                                        //   icon: Padding(
                                        //     padding: const EdgeInsets.only(left: 8),
                                        //     child: Icon(Icons.more_vert, size: 30, color: Color(0xFF442B72)),
                                        //   ),
                                        //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                        //     PopupMenuItem<String>(
                                        //       value: 'edit',
                                        //       child: GestureDetector(
                                        //         onTap: (){
                                        //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditeBus()));
                                        //
                                        //         },
                                        //         child: SizedBox(
                                        //           height: 20,
                                        //           child: Row(
                                        //             children: [
                                        //               Image.asset("assets/imgs/school/icons8_edit 1.png",width: 16,height: 16,),
                                        //               // Transform(
                                        //               //     alignment: Alignment.center,
                                        //               //     transform: Matrix4.rotationY(math.pi),
                                        //               //     child: Icon(Icons.edit_outlined, color: Color(0xFF442B72),size: 17,)
                                        //               // ),
                                        //               SizedBox(width: 10),
                                        //               Text('Edit', style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontFamily: "Poppins-Regular")),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     PopupMenuItem<String>(
                                        //       value: 'delete',
                                        //       child: SizedBox(
                                        //         height: 20,
                                        //         child: GestureDetector(
                                        //           onTap: (){
                                        //             Dialoge.deleteBusDialog(context);
                                        //           },
                                        //           child: Row(
                                        //             children: [
                                        //               //Icon(Icons.delete_outline_outlined, color: Color(0xFF442B72),size: 17,),
                                        //               Image.asset("assets/imgs/school/icons8_Delete 1 (1).png",width: 17,height: 17,),
                                        //               SizedBox(width: 10),
                                        //               Text('Delete', style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontFamily: "Poppins-Regular"),)
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        //   onSelected: (String value) {
                                        //     // Handle selection here
                                        //     if (value == 'edit') {
                                        //       // Handle edit action
                                        //       setState(() {
                                        //         isEditingSupervisor = true;
                                        //       });
                                        //
                                        //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditeBus()));
                                        //
                                        //     } else if (value == 'delete') {
                                        //       // Handle delete action
                                        //     }
                                        //   },
                                        // ),
                                        PopupMenuButton<String>(
                                          enabled: !isEditingSupervisor,

                                          shape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          icon: Padding(
                                            padding: const EdgeInsets.only(left: 8),
                                            child: Icon(Icons.more_vert,
                                                size: 30, color: Color(0xFF442B72)),
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                              value: 'edit',
                                              child: GestureDetector(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .hideCurrentSnackBar();
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditeBus()));
                                                },
                                                child: SizedBox(
                                                  height: 20,
                                                  child: Row(
                                                    children: [
                                                      Image.asset("assets/imgs/school/icons8_edit 1.png",width: 16,height: 16,),
                                                      // Transform(
                                                      //     alignment: Alignment.center,
                                                      //     transform:
                                                      //         Matrix4.rotationY(math.pi),
                                                      //     child:
                                                      //     Icon(
                                                      //       Icons.edit_outlined,
                                                      //       color: Color(0xFF442B72),
                                                      //       size: 17,
                                                      //     )
                                                      // ),
                                                      SizedBox(width: 10),
                                                      Text('Edit',
                                                          style: TextStyle(
                                                              color: Color(0xFF442B72),
                                                              fontSize: 17)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'delete',
                                              child: SizedBox(
                                                height: 20,
                                                child: Row(
                                                  children: [
                                                    Image.asset("assets/imgs/school/icons8_Delete 1 (1).png",width: 17,height: 17,),
                                                    // Icon(
                                                    //   Icons.delete_outline_outlined,
                                                    //   color: Color(0xFF442B72),
                                                    //   size: 17,
                                                    // ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Color(0xFF442B72),
                                                          fontSize: 17),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          onSelected: (String value) {
                                            // Handle selection here
                                            if (value == 'edit') {
                                              // Handle edit action
                                              setState(() {
                                                isEditingSupervisor = true;
                                              });

                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditeBus()));
                                            } else if (value == 'delete') {
                                              setState(() {

                                              });
                                            }
                                          },
                                        ),
                                        //trailing:Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                        tileColor: Colors.white,
                                        onTap: (){
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(40), // Rounded top left corner
                                                    topRight: Radius.circular(40), // Rounded top right corner
                                                  ),
                                                ),
                                                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6), // Decreased height
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('Bus', style: TextStyle(color: Color(0xff442B72), fontSize: 20, fontWeight: FontWeight.bold)),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.white,
                                                                  border: Border.all(
                                                                    color: Color(0xFF442B72),
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: FaIcon(
                                                                      FontAwesomeIcons.times,
                                                                      color: Color(0xFF442B72),
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(height: 10,),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 7,
                                                              height: 7,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Color(0xFF442B72),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              'Bus: 1234  ى ر س',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Color(0xFF442B72),
                                                                fontFamily: "Poppins-Regular"
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height:25,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                        Image.asset("assets/imgs/school/Frame 137.png",width: 69,height: 68,),
                                                        Image.asset("assets/imgs/school/Frame 137.png",width: 69,height: 68,),
                                                        Image.asset("assets/imgs/school/Frame 137.png",width: 69,height: 68,)
                                                      ],),
                                                      SizedBox(height: 25,),
                                                      Text("Driver", style: TextStyle(color: Color(0xff442B72), fontSize: 20, fontWeight: FontWeight.bold)),
                                                     SizedBox(height: 10,),
                                                      Row(
                                                        children: [

                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: CircleAvatar(
                                                              radius: 35,
                                                              backgroundImage: AssetImage('assets/imgs/school/Ellipse 1.png'),

                                                            ),
                                                          ),
                                                          SizedBox(width: 20,),
                                                          Column(
                                                            children: [
                                                              Text('Shady ayman', style: TextStyle(color: Color(0xff442B72), fontSize: 15)),
                                                              SizedBox(height: 10,),
                                                              Text('01028765006', style: TextStyle(color: Color(0xff442B72), fontSize: 15)),

                                                            ],
                                                          ),
                                                          //SizedBox(width: 110,),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 55),
                                                            child: Transform(
                                                              alignment: Alignment.centerRight,
                                                              transform: Matrix4.rotationY(math.pi),
                                                              child: Material(
                                                                elevation: 3,
                                                                shape: CircleBorder(),
                                                                child: Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors.white,
                                                                    child: FaIcon(
                                                                      FontAwesomeIcons.phone,
                                                                      color: Color(0xFF442B72),
                                                                      size: 26,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),


                                                        ],
                                                      ),
                                                      SizedBox(height: 30),
                                                      Text('Supervisors', style: TextStyle(color: Color(0xff442B72), fontSize: 20, fontWeight: FontWeight.bold)),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 7,
                                                              height: 7,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Color(0xFF442B72),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              'Ahmed Atef',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(0xFF442B72),
                                                                  fontFamily: "Poppins-Regular"
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 7,
                                                              height: 7,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Color(0xFF442B72),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              'Kariem atif',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(0xFF442B72),
                                                                  fontFamily: "Poppins-Regular"
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );



                                        },
                                      ),
                                      //),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      //Container(
                                      // decoration: BoxDecoration(
                                      //     color: Colors.white, // Your desired background color
                                      //     borderRadius: BorderRadius.circular(5),
                                      //     boxShadow: [
                                      //       BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                                      //     ]
                                      // ),
                                      //child:
                                      ListTile(
                                        leading: Image.asset('assets/imgs/school/buses.png'),
                                        title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                                        subtitle: Text("Driver name : Ahmed Atef",style:
                                        TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                        trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                                      ),
                                      // ),
                                      SizedBox(height: 40,),

                                        ListTile(
                                          leading: Container(
                                            width: 60,

                                            //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                              //color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                          ),
                                          subtitle: Text("Driver name : Ahmed Atef",style:
                                          TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                          trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                          ),

                                        ),
                                      SizedBox(height: 40,),

                                      ListTile(
                                        leading: Container(
                                          width: 60,

                                          //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                            //color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                        ),
                                        subtitle: Text("Driver name : Ahmed Atef",style:
                                        TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                        trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                        ),

                                      ),
                                      SizedBox(height: 40,),


                                      ListTile(
                                        leading: Container(
                                          width: 60,

                                          //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                            //color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                        ),
                                        subtitle: Text("Driver name : Ahmed Atef",style:
                                        TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                        trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                        ),

                                      ),
                                      SizedBox(height: 40,),
                                      ListTile(
                                        leading: Container(
                                          width: 60,

                                          //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                            //color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                        ),
                                        subtitle: Text("Driver name : Ahmed Atef",style:
                                        TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),

                                        trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                        ),

                                      ),
                                      SizedBox(height: 40,),
                                      ListTile(
                                        leading: Container(
                                          width: 60,

                                          //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                            //color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                        ),
                                        subtitle: Text("Driver name : Ahmed Atef",style:
                                        TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),

                                        trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),

                                        ),

                                      ),
                                      SizedBox(height: 40,),






                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Floating button add
                          // SizedBox(
                          //   height: 140,
                          // ),


                        ],
                      ),
              ),
                    ),
                  ],
                ),Positioned(bottom: 20,right: 8,
                child: Padding(
                  padding: const EdgeInsets.only(right:35),
                  child: Column(children: [
                    FloatingActionButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBus()));
                    },
                      backgroundColor: Color(0xFF442B72),
                      child: Icon(Icons.add,color: Colors.white,size: 35,),)
                  ],),
                ),
              )
              ]);
        }
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              },
              child: Image.asset(
                'assets/imgs/school/Ellipse 2 (2).png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),


        bottomNavigationBar:
        Directionality(
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         selectedIconIndex = 0; // Update the index for the Home icon
                        //       });
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => HomeScreen(),
                        //           maintainState: false,
                        //         ),
                        //       );
                        //     },
                        //     child: Wrap(
                        //       crossAxisAlignment: WrapCrossAlignment.center,
                        //       direction: Axis.vertical,
                        //       children: [
                        //         Image.asset(
                        //           selectedIconIndex == 0
                        //               ? 'assets/imgs/school/icons8_home_1 1.png' // Image for selected state
                        //               : 'assets/imgs/school/fillhome.png', // Image for unselected state
                        //           height: 21,
                        //           width: 21,
                        //         ),
                        //         Text(
                        //           "Home".tr,
                        //           style: TextStyle(color: Colors.white, fontSize: 10),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical:5),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              Navigator.pushReplacement(
                                context ,
                                MaterialPageRoute(
                                    builder: (context) =>  HomeScreen(),
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
                              _isButtonDisabled ? _incrementCounter():null;
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              Navigator.push(
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
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                                  Image.asset('assets/imgs/school/empty_supervisor.png',
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
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                                  Image.asset('assets/imgs/school/fillbus.png',
                                      height: 20, width: 20),
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
      ),
    );
  }

}




