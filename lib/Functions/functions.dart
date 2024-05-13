import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;


final String DynamicLink = 'https://schoolbusapp.page.link/requestdata';
final String Link = 'https://schoolbusapp.page.link/requestdata';
bool _isCreatingLink = false;

Future<void> createDynamicLink(bool short,requestID,String phone,String type) async {

  print('linnk');
  print(
      "https://www.schoolbusapp.com/request?id=${requestID}&phone=${phone}&type=${type}");

  DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://schoolbusapp.page.link',

    link: Uri.parse(
        "https://www.schoolbusapp.com/request?id=${requestID}&phone=${phone}&type=${type}"),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: "Share",
      // imageUrl: Uri.parse(
    ),
    androidParameters: const AndroidParameters(
      packageName: 'com.example.school_account',
      minimumVersion: 0,
    ),
    iosParameters: const IOSParameters(
      bundleId: 'com.example.school_account',
      minimumVersion: '0',
    ),
  );

  Uri url;
  if (short) {
    final ShortDynamicLink shortLink =
    await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    final result = await Share.shareWithResult(url.toString());
    if (result.status == ShareResultStatus.success) {
    }else{
      print('errroee1');
    }
  } else {
    url = await dynamicLinks.buildLink(parameters);
    final result = await Share.shareWithResult(url.toString());

    if (result.status == ShareResultStatus.success) {

    }else{
      print('errroee1');

    }
  }
}

String loginType='';
String id='';
int invitestate=0;

Future<bool> checkIfNumberExists(String phoneNumber) async {
  CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('schooldata');

  Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
  try {

    QuerySnapshot snapshot = await queryOfNumber.get();
    print(phoneNumber+'dataaa');
    if(snapshot.size > 0){
      loginType = 'schooldata';
      id =snapshot.docs[0].id;
      if(snapshot.docs[0].get('address') == null)
        sharedpref!.setInt('allData',0);
      else
      sharedpref!.setInt('allData',1);

      return true;
    }else{
      CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('parent');
      Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
      QuerySnapshot snapshot = await queryOfNumber.get();
      print(snapshot.docs.toString()+'dataaa');
      if(snapshot.size > 0){
        loginType = 'parent';
        id =snapshot.docs[0].id;
        sharedpref!.setInt('invitstate',snapshot.docs[0].get('state'));
        sharedpref!.setInt('invit',snapshot.docs[0].get('invite'));

        return true;
      }else{
        CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
        Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
        QuerySnapshot snapshot = await queryOfNumber.get();
        print(snapshot.docs.toString()+'dataaa');
        if(snapshot.size > 0){
          loginType = 'supervisor';
          id =snapshot.docs[0].id;
          sharedpref!.setInt('invitstate',snapshot.docs[0].get('state'));
          sharedpref!.setInt('invit',snapshot.docs[0].get('invite'));
          return true;
        }else{
          return false;
        }
      }
    }
  } catch (error) {

    print('Error: $error');
    return false;
  }
}


String Home='';
String SearchiId='';
int invitestateHome=0;

Future<bool> checkIfNumberExistsForSearch(String phoneNumber) async {
  CollectionReference schoolDataCollection = FirebaseFirestore.instance.collection('schooldata');
  CollectionReference parentCollection = FirebaseFirestore.instance.collection('parent');
  CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');

  try {
    // بحث في جميع المجموعات للتحقق من وجود الرقم
    QuerySnapshot schoolDataSnapshot = await schoolDataCollection.where('phoneNumber', isEqualTo: phoneNumber).get();
    QuerySnapshot parentSnapshot = await parentCollection.where('phoneNumber', isEqualTo: phoneNumber).get();
    QuerySnapshot supervisorSnapshot = await supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber).get();

     if (supervisorSnapshot.size > 0) {
      loginType = 'supervisor';
      SearchiId = supervisorSnapshot.docs[0].id;
      sharedpref!.setInt('invitstate', supervisorSnapshot.docs[0].get('state'));
      sharedpref!.setInt('invit', supervisorSnapshot.docs[0].get('invite'));

      // قم بالتوجيه إلى صفحة المشرف هنا
      // Navigator.pushNamed(context, '/supervisor');

      // استخراج بيانات الـ phoneNumber من مستند supervisor
      String supervisorPhoneNumber = supervisorSnapshot.docs[0].get('phoneNumber');
      // يمكنك استخدام هذه البيانات كما تحتاج، على سبيل المثال، تخزينها في متغير لاستخدامه لاحقًا
      print('Supervisor Phone Number: $supervisorPhoneNumber');

      return true;
    }
    // إذا كان الرقم غير موجود
    else {
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}