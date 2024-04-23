import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/controller/local.dart';
import 'package:school_account/screens/splashScreen.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
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
      // AddParents(),
      SplashScreen(),
    );
  }
}
