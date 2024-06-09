import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/screens/signUpScreen.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/custom_app_bar.dart';
import '../components/custom_switch.dart';
import '../components/dialogs.dart';
import '../components/elevated_icon_button.dart';
import '../components/elevated_simple_button.dart';
import '../components/home_drawer.dart';
import '../controller/local_controller.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  MyLocalController ControllerLang = Get.find();
  //fun delete account
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// fun delete school account only
  // void _deleteAccountFromFirestore() async {
  //   // Get the document ID from shared preferences
  //   String? documentId = sharedpref!.getString('id');
  //
  //   // Check if document ID is not null
  //   if (documentId != null) {
  //     try {
  //       // Delete the document from Firestore
  //       await _firestore.collection('schooldata').doc(documentId).delete();
  //       print('Data deleted for document ID: $documentId');
  //
  //       // Optionally, you can clear the shared preferences or any local storage related to this document
  //       sharedpref!.remove('id');
  //       sharedpref!.remove('allData');
  //     } catch (error) {
  //       print('Failed to delete data: $error');
  //     }
  //   } else {
  //     print('Document ID is null, cannot delete data');
  //   }
  // }
  void _deleteAccountFromFirestore() async {
    // Get the document ID from shared preferences
    String? documentId = sharedpref!.getString('id');

    // Check if document ID is not null
    if (documentId != null) {
      try {
        // Check if the document ID exists in each collection
        bool existsInParent = await _firestore.collection('parent').doc(documentId).get().then((doc) => doc.exists);
        bool existsInSchoolData = await _firestore.collection('schooldata').doc(documentId).get().then((doc) => doc.exists);
        bool existsInSupervisor = await _firestore.collection('supervisor').doc(documentId).get().then((doc) => doc.exists);

        // Delete the document from each collection if it exists
        if (existsInParent) {
          await _firestore.collection('parent').doc(documentId).delete();
          print('Data deleted from parent collection for document ID: $documentId');
        }
        if (existsInSchoolData) {
          await _firestore.collection('schooldata').doc(documentId).get().then((doc) async {
            //String schoolId = doc.get('schoolId'); // Assuming schoolId is a field in schooldata document

            // Delete documents from other collections that have the same schoolId
            await _deleteDocumentsFromCollection('supervisor', documentId);
            await _deleteDocumentsFromCollection('schoolholiday', documentId);
            await _deleteDocumentsFromCollection('schoolweekend', documentId);
            await _deleteDocumentsFromCollection('busdata', documentId);

            await _firestore.collection('schooldata').doc(documentId).delete();
            print('Data deleted from schooldata collection for document ID: $documentId');
          });
        }
        if (existsInSupervisor) {
          await _firestore.collection('supervisor').doc(documentId).delete();
          print('Data deleted from supervisor collection for document ID: $documentId');
        }

        // Optionally, you can clear the shared preferences or any local storage related to this document
        sharedpref!.remove('id');
        sharedpref!.remove('allData');
      } catch (error) {
        print('Failed to delete data: $error');
      }
    } else {
      print('Document ID is null, cannot delete data');
    }
  }

  Future<void> _deleteDocumentsFromCollection(String collectionName, String schoolId) async {
    QuerySnapshot querySnapshot = await _firestore.collection(collectionName).where('schoolid', isEqualTo: schoolId).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
      print('Data deleted from $collectionName collection for schoolId: $schoolId');
    }
  }
  // Completer<GoogleMapController> _controller = Completer();
  bool tracking = true;
  bool isExpanded = false;
  bool alarm=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  'Settings'.tr,
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
          //Custom().customAppBar(context, 'Settings'),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'General'.tr,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      height: 0.89,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  title:  Text(
                    'Notifications'.tr,
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  //trailing: CustomSwitch(),
                ),
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title:  Text(
                      'Language'.tr,
                      style: TextStyle(
                        color: Color(0xFF771F98),
                        fontSize: 15,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        height: 1.54,
                      ),
                    ),
                    trailing: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Color(0xffC8C8C8),
                      size: 24,
                    ),
                    onExpansionChanged: (bool expanded) {
                      setState(() => isExpanded = expanded);
                    },
                    children: [
                      ListTile(
                          title: Row(
                        children: [
                          Image.asset(
                            'assets/imgs/school/icons8_egypt 1.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          const Text(
                            'عربى',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 15,
                              fontFamily: 'Cairo-Regular',
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),
              onTap: (){
      ControllerLang.ChangeLang('ar');
      },
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.47,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0x14091C3F),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                          title: Row(
                        children: [
                          Image.asset(
                            'assets/imgs/school/icons8_usa_1 1.png',
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          const Text(
                            'English',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 15,
                              fontFamily: 'Cairo-Regular',
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),
                        onTap: () {
                          ControllerLang.ChangeLang('en');
                        },
                      ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFFFC53D),
                        ),
                      ),
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                  child: Text(
                    'Advanced'.tr,
                    style: TextStyle(
                      color: Color(0xFF442B72),
                      fontSize: 18,
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w600,
                      height: 0.89,
                    ),
                  ),
                ),
                ListTile(
                  title:  Text(
                    'Fingerprint and Face ID'.tr,
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  trailing: CustomSwitch(onChanged: (value) {
                    // Here, value will be true if the switch is turned on and false if it's turned off
                    if (value) {
                      // Add to Firestore
                      FirebaseFirestore.instance.collection('schooldata').doc(sharedpref!.getString('id')).set({
                        'fingerprint': true,
                      }, SetOptions(merge: true));
                    } else {
                      // Remove from Firestore
                      FirebaseFirestore.instance.collection('schooldata').doc(sharedpref!.getString('id')).set({
                        'fingerprint': false,
                      }, SetOptions(merge: true));
                    }
                  },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title:  Text(
                    'Alarm'.tr,
                    style: TextStyle(
                      color: Color(0xFF771F98),
                      fontSize: 15,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                    ),
                  ),
                  trailing: CustomSwitch(
                    onChanged: (value) {
                      // Here, value will be true if the switch is turned on and false if it's turned off
                      if (value) {
                        // Add to Firestore
                        FirebaseFirestore.instance.collection('parent').doc(sharedpref!.getString('id')).set({
                          'alarm': true,
                        }, SetOptions(merge: true));
                      } else {
                        // Remove from Firestore
                        FirebaseFirestore.instance.collection('parent').doc(sharedpref!.getString('id')).set({
                          'alarm': false,
                        }, SetOptions(merge: true));
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                // Center(
                //   child: ElevatedButton(onPressed: (){},
                //     style: ElevatedButton.styleFrom(
                //         primary: Color(0xff442B72), // Background color
                //         onPrimary: Colors.white, // Text color
                //
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10), // Rounded corners
                //         ),),
                //       child: Text("Delete Account",style: TextStyle(fontSize: 16,fontFamily:"Poppins-Medium" ),)),
                // )
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.4, color: Color(0xff442B72)),
                      bottom: BorderSide(width: 0.4, color: Color(0xff442B72)),
                      left: BorderSide.none,
                      right: BorderSide.none,
                    )),
                    child: GestureDetector(
                      onTap: () {
                        deleteAccoubtDialog(context);
                        // Dialoge.deleteAccoubtDialog(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Image.asset(
                              'assets/imgs/school/icons8_Delete 1.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Text(
                            "Delete Account".tr,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins-Medium",
                                color: Color(0xffF13939)),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      // print('Switch Button is OFF');
    }
  }

  deleteAccoubtDialog(context) {
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
                        child: Align(
                            alignment: AlignmentDirectional.topCenter,
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
                            )),
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
                        onPress: () {
                          _deleteAccountFromFirestore();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                              (Route<dynamic> route) => false);
                        },
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
