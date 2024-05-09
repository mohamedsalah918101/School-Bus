import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/screens/busesScreen.dart';
import 'package:school_account/screens/editeSupervisor.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/sendInvitationScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import 'package:url_launcher/url_launcher.dart';
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


class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => SupervisorScreenSate();
}

class SupervisorScreenSate extends State<SupervisorScreen> {

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
    // if (await canLaunch('tel:$phoneNumber')) {
    //   await launch('tel:$phoneNumber');
    //   print("succ");
    // } else {
    //   throw 'Could not launch $phoneNumber';
    // }
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      await launchUri;
      print("Phone call successful");
    } catch (e) {
      print("Error launching phone call: $e");
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
  void _deleteSupervisorDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('supervisor')
        .doc(documentId)
        .delete()
        .then((_) {
      setState(() {
        // Update UI by removing the deleted document from the data list
        data.removeWhere((document) => document.id == documentId);

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
                Expanded(
                  child: SingleChildScrollView(
                     //physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      size: 23,
                                      color: Color(0xff442B72),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Supervisors".tr,
                                      style: TextStyle(
                                        color: Color(0xFF993D9A),
                                        fontSize: 25,
                                        fontFamily: 'Poppins-Bold',
                                        fontWeight: FontWeight.w700,
                                        height: 0.64,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: InkWell(
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                                                label: 'Rejected'),
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
                                                              } else if (items.first.label == 'Rejected') {
                                                                selectedValueAccept = null;
                                                                selectedValueDecline = 'Rejected';
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
                                                                    currentFilter = 'Rejected';
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
                                        //itemCount: data.length,
                                        itemCount: filteredData.length,
                                        itemBuilder: (context, index) {
                                          String supervisorPhoneNumber = filteredData[index]['phoneNumber'];
                                          int state =data[index]['state']; // Assuming 'state' is the field from Firestore

                                          Color statusColor;
                                          String statusText;

                                          // Determine status color and text based on state
                                          switch (state) {
                                            case 0:
                                              statusColor = Colors.red; // Rejected (State = 0)
                                              statusText = 'Rejected';
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
                                            filteredData[index]['busphoto'] != null ? Image.network(filteredData[index]['busphoto']as String, width: 61, height: 61,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/school (2) 1.png', width: 61, height: 61); // Display a default image if loading fails
                                              },
                                            ):Image.asset('assets/images/school (2) 1.png', width: 61, height: 61),
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
                                              icon: Icon(Icons.more_vert,
                                                  size: 30, color: Color(0xFF442B72)),
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
                                                  _deleteSupervisorDocument(data[index].id);
                                                  // setState(() {
                                                  //
                                                  //   //showSnackBarFun(context);
                                                  // });
                                                }
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
                                                              Align(
                                                                alignment:
                                                                Alignment.centerLeft,
                                                                child: CircleAvatar(
                                                                  radius: 35,
                                                                  backgroundImage: AssetImage(
                                                                      'assets/imgs/school/Ellipse 1.png'),
                                                                ),
                                                              ),
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
                                                                    left: 55),
                                                                child: Transform(
                                                                  alignment:
                                                                  Alignment.centerRight,
                                                                  transform:
                                                                  Matrix4.rotationY(
                                                                      math.pi),
                                                                  child: Material(
                                                                    elevation: 3,
                                                                    shape: CircleBorder(),
                                                                    child: Align(
                                                                      alignment: Alignment
                                                                          .centerRight,
                                                                      child: GestureDetector(
                                                                        onTap: ()async{
                                                                          _makePhoneCall(supervisorPhoneNumber);
                                                                          //FlutterPhoneDirectCaller.callNumber(supervisorPhoneNumber);
                                                                        },
                                                                        child: CircleAvatar(
                                                                          backgroundColor:
                                                                          Colors.white,
                                                                          child: FaIcon(
                                                                            FontAwesomeIcons
                                                                                .phone,
                                                                            color: Color(
                                                                                0xFF442B72),
                                                                            size: 26,
                                                                          ),
                                                                        ),
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
                                                                'Bus: 1234  ى ر س',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(0xFF442B72),
                                                                ),
                                                              ),
                                                            ],
                                                          )
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
                        //Floating button add old
                        // Align(
                        //   alignment: AlignmentDirectional.bottomEnd,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(right: 20),
                        //     child: Column(
                        //       children: [
                        //         FloatingActionButton(
                        //           onPressed: () {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) => SendInvitation()));
                        //           },
                        //           backgroundColor: Color(0xFF442B72),
                        //           child: Icon(
                        //             Icons.add,
                        //             color: Colors.white,
                        //             size: 35,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
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
}

