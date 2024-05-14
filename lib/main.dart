import 'dart:ffi';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/controller/local.dart';
import 'package:school_account/screens/splashScreen.dart';
import 'package:school_account/supervisor_parent/model/user_item.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/googlemap_test.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controller/local_controller.dart';

SharedPreferences? sharedpref;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'school_account',
    options: FirebaseOptions(
        apiKey: "AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E",
        authDomain: "loginschoolaccount.firebaseapp.com",
        projectId: "loginschoolaccount",
        storageBucket: "loginschoolaccount.appspot.com",
        messagingSenderId: "615571135320",
        appId: "1:615571135320:web:38d8b8404aed2721dea32d",
        measurementId: "G-3YG0J7RYWM"
    ),
  );
  sharedpref = await SharedPreferences.getInstance();

//   final prefs = await SharedPreferences.getInstance();
//
// // Retrieve the stored values
//   final name = prefs.getString('name');
//   final phoneNumber = prefs.getString('phoneNumber');
  // if (name != null && phoneNumber != null) {
  //   // Use the retrieved values
  //   print('Name: $name');
  //   print('Phone Number: $phoneNumber');
  //
  // } else {
  //   // Handle case where values are not found
  //   print('Name or Phone Number not found in SharedPreferences');
  // }
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    MyLocalController Controller = Get.put(MyLocalController());
    return GetMaterialApp(
      locale: Controller.intialLang,
      translations: MyLocal(),
      debugShowCheckedModeBanner: false,
      home:
      // Chat()
        // ChatScreen(),
      // GoogleMapWidget()
      // TrackSupervisor()
      // ParentsView(),
      AttendanceSupervisorScreen(),
      // AddParents(),
      // SplashScreen(),
    );
  }
}