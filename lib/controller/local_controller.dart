import 'dart:ui';
import 'package:get/get.dart';

import '../main.dart';

class MyLocalController extends GetxController{

  Locale intialLang = sharedpref!.getString('lang') == null ? Get.deviceLocale! : Locale(sharedpref!.getString('lang')!);

  void ChangeLang( String CodeLang){
    Locale locale = Locale(CodeLang) ;
    sharedpref!.setString('lang', CodeLang);
    Get.updateLocale(locale);
  }
}