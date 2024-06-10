import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import '../classes/dropdowncheckboxitem.dart';
import '../main.dart';
import '../model/ParentModel.dart';
dynamic platform;

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
Set<Polyline> polyline = {};
List<ParentModel> childrenData = [];

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



List<PointLatLng> decodeEncodedPolyline(String encoded) {
  List<PointLatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;
  polyline.clear();

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    polyList.add(p);
  }
  polyline.add(Polyline(
    polylineId: const PolylineId('1'),
    visible: true,patterns: [
    PatternItem.dash(10),
    PatternItem.gap(10),
  ],
    color: const Color(0xff39BF4E),
    width: 4,
    points: polyList,
  )
    // polyline.add(
    //   Polyline(
    //       polylineId: const PolylineId('1'),
    //       color: Colors.blueAccent,
    //       visible: true,
    //       width: 4,
    //       points: polyList),
  );
  valueNotifierHome.incrementNotifier();
  return poly;
}

List<LatLng> polyList = [];

getPolylines() async {
  print('callhistory1');

  polyList.clear();
  String pickLat = '';
  String pickLng = '';
  String dropLat = '';
  String dropLng = '';
  List<String> wayPointsList = [];
  List<String> wayPointsAddressList = [];
  String wayPoints = '';

  print('callhistory1$dropLat--$dropLng');
  try {
    var response = await http.get(Uri.parse(wayPoints != ''
        ? 'httpon?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&waypoints=$wayPoints&avoid=ferries|indoor&transit_mode=bus&mode=driving&key=AIzaSyCkokUjMmOTA9NeIxSs-HEhrp5DtOeBM04'
        : 'https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&transit_mode=bus&mode=driving&key=AIzaSyCkokUjMmOTA9NeIxSs-HEhrp5DtOeBM04'));

    // 'https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&transit_mode=bus&mode=driving&key=$mapKey'));
    if (response.statusCode == 200) {
      var steps =
      jsonDecode(response.body)['routes'][0]['overview_polyline']['points'];

      decodeEncodedPolyline(steps);
    } else {
      debugPrint(';;;;;' + response.body);
    }
  } catch (e) {
    if (e is SocketException) {
     // internet = false;
    }
  }
  return polyList;
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
class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(double latitude, double longitude)
  // ignore: unnecessary_null_comparison
      : assert(latitude != null),
  // ignore: unnecessary_null_comparison
        assert(longitude != null),
  // ignore: unnecessary_this, prefer_initializing_formals
        this.latitude = latitude,
  // ignore: unnecessary_this, prefer_initializing_formals
        this.longitude = longitude;

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}