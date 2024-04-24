import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

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
Future<bool> checkIfNumberExists(String phoneNumber) async {
  CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('schooldata');

  Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
  try {

    QuerySnapshot snapshot = await queryOfNumber.get();
    print(phoneNumber+'dataaa');
    if(snapshot.size > 0){
      loginType = 'schooldata';
      return true;
    }else{
      CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('parent');
      Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
      QuerySnapshot snapshot = await queryOfNumber.get();
      print(snapshot.docs.toString()+'dataaa');
      if(snapshot.size > 0){
        loginType = 'parent';

        return true;
      }else{
        CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
        Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
        QuerySnapshot snapshot = await queryOfNumber.get();
        print(snapshot.docs.toString()+'dataaa');
        if(snapshot.size > 0){
          loginType = 'supervisor';

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