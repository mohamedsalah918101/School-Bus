import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/Functions/functions.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/editeSupervisor.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/sendInvitationScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../classes/dropdownRadiobutton.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/home_drawer.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'homeScreen.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';



class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => SupervisorScreenSate();
}

class SupervisorScreenSate extends State<SupervisorScreen> {


  String busNumber = '';
  Future<void> getBusNumber(String busId) async {
    DocumentSnapshot busDocument = await FirebaseFirestore.instance
        .collection('busdata')
        .doc(busId)
        .get();

    if (busDocument.exists) {
      setState(() {
        busNumber = busDocument['busnumber'];
        print('BUSSS $busNumber');
      });
    } else {
      print('Bus document does not exist for bus_id: $busId');
    }
  }


  bool isdelete= false;
  MyLocalController ControllerLang = Get.find();
  final TextEditingController searchController = TextEditingController();
  int? _selectedOption = 1;
  int selectedIconIndex = 0;
  bool isEditingSupervisor = false;
  List<DropdownCheckboxItem> selectedItems = [];
 // List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = [];
 // late Stream<QuerySnapshot> supervisorsStream;
  // void filterSearchResults(String query) {
  //   setState(() {
  //     // Update the Firestore query based on the search input
  //     supervisorsStream = FirebaseFirestore.instance
  //         .collection('supervisor')
  //         .where('name', isGreaterThanOrEqualTo: query)
  //         .where('name', isLessThan: query + 'z') // Use a range query for partial matches
  //         .snapshots();
  //   });
  // }

  //call phone
  void _makePhoneCall(String phoneNumber) async {
    var mobileCall = 'tel:$phoneNumber';
    if (await canLaunchUrlString(mobileCall)) {
      await launchUrlString(mobileCall);
    } else {
      throw 'Could not launch $mobileCall';
    }
  }

  void _editSupervisorDocument(String documentId, String name, String phone, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditeSupervisor(
          docid: documentId,
          oldName: name,
          oldPhone: phone,
          oldEmail: email,
        ),
      ),
    );
  }
// to lock in landscape view
  List<QueryDocumentSnapshot> data = [];
  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('supervisor').get();
    data.addAll(querySnapshot.docs);
    setState(() {
      data = querySnapshot.docs;
      filteredData = List.from(data);
    });
  }

  //fun get bus number
  Future<DocumentSnapshot> getOtherData(String busId) async {
    return await FirebaseFirestore.instance.collection('busdata').doc(busId).get();
  }




  void _deleteSupervisorDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('supervisor')
        .doc(documentId)
        .delete()
        .then((_) {
      setState(() {
        // Update UI by removing the deleted document from the data list
        data.removeWhere((document) => document.id == documentId);

        //new
        filteredData = List.from(data);

      });
      ScaffoldMessenger.of(context).showSnackBar(
          showSnackBarFun(context),
       // SnackBar(content: Text('Document deleted successfully')),
      );
    });
    //     .catchError((error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to delete document: $error')),
    //   );
    // }
    // );
  }


  //fun sarch


  @override
  void initState() {
    super.initState();

   // supervisorsStream = FirebaseFirestore.instance.collection('supervisor').snapshots();
    // responsible
  getData();
    // setState(() {
    //   filteredData = data;
    // });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  //functions of filter
  bool isAcceptFiltered = false;
  bool isDeclineFiltered = false;
  bool isWaitingFiltered = false;
  bool isFiltered  = false;
  String? currentFilter;
  bool Accepted = false;
  bool Declined = false;
  bool Waiting = false;
  String? selectedValueAccept;
  String? selectedValueDecline;
  String? selectedValueWaiting;
  getDataForDeclinedFilter()async{
    CollectionReference supervisor = FirebaseFirestore.instance.collection('supervisor');
    QuerySnapshot supervisorData = await supervisor.where('state' , isEqualTo: 0).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = supervisorData.docs;
      isFiltered = true;
    });
  }

  getDataForWaitingFilter()async{
    CollectionReference supervisor = FirebaseFirestore.instance.collection('supervisor');
    QuerySnapshot supervisorData = await supervisor.where('state' , isEqualTo: 1).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = supervisorData.docs;
      isFiltered = true;
    });
  }

  getDataForAcceptFilter()async{
    CollectionReference supervisor = FirebaseFirestore.instance.collection('supervisor');
    QuerySnapshot supervisorData = await supervisor.where('state' , isEqualTo: 2 ).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = supervisorData.docs;
      isFiltered = true;
    });
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

   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return
      SafeArea(
      child:
      Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),

        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return Stack(children: [
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: InkWell(
                            // onTap: ()=>exit(0),
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              // Navigate back to the previous page
                              // Navigator.pop(context);
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 26,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Align(alignment: AlignmentDirectional.center,
                              child: Text(
                                "Supervisors".tr,
                                style: TextStyle(
                                  color: Color(0xFF993D9A),
                                  fontSize: 25,
                                  fontFamily: 'Poppins-Bold',
                                  fontWeight: FontWeight.w700,
                                  // height: 0.99,
                                ),
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
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
                Expanded(
                  child: SingleChildScrollView(
                     //physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        const SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child:
                                Column (
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
                                                child:
                                                SearchBar(
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
                                                  onChanged: (query) {
                                                    // Filter the data based on the search query
                                                    setState(() {
                                                      if (query.isEmpty) {
                                                        filteredData = List.from(data); // Show all data if query is empty
                                                      } else {
                                                        filteredData = data.where((doc) {
                                                          // Debugging: Print the name and query to see what's being compared
                                                          print('Document Name: ${doc['name']}');
                                                          print('Search Query: $query');

                                                          // Perform case-insensitive search based on 'name' field
                                                          return doc['name'].toLowerCase().contains(query.toLowerCase());
                                                        }).toList();
                                                      }
                                                    });
                                                  },
                                                  // onChanged: (value) {
                                                  //   filterSearchResults(value);
                                                  // },
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
                                                ),
                                              ),
                                            ),
                                          ),


                                          SizedBox(
                                            width: 20,
                                          ),
                                          // Image(image: AssetImage("assets/imgs/school/icons8_slider 2.png"),
                                          // width: 27.62,
                                          // height: 21.6,),
                                          Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: PopupMenuButton<String>(
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
                                                                if (items.first.label == 'Accepted') {
                                                                  selectedValueAccept = 'Accepted';
                                                                  selectedValueDecline = null;
                                                                  selectedValueWaiting = null;
                                                                } else if (items.first.label == 'Declined') {
                                                                  selectedValueAccept = null;
                                                                  selectedValueDecline = 'Declined';
                                                                  selectedValueWaiting = null;
                                                                } else if (items.first.label == 'Waiting') {
                                                                  selectedValueAccept = null;
                                                                  selectedValueDecline = null;
                                                                  selectedValueWaiting = 'Waiting';
                                                                }
                                                              }
                                                              );
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
                                                                  onTap: (){
                                                                    if (selectedValueAccept != null) {
                                                                      currentFilter = 'Accepted';
                                                                      getDataForAcceptFilter();
                                                                      Navigator.pop(context);
                                                                      print('2');
                                                                    }else  if (selectedValueDecline != null) {
                                                                      currentFilter = 'Declined';
                                                                      getDataForDeclinedFilter();
                                                                      Navigator.pop(context);
                                                                      print('0');
                                                                    }else  if (selectedValueWaiting != null) {
                                                                      currentFilter = 'Waiting';
                                                                      getDataForWaitingFilter();
                                                                      Navigator.pop(context);
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
                                                                onTap:(){
                                                                     getData();
                                                                    Navigator.pop(context);
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
                                          ),
                                        ],
                                      ),

                                    ),



                                    //),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    //new code
                                    SizedBox(
                                      height: 500,
                                      child: ListView.builder(
                                        itemCount: isdelete ? data.length:filteredData.length,
                                        //data.length,
                                        //itemCount: filteredData.length,
                                        itemBuilder: (context, index) {
                                          //print(data[index]['bus_id']);
                                          getBusNumber(data[index]['bus_id']);

                                          // String supervisorId = data[index]['bus_id']; // Access the ID
                                          //
                                          // Future<String> getBusName() async {
                                          //   DocumentReference docRef = FirebaseFirestore.instance.collection('busdata').doc(supervisorId);
                                          //   DocumentSnapshot docSnapshot = await docRef.get();
                                          //   return docSnapshot['busnumber']; // Access the bus name
                                          // }


                                          String supervisorPhoneNumber = filteredData[index]['phoneNumber'];
                                          int state =data[index]['state']; // Assuming 'state' is the field from Firestore

                                          Color statusColor;
                                          String statusText;

                                          // Determine status color and text based on state
                                          switch (state) {
                                            case 0:
                                              statusColor = Colors.red; // Declined (State = 0)
                                              statusText = 'Declined';
                                              break;
                                            case 1:
                                              statusColor = Colors.yellow; // Waiting (State = 1)
                                              statusText = 'Waiting';
                                              break;
                                            case 2:
                                              statusColor = Colors.green; // Accepted (State = 2)
                                              statusText = 'Accepted';
                                              break;
                                            default:
                                              statusColor = Colors.grey; // Default color if state is unknown
                                              statusText = 'Unknown';
                                              break;
                                          }

                                          return ListTile(
                                              leading:
//                                              Map<String, dynamic> documentData = filteredData[index].data() as Map<String, dynamic>;
//
// // Check if the 'busphoto' field exists and is not null
//                                           if (documentData.containsKey('busphoto') && documentData['busphoto'] != null) {
//                                             // Display Image.network with the URL from 'busphoto' field
//                                             return Image.network(
//                                               documentData['busphoto'] as String,
//                                               width: 61,
//                                               height: 61,
//                                               errorBuilder: (context, error, stackTrace) {
//                                                 // Display a default image if loading fails
//                                                 return Image.asset(
//                                                   'assets/images/school (2) 1.png',
//                                                   width: 61,
//                                                   height: 61,
//                                                 );
//                                               },
//                                             );
//                                           } else {
//                                             // Display a default image if 'busphoto' field is absent or null
//                                             return Image.asset(
//                                               'assets/images/school (2) 1.png',
//                                               width: 61,
//                                               height: 61,
//                                             );
//                                           }
                                            filteredData[index]['busphoto'] != null ?
                                            Image.network(filteredData[index]['busphoto']as String, width: 61, height: 61,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                    width:50,
                                                    height:40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Color(0xffCCCCCC),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top:10,bottom: 3),
                                                      child: Image.asset("assets/imgs/school/Vector (16).png",width: 15,height: 15,),
                                                    ));
                                                  //Image.asset('assets/images/school (2) 1.png', width: 61, height: 61); // Display a default image if loading fails
                                              },
                                            ):
                                            //Image.asset('assets/images/school (2) 1.png', width: 61, height: 61),
                                            Container(
                                                width:50,
                                                height:40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Color(0xffCCCCCC),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:10,bottom: 3),
                                                  child: Image.asset("assets/imgs/school/Vector (16).png",width: 15,height: 15,),
                                                )),
                                            //Image.asset('assets/imgs/school/Ellipse 1.png'), // Icon or image

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
                                            trailing:
                                            PopupMenuButton<String>(
                                              enabled: !isEditingSupervisor,

                                              shape: RoundedRectangleBorder(

                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              icon: Padding(
                                                padding: const EdgeInsets.only(left: 14),
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
                                                      setState(() {
                                                        isEditingSupervisor = true;
                                                        _editSupervisorDocument(
                                                          data[index].id,
                                                          data[index]['name'],
                                                          data[index]['phoneNumber'],
                                                          data[index]['email'],
                                                        );
                                                      });
                                                      // Navigator.pushReplacement(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) =>
                                                      //             EditeSupervisor())
                                                      // );
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
                                                    _editSupervisorDocument(
                                                      data[index].id,
                                                      data[index]['name'],
                                                      data[index]['phoneNumber'],
                                                      data[index]['email'],
                                                    );
                                                  });

                                                  // Navigator.pushReplacement(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             EditeSupervisor()));
                                                } else if (value == 'delete') {
                                                  isdelete=true;
                                                  _deleteSupervisorDocument(data[index].id);
                                                  // setState(() {
                                                  //
                                                  //   //showSnackBarFun(context);
                                                  // });
                                                }
                                                isdelete=false;
                                              },
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            tileColor: Colors.white,
                                            onTap: () {

                                              showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(30.0)),
                                                ),
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(
                                                            40), // Rounded top left corner
                                                        topRight: Radius.circular(
                                                            40), // Rounded top right corner
                                                      ),
                                                    ),
                                                    constraints: BoxConstraints(
                                                        maxHeight: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                            0.4), // Decreased height
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text('Supervisor',
                                                                  style: TextStyle(
                                                                      color:
                                                                      Color(0xff442B72),
                                                                      fontSize: 20,
                                                                      fontWeight:
                                                                      FontWeight.bold)),
                                                              Expanded(
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment.centerRight,
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.white,
                                                                      border: Border.all(
                                                                        color:
                                                                        Color(0xFF442B72),
                                                                        width: 1,
                                                                      ),
                                                                    ),
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(4.0),
                                                                        child: FaIcon(
                                                                          FontAwesomeIcons
                                                                              .times,
                                                                          color: Color(
                                                                              0xFF442B72),
                                                                          size: 18,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                height: 80,
                                                                child: data[index]['busphoto'] != null && data[index]['busphoto'].isNotEmpty
                                                                    ? Image.network(
                                                                  data[index]['busphoto'],
                                                                  fit: BoxFit.scaleDown,
                                                                )
                                                                    // :  Container(
                                                                    // width:30,
                                                                    // height:20,
                                                                    // decoration: BoxDecoration(
                                                                    //   shape: BoxShape.circle,
                                                                    //   border: Border.all(
                                                                    //     color: Color(0xffCCCCCC),
                                                                    //     width: 2.0,
                                                                    //   ),
                                                                    // ),
                                                                    // child: Padding(
                                                                    //   padding: const EdgeInsets.only(top:10,bottom: 3),
                                                                    //   child: Image.asset("assets/imgs/school/Vector (16).png",width: 5,height: 5,),
                                                                    // )),
                                                               : Image.asset(
                                                                  'assets/imgs/school/empty_supervisor.png',
                                                                  fit: BoxFit.scaleDown,
                                                                ),
                                                              ),
                                                              // Align(
                                                              //   alignment:
                                                              //   Alignment.centerLeft,
                                                              //   child: CircleAvatar(
                                                              //     radius: 35,
                                                              //     backgroundImage:
                                                              //     AssetImage(
                                                              //         'assets/imgs/school/Ellipse 1.png'
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text('${filteredData[index]['name']}',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff442B72),
                                                                          fontSize: 15)),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text('${filteredData[index]['phoneNumber']}',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff442B72),
                                                                          fontSize: 15)),
                                                                ],
                                                              ),
                                                              //SizedBox(width: 110,),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 70),
                                                                child: Material(
                                                                  elevation: 3,
                                                                  shape: CircleBorder(),
                                                                  child: Align(
                                                                    alignment: Alignment
                                                                        .centerRight,
                                                                    child: GestureDetector(
                                                                      onTap: ()async{
                                                                        _makePhoneCall(supervisorPhoneNumber);
                                                                     //   FlutterPhoneDirectCaller.callNumber(supervisorPhoneNumber);
                                                                        //FlutterPhoneDirectCaller.callNumber(supervisorPhoneNumber);
                                                                      },
                                                                      // onTap: () async {
                                                                      //   try {
                                                                      //     await FlutterPhoneDirectCaller.callNumber(supervisorPhoneNumber);
                                                                      //   } catch (e) {
                                                                      //     print('Error making phone call: $e');
                                                                      //     // Handle error gracefully (e.g., show a snackbar or alert)
                                                                      //   }
                                                                      // },
                                                                      child: CircleAvatar(
                                                                        backgroundColor:
                                                                        Colors.white,
                                                                        child:Transform.scale(
                                                                            scaleX: -1,
                                                                            child:  FaIcon(
                                                                          FontAwesomeIcons
                                                                              .phone,
                                                                          color: Color(
                                                                              0xFF442B72),
                                                                          size: 26,
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 20),
                                                          Text('Buses',
                                                              style: TextStyle(
                                                                  color: Color(0xff442B72),
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight.bold)),
                                                          SizedBox(height: 10),

                                                          // old bus
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 10,
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Color(0xFF442B72),
                                                                ),
                                                              ),
                                                              SizedBox(width: 10),
                                                              Text(
                                                                'Bus: $busNumber',
                                                                //'Bus: 1 2 3 ى س ج',
                                                               // data[index]['bus_id'],
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(0xFF442B72),
                                                                ),
                                                              ),

                                                            ],
                                                          )
                                                    // ListTile(
                                                    //   title: Text(data[index]['name']), // Assuming 'name' in supervisor
                                                    //   subtitle: FutureBuilder<String>(
                                                    //     future: getBusName(),
                                                    //     builder: (context, snapshot) {
                                                    //       if (snapshot.hasData) {
                                                    //         return Text(snapshot.data!);
                                                    //       } else {
                                                    //         return Text('Loading...');
                                                    //       }
                                                    //     },
                                                    //   ),
                                                    // ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },

                                          );
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(bottom: 20,right: 8,
            child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: FloatingActionButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SendInvitation()));
              },
              backgroundColor: Color(0xFF442B72),
              child: Icon(Icons.add,color: Colors.white,size: 35,),),
            )
            ],),
            )
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
                              horizontal: 2.0, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushReplacement(
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
                                  Image.asset(
                                      'assets/imgs/school/supervisor (1) 1.png',
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
            'Supervisor deleted successfully',
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins-Bold",
                color: Color(0xff4CAF50)),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 170,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // void resetRadioButtons() {
  //   setState(() {
  //     // Unselect all items
  //     for (var item in widget.items) {
  //       item.isChecked = false;
  //     }
  //     // Clear selected items list
  //     widget.selectedItems.clear();
  //   });
  // }
  deletePhotoDialog(context) {
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
            height: 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Align(alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Are you sure you want to',
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 20,
                                fontFamily: 'Poppins-Regular',
                                //fontWeight: FontWeight.w400,
                                height: 1.23,
                              ),
                            ),
                            Center(
                              child: Text(
                                'delete this supervisor?',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 20,
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
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete',
                        width: 120,
                        hight: 38,
                        onPress: () => {

                        }

                        // Navigator.of(context).pushAndRemoveUntil(
                        // MaterialPageRoute(
                        //     builder: (context) => const SignUpScreen()),
                        //     (Route<dynamic> route) => false)
                        ,
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
}

