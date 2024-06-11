import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/editeSupervisor.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/sendInvitationScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../classes/dropdownRadiobutton.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'homeScreen.dart';
import 'dart:math' as math;

class ParentsScreen extends StatefulWidget {
  const ParentsScreen({super.key});

  @override
  State<ParentsScreen> createState() => ParentsScreenSate();
}

class ParentsScreenSate extends State<ParentsScreen> {
  MyLocalController ControllerLang = Get.find();
  final TextEditingController searchController = TextEditingController();
  int? _selectedOption = 1;

  int selectedIconIndex = 0;
  bool isEditingSupervisor = false;

  List<DropdownCheckboxItem> selectedItems = [];

// to lock in landscape view
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('parent').where('state', isEqualTo:1).where('schoolid',isEqualTo:sharedpref!.getString('id') ).get();
    data.addAll(querySnapshot.docs);
    setState(() {
      data = querySnapshot.docs;
      filteredData = List.from(data);
    });
  }

  //functions of filter
  String selectedFilter = '';
  List<QueryDocumentSnapshot> filteredData = [];
  bool isAcceptFiltered = false;
  bool isDeclineFiltered = false;
  bool isWaitingFiltered = false;
  bool isFiltered = false;
  String? currentFilter;
  bool Accepted = false;
  bool Declined = false;
  bool Waiting = false;
  String? selectedValueAccept;
  String? selectedValueDecline;
  String? selectedValueWaiting;

  getDataForDeclinedFilter() async {
    CollectionReference supervisor =
        FirebaseFirestore.instance.collection('parent');
    QuerySnapshot supervisorData =
        await supervisor.where('state', isEqualTo: 2).get(); //0
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      filteredData = supervisorData.docs;
      isFiltered = true;
    });
  }

  getDataForWaitingFilter() async {
    CollectionReference supervisor =
        FirebaseFirestore.instance.collection('parent');
    QuerySnapshot supervisorData =
        await supervisor.where('state', isEqualTo: 0).get(); //1
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      filteredData = supervisorData.docs;
      isFiltered = true;
    });
  }

  getDataForAcceptFilter() async {
    CollectionReference supervisor =
        FirebaseFirestore.instance.collection('parent');
    QuerySnapshot supervisorData =
        await supervisor.where('state', isEqualTo: 1).get(); //2
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      filteredData = supervisorData.docs;
      isFiltered = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // responsible
    getData();
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
          return Stack(children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            // onTap: ()=>exit(0),
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Parents".tr,
                              style: TextStyle(
                                color: Color(0xFF993D9A),
                                fontSize: 20,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                // height: 0.64,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        //width: constrains.maxWidth / 1.0,
                                        height: 50,
                                        child: Theme(
                                          data: ThemeData(
                                            textSelectionTheme:
                                                TextSelectionThemeData(
                                              cursorColor: Color(0xFF442B72),
                                              // Set the desired cursor color here
                                            ),
                                          ),
                                          child: SearchBar(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Image.asset(
                                                "assets/imgs/school/icons8_search 1.png",
                                                width: 22,
                                                height: 22,
                                              ),
                                            ),
                                            //Icon(Icons.search,color: Color(0xFFC2C2C2),),
                                            controller: searchController,
                                            textStyle: MaterialStateProperty
                                                .all<TextStyle?>(TextStyle(
                                              color: Color(0xFF442B72),
                                            )),
                                            hintText: "Search Name".tr,
                                            hintStyle: MaterialStateProperty
                                                .all<TextStyle?>(TextStyle(
                                                    color: Color(0xFFC2C2C2),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'Poppins-Bold')),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color?>(Color(0xFFF1F1F1)),
                                            elevation: MaterialStateProperty
                                                .all<double?>(0.0),
                                            onChanged: (query) {
                                              // Filter the data based on the search query
                                              setState(() {
                                                if (query.isEmpty) {
                                                  filteredData = List.from(
                                                      data); // Show all data if query is empty
                                                } else {
                                                  filteredData =
                                                      data.where((doc) {
                                                    // Debugging: Print the name and query to see what's being compared
                                                    print(
                                                        'Document Name: ${doc['name']}');
                                                    print(
                                                        'Search Query: $query');

                                                    // Perform case-insensitive search based on 'name' field
                                                    return doc['name']
                                                        .toLowerCase()
                                                        .contains(query
                                                            .toLowerCase());
                                                  }).toList();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    PopupMenuButton<String>(
                                      child: Image(
                                        image: AssetImage(
                                            "assets/imgs/school/icons8_slider 2.png"),
                                        width: 29,
                                        height: 29,
                                        color: Color(
                                            0xFF442B72), // Optionally, you can set the color of the image
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
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: DropdownRadiobutton(
                                                    items: [
                                                      DropdownCheckboxItem(
                                                          label: 'Accepted'),
                                                      DropdownCheckboxItem(
                                                          label: 'Declined'),
                                                      DropdownCheckboxItem(
                                                          label: 'Waiting'),
                                                    ],
                                                    selectedItems:
                                                        selectedItems,
                                                    onSelectionChanged:
                                                        (items) {
                                                      setState(() {
                                                        selectedItems = items;
                                                        if (items.first.label ==
                                                            'Accepted') {
                                                          selectedValueAccept =
                                                              'Accepted';
                                                          selectedValueDecline =
                                                              null;
                                                          selectedValueWaiting =
                                                              null;
                                                        } else if (items
                                                                .first.label ==
                                                            'Declined') {
                                                          selectedValueAccept =
                                                              null;
                                                          selectedValueDecline =
                                                              'Declined';
                                                          selectedValueWaiting =
                                                              null;
                                                        } else if (items
                                                                .first.label ==
                                                            'Waiting') {
                                                          selectedValueAccept =
                                                              null;
                                                          selectedValueDecline =
                                                              null;
                                                          selectedValueWaiting =
                                                              'Waiting';
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // Handle cancel action
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Color(
                                                                      0xFF442B72)),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10), // Adjust the radius as needed
                                                            ),
                                                          ),
                                                        ),
                                                        child: GestureDetector(
                                                          child: Text(
                                                            'Apply',
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          ),
                                                          onTap: () {
                                                            if (selectedValueAccept !=
                                                                null) {
                                                              currentFilter =
                                                                  'Accepted';
                                                              selectedFilter='Accepted';
                                                              getDataForAcceptFilter();
                                                              Navigator.pop(
                                                                  context);
                                                              print('2');
                                                            } else if (selectedValueDecline !=
                                                                null) {
                                                              currentFilter =
                                                                  'Declined';
                                                              selectedFilter='Declined';
                                                              getDataForDeclinedFilter();
                                                              Navigator.pop(
                                                                  context);
                                                              print('0');
                                                            } else if (selectedValueWaiting !=
                                                                null) {
                                                              currentFilter =
                                                                  'Waiting';
                                                              selectedFilter='Waiting';
                                                              getDataForWaitingFilter();
                                                              Navigator.pop(
                                                                  context);
                                                              print('1');
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          getData();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Reset",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF442B72),
                                                              fontSize: 20),
                                                        ),
                                                      ),
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
                                height: 20,
                              ),

                              //old listview without listtile
                              //  SizedBox(
                              //    height: 500,
                              //    child: ListView.builder(
                              //      // shrinkWrap: true,
                              //        itemCount: data.length,
                              //        itemBuilder: (context, index) {
                              //          return
                              //            Column(
                              //              children: [
                              //                Row(
                              //                  children: [
                              //                    Image.asset('assets/imgs/school/imgparent.png',width: 40,height: 40,),
                              //                    SizedBox(width: 10,),
                              //                    Text(
                              //                      '${data[index]['name'] }',
                              //                      style: TextStyle(
                              //                        color: Color(0xFF442B72),
                              //                        fontSize: 17,
                              //                        fontWeight: FontWeight.bold,
                              //                        fontFamily: 'Poppins-Bold',
                              //                      ),
                              //                    )
                              //                  ],
                              //                ),
                              //                SizedBox(
                              //                  height: 20,
                              //                )
                              //
                              //              ],
                              //            );
                              //
                              //        }),
                              //  ),
                              Column(
                                children: [
                                  if (filteredData.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Text('No data available',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  if (filteredData.isNotEmpty)
                                    SizedBox(
                                        height: 500,
                                        child: ListView.builder(
                                            // shrinkWrap: true,
                                            itemCount: filteredData.length,
                                            itemBuilder: (context, index) {
                                              int state = filteredData[index][
                                                  'state']; // Assuming 'state' is the field from Firestore
                                              Color statusColor;
                                              String statusText;

                                              // Determine status color and text based on state
                                              switch (state) {
                                                case 2: //0
                                                  statusColor = Color(
                                                      0xffAD1519); // Declined (State = 0)
                                                  statusText = 'Not joined yet';
                                                  break;

                                                case 0: //1
                                                  statusColor = Color(
                                                      0xffFFC53E); // Waiting (State = 1)
                                                  statusText =
                                                      'Waiting for response';
                                                  break;

                                                case 1: //2
                                                  statusColor = Color(
                                                      0xff0E8113); // Accepted (State = 2)
                                                  statusText = 'Joined';
                                                  break;
                                                default:
                                                  statusColor = Colors
                                                      .grey; // Default color if state is unknown
                                                  statusText = 'Unknown';
                                                  break;
                                              }
                                              return ListTile(
                                                leading: Container(
                                                    width: 50,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xffCCCCCC),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 3),
                                                      child: Image.asset(
                                                        "assets/imgs/school/Vector (16).png",
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                    )),
                                                title: Text(
                                                  '${filteredData[index]['name']}',
                                                  style: TextStyle(
                                                    color: Color(0xFF442B72),
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins-Bold',
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  //  '${filteredData[index]['state']}',
                                                  statusText,
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                //trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                                              );
                                            })),
                                ],
                              ),

                              // ListTile(
                              //   leading: Image.asset('assets/imgs/school/Ellipse 1.png'),
                              //   title: Text('Shady Ayman'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',),),
                              //   subtitle: Text("Joined yesterday",style: TextStyle(fontSize: 13,color: Color(0xff0E8113),fontFamily: "Poppins"),),
                              //  // trailing:
                              //
                              //   //trailing:Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                              //  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                              //   //tileColor: Colors.white,
                              //
                              // ),
                              // //),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // //Container(
                              // // decoration: BoxDecoration(
                              // //     color: Colors.white, // Your desired background color
                              // //     borderRadius: BorderRadius.circular(5),
                              // //     boxShadow: [
                              // //       BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                              // //     ]
                              // // ),
                              // //child:
                              // ListTile(
                              //   leading: Container(
                              //     width: 45,
                              //       height: 45,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(width: 2, color: Color(0xffCCCCCC)),
                              //       ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(6.0),
                              //       child: Image.asset('assets/imgs/school/Vector (9).png',width: 30,height: 30,),
                              //     )),
                              //   title: Text('Shady Ayman'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                              //   subtitle: Text("Waiting for response",style: TextStyle(fontSize: 13,color: Color(0xffFFC53E ),fontFamily: "Poppins"),),
                              //   //trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                              //   onTap: (){
                              //     Navigator.push(
                              //         context ,
                              //         MaterialPageRoute(
                              //             builder: (context) =>  BusScreen(),
                              //             maintainState: false));
                              //     // _key.currentState!.openDrawer();
                              //   },
                              // ),
                              // // ),
                              // SizedBox(height: 10,),
                              // Container(
                              //
                              //   //   decoration: BoxDecoration(
                              //   //     color: Colors.white, // Your desired background color
                              //   //     borderRadius: BorderRadius.circular(5),
                              //   //     boxShadow: [
                              //   //       BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
                              //   //     ]
                              //   // ),
                              //   child:
                              //   ListTile(
                              //     leading: Container(
                              //         width: 45,
                              //         height: 45,
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           border: Border.all(width: 2, color: Color(0xffCCCCCC)),
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(6.0),
                              //           child: Image.asset('assets/imgs/school/Vector (9).png',width: 30,height: 30,),
                              //         )),
                              //     title: Text('Shady Ayman'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                              //     ),
                              //     subtitle: Text("Not joined yet",style: TextStyle(fontSize: 13,color: Color(0xffAD1519),fontFamily: "Poppins"),),
                              //     //trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),),
                              //
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //Floating button add
                  SizedBox(
                    height: 140,
                  ),
                ],
              ),
            ),
          ]);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
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
              shape: const CircularNotchedRectangle(),
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
                              horizontal: 2.0, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.push(
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
                                  Image.asset(
                                      'assets/imgs/school/icons8_home_1 1.png',
                                      height: 21,
                                      width: 21),
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen(),
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupervisorScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset(
                                      'assets/imgs/school/empty_supervisor.png',
                                      height: 22,
                                      width: 22),
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.push(
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
                                  Image.asset(
                                      'assets/imgs/school/ph_bus-light (1).png',
                                      height: 22,
                                      width: 22),
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
