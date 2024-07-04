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
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:url_launcher/url_launcher_string.dart';
import '../classes/dropdownRadiobutton.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/dialogs.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'editeBus.dart';
import 'homeScreen.dart';
import 'dart:math' as math;


class Supervisor {
  String name;

  Supervisor({required this.name});
}
class BusScreen extends StatefulWidget{

  // const EditeSupervisor({super.key});

  //const BusScreen({super.key});
  @override
  State<BusScreen> createState() => BusScreenSate();
}


class BusScreenSate extends State<BusScreen> {



  // Blend the colors with a 50-50 ratio
  Color blendedColor = Color.lerp(Color(0xFFe6bdf0), Color(0xFFBE7FBF), 0.1)!;

  //func to get current schoolid
  String? _schoolId;
  Future<void> getSchoolId() async {
    try {
      // Get the SharedPreferences instance
      // final prefs = await SharedPreferences.getInstance();

      // Retrieve the school ID from SharedPreferences
      _schoolId = sharedpref!.getString('id');
      print("SCHOOLID$_schoolId");
      // If the school ID is not found in SharedPreferences, you can handle this case
      if (_schoolId == null) {
        // You can either throw an exception or set a default value
        throw Exception('School ID not found in SharedPreferences');
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error retrieving school ID: $e');
    }
  }

  //fun to make call
  void _makePhoneCall(String phoneNumber) async {
    var mobileCall = 'tel:$phoneNumber';
    if (await canLaunchUrlString(mobileCall)) {
      await launchUrlString(mobileCall);
    } else {
      throw 'Could not launch $mobileCall';
    }
  }
  List<QueryDocumentSnapshot> filteredData = [];
  List<QueryDocumentSnapshot<Object?>> filteredQuerySnapshots = [];

  List data=[];
  // getData()async{
  //   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('busdata').get();
  //   data.addAll(querySnapshot.docs);
  //   setState(() {
  //     data = querySnapshot.docs;
  //     // Initialize filteredData with a copy of data
  //     filteredData = List.from(data);
  //
  //     // Cast filteredData to List<QueryDocumentSnapshot<Object?>>
  //     filteredQuerySnapshots =
  //         filteredData.cast<QueryDocumentSnapshot<Object?>>();
  //     //filteredData = List.from(data);
  //   });
  // }
  getData() async {
   // Get the current school ID from SharedPreferences
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('busdata')
        .where('schoolid', isEqualTo: _schoolId) // Filter by school ID
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {
      data = querySnapshot.docs;
      // Initialize filteredData with a copy of data
      filteredData = List.from(data);

      // Cast filteredData to List<QueryDocumentSnapshot<Object?>>
      filteredQuerySnapshots =
          filteredData.cast<QueryDocumentSnapshot<Object?>>();
    });
  }
  void _editBusDocument(String documentId, String imagedriver, String namedriver,
      String driverphone,List<dynamic> photobus,String numberbus ,List<dynamic>supervisors) {
    List<DropdownCheckboxItem>allSupervisors=[];
    for(int i=0;i<supervisors.length;i++){
      allSupervisors.add(DropdownCheckboxItem(label: supervisors[i]['name'],phone: supervisors[i]['phone'],docID: supervisors[i]['id']));
    }
    selectedItems.clear();
    selectedItems=allSupervisors;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditeBus(
          docid: documentId,
          oldphotodriver: imagedriver,
          olddrivername:namedriver,
          olddriverphone:driverphone,
          oldphotobus:photobus,
          olddnumberbus:numberbus, allSupervisors: allSupervisors,
        ),
      ),
    );
  }
//fun delete bus
//   void _deletebusDocument(String documentId) {
//     FirebaseFirestore.instance
//         .collection('busdata')
//         .doc(documentId)
//         .delete()
//         .then((_) {
//       setState(() {
//         // Update UI by removing the deleted document from the data list
//         data.removeWhere((document) => document.id == documentId);
//         filteredData = List.from(data);
//       });
//
//     });
//
//   }
  void _deleteBusDocument(String documentId) async {
    try {
      // Step 1: Get the bus document to retrieve the list of supervisors
      DocumentSnapshot busDoc = await FirebaseFirestore.instance.collection('busdata').doc(documentId).get();

      if (busDoc.exists) {
        List<dynamic> supervisors = busDoc['supervisors'];
        if (supervisors != null && supervisors.isNotEmpty) {
          // Step 2: Delete supervisor documents from 'supervisor' collection
          for (var supervisor in supervisors) {
            String supervisorId = supervisor['id'];
            await FirebaseFirestore.instance.collection('supervisor').doc(supervisorId).delete().then((_) {
              print('Supervisor document deleted: $supervisorId');
            }).catchError((error) {
              print('Error deleting supervisor document: $supervisorId, $error');
            });
          }
        }

// انا ضفتها جديد علشان يمسح البارنت بس مجربتهاش لسه
//         if (busDoc.exists) {
//           List<dynamic> parents = busDoc['parent'];
//           if (parents != null && parents.isNotEmpty) {
//             // Step 2: Delete supervisor documents from 'supervisor' collection
//             for (var parent in parents) {
//               String parentId = parent['id'];
//               await FirebaseFirestore.instance.collection('parent').doc(parentId).delete().then((_) {
//                 print('parent document deleted: $parentId');
//               }).catchError((error) {
//                 print('Error deleting parent document: $parentId, $error');
//               });
//             }
//           }}

        // Step 3: Delete the bus document
        await FirebaseFirestore.instance.collection('busdata').doc(documentId).delete().then((_) {
          print('Bus document deleted: $documentId');
          setState(() {
            // Update UI by removing the deleted document from the data list
            data.removeWhere((document) => document.id == documentId);
            filteredData = List.from(data);
          });
        }).catchError((error) {
          print('Error deleting bus document: $error');
        });
      } else {
        print('Bus document not found: $documentId');
      }
    } catch (error) {
      print('Error in _deleteBusDocument: $error');
    }
  }




  //fun filter
  String selectedFilter = '';
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
  getDataForBusNumberFilter()async{
    CollectionReference Bus = FirebaseFirestore.instance.collection('busdata');
    QuerySnapshot BusData = await Bus.where('busnumber').where('schoolid', isEqualTo: sharedpref!.getString('id')).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = BusData.docs;
      isFiltered = true;
    });
  }

  getDataForDriverNameFilter()async{
    CollectionReference Bus = FirebaseFirestore.instance.collection('busdata');
    QuerySnapshot BusData = await Bus.where('namedriver' ).where('schoolid', isEqualTo: sharedpref!.getString('id')).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = BusData.docs;
      isFiltered = true;
    });
  }

  // getDataForSupervisorFilter()async{
  //   CollectionReference Bus = FirebaseFirestore.instance.collection('busdata');
  //   QuerySnapshot BusData = await Bus.where('supervisorname').where('schoolid', isEqualTo: sharedpref!.getString('id')).get();
  //   // parentData.docs.forEach((element) {
  //   //   data.add(element);
  //   // }
  //   // );
  //   setState(() {
  //     data = BusData.docs;
  //     isFiltered = true;
  //   });
  // }
  Future<void> getDataForSupervisorFilter() async {
    CollectionReference busDataCollection = FirebaseFirestore.instance.collection('busdata');
    QuerySnapshot busDataQuerySnapshot = await busDataCollection.where('schoolid', isEqualTo: sharedpref!.getString('id')).get();
    List<QueryDocumentSnapshot> filteredData = busDataQuerySnapshot.docs;

    setState(() {
      data = filteredData;
      isFiltered = true;
    });

    // Extract the supervisors from the filtered data
    List<Supervisor> supervisors = [];
    for (QueryDocumentSnapshot doc in filteredData) {
      List<dynamic> docSupervisors = doc.get('supervisors');
      for (dynamic supervisor in docSupervisors) {
        supervisors.add(Supervisor(name: supervisor['name']));
      }
    }

    // Update the _supervisors list with the extracted supervisors
    setState(() {
      _supervisors = supervisors;
    });
  }


  MyLocalController ControllerLang = Get.find();
  final TextEditingController searchController=TextEditingController();
  int? _selectedOption=1 ;
  int selectedIconIndex = 0;
  bool isEditingBus = false;
  int _counter = 0;
  // هنا تقوم بتعريف الحالة
  bool _isButtonDisabled= true;
  final _firestore = FirebaseFirestore.instance;
  //هنا بتعريق الدالة التي ستفوم بعمل الزيادة
  void _incrementCounter() {
    setState(() {
      _isButtonDisabled = true;
      _counter++;
    });
  }
  //new
  List<DropdownCheckboxItem> selectedItems = [];

  //new
  List<Supervisor> _supervisors = [];
  Future<void> _getSupervisorName() async {
    final firestore = FirebaseFirestore.instance;
    final busDataCollection = firestore.collection('busdata');
    final busDataDoc = busDataCollection.doc('LHYs0SGoFtBM9H4dUr4X'); // Replace with the actual document ID
    final busData = await busDataDoc.get();
    final supervisors = busData.get('supervisors');

    if (supervisors.isNotEmpty) {
      final supervisorDoc = await firestore.collection('supervisor').doc(supervisors[0]['id']).get();
      final supervisorName = supervisorDoc.get('name');
      setState(() {
        _supervisorName = supervisorName;
      });
    }
  }
  String _supervisorName = '';
  final PageController _pageController = PageController(viewportFraction: 0.8);
// to lock in landscape view
  @override
  void initState() {

    super.initState();
    getSchoolId();
    getData();
    _getSupervisorName();
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
    _pageController.dispose();
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
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                size: 26,
                                color: Color(0xff442B72),
                              ),
                            ),
                          ),
                          // SizedBox(width: 20,),
                          Expanded(
                            child: Center(
                              child: Align( alignment: AlignmentDirectional.center,
                                child: Text(
                                  "Buses".tr,
                                  style: TextStyle(
                                    color: Color(0xFF993D9A),
                                    fontSize: 20,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.w700,
                                    //height: 0.64,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(onTap: (){
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            const SizedBox(
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
                                                  color: Color(0xffffffff),
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
                                                      child:
                                                      SearchBar(
                                                        leading: Padding(
                                                          padding: const EdgeInsets.only(left: 4.0),
                                                          child: Image.asset("assets/imgs/school/icons8_search 1.png",width: 22,height: 22,),
                                                        ),
                                                        //Icon(Icons.search,color: Color(0xFFC2C2C2),),
                                                        controller: searchController,
                                                        textStyle:MaterialStateProperty.all<TextStyle?>(TextStyle(color: Color(0xFF442B72),)) ,
                                                        hintText: "Search Name".tr,
                                                        onChanged: (query) {
                                                          setState(() {
                                                            filteredData = data.where((item) {
                                                              if (selectedFilter == 'Bus Number') {
                                                                // Filter by bus number
                                                                String busNumber = item['busnumber'] as String;
                                                                return busNumber.toLowerCase().contains(query.toLowerCase());
                                                              } else if (selectedFilter == 'Driver Name')
                                                              {
                                                                // Filter by driver name
                                                                String driverName = item['namedriver'] as String;
                                                                return driverName.toLowerCase().contains(query.toLowerCase());
                                                              }
                                                              else if (selectedFilter == 'Supervisor') {
                                                                // Filter by supervisor name
                                                                List<dynamic> supervisors = item['supervisors'];
                                                                for (var supervisor in supervisors) {
                                                                  if (supervisor['name'].toLowerCase().contains(query.toLowerCase())) {
                                                                    return true;
                                                                  }
                                                                }
                                                                return false;
                                                              }

                                                              return false; // Default case
                                                            }).toList().cast<QueryDocumentSnapshot<Object?>>();
                                                          });
                                                          // setState(() {
                                                          //   filteredData = data.where((item) {
                                                          //     if (selectedFilter == 'Bus Number') {
                                                          //       // Filter by bus number
                                                          //       return item['busnumber'].toString().toLowerCase().contains(query.toLowerCase());
                                                          //     } else if (selectedFilter == 'Driver Name') {
                                                          //       // Filter by driver name
                                                          //       return item['namedriver'].toString().toLowerCase().contains(query.toLowerCase());
                                                          //     }
                                                          //     return false; // Default case
                                                          //   }).toList();
                                                          // });
                                                        },
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
                                                color: Color(0xffffffff),
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
                                                                DropdownCheckboxItem(label: 'Bus Number'.tr),
                                                                DropdownCheckboxItem(label: 'Driver Name'.tr),
                                                                DropdownCheckboxItem(label: 'Supervisor'.tr),
                                                              ],
                                                              selectedItems: selectedItems,
                                                              onSelectionChanged: (items) {
                                                                setState(() {
                                                                  selectedItems = items;
                                                                  selectedItems = items;
                                                                  if (items.first.label == 'Bus Number') {
                                                                    selectedValueAccept = 'Bus Number';
                                                                    selectedValueDecline = null;
                                                                    selectedValueWaiting = null;
                                                                  } else if (items.first.label == 'Driver Name') {
                                                                    selectedValueAccept = null;
                                                                    selectedValueDecline = 'Driver Name';
                                                                    selectedValueWaiting = null;
                                                                  } else if (items.first.label == 'Supervisor') {
                                                                    selectedValueAccept = null;
                                                                    selectedValueDecline = null;
                                                                    selectedValueWaiting = 'Supervisor';
                                                                  }
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
                                                                  child: GestureDetector(
                                                                      onTap:(){
                                                                        if (selectedValueAccept != null) {
                                                                          currentFilter = 'Bus Number';
                                                                          selectedFilter = 'Bus Number';
                                                                          getDataForBusNumberFilter();
                                                                          Navigator.pop(context);
                                                                          print('2');
                                                                        }else  if (selectedValueDecline != null) {
                                                                          currentFilter = 'Driver Name';
                                                                          selectedFilter = 'Driver Name';
                                                                          getDataForDriverNameFilter();
                                                                          Navigator.pop(context);
                                                                          print('0');
                                                                        }else  if (selectedValueWaiting != null) {
                                                                          currentFilter = 'Supervisor';
                                                                          selectedFilter='Supervisor';
                                                                          getDataForSupervisorFilter();
                                                                          Navigator.pop(context);
                                                                          print('1');
                                                                        }
                                                                      },
                                                                      child: Text('Apply'.tr,style: TextStyle(fontSize:18,color: Color(0xffFFFFFF)),)

                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width: 3,),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: GestureDetector(
                                                                    onTap: (){
                                                                      getData();
                                                                      Navigator.pop(context);
                                                                    },child: Text("Reset".tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 20),)),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ];
                                                },
                                              ),


                                            ],
                                          ),
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
                                        //function get data
                                        // FutureBuilder(
                                        //   future: _firestore.collection('busdata').doc('UzrcI6MfSYP1mbGY2Ci3').get(),
                                        //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                        //     if (snapshot.hasError) {
                                        //       return Text('Something went wrong');
                                        //     }
                                        //
                                        //     if (snapshot.connectionState == ConnectionState.done) {
                                        //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                        //       return ListTile(
                                        //         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        //         leading: GestureDetector(
                                        //           onTap: () {
                                        //             Navigator.push(
                                        //               context,
                                        //               MaterialPageRoute(
                                        //                 builder: (context) => ProfileScreen(),
                                        //                 maintainState: false,
                                        //               ),
                                        //             );
                                        //           },
                                        //           child: Image.network(data['busphoto'], width: 61, height: 61,
                                        //             errorBuilder: (context, error, stackTrace) {
                                        //               return Image.asset('assets/imgs/school/default_image.png', width: 61, height: 61); // Display a default image if loading fails
                                        //             },),
                                        //         ),
                                        //         title: Text(
                                        //           data['busnumber'],
                                        //           style: TextStyle(
                                        //             color: Color(0xFF442B72),
                                        //             fontSize: 15,
                                        //             fontWeight: FontWeight.bold,
                                        //             fontFamily: 'Poppins-Bold',
                                        //           ),
                                        //         ),
                                        //         subtitle: Text("Driver Name : "+
                                        //           data['namedriver'],
                                        //           style: TextStyle(fontSize: 12, fontFamily: "Poppins-Regular", color: Color(0xff442B72)),
                                        //         ),
                                        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                        //           trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                        //         //tileColor: Colors.white,
                                        //
                                        //       ),);
                                        //     }
                                        //
                                        //     return CircularProgressIndicator();
                                        //   },
                                        // ),
                                        // show data from firestore بس مش كامله
                                        Column(
                                          children: [
                                            if (filteredData.isEmpty)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 30),
                                                child: Text('No data available', style: TextStyle(color: Colors.grey)),
                                              ),
                                            if(filteredData.isNotEmpty)
                                              SizedBox(
                                                height: 500,
                                                child: ListView.builder(
                                                  // shrinkWrap: true,
                                                  //itemCount: filteredData.length,
                                                  //itemCount: data.length,
                                                    itemCount: selectedFilter == 'Driver Name'|| selectedFilter == 'Bus Number' || selectedFilter =='Supervisor' ?  filteredData.length : data.length,
                                                    itemBuilder: (context, index) {


                                                      String supervisorPhoneNumber = filteredData[index]['phonedriver'];
                                                      // to change image depended on filter if filter with bus number show image of bus & if filter with driver name image of driver appear
                                                      String imageUrl = selectedFilter == 'Bus Number'
                                                          ? filteredData[index]['busphoto'][0] // Use busphoto for Bus Number filter
                                                          : filteredData[index]['imagedriver'];
                                                      // Determine the fallback image asset based on the selected filter
                                                      String defaultImageAsset = selectedFilter == 'Bus Number'
                                                          ? 'assets/imgs/school/bus 2.png' // Default image for Bus Number filter
                                                          : 'assets/imgs/school/empty_supervisor.png'; // Default image for Driver Name filter
                                                      return
                                                        Column(
                                                          children: [
                                                            ListTile(
                                                              leading: imageUrl.isNotEmpty
                                                                  ? ClipOval(
                                                                  child: Image.network(
                                                                    imageUrl,
                                                                    width: 61,
                                                                    height: 61,
                                                                    fit: BoxFit.cover,
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                      // Display a default image if loading fails
                                                                      return Image.asset(
                                                                        defaultImageAsset,
                                                                        width: 61,
                                                                        height: 61,
                                                                        fit: BoxFit.cover,
                                                                      );
                                                                    },
                                                                  ))
                                                                  :       Container(
                                                                width: 65,
                                                                // Adjust size as needed
                                                                height: 65,
                                                                decoration:
                                                                BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xffCCCCCC),
                                                                    // Adjust border color
                                                                    width:
                                                                    2, // Adjust border width
                                                                  ),
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .bottomCenter,
                                                                  child:
                                                                  CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundImage:
                                                                    AssetImage(
                                                                      "assets/imgs/school/Vector (14).png",
                                                                    ),
                                                                    backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                          //new
                                                              // Image.asset(
                                                              //   'assets/imgs/school/empty_supervisor.png',
                                                              //   width: 61,
                                                              //   height: 61,
                                                              //   fit: BoxFit.cover,
                                                              // ),
                                                      //old
                                                              // Image.network(filteredData[index]['imagedriver'], width: 61, height: 61,
                                                              //               errorBuilder: (context, error, stackTrace) {
                                                              //                 return Image.asset('assets/imgs/school/default_image.png', width: 61, height: 61); // Display a default image if loading fails
                                                              //               },),
                                                              title: Text(
                                                                selectedFilter == 'Bus Number'
                                                                    ? '${filteredData[index]['busnumber']}'
                                                                    : selectedFilter == 'Supervisor'
                                                                    ? '${filteredData[index]['supervisors'][0]['name']}'
                                                                    : '${filteredData[index]['namedriver']}',
                                                                style: TextStyle(
                                                                  color: Color(0xFF442B72),
                                                                  fontSize: 17,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Poppins-Bold',
                                                                ),
                                                              ),
                                                              subtitle: Text(
                                                                selectedFilter == 'Bus Number'
                                                                    ? 'Driver Name: ${filteredData[index]['namedriver']}'
                                                                    : selectedFilter == 'Supervisor'
                                                                    ? 'Bus Number: ${filteredData[index]['busnumber']}'
                                                                    : 'Bus number: ${filteredData[index]['busnumber']}',
                                                                style: TextStyle(fontSize: 12, fontFamily: "Poppins-Regular", color: Color(0xff771F98)),
                                                              ),

                                                              trailing:
                                                              PopupMenuButton<String>(
                                                                enabled: !isEditingBus,

                                                                shape: RoundedRectangleBorder(

                                                                  borderRadius: BorderRadius.all(
                                                                    Radius.circular(10.0),
                                                                  ),
                                                                ),
                                                                icon: Padding(
                                                                  padding: const EdgeInsets.only(left: 12),
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
                                                                          isEditingBus = true;
                                                                          _editBusDocument(
                                                                              data[index].id,
                                                                              data[index]['imagedriver'],
                                                                              data[index]['namedriver'],
                                                                              data[index]['phonedriver'],
                                                                              data[index]['busphoto'],
                                                                              data[index]['busnumber'],
                                                                              data[index]['supervisors']

                                                                          );
                                                                          // _editSupervisorDocument(
                                                                          //   data[index].id,
                                                                          //   data[index]['name'],
                                                                          //   data[index]['phoneNumber'],
                                                                          //   data[index]['email'],
                                                                          // );
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
                                                                    //   print('daaaata'+data[index]['supervisors'].toString());

                                                                    // Handle edit action
                                                                    setState(() {
                                                                      isEditingBus = true;
                                                                      _editBusDocument(
                                                                          data[index].id,
                                                                          data[index]['imagedriver'],
                                                                          data[index]['namedriver'],
                                                                          data[index]['phonedriver'],
                                                                          data[index]['busphoto'],
                                                                          data[index]['busnumber'],
                                                                          data[index]['supervisors']


                                                                      );
                                                                    });
                                                                    // Navigator.pushReplacement(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) =>
                                                                    //             EditeSupervisor()));
                                                                  } else if (value == 'delete') {

                                                                    deletePhotoDialog(context, data[index].id);


                                                                    // if (index < filteredData.length) {
                                                                    //   _deletebusDocument(filteredData[index].id);
                                                                    // } else {
                                                                    //   print('Invalid index: $index');
                                                                    // }

                                                                  }
                                                                },
                                                              ),
                                                              tileColor: Colors.white,
                                                              onTap: (){
                                                                // List<DropdownCheckboxItem>allSupervisors=[];
                                                                // for(int i=0;i<data[index]['supervisors'].length;i++){
                                                                //   allSupervisors.add(DropdownCheckboxItem(label:data[index]['supervisors'][i]['name'],phone: data[index]['supervisors'][i]['phone'],docID: data[index]['supervisors'][i]['id']));
                                                                // }
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
                                                                                    'Bus: ${data[index]['busnumber']}',
                                                                                    style: TextStyle(
                                                                                        fontSize: 14,
                                                                                        color: Color(0xFF442B72),
                                                                                        fontFamily: "Poppins-Regular"
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height:20,),
                                                                            //
                                                                            // ListView.builder(
                                                                            //   shrinkWrap: true,
                                                                            //   itemCount: data.length,
                                                                            //   itemBuilder: (context, index) {
                                                                            //     return
                                                                                  Center(
                                                                                    child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: SizedBox(
                                                                                      width: 250,
                                                                                      height: 100,
                                                                                      child: data[index]['busphoto'] != null && data[index]['busphoto'] is List && data[index]['busphoto'].isNotEmpty
                                                                                          ?
                                                                                      // ListView.builder(
                                                                                      //   scrollDirection: Axis.horizontal,
                                                                                      //
                                                                                      //   itemCount: (data[index]['busphoto'] as List).length,
                                                                                      //   itemBuilder: (context, imageIndex) {
                                                                                      //     return Padding(
                                                                                      //       padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                      //       child: Container(
                                                                                      //         width: 80,
                                                                                      //         decoration: BoxDecoration(
                                                                                      //           border: Border.all(
                                                                                      //             color: Color(0xFF442B72), // border color
                                                                                      //             width: 2, // border width
                                                                                      //           ),
                                                                                      //           borderRadius: BorderRadius.circular(5),
                                                                                      //         ),
                                                                                      //         child: Image.network(
                                                                                      //           (data[index]['busphoto'] as List)[imageIndex],
                                                                                      //           fit: BoxFit.cover,
                                                                                      //         ),
                                                                                      //       ),
                                                                                      //     );
                                                                                      //   },
                                                                                      // )
                                                                                      Center(
                                                                                        child: SizedBox(
                                                                                          height: 200,
                                                                                          // Set the height according to your requirements
                                                                                          child: PageView.builder(
                                                                                            controller: _pageController,
                                                                                            itemCount: (data[index]['busphoto'] as List).length,
                                                                                            itemBuilder: (context, imageIndex) {
                                                                                              return AnimatedBuilder(
                                                                                                animation: _pageController,
                                                                                                builder: (context, child) {
                                                                                                  double scale = 0.8;
                                                                                                  if (_pageController.position.haveDimensions) {
                                                                                                    double currentPage = _pageController.page ?? _pageController.initialPage.toDouble();
                                                                                                    double distance = (currentPage - imageIndex).abs();
                                                                                                    if (distance < 0.5) { // Check if the current image is the middle one
                                                                                                      scale = 1.0; // Make the middle image bigger
                                                                                                    } else {
                                                                                                      scale = 0.8 - (distance * 0.2).clamp(0.0, 0.2); // Scale down other images
                                                                                                    }
                                                                                                  }
                                                                                                  return Transform.scale(
                                                                                                    scale: scale,
                                                                                                    child: child,
                                                                                                  );
                                                                                                },
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                                  child: AspectRatio(
                                                                                                    aspectRatio: 1,
                                                                                                    child: Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                        border: Border.all(
                                                                                                          color: Color(0xFF442B72),
                                                                                                          width: 2,
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                                      ),
                                                                                                      child: Image.network(
                                                                                                        (data[index]['busphoto'] as List)[imageIndex],

                                                                                                        fit: BoxFit.cover,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                          : Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xffe6bdf0),
                                                                                            ),
                                                                                            child: Center(
                                                                                              child: Image.asset(
                                                                                                'assets/imgs/school/image-gallery 1.png',
                                                                                                width: 40,
                                                                                                height: 40,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                ),
                                                                                  ),
                                                                            //   },
                                                                            // ),
                                                                            SizedBox(height: 10,),
                                                                            Text("Driver", style: TextStyle(color: Color(0xff442B72), fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            SizedBox(height: 10,),
                                                                            Row(
                                                                              children: [

                                                                                // Align(
                                                                                //   alignment: Alignment.centerLeft,
                                                                                //   child: CircleAvatar(
                                                                                //     radius: 35,
                                                                                //     backgroundImage: AssetImage('assets/imgs/school/Ellipse 1.png'),
                                                                                //
                                                                                //   ),
                                                                                // ),
                                                                                SizedBox(
                                                                                  width: 60,
                                                                                  height: 60,
                                                                                  child: ClipOval(
                                                                                    child: data[index]['imagedriver'] != null && data[index]['imagedriver'].isNotEmpty
                                                                                        ? Image.network(
                                                                                      data[index]['imagedriver'],
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                        :       Container(
                                                                                      width: 65,
                                                                                      // Adjust size as needed
                                                                                      height: 65,
                                                                                      decoration:
                                                                                      BoxDecoration(
                                                                                        shape: BoxShape
                                                                                            .circle,
                                                                                        border: Border
                                                                                            .all(
                                                                                          color: Color(
                                                                                              0xffCCCCCC),
                                                                                          // Adjust border color
                                                                                          width:
                                                                                          2, // Adjust border width
                                                                                        ),
                                                                                      ),
                                                                                      child: Align(
                                                                                        alignment:
                                                                                        Alignment
                                                                                            .bottomCenter,
                                                                                        child:
                                                                                        CircleAvatar(
                                                                                          radius: 20,
                                                                                          backgroundImage:
                                                                                          AssetImage(
                                                                                            "assets/imgs/school/Vector (14).png",
                                                                                          ),
                                                                                          backgroundColor:
                                                                                          Colors
                                                                                              .white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    // Image.asset(
                                                                                    //   'assets/imgs/school/empty_supervisor.png',
                                                                                    //   fit: BoxFit.cover,
                                                                                    // ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 20,),
                                                                                Column(
                                                                                  children: [
                                                                                    Text('${data[index]['namedriver']}', style: TextStyle(color: Color(0xff442B72), fontSize: 15)),
                                                                                    SizedBox(height: 10,),
                                                                                    Text('${data[index]['phonedriver']}', style: TextStyle(color: Color(0xff442B72), fontSize: 15)),

                                                                                  ],
                                                                                ),
                                                                                //SizedBox(width: 110,),
                                                                                Spacer(),
                                                                                Material(
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


                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 30),
                                                                            Text('Supervisors', style: TextStyle(color: Color(0xff442B72), fontSize: 20, fontWeight: FontWeight.bold)),
                                                                            SizedBox(height: 10),

                                                                        for(int i=0;i<data[index]['supervisors'].length;i++)
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
                                                                                    data[index]['supervisors'][i]['name'],
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

                                                            // SizedBox(width: 10,),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(horizontal: 5),
                                                            //   child:
                                                            // ),

                                                            SizedBox(
                                                              height: 20,
                                                            )

                                                          ],
                                                        );

                                                    }),

                                              ),
                                          ],
                                        ),

                                        SizedBox(height: 40,),

                                        // ListTile(
                                        //   leading: Container(
                                        //     width: 60,
                                        //
                                        //     //child: Image.asset('assets/imgs/school/fruits.jpeg'),
                                        //     decoration: BoxDecoration(
                                        //       image: DecorationImage(image:AssetImage("assets/imgs/school/buses.png"),fit: BoxFit.cover),
                                        //       //color: Colors.white,
                                        //       shape: BoxShape.circle,
                                        //     ),
                                        //   ),
                                        //   title: Text('1458 ى ر س'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)
                                        //   ),
                                        //   subtitle: Text("Driver name : Ahmed Atef",style:
                                        //   TextStyle(color: Color(0xff771F98),fontSize: 11,fontFamily: "Poppins-Regular"),),
                                        //
                                        //   trailing: Icon(Icons.more_vert,size: 30,color: Color(0xFF442B72),
                                        //
                                        //   ),
                                        //
                                        // ),
                                        // SizedBox(height: 40,),






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
                    padding: const EdgeInsets.only(right:20),
                    child: Column(children: [
                      FloatingActionButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddBus()));
                      },
                        backgroundColor: Color(0xFF442B72),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
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


        bottomNavigationBar:
        Directionality(
          textDirection: TextDirection.ltr,
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
                height: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
  deletePhotoDialog(context,String supervisorId) {
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
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Delete Bus",style: TextStyle(fontSize: 18,fontFamily: 'Poppins-SemiBold', color: Color(0xFF442B72),),)),
                SizedBox(height: 10,),
                  Center(
                    child: Align(alignment: AlignmentDirectional.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'There are supervisors and parents',
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                                //fontWeight: FontWeight.w400,
                                height: 1.23,
                              ),
                            ),
                            Center(
                              child: Text(
                                'on this bus all will be deleted',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 14,
                                  fontFamily: 'Poppins-Regular',
                                  // fontWeight: FontWeight.w400,
                                  height: 1.23,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'once you delete the bus',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 14,
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
                    height: 18,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete',
                        width: 120,
                        hight: 36,
                        onPress: () => {
                        Navigator.pop(context),
                          _deleteBusDocument(supervisorId)
                          //_deletebusDocument(documentId)
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
                        hight: 36,
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



