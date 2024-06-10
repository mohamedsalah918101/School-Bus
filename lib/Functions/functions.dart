import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as FDB;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import '../classes/dropdowncheckboxitem.dart';
import '../main.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

dynamic platform;

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

List<DropdownCheckboxItem> selectedItems = [];
class ValueNotifying {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifying valueNotifier = ValueNotifying();

class ValueNotifyingHome {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingNotification {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifying valueNotifierHome = ValueNotifying();
ValueNotifying valueNotifiercheck = ValueNotifying();
ValueNotifyingNotification valueNotifierNotification =
ValueNotifyingNotification();
final String DynamicLink = 'https://schoolbusapp.page.link/requestdata';
final String Link = 'https://schoolbusapp.page.link/requestdata';
bool _isCreatingLink = false;

Future<String> createDynamicLink(bool short,requestID,String phone,String type) async {

  print("https://www.schoolbusapp.com/request?id=${requestID}&phone=${phone}&type=${type}");

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
      return "success";
    }else{
      return "failed";

    }
  } else {
    url = await dynamicLinks.buildLink(parameters);
    final result = await Share.shareWithResult(url.toString());

    if (result.status == ShareResultStatus.success) {
      return "success";

    }else{
      return "failed";

    }
  }
}

String loginType='';
String id='';
int invitestate=0;

Future<bool> checkIfNumberExists(String phoneNumber) async {

  try {
    CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('schooldata');

    Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
    QuerySnapshot snapshot = await queryOfNumber.get();
    print(snapshot.docs.toString()+'dataaaschooldata');
    if(snapshot.size > 0){
      loginType = 'schooldata';
      id =snapshot.docs[0].id;
      sharedpref!.setString('nameEnglish',snapshot.docs[0].get('nameEnglish'));
      sharedpref!.setString('photo',snapshot.docs[0].get('photo'));

      if(snapshot.docs[0].get('state') == 0)
       {
         print(snapshot.docs[0].get('state').toString()+'ghghgh');
         sharedpref!.setInt('allData',0);}
      else
     { sharedpref!.setInt('allData',1);}

      return true;
    }else{
      CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('parent');
      Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
      QuerySnapshot snapshot = await queryOfNumber.get();
      print(snapshot.docs.toString()+'dataaaparent');
      if(snapshot.size > 0){
        loginType = 'parent';
        id =snapshot.docs[0].id;
        sharedpref!.setInt('invitstate',snapshot.docs[0].get('state'));
        sharedpref!.setInt('invit',snapshot.docs[0].get('invite'));
        sharedpref!.setString('name',snapshot.docs[0].get('name'));

        if(snapshot.docs[0].data().toString().contains('address'))
        sharedpref!.setInt('address',1);
        else
          sharedpref!.setInt('address',0);

        return true;
      }else{
        CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
        Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
        QuerySnapshot snapshot = await queryOfNumber.get();
        print(snapshot.docs.toString()+'dataaasupervisor');
        if(snapshot.size > 0){
          loginType = 'supervisor';
          id =snapshot.docs[0].id;
          sharedpref!.setInt('invitstate',snapshot.docs[0].get('state'));
          sharedpref!.setInt('invit',snapshot.docs[0].get('invite'));
          sharedpref!.setString('name',snapshot.docs[0].get('name'));

          print('invitstate');
          print(snapshot.docs[0].get('invite').toString());
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

Future<bool> addSupervisorCheck(String phoneNumber) async {
  CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('schooldata');

  Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
  try {

    QuerySnapshot snapshot = await queryOfNumber.get();
    print(phoneNumber+'dataaa');
    if(snapshot.size > 0){

      return true;
    }else{
      CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
      Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
      QuerySnapshot snapshot = await queryOfNumber.get();
      print(snapshot.docs.toString()+'dataaa');
      if(snapshot.size > 0){
        return true;
      }else{
        return false;
      }

    }
  } catch (error) {

    print('Error: $error');
    return false;
  }
}
String constructFCMPayload(String? token) {

  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': 1,
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#) was created via FCM!',
    },  "android": {
      "notification": {
        "channel_id": "notification"
      }
    }
  });
}
Future<void> sendPushMessage(_token) async {
  if (_token == null) {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  try {
    await http.post(
      Uri.parse('https://api.rnfirebase.io/messaging/send'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : " key=AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E",
      },
      body: constructFCMPayload(_token),
    );
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}
sendNotification(String token,String msg) async {

  var request =await  http.post( Uri.parse("https://fcm.googleapis.com/fcm/send"),body:

  jsonEncode({
  'to' :token,
  'notification':[{
  'title' :'School Account',
  'body' : msg,
   // 'json_data': jsonEncode({"ddddd", true})
    }]
  }),headers: {'Authorization' :'key=AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E',
  'Content-Type': 'application/json'});
  print(request.body.toString());


}

Future<bool> addParentCheck(String phoneNumber) async {
  CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('schooldata');

  Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
  try {

    QuerySnapshot snapshot = await queryOfNumber.get();
    print(phoneNumber+'dataaa');
    if(snapshot.size > 0){

      return true;
    }else{
        CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
        Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
        QuerySnapshot snapshot = await queryOfNumber.get();
        print(snapshot.docs.toString()+'dataaa');
        if(snapshot.size > 0){
          return true;
        }else{
          return false;
        }

    }
  } catch (error) {

    print('Error: $error');
    return false;
  }
}
String docID='';
int invitCheck=0;
int childNum=0;
Future<bool> checkUpdate(String phoneNumber) async {

  try {


      CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('parent');
      Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
      QuerySnapshot snapshot = await queryOfNumber.get();
      print(snapshot.docs.toString()+'dataaa');
      if(snapshot.size > 0){
        loginType = 'parent';
        docID =snapshot.docs[0].id;
        invitCheck =snapshot.docs[0].get('invite');
        if(snapshot.docs[0].data().toString().contains('numberOfChildren'))
          childNum = 1;
        else
          childNum = 0;
        return true;


    }else {
        return false;

      }
  } catch (error) {

    print('Error: $error');
    return false;
  }
}
Future<bool> checkUpdateSupervisor(String phoneNumber) async {

  try {


    CollectionReference supervisorCollection = FirebaseFirestore.instance.collection('supervisor');
    Query queryOfNumber = supervisorCollection.where('phoneNumber', isEqualTo: phoneNumber);
    QuerySnapshot snapshot = await queryOfNumber.get();
    print(snapshot.docs.toString()+'dataaa');
    if(snapshot.size > 0){
      loginType = 'supervisor';
      docID =snapshot.docs[0].id;
      invitCheck =snapshot.docs[0].get('invite');

      return true;


    }else {
      return false;

    }
  } catch (error) {

    print('Error: $error');
    return false;
  }
}
void makePhoneCall(String phoneNumber) async {
  var mobileCall = 'tel:$phoneNumber';
  if (await canLaunchUrlString(mobileCall)) {
    await launchUrlString(mobileCall);
  } else {
    throw 'Could not launch $mobileCall';
  }

}


dynamic center;
dynamic last;

//supervisir track
addPoints(){
  Timer.periodic(const Duration(seconds: 15), (timer) async {
    var locs = await geolocator.Geolocator.getLastKnownPosition();
    if (locs != null) {
      center = LatLng(locs.latitude, locs.longitude);
    } else {
      var loc = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.low);
      center = LatLng(double.parse(loc.latitude.toString()),
          double.parse(loc.longitude.toString()));
    }

    if (last == null || last.latitude != center.latitude || last.longitude != center.longitude) {
      last = center;
      FDB.FirebaseDatabase.instance
          .ref()
          .child('supervisors').child(sharedpref!.getString("id").toString()).push().set({
        'lat': center.latitude, 'lang': center.longitude
      });
    }
  });
}




// dynamic center;
//
// //supervisir track
// addPoints(){
//
//   Timer.periodic(const Duration(seconds: 15), (timer) async {
//     var locs = await geolocator.Geolocator.getLastKnownPosition();
//     if (locs != null) {
//       center = LatLng(locs.latitude, locs.longitude);
//     } else {
//     var  loc = await geolocator.Geolocator.getCurrentPosition(
//           desiredAccuracy: geolocator.LocationAccuracy.low);
//       center = LatLng(double.parse(loc.latitude.toString()),
//           double.parse(loc.longitude.toString()));
//     }
//
//     FDB.FirebaseDatabase.instance
//         .ref()
//         .child('supervisors').child(sharedpref!.getString("id").toString()).push().set({
//       'lat': center.latitude, 'lang': center.longitude
//
//     });
//   });
//
// }