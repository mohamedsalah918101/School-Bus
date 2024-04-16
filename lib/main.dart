import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/controller/local.dart';
import 'package:school_account/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';

import 'controller/local_controller.dart';

SharedPreferences? sharedpref;

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'school_account',
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      authDomain: "YOUR_AUTH_DOMAIN",
      projectId: "YOUR_PROJECT_ID",
      storageBucket: "YOUR_STORAGE_BUCKET",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "YOUR_APP_ID",
      measurementId: "YOUR_MEASUREMENT_ID",
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
      home: SplashScreen(),
    );
  }
}

