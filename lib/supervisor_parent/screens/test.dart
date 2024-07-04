// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:school_account/components/elevated_simple_button.dart';
// import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
// import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
// import '../../main.dart';
// import '../components/supervisor_drawer.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'dart:ui';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert' as convert;
//
//
// class PaginatedList extends StatefulWidget {
//   @override
//   _PaginatedListState createState() => _PaginatedListState();
// }
//
// class _PaginatedListState extends State<PaginatedList> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final int _limit = 3;
//   DocumentSnapshot? _lastDocument;
//   bool _isLoading = false;
//   bool _hasMoreData = true;
//   List<DocumentSnapshot> _documents = [];
//   List<Map<String, dynamic>> childrenData = [];
//   final ScrollController _scrollController = ScrollController();
//   bool hasArrived = false;
//   String arrivalTime = '';
//   int remainingTime = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   Position? currentPosition;
//   bool dataLoading = false;
//   List<QueryDocumentSnapshot> data = [];
//   GoogleMapController? controller;
//   BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
//   late final String title;
//   bool tracking = true;
//   String _namedriver = ' ';
//   String _photobus = ' ';
//   String _busnumber = ' ';
//   late DateTime estimatedArrivalTime;
//   late Timer _timer;
//   Timer? locationUpdateTimer;
//   StreamSubscription<Position>? _positionStreamSubscription;
//
//
//
//   double targetLatitude = 27.182;
//     double targetLongitude = 31.186;
//   //
//     Future<List<GeoPoint>> getLocationsFromFirestore() async {
//       List<GeoPoint> locations = [];
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('locations').get();
//
//       snapshot.docs.forEach((doc) {
//         locations.add(doc['location']); // افترض أن لديك حقل اسمه location في المستند
//       });
//
//       return locations;
//     }
//
//     Future<int> getRemainingTime(List<GeoPoint> locations) async {
//       String apiKey = 'AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E';
//       String origins = '${locations.first.latitude},${locations.first.longitude}';
//       String destinations = '${locations.last.latitude},${locations.last.longitude}';
//
//       String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destinations&key=$apiKey';
//
//       http.Response response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         var data = convert.json.decode(response.body);
//         var duration = data['rows'][0]['elements'][0]['duration']['value']; // الوقت بالثواني
//         return (duration / 60).round(); // تحويل الوقت إلى دقائق
//       } else {
//         throw Exception('Failed to fetch distance matrix');
//       }
//     }
//
//   //
//     Future<void> getCurrentLocation() async {
//       try {
//         Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         setState(() {
//           currentPosition = position;
//           arrivalTime = calculateArrivalTime(); // Update arrival time here
//           hasArrived = checkIfArrived(position); // Update arrival status here
//         });
//
//         // Store the latitude and longitude values in Firestore
//         final databaseReference = FirebaseFirestore.instance;
//         databaseReference.collection('users').doc('current_location').set({
//           'latitude': currentPosition!.latitude,
//           'longitude': currentPosition!.longitude,
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   //
//     Future<bool> _checkLocationPermission() async {
//       bool serviceEnabled;
//       LocationPermission permission;
//
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return false;
//       }
//
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return false;
//         }
//       }
//
//       return true;
//     }
//   //
//
//
//     Future<void> updateCurrentLocation() async {
//       try {
//         Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         setState(() {
//           currentPosition = position;
//         });
//
//         // Store the latitude and longitude values in Realtime Database
//         final databaseReference = FirebaseDatabase.instance.reference();
//         databaseReference.child('users').child('current_location').set({
//           'latitude': currentPosition!.latitude,
//           'longitude': currentPosition!.longitude,
//         });
//       } catch (e) {
//         print(e);
//       }
//     }
//   //
//     Future<int> calculateRemainingTime() async {
//       List<GeoPoint> locations = await getLocationsFromFirestore();
//       return await getRemainingTime(locations);
//     }
//
//     Future<void> fetchRemainingTime() async {
//       int time = await calculateRemainingTime();
//       setState(() {
//         remainingTime = time;
//       });
//     }
//
//
//     void _startListeningToPositionStream() {
//       Geolocator.getPositionStream().listen((Position position) {
//         setState(() {
//           currentPosition = position;
//         });
//       }, onError: (error) {
//         print('Error in geolocation stream: $error');
//       });
//     }
//   //
//     void _stopListeningToPositionStream() {
//       _positionStreamSubscription?.cancel();
//     }
//   //
//     void _startTimer() {
//       _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
//         if (mounted) { // Check if the widget is still mounted
//           int time = await calculateRemainingTime(); // Await the Future
//           setState(() {
//             remainingTime = time; // Assign the awaited value
//           });
//         }
//       });
//     }
//   //
//   //
//     void initData() async {
//       await getCurrentLocation();
//       if (mounted) { // Check if the widget is still mounted
//         print('Current position: ${currentPosition}');
//         if (await _checkLocationPermission()) {
//           // Enable MyLocation layer
//           print('Location permission granted');
//         } else {
//           // Show message asking user to grant location permissions
//           print('Location permission denied');
//         }
//       }
//     }
//
//
//     String calculateArrivalTime() {
//       // Your logic to calculate the arrival time
//       // This is just a placeholder example
//       DateTime now = DateTime.now();
//       DateTime arrival = now.add(Duration(minutes: 15)); // Assume bus arrives in 15 minutes
//       return '${arrival.hour}:${arrival.minute}';
//     }
//   //
//     bool checkIfArrived(Position position) {
//       // Your logic to check if the bus has arrived
//       // This is just a placeholder example
//       // Replace this with actual logic to check if the bus has arrived
//       return position.latitude == targetLatitude && position.longitude == targetLongitude;
//     }
//
//
//   BitmapDescriptor anotherCustomIcon = BitmapDescriptor.defaultMarker;
//
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     final ByteData data = await rootBundle.load(path);
//     final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     final FrameInfo frameInfo = await codec.getNextFrame();
//     final Uint8List resizedImage =
//     (await frameInfo.image.toByteData(format: ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//     return resizedImage;
//   }
//
//
//   Future<void> loadCustomIcon() async {
//     final Uint8List imageData2 =
//     await getBytesFromAsset("assets/images/yellow_bus_2.png", 90);
//     anotherCustomIcon = BitmapDescriptor.fromBytes(imageData2);
//
//     setState(() {});
//   }
//
//   TextDirection _getTextDirection(String text) {
//     // Determine the text direction based on text content
//     if (text.contains(RegExp(
//         r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF\uFE70-\uFEFF\uFB50-\uFDFF\u2000-\u206F\u202A-\u202E\u2070-\u209F\u20A0-\u20CF\u2100-\u214F\u2150-\u218F]'))) {
//       // RTL language detected
//       return TextDirection.rtl;
//     } else {
//       // LTR language detected
//       return TextDirection.ltr;
//     }
//   }
//
//
//   Future<void> getDataForBus() async {
//     setState(() {
//       dataLoading = true;
//     });
//
//     DocumentSnapshot supervisorDoc = await FirebaseFirestore.instance
//         .collection('supervisor')
//         .doc(sharedpref?.getString('id'))
//         .get();
//
//     if (supervisorDoc.exists) {
//       String busId = supervisorDoc['bus_id'];
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('busdata')
//           .where(FieldPath.documentId, isEqualTo: busId)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         var busData = querySnapshot.docs.first;
//         String namedriver = busData['namedriver'];
//         String photobus = busData['busphoto'];
//         String busnumber = busData['busnumber'];
//
//         setState(() {
//           _namedriver = namedriver;
//           _photobus = photobus;
//           _busnumber = busnumber;
//         });
//       }
//       else {
//         print('No bus data found');
//       }
//     }
//     else {
//       print('Supervisor document does not exist');
//     }
//
//     setState(() {
//       dataLoading = false;
//     });
//   }
//
//
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//   locationUpdateTimer?.cancel();
//   _stopListeningToPositionStream();
//   _timer.cancel();
//   super.dispose();
//   }
//
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
//       _fetchData();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     _fetchData();
//     getDataForBus();
//     loadCustomIcon();
//     fetchRemainingTime();
//     _startListeningToPositionStream();
//     estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
//     _startTimer();
//     initData();
//     locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//       updateCurrentLocation();
//     });
//
//     Geolocator.getPositionStream().listen((Position position) {
//       setState(() {
//         currentPosition = position;
//       });
//
//
//       // Update Realtime Database with the new position
//       final databaseReference = FirebaseDatabase.instance.ref();
//       databaseReference.child('users').child('current_location').set({
//         'latitude': currentPosition!.latitude,
//         'longitude': currentPosition!.longitude,
//       });
//     });
//   }
//
//   Future<void> _fetchData({String query = ""}) async {
//     if (_isLoading || !_hasMoreData) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     var query = _firestore.collection('parent').limit(_limit);
//     if (_lastDocument != null) {
//       query = query.startAfterDocument(_lastDocument!);
//     }
//
//     final QuerySnapshot snapshot = await query.get();
//     if (snapshot.docs.isEmpty) {
//       setState(() {
//         _hasMoreData = false;
//       });
//     } else {
//       List<Map<String, dynamic>> allChildren = [];
//       String supervisorId = sharedpref!.getString('id') ?? '';
//
//       for (var parentDoc in snapshot.docs) {
//         List<dynamic> children = parentDoc['children'];
//         List<Map<String, dynamic>> filteredChildren = children
//             .where((child) => child['supervisor'] == supervisorId)
//             .map((child) => child as Map<String, dynamic>)
//             .toList();
//         allChildren.addAll(filteredChildren);
//       }
//
//       setState(() {
//         _lastDocument = snapshot.docs.last;
//         _documents.addAll(snapshot.docs);
//         childrenData.addAll(allChildren);
//       });
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     LatLng startLocation = LatLng(currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0);
//
//     List<LatLng> polylineCoordinates = [startLocation];
//     Set<Marker> markers = {
//       Marker(
//         markerId: MarkerId('current_location'),
//         position: startLocation,
//         icon: anotherCustomIcon,
//       ),
//     };
//
//     for (var doc in data) {
//       var childData = doc.data() as Map<String, dynamic>;
//       var latString = childData['lat'];
//       var lngString = childData['lng'];
//
//       if (latString != null && lngString != null) {
//         try {
//           var lat = double.parse(latString.toString());
//           var lng = double.parse(lngString.toString());
//           var childLocation = LatLng(lat, lng);
//
//           markers.add(
//             Marker(
//               markerId: MarkerId(doc.id),
//               position: childLocation,
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//               // infoWindow: InfoWindow(
//               //   title: childData['name'],
//               // ),
//             ),
//           );
//
//           // Check if the bus has reached the child location (e.g., within 50 meters)
//           double distanceInMeters = Geolocator.distanceBetween(
//             currentPosition!.latitude,
//             currentPosition!.longitude,
//             lat,
//             lng,
//           );
//
//           if (distanceInMeters <= 50) {
//             polylineCoordinates.add(childLocation);
//           }
//
//         } catch (e) {
//           print('Invalid double: $e');
//         }
//       }
//     }
//
//     return Scaffold(
//         endDrawer: SupervisorDrawer(),
//         key: _scaffoldKey,
//         appBar: PreferredSize(
//           child: Container(
//             decoration: BoxDecoration(boxShadow: [
//               BoxShadow(
//                 color: Color(0x3F000000),
//                 blurRadius: 12,
//                 offset: Offset(-1, 4),
//                 spreadRadius: 0,
//               )
//             ]),
//             child: AppBar(
//               toolbarHeight: 70,
//               centerTitle: true,
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(16.49),
//                 ),
//               ),
//               elevation: 0.0,
//               leading: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Padding(
//                   padding: (sharedpref?.getString('lang') == 'ar')
//                       ? EdgeInsets.all(23.0)
//                       : EdgeInsets.all(17.0),
//                   child: Image.asset(
//                     (sharedpref?.getString('lang') == 'ar')
//                         ? 'assets/images/Layer 1.png'
//                         : 'assets/images/fi-rr-angle-left.png',
//                     width: 10,
//                     height: 22,
//                   ),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       _scaffoldKey.currentState!.openEndDrawer();
//                     },
//                     child: const Icon(
//                       Icons.menu_rounded,
//                       color: Color(0xff442B72),
//                       size: 35,
//                     ),
//                   ),
//                 ),
//               ],
//               title: Text(
//                 'Tracking Bus'.tr,
//                 style: const TextStyle(
//                   color: Color(0xFF993D9A),
//                   fontSize: 17,
//                   fontFamily: 'Poppins-Bold',
//                   fontWeight: FontWeight.w700,
//                   height: 1,
//                 ),
//               ),
//               backgroundColor: Color(0xffF8F8F8),
//               surfaceTintColor: Colors.transparent,
//             ),
//           ),
//           preferredSize: Size.fromHeight(70),
//         ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//                 height: 350,
//                 child: StreamBuilder<DatabaseEvent>(
//                   stream:FirebaseDatabase.instance
//                       .ref()
//                       .child('users')
//                       .child('current_location')
//                       .onValue,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       var data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                       var latitude = data['latitude'] ?? startLocation.latitude;
//                       var longitude = data['longitude'] ?? startLocation.longitude;
//                       var targetLocation = LatLng(latitude, longitude);
//
//                       return dataLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : GoogleMap(
//                         zoomControlsEnabled: false,
//                         scrollGesturesEnabled: true,
//                         gestureRecognizers: Set()
//                           ..add(Factory<EagerGestureRecognizer>(() =>
//                               EagerGestureRecognizer())),
//                         initialCameraPosition: CameraPosition(
//                           target: startLocation,
//                           zoom: 12,
//                         ),
//                         markers: markers,
//                         polylines: {
//                           Polyline(
//                             polylineId: PolylineId('route'),
//                             points: polylineCoordinates,
//                             color: Colors.red,
//                             width: 5,
//                           ),
//                         },
//                         onMapCreated: (GoogleMapController controller) {
//                           this.controller = controller;
//                         },
//                       );
//                     }
//                     //   GoogleMap(
//                     //   scrollGesturesEnabled: true,
//                     //   gestureRecognizers: Set()
//                     //     ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
//                     //   initialCameraPosition: CameraPosition(
//                     //     target: targetLocation,
//                     //     zoom: 12,
//                     //   ),
//                     //   markers: {
//                     //     Marker(
//                     //       markerId: MarkerId('current_location'),
//                     //       position: targetLocation,
//                     //       icon: anotherCustomIcon,
//                     //     ),
//                     //   },
//                     //   onMapCreated: (mapController) {
//                     //     setState(() {
//                     //       controller = mapController;
//                     //     });
//                     //   },
//                     // );
//                     else if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     } else {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                   },
//                 )),
//             const SizedBox(
//               height: 8,
//             ),
//             SizedBox(
//               height: 45,
//               child: Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Flexible(
//                     flex: 5,
//                     child: Theme(
//                       data: ThemeData(
//                         splashFactory: NoSplash.splashFactory,
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                       ),
//                       child: ListTile(
//                         onTap: () {
//                           tracking = true;
//                           setState(() {});
//                         },
//                         title: Column(
//                           children: [
//                             Text(
//                               'bus Tracking'.tr,
//                               style: TextStyle(
//                                   color: const Color(0xFF432B72),
//                                   fontSize: 16,
//                                   fontFamily: tracking
//                                       ? 'Poppins-SemiBold'
//                                       : 'Poppins-Light',
//                                   fontWeight: tracking
//                                       ? FontWeight.w600
//                                       : FontWeight.w400),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Container(
//                               height: 2,
//                               width: tracking ? 75 : 0,
//                               color: const Color(0xFFFFC53E),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     flex: 1,
//                     child: Container(
//                       // height: 32,
//                       width: 1,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Flexible(
//                     flex: 3,
//                     child: Theme(
//                       data: ThemeData(
//                         splashFactory: NoSplash.splashFactory,
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                       ),
//                       child: ListTile(
//                         onTap: () {
//                           tracking = false;
//                           setState(() {});
//                         },
//                         title: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 7.0),
//                               child: Text(
//                                 'Bus Info'.tr,
//                                 style: TextStyle(
//                                     color: const Color(0xFF432B72),
//                                     fontSize: 17,
//                                     fontFamily: tracking
//                                         ? 'Poppins-Light'
//                                         : 'Poppins-SemiBold',
//                                     fontWeight: tracking
//                                         ? FontWeight.w400
//                                         : FontWeight.w600),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 4,
//                             ),
//                             Container(
//                               height: 2,
//                               width: tracking ? 0 : 75,
//                               color: const Color(0xFFFFC53E),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 6,
//             ),
//             Container(
//               width: double.infinity,
//               height: 1,
//               color: const Color(0xFFD8D8D8),
//             ),
//             const SizedBox(
//               height: 25,
//             ),
//
//
//
//
//
//             tracking ?
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(child:
//                 ElevatedSimpleButton(txt: 'Start your journey',
//                     width: 278,
//                     hight: 48,
//                     onPress: (){
//                       fetchRemainingTime();
//                       _startListeningToPositionStream();
//                       estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
//                       _startTimer();
//                       initData();
//                       locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//                         updateCurrentLocation();
//                       });
//                       Geolocator.getPositionStream().listen((Position position) {
//                         setState(() {
//                           currentPosition = position;
//                         });
//
//
//                         // Update Realtime Database with the new position
//                         final databaseReference = FirebaseDatabase.instance.ref();
//                         databaseReference.child('users').child('current_location').set({
//                           'latitude': currentPosition!.latitude,
//                           'longitude': currentPosition!.longitude,
//                         });
//                       });
//                     },
//                     color: Color(0xff442B72),
//                     fontSize: 16)),
//                 SizedBox(height: 25,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                   child: Text.rich(
//                     TextSpan(children: [
//                       TextSpan(
//                         text: '$remainingTime', // Use the dynamic value here
//                         style: TextStyle(
//                           color: Color(0xFF993D9A),
//                           fontSize: 29.71,
//                           fontFamily: 'Poppins-Medium',
//                           fontWeight: FontWeight.w700,
//                           height: 1.23,
//                         ),
//                       ),
//                       TextSpan(
//                         text: ' Min.'.tr,
//                         style: TextStyle(
//                           color: Color(0xFF993D9A),
//                           fontSize: 29.71,
//                           fontFamily: 'Poppins-Medium',
//                           fontWeight: FontWeight.w700,
//                           height: 1.23,
//                         ),
//                       ),
//                     ]),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//                   child: Text(
//                     'To arrive'.tr,
//                     style: TextStyle(
//                       color: Color(0xFF442B72),
//                       fontSize: 24.12,
//                       fontFamily: 'Poppins-Light',
//                       fontWeight: FontWeight.w300,
//                       height: 1.23,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//
//               ],
//             )
//                 :
//             Expanded(
//               flex: 1,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(child:
//                     ElevatedSimpleButton(txt: 'Start your journey', width: 278, hight: 48, onPress: (){
//                       fetchRemainingTime();
//                       _startListeningToPositionStream();
//                       estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
//                       _startTimer();
//                       initData();
//                       locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//                         updateCurrentLocation();
//                       });
//                       Geolocator.getPositionStream().listen((Position position) {
//                         setState(() {
//                           currentPosition = position;
//                         });
//
//
//                         // Update Realtime Database with the new position
//                         final databaseReference = FirebaseDatabase.instance.ref();
//                         databaseReference.child('users').child('current_location').set({
//                           'latitude': currentPosition!.latitude,
//                           'longitude': currentPosition!.longitude,
//                         });
//                       });
//                     }, color: Color(0xff442B72), fontSize: 16)),
//                     SizedBox(height: 25,),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Bus Number'.tr,
//                                 style: TextStyle(
//                                   color: Color(0xFF432B72),
//                                   fontSize: 17,
//                                   fontFamily: 'Poppins-SemiBold',
//                                   fontWeight: FontWeight.w600,
//                                   height: 0.94,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               Text(
//                                 '$_busnumber',
//                                 textDirection:
//                                 _getTextDirection(" 1458ى ر س "),
//                                 style: TextStyle(
//                                   color: Color(0xFF919191),
//                                   fontSize: 17,
//                                   fontFamily: 'Roboto-Regular',
//                                   fontWeight: FontWeight.w400,
//                                   height: 0.89,
//                                 ),
//                                 overflow: TextOverflow.ellipsis, //,
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Driver Name'.tr,
//                                 style: TextStyle(
//                                   color: Color(0xFF432B72),
//                                   fontSize: 17,
//                                   fontFamily: 'Poppins-SemiBold',
//                                   fontWeight: FontWeight.w600,
//                                   height: 0.94,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               Text(
//                                 _namedriver,
//                                 style: TextStyle(
//                                   color: Color(0xFF919191),
//                                   fontSize: 18,
//                                   fontFamily: 'Poppins-Regular',
//                                   fontWeight: FontWeight.w500,
//                                   height: 0.89,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 22.0),
//                       child: Text(
//                         'Bus photos'.tr,
//                         style: TextStyle(
//                           color: Color(0xFF432B72),
//                           fontSize: 17,
//                           fontFamily: 'Poppins-SemiBold',
//                           fontWeight: FontWeight.w600,
//                           height: 0.94,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 22.0),
//                       child: Container(
//                           height: 170,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             children: <Widget>[
//                               InteractiveViewer(
//                                   child:(_photobus == null || _photobus == '') ?
//                                   Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                                   Image.network(_photobus!,width: 144,height: 154.42,fit: BoxFit.cover,)
//                               ),
//
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               // InteractiveViewer(
//                               //     child:(_photobus == null || _photobus == '') ?
//                               //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                               //     Image.network(_photobus!,width: 104,height: 111.53,)
//                               // ),
//                               // SizedBox(
//                               //   width: 10,
//                               // ),
//                               // InteractiveViewer(
//                               //     child:(_photobus == null || _photobus == '') ?
//                               //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                               //     Image.network(_photobus!,width: 104,height: 111.53,)
//                               // ),
//                               // SizedBox(
//                               //   width: 10,
//                               // ),
//                               // InteractiveViewer(
//                               //     child:(_photobus == null || _photobus == '') ?
//                               //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                               //     Image.network(_photobus!,width: 104,height: 111.53,)
//                               // ),
//                             ],
//                           )),
//                     ),
//                     // SizedBox(
//                     //   height: 44,
//                     // )
//                   ],
//                 ),
//               ),
//             ),
//             tracking?
//             Expanded(
//               child:
//                   Stack(
//                     children: [
//                       ListView.builder(
//                         controller: _scrollController,
//                         itemCount: childrenData.length + 1,
//                         itemBuilder: (context, index) {
//                           if (index == childrenData.length) {
//                             return _isLoading
//                                 ? Center(child: CircularProgressIndicator())
//                                 : Center(child: Container());
//                           }
//
//                           var child = childrenData[index];
//                           String name = child['name'] ?? 'No Name';
//                           bool isFirstOrLast = index == 0 || index == childrenData.length - 1;
//
//                           if (isFirstOrLast) {
//                             // name = 'welcome $name';
//                           }
//
//                           return Padding(
//                             padding: const EdgeInsets.only(left: 23.0),
//                             child: SizedBox(
//                               width: double.infinity,
//                               height: 70, // Adjust height as needed
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (isFirstOrLast)
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 15.0),
//                                       child: Text('- - -', style: TextStyle(
//                                         color: Color(0xffFFC53E),),),
//                                     )
//                                   else SizedBox(width: 18,),
//                                   CircleAvatar(
//                                     radius: 25,
//                                     backgroundColor: Color(0xff442B72),
//                                     child: CircleAvatar(
//                                       backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                       radius: 25,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         name,
//                                         style: TextStyle(
//                                           color: Color(0xFF442B72),
//                                           fontSize: 15,
//                                           fontFamily: 'Poppins-SemiBold',
//                                           fontWeight: FontWeight.w600,
//                                           height: 1.07,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 3,
//                                       ),
//                                       hasArrived
//                                           ? Text.rich(
//                                         TextSpan(
//                                           children: [
//                                             TextSpan(
//                                               text: 'arrived :'.tr,
//                                               style: TextStyle(
//                                                 color: Color(0xFF13DB63),
//                                                 fontSize: 13,
//                                                 fontFamily: 'Poppins-Regular',
//                                                 fontWeight: FontWeight.w400,
//                                                 height: 1.23,
//                                               ),
//                                             ),
//                                             TextSpan(
//                                               text: ' $arrivalTime '.tr,
//                                               style: TextStyle(
//                                                 color: Color(0xFF13DB63),
//                                                 fontSize: 13,
//                                                 fontFamily: 'Poppins-Regular',
//                                                 fontWeight: FontWeight.w400,
//                                                 height: 1.23,
//                                               ),
//                                             ),
//                                             TextSpan(
//                                               text: 'AM'.tr,
//                                               style: TextStyle(
//                                                 color: Color(0xFF13DB63),
//                                                 fontSize: 13,
//                                                 fontFamily: 'Poppins-Regular',
//                                                 fontWeight: FontWeight.w400,
//                                                 height: 1.23,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                           : Text(
//                                         'not yet'.tr,
//                                         style: TextStyle(
//                                           color: Colors.red,
//                                           fontSize: 13,
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w400,
//                                           height: 1.23,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       ( sharedpref?.getString('lang') == 'ar')
//                           ? Positioned(
//                         left: 299,
//                         top: 35,
//                         bottom: 85,
//                         child: buildDashedLine(),
//                       )
//                           : Positioned(
//                         top: 28,
//                         bottom: 105,
//                         child: buildDashedLine(),
//                       )
//                     ],
//                   ),
//                )
//                 :
//             Container()
//
//
//
//
//           ]),
//       ),
//
//         extendBody: true,
//         resizeToAvoidBottomInset: false,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100)),
//             backgroundColor: Color(0xff442B72),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProfileSupervisorScreen(
//                     // onTapMenu: onTapMenu
//                   )));
//             },
//             child: Image.asset(
//               'assets/images/174237 1.png',
//               height: 33,
//               width: 33,
//               fit: BoxFit.cover,
//             )),
//         bottomNavigationBar: Directionality(
//             textDirection: Get.locale == Locale('ar')
//                 ? TextDirection.rtl
//                 : TextDirection.ltr,
//             child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//                 child: BottomAppBar(
//                     padding: EdgeInsets.symmetric(vertical: 3),
//                     height: 60,
//                     color: const Color(0xFF442B72),
//                     clipBehavior: Clip.antiAlias,
//                     shape: const AutomaticNotchedShape(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(38.5),
//                                 topRight: Radius.circular(38.5))),
//                         RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(50)))),
//                     notchMargin: 7,
//                     child: SizedBox(
//                         height: 10,
//                         child: SingleChildScrollView(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               HomeForSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(top: 7, right: 15)
//                                       : EdgeInsets.only(left: 15),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (7).png',
//                                           height: 20,
//                                           width: 20),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Home".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AttendanceSupervisorScreen()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(top: 9, left: 50)
//                                       : EdgeInsets.only(right: 50, top: 2),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/icons8_checklist_1 1.png',
//                                           height: 19,
//                                           width: 19),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Attendance".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               NotificationsSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(
//                                       top: 12, bottom: 4, right: 10)
//                                       : EdgeInsets.only(
//                                       top: 8, bottom: 4, left: 20),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (2).png',
//                                           height: 17,
//                                           width: 16.2),
//                                       Image.asset(
//                                           'assets/images/Vector (5).png',
//                                           height: 4,
//                                           width: 6),
//                                       SizedBox(height: 2),
//                                       Text(
//                                         "Notifications".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: (sharedpref?.getString('lang') == 'ar')
//                                     ? EdgeInsets.only(
//                                     top: 10, bottom: 2, right: 10, left: 0)
//                                     : EdgeInsets.only(
//                                     top: 8, bottom: 2, left: 0, right: 10),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                         'assets/images/icons8_bus 1 (1).png',
//                                         height: 22,
//                                         width: 25),
//                                     SizedBox(height: 3),
//                                     Text(
//                                       "Buses".tr,
//                                       style: TextStyle(
//                                         fontFamily: 'Poppins-Regular',
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white,
//                                         fontSize: 8,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )))))
//     );
//   }
//
//   Widget buildDashedLine() {
//     // double lineLength = students.length * 40.0;
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: DottedLine(
//         lineLength: double.infinity,
//         // lineLength: lineLength,
//         direction: Axis.vertical,
//         dashColor: Color(0xffFFC53E),
//       ),
//     );
//   }
//
// }
//
//
//
//
//
//
//
// // attendance
// // class _PaginatedListState extends State<PaginatedList> {
// //
// //
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final ScrollController _scrollController = ScrollController();
// //   final TextEditingController _searchController = TextEditingController();
// //
// //   bool _isLoading = false;
// //   bool _hasMoreData = true;
// //   DocumentSnapshot? _lastDocument;
// //   int _limit = 7;
// //   String searchQuery = "";
// //
// //   List<DocumentSnapshot> _documents = [];
// //   List<Map<String, dynamic>> childrenData = [];
// //   List<bool> checkin = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController.addListener(_scrollListener);
// //     _searchController.addListener(_onSearchChanged);
// //     _fetchMoreData();
// //   }
// //
// //   Future<void> _fetchMoreData() async {
// //     if (_isLoading || !_hasMoreData) return;
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     print('Fetching data...');
// //     Query query = _firestore.collection('parent').limit(_limit);
// //     if (_lastDocument != null) {
// //       query = query.startAfterDocument(_lastDocument!);
// //       print('Starting after document: ${_lastDocument!.id}');
// //     }
// //
// //     try {
// //       QuerySnapshot querySnapshot = await query.get();
// //       print('Fetched ${querySnapshot.docs.length} documents');
// //       if (querySnapshot.docs.isNotEmpty) {
// //         _lastDocument = querySnapshot.docs.last;
// //         List<Map<String, dynamic>> allChildren = [];
// //         for (var parentDoc in querySnapshot.docs) {
// //           List<dynamic> children = parentDoc['children'];
// //           allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
// //         }
// //         setState(() {
// //           _documents.addAll(querySnapshot.docs);
// //           childrenData.addAll(allChildren);
// //           checkin = List.filled(_documents.length, false);
// //           print('Total documents: ${_documents.length}');
// //           if (querySnapshot.docs.length < _limit) {
// //             _hasMoreData = false;
// //             print('No more data to fetch');
// //           }
// //         });
// //       } else {
// //         setState(() {
// //           _hasMoreData = false;
// //           print('No more data to fetch');
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching data: $e');
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _fetchData({String query = ""}) async {
// //     if (_isLoading || !_hasMoreData) return;
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     Query query = _firestore.collection('parent').limit(_limit);
// //     if (_lastDocument != null) {
// //       query = query.startAfterDocument(_lastDocument!);
// //     }
// //
// //     final QuerySnapshot snapshot = await query.get();
// //     if (snapshot.docs.isEmpty) {
// //       setState(() {
// //         _hasMoreData = false;
// //       });
// //     } else {
// //
// //       // List<Map<String, dynamic>> filteredChildrenData = childrenData.where((child) {
// //       //   return child['name'].toLowerCase().contains(searchQuery.toLowerCase());
// //       // }).toList();
// //       List<Map<String, dynamic>> allChildren = [];
// //       for (var parentDoc in snapshot.docs) {
// //         List<dynamic> children = parentDoc['children'];
// //         allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
// //       }
// //
// //       setState(() {
// //         _lastDocument = snapshot.docs.last;
// //         _documents.addAll(snapshot.docs);
// //         childrenData.addAll(allChildren);
// //         checkin = List.filled(_documents.length, false);
// //
// //       });
// //     }
// //
// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }
// //
// //
// //   void _onSearchChanged() {
// //     setState(() {
// //       searchQuery = _searchController.text.trim();
// //       print('Search query changed: $searchQuery');
// //     });
// //     _fetchData(query: searchQuery);
// //   }
// //
// //   void _scrollListener() {
// //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
// //       _fetchMoreData();
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _searchController.removeListener(_onSearchChanged);
// //     _searchController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: GestureDetector(
// //         onTap: () {
// //           FocusScope.of(context).unfocus();
// //         },
// //         child: Column(
// //           children: [
// //             SizedBox(height: 400,),
// //             // Add your AppBar and other UI elements here
// //             Expanded(
// //               child: ListView.builder(
// //                 controller: _scrollController,
// //                 itemCount: _documents.length + 1,
// //                 itemBuilder: (context, index) {
// //                   if (index == _documents.length) {
// //                     return _isLoading
// //                         ? Center(child: CircularProgressIndicator())
// //                         : _hasMoreData
// //                         ? SizedBox.shrink()
// //                         : Center(child: Text('No more data'));
// //                   }
// //                   final DocumentSnapshot doc = _documents[index];
// //                   final data = doc.data() as Map<String, dynamic>;
// //                   var child = childrenData[index];
// //                   String supervisorPhoneNumber = _documents[index]['phoneNumber'] ?? '';
// //
// //                   return ListTile(
// //                     title: Text(child['name'] ?? 'No Name'),
// //                     subtitle: Text('Grade: ${child['grade']}'),
// //                     trailing: Row(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         IconButton(
// //                           icon: Icon(Icons.phone),
// //                           onPressed: () {
// //                             // makePhoneCall(supervisorPhoneNumber);
// //                           },
// //                         ),
// //                         IconButton(
// //                           icon: Icon(Icons.chat),
// //                           onPressed: () {
// //                             Navigator.of(context).push(
// //                               MaterialPageRoute(
// //                                 builder: (context) => ChatScreen(
// //                                   receiverName: child['name'],
// //                                   receiverPhone: child['phoneNumber'],
// //                                   receiverId: doc.id,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // done
//
//
//
//
//
//
//
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final int _limit = 5; // Number of documents to fetch per page
// //   DocumentSnapshot? _lastDocument;
// //   bool _isLoading = false;
// //   bool _hasMoreData = true;
// //   List<DocumentSnapshot> _documents = [];
// //   final ScrollController _scrollController = ScrollController();
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   TextEditingController _searchController = TextEditingController();
// //   String searchQuery = '';
// //   List<bool> checkin = [];
// //   bool isStarting = false;
// //
// //
// //
// //   List<Map<String, dynamic>> childrenData = [];
// //
// //
// //   void makePhoneCall(String phoneNumber) async {
// //     var mobileCall = 'tel:$phoneNumber';
// //     if (await canLaunchUrlString(mobileCall)) {
// //       await launchUrlString(mobileCall);
// //     } else {
// //       throw 'Could not launch $mobileCall';
// //     }
// //
// //   }
// //
// //
// //   String getJoinText(Timestamp? timestamp) {
// //     if (timestamp == null) {
// //       return 'Unknown date';
// //     }
// //
// //     DateTime dateTime = timestamp.toDate();
// //     Duration difference = DateTime.now().difference(dateTime);
// //
// //     if (difference.inDays > 1) {
// //       return 'Added ${difference.inDays} days ago';
// //     } else if (difference.inDays == 1) {
// //       return 'Added yesterday';
// //     } else if (difference.inHours >= 1) {
// //       return 'Added ${difference.inHours} hours ago';
// //     } else if (difference.inMinutes >= 1) {
// //       return 'Added ${difference.inMinutes} minutes ago';
// //     } else {
// //       return 'Added just now';
// //     }
// //   }
// //
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _searchController.addListener(_onSearchChanged);
// //     _scrollController.addListener(_scrollListener);
// //     _fetchData();
// //   }
// //
// //   Future<void> _fetchData({String query = ""}) async {
// //     if (_isLoading || !_hasMoreData) return;
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     Query query = _firestore.collection('parent').limit(_limit);
// //     if (_lastDocument != null) {
// //       query = query.startAfterDocument(_lastDocument!);
// //     }
// //
// //     final QuerySnapshot snapshot = await query.get();
// //     if (snapshot.docs.isEmpty) {
// //       setState(() {
// //         _hasMoreData = false;
// //       });
// //     } else {
// //
// //       // List<Map<String, dynamic>> filteredChildrenData = childrenData.where((child) {
// //       //   return child['name'].toLowerCase().contains(searchQuery.toLowerCase());
// //       // }).toList();
// //       List<Map<String, dynamic>> allChildren = [];
// //       for (var parentDoc in snapshot.docs) {
// //         List<dynamic> children = parentDoc['children'];
// //         allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
// //       }
// //
// //       setState(() {
// //         _lastDocument = snapshot.docs.last;
// //         _documents.addAll(snapshot.docs);
// //         childrenData.addAll(allChildren);
// //         checkin = List.filled(_documents.length, false);
// //
// //       });
// //     }
// //
// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }
// //
// //   // Future<void> _fetchData({String query = ""}) async {
// //   //   if (_isLoading || !_hasMoreData) return;
// //   //   setState(() {
// //   //     _isLoading = true;
// //   //   });
// //   //   Query query = _firestore.collection('parent').limit(_limit);
// //   //   if (_lastDocument != null) {
// //   //     query = query.startAfterDocument(_lastDocument!);
// //   //   }
// //   //   final QuerySnapshot snapshot = await query.get();
// //   //   if (snapshot.docs.isEmpty) {
// //   //     setState(() {
// //   //       _hasMoreData = false;
// //   //     });
// //   //   } else {
// //   //     setState(() {
// //   //       _lastDocument = snapshot.docs.last;
// //   //       _documents.addAll(snapshot.docs);
// //   //     });
// //   //   }
// //   //   setState(() {
// //   //     _isLoading = false;
// //   //   });
// //   // }
// //   void _onSearchChanged() {
// //     setState(() {
// //       searchQuery = _searchController.text.trim();
// //       print('Search query changed: $searchQuery');
// //     });
// //     _fetchData(query: searchQuery);
// //   }
// //
// //
// //   @override
// //   void dispose() {
// //     _searchController.removeListener(_onSearchChanged);
// //     _searchController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _scrollListener() {
// //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
// //       _fetchData();
// //     }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // appBar: AppBar(
// //       //   title: Text('Paginated List'),
// //       // ),
// //         body: GestureDetector(
// //           onTap: () {
// //             FocusScope.of(context).unfocus();
// //           },
// //           child: Column(
// //             children: [
// //               SizedBox(
// //                 height: 35,
// //               ),
// //               Container(
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     GestureDetector(
// //                       onTap: (){
// //                         Navigator.of(context).pop();
// //                       },
// //                       child:  Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: 17.0),
// //                         child: Image.asset(
// //                           (sharedpref?.getString('lang') == 'ar')?
// //                           'assets/images/Layer 1.png':
// //                           'assets/images/fi-rr-angle-left.png',
// //                           width: 20,
// //                           height: 22,),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.only(left: 0.0),//28
// //                       child: Text(
// //                         'Attendance'.tr,
// //                         style: TextStyle(
// //                           color: Color(0xFF993D9A),
// //                           fontSize: 16,
// //                           fontFamily: 'Poppins-Bold',
// //                           fontWeight: FontWeight.w700,
// //                           height: 1,
// //                         ),
// //                       ),
// //                     ),
// //                     IconButton(
// //                       onPressed: () {
// //                         _scaffoldKey.currentState!.openEndDrawer();
// //                       },
// //                       icon: Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 17.0),
// //                         child: const Icon(
// //                           Icons.menu_rounded,
// //                           color: Color(0xff442B72),
// //                           size: 35,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //
// //               Expanded(
// //                 flex: 0,
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       SizedBox(height: 20,),
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Padding(
// //                                   padding: const EdgeInsets.only(bottom: 20.0),
// //                                   child:
// //
// //                                   FutureBuilder(
// //                                     future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
// //                                     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
// //                                       if (snapshot.hasError) {
// //                                         return Text('Something went wrong');
// //                                       }
// //                                       if (snapshot.connectionState == ConnectionState.done) {
// //                                         if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['photo'] == null || snapshot.data!.data()!['photo'].toString().trim().isEmpty) {
// //                                           return CircleAvatar(
// //                                             radius: 30,
// //                                             backgroundColor: Color(0xff442B72),
// //                                             child: CircleAvatar(
// //                                               backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
// //                                               radius: 30,
// //                                             ),
// //                                           );
// //                                         }
// //
// //                                         Map<String, dynamic>? data = snapshot.data?.data();
// //                                         if (data != null && data['photo'] != null) {
// //                                           return CircleAvatar(
// //                                             radius: 30,
// //                                             backgroundColor: Color(0xff442B72),
// //                                             child: CircleAvatar(
// //                                               backgroundImage: NetworkImage('${data['photo']}'),
// //                                               radius:30,
// //                                             ),
// //                                           );
// //                                         }
// //                                       }
// //
// //                                       return Container();
// //                                     },
// //                                   ),
// //                                 ),
// //                                 SizedBox(width: 10,),
// //                                 FutureBuilder(
// //                                   future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
// //                                   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// //                                     if (snapshot.hasError) {
// //                                       return Text('Something went wrong');
// //                                     }
// //
// //                                     if (snapshot.connectionState == ConnectionState.done) {
// //                                       if (snapshot.data?.data() == null) {
// //                                         return Text(
// //                                           'No data available',
// //                                           style: TextStyle(
// //                                             color: Color(0xff442B72),
// //                                             fontSize: 12,
// //                                             fontFamily: 'Poppins-Regular',
// //                                             fontWeight: FontWeight.w400,
// //                                           ),
// //                                         );
// //                                       }
// //
// //                                       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
// //
// //                                       String schoolName = data['schoolname']?.toString() ?? 'no school';
// //                                       List<String> words = schoolName.split(' ');
// //
// //                                       return Text.rich(
// //                                         TextSpan(
// //                                           children: [
// //                                             for (String word in words) ...[
// //                                               TextSpan(
// //                                                 text: '$word\n',
// //                                                 style: TextStyle(
// //                                                   color: Color(0xFF993D9A),
// //                                                   fontSize: 20,
// //                                                   fontFamily: 'Poppins-Bold',
// //                                                   fontWeight: FontWeight.w700,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ],
// //                                         ),
// //                                       );
// //                                     }
// //
// //                                     return CircularProgressIndicator();
// //                                   },
// //                                 )
// //
// //
// //                                 // SizedBox(width: 25,),
// //                               ],
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.only(bottom: 25.0),
// //                               child: SizedBox(
// //                                 width: 119,
// //                                 height: 40,
// //                                 child: ElevatedButton(
// //                                   style: ElevatedButton.styleFrom(
// //                                       padding:  EdgeInsets.all(0),
// //                                       backgroundColor: Color(0xFF442B72),
// //                                       shape: RoundedRectangleBorder(
// //                                           borderRadius: BorderRadius.circular(5)
// //                                       )
// //                                   ),
// //                                   onPressed: () async {
// //                                     isStarting =! isStarting;
// //                                     setState(() {
// //                                     });
// //                                   },
// //                                   child: Text(
// //                                     // 'test2',
// //                                     isStarting? 'End Your trip'.tr:'Start your trip'.tr,
// //                                     style: TextStyle(
// //                                         fontFamily: 'Poppins-SemiBold',
// //                                         fontWeight: FontWeight.w600,
// //                                         color: Colors.white,
// //                                         fontSize: 13
// //                                     ),),
// //                                 ),
// //                               ),
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(height: 15,),
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 28.0),
// //                         child: Text('Attendances'.tr,
// //                           style: TextStyle(
// //                             color: Color(0xFF771F98),
// //                             fontSize: 19,
// //                             fontFamily: 'Poppins-Bold',
// //                             fontWeight: FontWeight.w700,
// //                           ),),
// //                       ),
// //                       SizedBox(height: 15,)
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //
// //               Expanded(
// //
// //                 child:
// //                 sharedpref!.getInt('invit') == 1 ?
// //
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
// //                   child: ListView.builder(
// //                     shrinkWrap: true,
// //                     // physics:  NeverScrollableScrollPhysics(),
// //                     controller: _scrollController,
// //                     itemCount: _documents.length + 1,
// //                     itemBuilder: (context, index) {
// //
// //                       if (index == _documents.length) {
// //                         return _isLoading
// //                             ? Center(child: CircularProgressIndicator())
// //                             : Center(child: Container()
// //                           // Text('No more data')
// //                         );
// //                       }
// //                       final DocumentSnapshot doc = _documents[index];
// //                       final data = doc.data() as Map<String, dynamic>;
// //                       var child = childrenData[index];
// //                       String supervisorPhoneNumber = _documents[index]['phoneNumber']?? 0;
// //
// //                       return Column(
// //                         children: [
// //                           // for (var child in children)
// //                             if (child['supervisor'] == sharedpref!.getString('id').toString())
// //                               SizedBox(
// //                                 width: double.infinity,
// //                                 height:122,
// //                                 child: Card(
// //                                   elevation: 10,
// //                                   color: Colors.white,
// //                                   surfaceTintColor: Colors.transparent,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(14.0),
// //                                   ),
// //                                   child: Padding(
// //                                       padding: (sharedpref?.getString('lang') == 'ar')?
// //                                       EdgeInsets.only(right: 10.0 , left: 10) :
// //                                       EdgeInsets.only(left: 14.0 , right: 14 , bottom: 0),
// //                                       child: Column(
// //                                         mainAxisAlignment: MainAxisAlignment.start,
// //                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                         children: [
// //                                           Row(
// //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Padding(
// //                                                 padding: const EdgeInsets.only(bottom: 20.0),
// //                                                 child: Row(
// //                                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                                   mainAxisAlignment: MainAxisAlignment.start,
// //                                                   children: [
// //                                                     FutureBuilder(
// //                                                       future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
// //                                                       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
// //                                                         if (snapshot.hasError) {
// //                                                           return Text('Something went wrong');
// //                                                         }
// //
// //                                                         if (snapshot.connectionState == ConnectionState.done) {
// //                                                           if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
// //                                                             return CircleAvatar(
// //                                                               radius: 25,
// //                                                               backgroundColor: Color(0xff442B72),
// //                                                               child: CircleAvatar(
// //                                                                 backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
// //                                                                 radius: 25,
// //                                                               ),
// //                                                             );
// //                                                           }
// //
// //                                                           Map<String, dynamic>? data = snapshot.data?.data();
// //                                                           if (data != null && data['busphoto'] != null) {
// //                                                             return CircleAvatar(
// //                                                               radius: 25,
// //                                                               backgroundColor: Color(0xff442B72),
// //                                                               child: CircleAvatar(
// //                                                                 backgroundImage: NetworkImage('${data['busphoto']}'),
// //                                                                 radius:25,
// //                                                               ),
// //                                                             );
// //                                                           }
// //                                                         }
// //
// //                                                         return Container();
// //                                                       },
// //                                                     ),
// //
// //                                                     const SizedBox(
// //                                                       width: 7,
// //                                                     ),
// //                                                     Padding(
// //                                                       padding: const EdgeInsets.only(top: 10.0),
// //                                                       child: Column(
// //                                                         mainAxisAlignment: MainAxisAlignment.start,
// //                                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                                         children: [
// //                                                           Text(
// //                                                             '${child['name']}',
// //                                                             style: TextStyle(
// //                                                               color: Color(0xff442B72),
// //                                                               fontSize: 17,
// //                                                               fontFamily: 'Poppins-SemiBold',
// //                                                               fontWeight: FontWeight.w600,
// //                                                               height: 0.94,
// //                                                             ),
// //                                                           ),
// //                                                           SizedBox(
// //                                                             height: 4,
// //                                                           ),
// //                                                           Text.rich(
// //                                                             TextSpan(
// //                                                               children: [
// //                                                                 TextSpan(
// //                                                                   text: 'Grade: '.tr,
// //                                                                   style: TextStyle(
// //                                                                     color: Color(0xFF919191),
// //                                                                     fontSize: 12,
// //                                                                     fontFamily: 'Poppins-Light',
// //                                                                     fontWeight: FontWeight.w400,
// //                                                                     // height: 1.33,
// //                                                                   ),
// //                                                                 ),
// //                                                                 TextSpan(
// //                                                                   text: '${child['grade']}',
// //                                                                   // '${data[index]['children']?[0]['grade'] }',
// //                                                                   style: TextStyle(
// //                                                                     color: Color(0xFF442B72),
// //                                                                     fontSize: 12,
// //                                                                     fontFamily: 'Poppins-Light',
// //                                                                     fontWeight: FontWeight.w400,
// //                                                                     // height: 1.33,
// //                                                                   ),
// //                                                                 ),
// //                                                               ],
// //                                                             ),
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                               Column(
// //                                                 children: [
// //                                                   SizedBox(height: 20),
// //                                                   Column(
// //                                                     children: [
// //                                                       SizedBox(
// //                                                         height: 40,
// //                                                         width: 80,
// //                                                         child: ElevatedButton(
// //                                                           style: ElevatedButton.styleFrom(
// //                                                               padding:  EdgeInsets.all(0),
// //                                                               backgroundColor: Color(0xFF442B72),
// //                                                               shape: RoundedRectangleBorder(
// //                                                                   borderRadius: BorderRadius.circular(5)
// //                                                               )
// //                                                           ),
// //                                                           onPressed: (){
// //                                                             // checkinStates[children.indexOf(child)] =!checkinStates[children.indexOf(child)];
// //
// //
// //                                                             setState(() {
// //                                                               checkin[index] = !checkin[index];
// //                                                             });
// //                                                           },
// //                                                           child: Text(
// //                                                             // 'test1',
// //                                                             checkin[index] ? 'Check out'.tr : 'Check in'.tr,
// //                                                             style: TextStyle(
// //                                                                 fontFamily: 'Poppins-SemiBold',
// //                                                                 fontWeight: FontWeight.w600,
// //                                                                 color: Colors.white,
// //                                                                 fontSize: 13
// //                                                             ),),
// //                                                         ),
// //                                                       ),
// //                                                       SizedBox(height: 15,),
// //                                                       Row(
// //                                                         mainAxisAlignment: MainAxisAlignment.start,
// //                                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                                         children: [
// //                                                           GestureDetector(
// //                                                             onTap:(){
// //                                                               makePhoneCall(supervisorPhoneNumber);
// //
// //                                                             },
// //                                                             child: Image.asset('assets/images/icons8_phone 1 (1).png' ,
// //                                                               color: Color(0xff442B72),
// //                                                               width: 28,
// //                                                               height: 28,),
// //                                                           ),
// //                                                           SizedBox(width: 9),
// //                                                           GestureDetector(
// //                                                             child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
// //                                                               color: Color(0xff442B72),
// //                                                               width: 26,
// //                                                               height: 26,),
// //                                                             onTap: () {
// //                                                               print('object');
// //                                                               Navigator.of(context).push(
// //                                                                   MaterialPageRoute(builder: (context) =>
// //                                                                       ChatScreen(
// //                                                                         receiverName: data[index]['name'],
// //                                                                         receiverPhone: data[index]['phoneNumber'],
// //                                                                         receiverId : data[index].id,
// //                                                                       )));
// //                                                             },
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ],
// //                                               )
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       )),
// //                                 ),
// //                               ),
// //                           SizedBox(height: 5,)
// //                         ],
// //                       );
// //                     },
// //                   ),
// //                 ) :
// //                 Column(
// //                   children: [
// //                     SizedBox(height: 50,),
// //                     Image.asset('assets/images/Group 237684.png',
// //                     ),
// //                     Text('No Data Found'.tr,
// //                       style: TextStyle(
// //                         color: Color(0xff442B72),
// //                         fontFamily: 'Poppins-Regular',
// //                         fontWeight: FontWeight.w500,
// //                         fontSize: 19,
// //                       ),
// //                     ),
// //                     Text('You haven’t added any \n '
// //                         'dates yet'.tr,
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                         color: Color(0xffBE7FBF),
// //                         fontFamily: 'Poppins-Light',
// //                         fontWeight: FontWeight.w400,
// //                         fontSize: 12,
// //                       ),)
// //                   ],
// //                 ),
// //
// //               ),
// //             ],
// //           ),
// //         ),
// //
// //         resizeToAvoidBottomInset: false,
// //         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// //         floatingActionButton: FloatingActionButton(
// //             shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(100)),
// //             backgroundColor: Color(0xff442B72),
// //             onPressed: () {
// //               Navigator.of(context).push(MaterialPageRoute(
// //                   builder: (context) => ProfileSupervisorScreen()));
// //             },
// //             child: Image.asset(
// //               'assets/images/174237 1.png',
// //               height: 33,
// //               width: 33,
// //               fit: BoxFit.cover,
// //             )),
// //         bottomNavigationBar: Directionality(
// //             textDirection: Get.locale == Locale('ar')
// //                 ? TextDirection.rtl
// //                 : TextDirection.ltr,
// //             child: ClipRRect(
// //                 borderRadius: const BorderRadius.only(
// //                   topLeft: Radius.circular(25),
// //                   topRight: Radius.circular(25),
// //                 ),
// //                 child: BottomAppBar(
// //                     padding: EdgeInsets.symmetric(vertical: 3),
// //                     height: 60,
// //                     color: const Color(0xFF442B72),
// //                     clipBehavior: Clip.antiAlias,
// //                     shape: const AutomaticNotchedShape(
// //                         RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.only(
// //                                 topLeft: Radius.circular(38.5),
// //                                 topRight: Radius.circular(38.5))),
// //                         RoundedRectangleBorder(
// //                             borderRadius:
// //                             BorderRadius.all(Radius.circular(50)))),
// //                     notchMargin: 7,
// //                     child: SizedBox(
// //                         height: 10,
// //                         child: SingleChildScrollView(
// //                           child: Row(
// //                             crossAxisAlignment: CrossAxisAlignment.center,
// //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                             children: [
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (context) =>
// //                                               HomeForSupervisor()),
// //                                     );
// //                                   });
// //                                 },
// //                                 child: Padding(
// //                                   padding:
// //                                   (sharedpref?.getString('lang') == 'ar')
// //                                       ? EdgeInsets.only(top: 7, right: 15)
// //                                       : EdgeInsets.only(left: 15),
// //                                   child: Column(
// //                                     children: [
// //                                       Image.asset(
// //                                           'assets/images/Vector (7).png',
// //                                           height: 20,
// //                                           width: 20),
// //                                       SizedBox(height: 3),
// //                                       Text(
// //                                         "Home".tr,
// //                                         style: TextStyle(
// //                                           fontFamily: 'Poppins-Regular',
// //                                           fontWeight: FontWeight.w500,
// //                                           color: Colors.white,
// //                                           fontSize: 8,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (context) =>
// //                                               AttendanceSupervisorScreen()),
// //                                     );
// //                                   });
// //                                 },
// //                                 child: Padding(
// //                                   padding:
// //                                   (sharedpref?.getString('lang') == 'ar')
// //                                       ? EdgeInsets.only(top: 9, left: 50)
// //                                       : EdgeInsets.only(right: 50, top: 2),
// //                                   child: Column(
// //                                     children: [
// //                                       Image.asset(
// //                                           'assets/images/icons8_checklist_1 1.png',
// //                                           height: 19,
// //                                           width: 19),
// //                                       SizedBox(height: 3),
// //                                       Text(
// //                                         "Attendance".tr,
// //                                         style: TextStyle(
// //                                           fontFamily: 'Poppins-Regular',
// //                                           fontWeight: FontWeight.w500,
// //                                           color: Colors.white,
// //                                           fontSize: 8,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (context) =>
// //                                               NotificationsParent()),
// //                                     );
// //                                   });
// //                                 },
// //                                 child: Padding(
// //                                   padding:
// //                                   (sharedpref?.getString('lang') == 'ar')
// //                                       ? EdgeInsets.only(
// //                                       top: 12, bottom: 4, right: 10)
// //                                       : EdgeInsets.only(
// //                                       top: 8, bottom: 4, left: 20),
// //                                   child: Column(
// //                                     children: [
// //                                       Image.asset(
// //                                           'assets/images/Vector (2).png',
// //                                           height: 17,
// //                                           width: 16.2),
// //                                       Image.asset(
// //                                           'assets/images/Vector (5).png',
// //                                           height: 4,
// //                                           width: 6),
// //                                       SizedBox(height: 2),
// //                                       Text(
// //                                         "Notifications".tr,
// //                                         style: TextStyle(
// //                                           fontFamily: 'Poppins-Regular',
// //                                           fontWeight: FontWeight.w500,
// //                                           color: Colors.white,
// //                                           fontSize: 8,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                               GestureDetector(
// //                                 onTap: () {
// //                                   setState(() {
// //                                     Navigator.push(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (context) => TrackParent()),
// //                                     );
// //                                   });
// //                                 },
// //                                 child: Padding(
// //                                   padding:
// //                                   (sharedpref?.getString('lang') == 'ar')
// //                                       ? EdgeInsets.only(
// //                                       top: 10,
// //                                       bottom: 2,
// //                                       right: 10,
// //                                       left: 0)
// //                                       : EdgeInsets.only(
// //                                       top: 8,
// //                                       bottom: 2,
// //                                       left: 0,
// //                                       right: 10),
// //                                   child: Column(
// //                                     children: [
// //                                       Image.asset(
// //                                           'assets/images/Vector (4).png',
// //                                           height: 18.36,
// //                                           width: 23.5),
// //                                       SizedBox(height: 3),
// //                                       Text(
// //                                         "Buses".tr,
// //                                         style: TextStyle(
// //                                           fontFamily: 'Poppins-Regular',
// //                                           fontWeight: FontWeight.w500,
// //                                           color: Colors.white,
// //                                           fontSize: 8,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         )))))
// //     );
// //   }
// // }
// //
// //

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  int _limit = 10;
  List<DocumentSnapshot> _documents = [];
  List<Map<String, dynamic>> childrenData = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
    _fetchMoreData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreData();
    }
  }

  void _onSearchChanged() {
    // Handle search logic
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    print('Fetching data...');
    String? supervisorId = sharedpref!.getString('id').toString(); // Replace with actual supervisor ID retrieval logic
    if (supervisorId == null) {
      print('Supervisor ID is null');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Query query = _firestore.collection('parent')
        .where('supervisor', isEqualTo: supervisorId)
        .where('state', isEqualTo: 1)
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
      print('Starting after document: ${_lastDocument!.id}');
    }

    try {
      QuerySnapshot querySnapshot = await query.get();
      print('Fetched ${querySnapshot.docs.length} documents');
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        List<Map<String, dynamic>> allChildren = [];
        for (var parentDoc in querySnapshot.docs) {
          List<dynamic> children = parentDoc['children'];
          allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
        }
        setState(() {
          _documents.addAll(querySnapshot.docs);
          childrenData.addAll(allChildren);
          print('Total documents: ${_documents.length}');
          print('Total children: ${childrenData.length}');
          if (querySnapshot.docs.length < _limit) {
            _hasMoreData = false;
            print('No more data to fetch');
          }
        });
      } else {
        setState(() {
          _hasMoreData = false;
          print('No more data to fetch');
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: childrenData.length + 1,
          itemBuilder: (context, index) {
            if (index == childrenData.length) {
              return _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : !_hasMoreData
                  ? Center(child: Text('No more data'))
                  : SizedBox.shrink();
            }
        
            final childData = childrenData[index];
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xff442B72),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/Group 237679 (2).png'),
                          radius: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          childData['name'] ?? '',
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 17,
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w600,
                            height: 1.07,
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: Text(
                            'Added from ${getJoinText(childData['joinDate'] ?? DateTime.now())}',
                            style: TextStyle(
                              color: Color(0xFF0E8113).withOpacity(0.7),
                              fontSize: 13,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.w400,
                              height: 1.23,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),
              ],
            );
          },
        ),
      ),
    );
  }

  String getJoinText(DateTime dateTime) {
    // Return formatted date string
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

// addparent
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttercontactpicker/fluttercontactpicker.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:school_account/Functions/functions.dart';
// import 'package:school_account/supervisor_parent/components/dialogs.dart';
// import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
// import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
// import 'package:school_account/supervisor_parent/screens/add_parents.dart';
//
// import '../../main.dart';
//
//
// class CardPage extends StatefulWidget {
//   @override
//   _CardPageState createState() => _CardPageState();
// }
// class _CardPageState extends State<CardPage> {
//   int numberOfCards = 0;
//   bool showCards = true;
//   bool isFirstImage = true;
//   bool typeOfParentError = false;
//   List<TextEditingController> nameChildControllers = [];
//   List<TextEditingController> gradeControllers = [];
//   List<String> genderSelection = [];
//   final _firestore = FirebaseFirestore.instance;
//   String enteredPhoneNumber = '';
//   bool _isLoading = false;
//   bool phoneAdded = false;
//   bool phoneError = false;
//   final _phoneNumberController = TextEditingController();
//   final _numberOfChildrenController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String kPickerNumber='';
//   String kPickerName='';
//   PhoneContact? _phoneContact;
//   final _nameController = TextEditingController();
//   bool nameError = false;
//   // bool typeOfParentError = true;
//   bool showList = false;
//   String selectedValue = '';
//   bool numberOfChildrenError = false;
//   bool childNameError = false;
//   bool childGradeError = false;
//   List<bool> childNameErrors = [];
//   List<bool> childGradeErrors = [];
//   bool _phoneNumberEntered = true;
//
//
//   void _addDataToFirestore() async {
//     int numberOfChildren = numberOfCards;
//     String busID = '';
//     String SchoolID = '';
//     // Assuming sharedpref is already defined somewhere
//     DocumentSnapshot documentSnapshot = await _firestore
//         .collection('supervisor')
//         .doc(sharedpref!.getString('id'))
//         .get();
//
//     if (documentSnapshot.exists) {
//       SchoolID = documentSnapshot.get('schoolid');
//       busID = documentSnapshot.get('bus_id');
//     }
//
//     Timestamp currentTimestamp = Timestamp.now();
//     for (int i = 0; i < numberOfCards; i++) {
//       if (nameChildControllers[i].text.isEmpty) {
//         setState(() {
//           childNameErrors[i] = true;
//         });
//       }else {
//         setState(() {
//           childNameErrors[i] = false;
//         });
//       }
//       if (gradeControllers[i].text.isEmpty) {
//         setState(() {
//           childGradeErrors[i] = true;
//         });
//       }else {
//         setState(() {
//           childGradeErrors[i] = false;
//         });
//       }
//     }
//
//     if (_nameController.text.isEmpty) {
//       setState(() {
//         nameError = true;
//       });
//     }else {
//       setState(() {
//         nameError = false;
//       });
//     }
//
//     if (selectedValue.isEmpty) {
//       setState(() {
//         typeOfParentError = true;
//       });
//     }else {
//       setState(() {
//         typeOfParentError = false;
//       });
//     }
//
//     if (_phoneNumberController.text.isEmpty) {
//       setState(() {
//         phoneError = true;
//       });
//     }else {
//       setState(() {
//         phoneError = false;
//       });
//     }
//
//     if (numberOfCards == 0 || numberOfCards == null) {
//       setState(() {
//         numberOfChildrenError = true;
//       });
//     }else {
//       setState(() {
//         numberOfChildrenError = false;
//       });
//     }
//
//     if (childNameError || childGradeError || numberOfChildrenError || nameError || phoneError || typeOfParentError) {
//       return;
//     }
//
//     List<Map<String, dynamic>> childrenData = List.generate(
//       numberOfChildren,
//           (index) => {
//         'name': nameChildControllers[index].text,
//         'grade': gradeControllers[index].text,
//         'gender': genderSelection[index],
//         'supervisor': sharedpref!.getString('id'),
//         'supervisor_name': sharedpref!.getString('name'),
//         'bus_id': busID,
//         'schoolid': SchoolID,
//         'joinDateChild': currentTimestamp,
//       },
//     );
//
//     Map<String, dynamic> data = {
//       'name': _nameController.text,
//       'typeOfParent': selectedValue,
//       'phoneNumber': enteredPhoneNumber,
//       'numberOfChildren': _numberOfChildrenController.text,
//       'schoolid': SchoolID,
//       'address': '',
//       'children': childrenData,
//       'state': 0,
//       'invite': 0,
//       'supervisor': sharedpref!.getString('id'),
//       'supervisor_name': sharedpref!.getString('name'),
//       'joinDate': FieldValue.serverTimestamp(),
//     };
//
//     try {
//       print('Checking parent existence...');
//       var check = await addParentCheck(enteredPhoneNumber);
//       if (!check) {
//         print('Parent does not exist. Checking for update...');
//         var res = await checkUpdate(enteredPhoneNumber);
//         if (!res) {
//           print('Adding new parent to Firestore...');
//           await _firestore.collection('parent').add(data).then((docRef) async {
//             print('Data added with document ID: ${docRef.id}');
//             String docid = docRef.id;
//             // setState(() {
//             //   _isLoading = false;
//             // });
//             var res = await createDynamicLink(false, docid, enteredPhoneNumber, 'parent');
//
//             if (res == "success") {
//               InvitationSendSnackBar(context, 'Invitation sent successfully', Color(0xFF4CAF50));
//
//               await _firestore.collection('notification').add({
//                 'item': 'You have Invitation',
//                 'timestamp': FieldValue.serverTimestamp(),
//                 'parentId': docid,
//                 'phoneNumber': enteredPhoneNumber,
//               });
//
//               await _firestore.collection('parent').doc(docid).update({'invite': 1});
//
//               setState(() {
//                 // count = 0;
//                 // showList = false;
//                 _isLoading = false;
//                 showCards = false;
//                 nameChildControllers.clear();
//                 gradeControllers.clear();
//                 _phoneNumberController.clear();
//                 _nameController.clear();
//                 selectedValue = '';
//                 _numberOfChildrenController.clear();
//                 _phoneNumberController.clear();
//
//               });
//             } else {
//               InvitationNotSendSnackBar(context, 'Invitation doesn\'t sent', Color(0xFFFF3C3C));
//             }
//           }).catchError((error) {
//             print('Failed to add data: $error');
//           });
//         } else {
//           if (childNum == 0) {
//             await _firestore.collection('parent').doc(docID).update(data);
//           } else {
//             await _firestore.collection('parent').doc(docID).update({
//               'children': FieldValue.arrayUnion(childrenData),
//               'numberOfChildren': childNum + numberOfChildren,
//               'supervisor': sharedpref!.getString('id'),
//               'supervisor_name': sharedpref!.getString('name'),
//               'joinDate': FieldValue.serverTimestamp(),
//               'bus_id': busID,
//               'schoolid': SchoolID
//             });
//           }
//           if (invitCheck == 0) {
//             var res = await createDynamicLink(false, docID, enteredPhoneNumber, 'parent');
//             if (res == "success") {
//               InvitationSendSnackBar(context, 'Invitation sent successfully', Color(0xFF4CAF50));
//               await _firestore.collection('notification').add({
//                 'item': 'You have Invitation',
//                 'timestamp': FieldValue.serverTimestamp(),
//                 'parentId': docID,
//                 'phoneNumber': _phoneNumberController.text,
//               });
//               await _firestore.collection('parent').doc(docID).update({'invite': 1});
//               setState(() {
//                 _isLoading = false;
//                 showCards = false;
//                 nameChildControllers.clear();
//                 gradeControllers.clear();
//                 _phoneNumberController.clear();
//                 _nameController.clear();
//                 selectedValue = '';
//                 _numberOfChildrenController.clear();
//               //  count = 0;
//               });
//             }
//           } else {
//             Dialoge.CantAddNewParent(context);
//           }
//         }
//       } else {
//         phoneAdded = false;
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//   void toggleCardsVisibility() {
//     setState(() {
//       showCards = !showCards;
//     });
//   }
//   void toggleImage() {
//     setState(() {
//       isFirstImage = !isFirstImage;
//     });
//   }
//   void updateControllers(int newCount) {
//     if (newCount > nameChildControllers.length) {
//       for (int i = nameChildControllers.length; i < newCount; i++) {
//         nameChildControllers.add(TextEditingController());
//         gradeControllers.add(TextEditingController());
//         genderSelection.add('');
//         childNameErrors.add(false); // Add this line
//         childGradeErrors.add(false); // Add this line
//       }
//     } else {
//       nameChildControllers = nameChildControllers.sublist(0, newCount);
//       gradeControllers = gradeControllers.sublist(0, newCount);
//       genderSelection = genderSelection.sublist(0, newCount);
//       childNameErrors = childNameErrors.sublist(0, newCount); // Add this line
//       childGradeErrors = childGradeErrors.sublist(0, newCount); // Add this line
//     }
//   }
//   // void updateControllers(int newCount) {
//   //   if (newCount > nameChildControllers.length) {
//   //     for (int i = nameChildControllers.length; i < newCount; i++) {
//   //       nameChildControllers.add(TextEditingController());
//   //       gradeControllers.add(TextEditingController());
//   //       genderSelection.add('');
//   //     }
//   //   } else {
//   //     nameChildControllers = nameChildControllers.sublist(0, newCount);
//   //     gradeControllers = gradeControllers.sublist(0, newCount);
//   //     genderSelection = genderSelection.sublist(0, newCount);
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       endDrawer: SupervisorDrawer(),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 35,
//             ),
//             Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 17.0),
//                       child: Image.asset(
//                         (sharedpref?.getString('lang') == 'ar')
//                             ? 'assets/images/Layer 1.png'
//                             : 'assets/images/fi-rr-angle-left.png',
//                         width: 20,
//                         height: 22,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: (sharedpref?.getString('lang') == 'ar')
//                         ? EdgeInsets.only(right: 40)
//                         : EdgeInsets.only(left: 40),
//                     child: Text(
//                       'Parents'.tr,
//                       style: TextStyle(
//                         color: Color(0xFF993D9A),
//                         fontSize: 16,
//                         fontFamily: 'Poppins-Bold',
//                         fontWeight: FontWeight.w700,
//                         height: 1,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () async{
//                             bool permission = await FlutterContactPicker.requestPermission();
//                             if(permission){
//                               if(await FlutterContactPicker.hasPermission()){
//                                 _phoneContact=await FlutterContactPicker.pickPhoneContact();
//                                 if(_phoneContact!=null){
//                                   if(_phoneContact!.fullName!.isNotEmpty){
//                                     setState(() {
//                                       kPickerName=_phoneContact!.fullName.toString();
//                                       _nameController.text=kPickerName;
//                                     });
//                                   }
//                                   if (_phoneContact!.phoneNumber != null &&
//                                       _phoneContact!.phoneNumber!.number != null &&
//                                       _phoneContact!.phoneNumber!.number!.isNotEmpty) {
//                                     setState(() {
//                                       kPickerNumber = _phoneContact!.phoneNumber!.number!; // Extract only the phone number
//                                       if (kPickerNumber.startsWith('0')) {
//                                         kPickerNumber = kPickerNumber.substring(1);
//
//                                       }
//                                       kPickerNumber = kPickerNumber.replaceAll(' ', '');
//                                       _phoneNumberController.text = kPickerNumber;
//                                     });
//                                   }
//                                   // if(_phoneContact!.phoneNumber!.number!.isNotEmpty){
//                                   //   setState(() {
//                                   //     kPickerNumber=_phoneContact!.phoneNumber.toString();
//                                   //     _phoneNumberController.text=kPickerNumber;
//                                   //   });
//                                   // }
//                                 }
//
//                               }
//                             }
//                           },
//                           child: Image(image: AssetImage("assets/imgs/school/icons8_Add_Male_User_Group 1.png"),width: 27,height: 27,
//                             color: Color(0xff442B72),),
//                         ),
//                         // Image.asset(
//                         //   'assets/images/icons8_Add_Male_User_Group 1.png',
//                         //   width: 27,
//                         //   height: 27,
//                         // ),
//                         IconButton(
//                           onPressed: () {
//                             _scaffoldKey.currentState!.openEndDrawer();
//                           },
//                           icon: const Icon(
//                             Icons.menu_rounded,
//                             color: Color(0xff442B72),
//                             size: 35,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 25.0)
//                           : EdgeInsets.only(left: 25.0),
//                       child: Text(
//                         'Parent'.tr,
//                         style: TextStyle(
//                           fontSize: 19,
//                           // height:  0.94,
//                           fontFamily: 'Poppins-Bold',
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xff771F98),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 42.0)
//                           : EdgeInsets.only(left: 42.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Parent'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 42),
//                       child: Stack(
//                         children: [
//                           Container(
//                             // width: 300,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               color: Color(0xFFF1F1F1),
//                               border: Border.all(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       showList = !showList;
//                                     });
//                                   },
//                                   child: Container(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 17.0),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             showList = !showList;
//                                           });
//                                         },
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   showList = !showList;
//                                                 });
//                                               },
//                                               child: Padding(padding: const EdgeInsets.only(right: 0.0),
//                                                 child: Text(
//                                                   selectedValue!.isNotEmpty
//                                                       ? selectedValue
//                                                       : 'Choose your type',
//                                                   style: TextStyle(
//                                                     color: Color(0xFF9E9E9E),
//                                                     fontSize: 12,
//                                                     fontFamily: 'Poppins-Bold',
//                                                     fontWeight: FontWeight.w700,
//                                                     height: 1.33,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: selectedValue!.isNotEmpty
//                                                   ? 160
//                                                   : 90,
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   showList =
//                                                   !showList; // Toggle the visibility of the list
//                                                 });
//                                               },
//                                               child: Container(
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(top: 14.0 , bottom: 14, left: 30,
//                                                       right:0),
//                                                   child: Image.asset(
//                                                     'assets/images/Vectorbottom (12).png',
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (showList)
//                             Container(
//                               height: 140,
//                               child: Card(
//                                 surfaceTintColor: Colors.transparent,
//                                 color: Colors.white,
//                                 child: ListView(
//                                   shrinkWrap: true,
//                                   children: [
//                                     ListTile(
//                                       title: Text(
//                                         'Father',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           color: Color(0xFF9E9E9E),
//                                           fontSize: 12,
//                                           fontFamily: 'Poppins-Bold',
//                                           fontWeight: FontWeight.w700,
//                                           height: 1.33,
//                                         ),
//                                       ),
//                                       onTap: () {
//                                         setState(() {
//                                           selectedValue = 'Father';
//                                           showList = false;
//                                         });
//                                       },
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.zero,
//                                       child: ListTile(
//                                         title: Text(
//                                           'Mother',
//                                           textAlign: TextAlign.start,
//                                           style: TextStyle(
//                                             color: Color(0xFF9E9E9E),
//                                             fontSize: 12,
//                                             fontFamily: 'Poppins-Bold',
//                                             fontWeight: FontWeight.w700,
//                                             height: 1.33,
//                                           ),
//                                         ),
//                                         onTap: () {
//                                           setState(() {
//                                             selectedValue = 'Mother';
//                                             showList = false;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     typeOfParentError
//                         ? Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 48),
//                       child: Text(
//                         "Please enter your type".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ): Container(),
//                     SizedBox(
//                       height: 11,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 42.0)
//                           : EdgeInsets.only(left: 42.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Name'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 42.0),
//                       child: SizedBox(
//                         // width: 277,
//                         height: 40,
//                         child: TextFormField(
//                             controller: _nameController,
//
//                             // cursorRadius: Radius.circular(300),
//                             style: TextStyle(
//                               color: Color(0xFF442B72),
//                             ),
//                             cursorColor: const Color(0xFF442B72),
//                             textDirection: (sharedpref?.getString('lang') == 'ar')
//                                 ? TextDirection.rtl
//                                 : TextDirection.ltr,
//                             // selectionHeightStyle: 20,
//                             autofocus: true,
//                             textInputAction: TextInputAction.next,
//                             keyboardType: TextInputType.text,
//                             textAlign: (sharedpref?.getString('lang') == 'ar')
//                                 ? TextAlign.right
//                                 : TextAlign.left,
//                             scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                             decoration: InputDecoration(
//                               alignLabelWithHint: false,
//                               counterText: "",
//                               fillColor: const Color(0xFFF1F1F1),
//                               filled: true,
//                               contentPadding:
//                               (sharedpref?.getString('lang') == 'ar')
//                                   ? EdgeInsets.fromLTRB(166, 0, 17, 10)
//                                   : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                               hintText: 'Please enter your name'.tr,
//                               floatingLabelBehavior: FloatingLabelBehavior.never,
//                               hintStyle: const TextStyle(
//                                 color: Color(0xFF9E9E9E),
//                                 fontSize: 12,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.33,
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(7)),
//                                   borderSide: BorderSide(
//                                     color: Color(0xFFFFC53E),
//                                     width: 0.5,
//                                   )),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(7)),
//                                 borderSide: BorderSide(
//                                   color: Color(0xFFFFC53E),
//                                   width: 0.5,
//                                 ),
//                               ),
//
//                               // enabledBorder: myInputBorder(),
//                               // focusedBorder: myFocusBorder(),
//                             )),
//                       ),
//                     ),
//                     nameError
//                         ?Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 48),
//                       child: Text(
//                         "Please enter your name".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ):
//                         Container(),
//                     SizedBox(
//                       height: 17,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 42.0)
//                           : EdgeInsets.only(left: 42.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Phone Number'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 42.0),
//                       child: SizedBox(
//                         // width: 277,
//                         height: 65,
//                         child: IntlPhoneField(
//
//                           textInputAction: TextInputAction.next,
//                           // Move to the next field when "Done" is pressed
//                           cursorColor: Color(0xFF442B72),
//                           controller: _phoneNumberController,
//                           dropdownIconPosition: IconPosition.trailing,
//                           invalidNumberMessage: " ",
//                           style: TextStyle(color: Color(0xFF442B72), height: 1.5),
//                           dropdownIcon: Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Color(0xff442B72),
//                           ),
//                           decoration: InputDecoration(
//                             fillColor: Color(0xffF1F1F1),
//                             filled: true,
//                             hintText: 'Phone Number'.tr,
//                             hintStyle: TextStyle(
//                                 color: Color(0xFFC2C2C2),
//                                 fontSize: 12,
//                                 fontFamily: "Poppins-Bold"),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: !_phoneNumberEntered
//                                     ? Colors
//                                     .red // Red border if phone number not entered
//                                     : Color(0xFFFFC53E),
//                               ),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(color: Colors.red, width: 2),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(7)),
//                                 borderSide:
//                                 BorderSide(color: Colors.red, width: 2)),
//                             focusedBorder: OutlineInputBorder(
//                               // Set border color when the text field is focused
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12.0, horizontal: 16.0),
//                           ),
//
//                           initialCountryCode: 'EG',
//                           // Set initial country code if needed
//                           onChanged: (phone) {
//                             enteredPhoneNumber = phone.completeNumber;
//                             // Update the enteredPhoneNumber variable with the entered phone number
//                           },
//                         ),
//                       ),
//                     ),
//                     phoneAdded
//                         ?  Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 48,
//                       ),
//                       child: Text(
//                         "This phone number is already added".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ): Container(),
//                     phoneError
//                         ?  Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 48,
//                       ),
//                       child: Text(
//                         "Please enter your phone number".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ): Container(),
//                     SizedBox(
//                       height: 17,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 42.0)
//                           : EdgeInsets.only(left: 42.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Number of children'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 42.0),
//                       child: SizedBox(
//                         // width: 277,
//                         height: 40,
//                         child: TextFormField(
//                           onChanged: (value) {
//                                               setState(() {
//                                                 numberOfCards = int.tryParse(value) ?? 0;
//                                                 updateControllers(numberOfCards);
//                                               });
//                                             },
//                           controller: _numberOfChildrenController,
//                           style: TextStyle(
//                             color: Color(0xFF442B72),
//                           ),
//                           cursorColor: Color(0xFF442B72),
//                           textDirection: (sharedpref?.getString('lang') == 'ar')
//                               ? TextDirection.rtl
//                               : TextDirection.ltr,
//                           // autofocus: true,
//                           textInputAction: TextInputAction.done,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.digitsOnly
//                           ],
//                           textAlign: (sharedpref?.getString('lang') == 'ar')
//                               ? TextAlign.right
//                               : TextAlign.left,
//                           scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                           decoration: InputDecoration(
//                             alignLabelWithHint: true,
//                             counterText: "",
//                             fillColor: const Color(0xFFF1F1F1),
//                             filled: true,
//                             contentPadding:
//                             (sharedpref?.getString('lang') == 'ar')
//                                 ? EdgeInsets.fromLTRB(166, 0, 17, 10)
//                                 : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                             hintText: 'Please enter your number children'.tr,
//                             floatingLabelBehavior: FloatingLabelBehavior.never,
//                             hintStyle: const TextStyle(
//                               color: Color(0xFF9E9E9E),
//                               fontSize: 12,
//                               fontFamily: 'Poppins-Bold',
//                               fontWeight: FontWeight.w700,
//                               height: 1.33,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             // enabledBorder: myInputBorder(),
//                             // focusedBorder: myFocusBorder(),
//                           ),
//                           maxLength: 1,
//                         ),
//                       ),
//                     ),
//                     numberOfChildrenError
//                         ? Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 48),
//                       child: Text(
//                         "Please enter your number of children".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ):Container(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 25.0, left: 30)
//                           : EdgeInsets.only(left: 25.0, right: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Children'.tr,
//                             style: TextStyle(
//                               fontSize: 19,
//                               // height:  0.94,
//                               fontFamily: 'Poppins-Bold',
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xff771F98),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               toggleCardsVisibility();
//                               toggleImage();
//                             },
//                             child: Image.asset(
//                               isFirstImage
//                                   ? 'assets/images/iconamoon_arrow-up-2-thin (1).png'
//                                   : 'assets/images/iconamoon_arrow-up-2-thin.png',
//                               width: 34,
//                               height: 34,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     showCards
//                         ? Column(
//                       children: List.generate(numberOfCards, (index) {
//                         return Center(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 width: 296,
//                                 height: 310,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Color(0xff771F98).withOpacity(0.03),
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 10),
//                                           Padding(
//                                             padding: (sharedpref?.getString('lang') == 'ar')
//                                                 ? EdgeInsets.only(right: 12.0)
//                                                 : EdgeInsets.only(left: 12.0),
//                                             child: Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text: 'Child '.tr,
//                                                     style: TextStyle(
//                                                       color: Color(0xff771F98),
//                                                       fontSize: 16,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: '${index + 1}',
//                                                     style: TextStyle(
//                                                       color: Color(0xff771F98),
//                                                       fontSize: 16,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 8),
//                                           Padding(
//                                             padding: (sharedpref?.getString('lang') == 'ar')
//                                                 ? EdgeInsets.only(right: 18.0)
//                                                 : EdgeInsets.only(left: 18.0),
//                                             child: Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text: 'Name'.tr,
//                                                     style: TextStyle(
//                                                       color: Color(0xFF442B72),
//                                                       fontSize: 15,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                       height: 1.07,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: ' *',
//                                                     style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 15,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                       height: 1.07,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 8),
//                                           Padding(
//                                             padding: EdgeInsets.symmetric(horizontal: 18.0),
//                                             child: SizedBox(
//                                               width: 277,
//                                               height: 38,
//                                               child: TextField(
//                                                 controller: nameChildControllers[index],
//                                                 style: TextStyle(
//                                                   color: Color(0xFF442B72),
//                                                   fontSize: 12,
//                                                   fontFamily: 'Poppins-Light',
//                                                   fontWeight: FontWeight.w400,
//                                                   height: 1.33,
//                                                 ),
//                                                 cursorColor: const Color(0xFF442B72),
//                                                 textDirection: (sharedpref?.getString('lang') == 'ar')
//                                                     ? TextDirection.rtl
//                                                     : TextDirection.ltr,
//                                                 textInputAction: TextInputAction.next,
//                                                 keyboardType: TextInputType.text,
//                                                 textAlign: (sharedpref?.getString('lang') == 'ar')
//                                                     ? TextAlign.right
//                                                     : TextAlign.left,
//                                                 scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                                                 decoration: InputDecoration(
//                                                    alignLabelWithHint: true,
//                                                    counterText: "",
//                                                    fillColor: const Color( 0xFFF1F1F1),
//                                                    filled: true,
//                                                   contentPadding: (sharedpref ?.getString( 'lang') == 'ar') ? EdgeInsets.fromLTRB( 0, 0, 17, 10)
//                                                   : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                                                    hintText:'Please enter your child name'.tr,
//                                                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                                                   hintStyle: const TextStyle(color:Color(0xFF9E9E9E),
//                                                   fontSize: 12,
//                                                   fontFamily:'Poppins-Bold',
//                                                   fontWeight: FontWeight.w700,
//                                                   height: 1.33,
//                                                   ),
//                                                   errorText: childNameErrors[index] ? 'Please enter child name' : null,
//                                                   focusedBorder: OutlineInputBorder(
//                                                    borderRadius: BorderRadius.all( Radius.circular(7)),
//                                                    borderSide: BorderSide(
//                                                     color: Color(0xFFFFC53E),
//                                                     width: 0.5, ),),
//                                                    enabledBorder: OutlineInputBorder(
//                                                      borderRadius: BorderRadius.all(
//                                                          Radius.circular(7)),
//                                                      borderSide: BorderSide(
//                                                        color: Color(0xFFFFC53E),
//                                                        width: 0.5,),),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 12),
//                                           Padding(
//                                             padding: (sharedpref?.getString('lang') == 'ar')
//                                                 ? EdgeInsets.only(right: 18.0)
//                                                 : EdgeInsets.only(left: 18.0),
//                                             child: Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text: 'Grade'.tr,
//                                                     style: TextStyle(
//                                                       color: Color(0xFF442B72),
//                                                       fontSize: 15,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                       height: 1.07,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: ' *',
//                                                     style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 15,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                       height: 1.07,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 8),
//                                           Padding(
//                                             padding:  EdgeInsets.symmetric(horizontal: 18.0),
//                                             child: SizedBox(
//                                               width: 277,
//                                               height: 38,
//                                               child: TextField(
//                                                 controller: gradeControllers[index],
//                                                 style: TextStyle(
//                                                   color: Color(0xFF442B72),
//                                                   fontSize: 12,
//                                                   fontFamily: 'Poppins-Light',
//                                                   fontWeight: FontWeight.w400,
//                                                   height: 1.33,
//                                                 ),
//                                                 cursorColor: const Color(0xFF442B72),
//                                                 textDirection: (sharedpref?.getString('lang') == 'ar') ? TextDirection.rtl : TextDirection.ltr,
//                                                 textInputAction: TextInputAction.done,
//                                                 keyboardType: TextInputType.number,
//                                                 inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
//                                                 textAlign:(sharedpref?.getString('lang') == 'ar') ? TextAlign.right : TextAlign.left,
//                                                 scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                                                 decoration: InputDecoration(
//                                                   alignLabelWithHint: true,
//                                                   counterText: "",
//                                                   fillColor: const Color(0xFFF1F1F1),
//                                                   filled: true,
//                                                   contentPadding: (sharedpref?.getString('lang') == 'ar') ? EdgeInsets.fromLTRB(0, 0, 17, 10)
//                                                       : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                                                   errorText: childGradeErrors[index] ? 'Please enter grade name' : null,
//                                                   hintText: 'Please enter your child grade'.tr,
//                                                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                                                   hintStyle: const TextStyle(
//                                                     color: Color(0xFF9E9E9E),
//                                                     fontSize: 12,
//                                                     fontFamily: 'Poppins-Bold',
//                                                     fontWeight: FontWeight.w700,
//                                                     height: 1.33,
//                                                   ),
//                                                     focusedBorder: OutlineInputBorder(
//                                                       borderRadius: BorderRadius.all(
//                                                           Radius.circular(7)),
//                                                       borderSide: BorderSide(
//                                                         color: Color(0xFFFFC53E),
//                                                         width: 0.5,),),
//                                                     enabledBorder: OutlineInputBorder(borderRadius:
//                                                     BorderRadius.all(
//                                                         Radius.circular(7)),
//                                                       borderSide: BorderSide(
//                                                         color: Color(0xFFFFC53E),
//                                                         width: 0.5,),),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 12),
//                                           Padding(
//                                             padding: (sharedpref?.getString('lang') == 'ar')
//                                                 ? EdgeInsets.only(right: 18.0)
//                                                 : EdgeInsets.only(left: 18.0),
//                                             child: Text(
//                                               'Gender',
//                                               style: TextStyle(
//                                                 color: Color(0xFF442B72),
//                                                 fontSize: 15,
//                                                 fontFamily: 'Poppins-Bold',
//                                                 fontWeight: FontWeight.w700,
//                                                 height: 1.07,
//                                               ),
//                                             ),
//                                           ),
//                                           // SizedBox(height: 6),
//                                           // Padding(
//                                           //   padding: (sharedpref?.getString('lang') == 'ar')
//                                           //       ? EdgeInsets.only(right: 15.0)
//                                           //       : EdgeInsets.only(left: 15.0),
//                                           //   child: Row(
//                                           //     children: [
//                                           //       Expanded(
//                                           //         child: RadioListTile<String>(
//                                           //           title: Text('Male'),
//                                           //           value: 'male',
//                                           //           groupValue: genderSelection[index],
//                                           //           onChanged: (value) {
//                                           //             setState(() {
//                                           //               genderSelection[index] = value!;
//                                           //             });
//                                           //           },
//                                           //         ),
//                                           //       ),
//                                           //       Expanded(
//                                           //         child: RadioListTile<String>(
//                                           //           title: Text('Female'),
//                                           //           value: 'female',
//                                           //           groupValue: genderSelection[index],
//                                           //           onChanged: (value) {
//                                           //             setState(() {
//                                           //               genderSelection[index] = value!;
//                                           //             });
//                                           //           },
//                                           //         ),
//                                           //       ),
//                                           //     ],
//                                           //   ),
//                                           // ),
//                                           Padding(
//                                               padding: (sharedpref?.getString('lang') == 'ar') ?
//                                               EdgeInsets.only(right: 15.0)
//                                               : EdgeInsets.only(left: 15.0),
//                                               child: Row(children: [
//                                                 Row(
//                                                   children: [
//                                                     Radio(
//                                                       value: 'female',
//                                                       groupValue: genderSelection[index],
//                                                       onChanged: (value) {
//                                                         setState(() {
//                                                           genderSelection[index] = 'female';
//                                                         });
//                                                       },
//                                                       fillColor: MaterialStateProperty.resolveWith((states) {
//                                                                 if (states.contains(MaterialState.selected)) {
//                                                               return Color(0xff442B72);}
//                                                               return Color(0xff442B72);}),
//                                                       activeColor: Color(0xff442B72), ),// Set the color of the selected radio button
//                                                     Text(
//                                                       "Female".tr,
//                                                       style: TextStyle(
//                                                         fontSize: 15,
//                                                         fontFamily: 'Poppins-Regular',
//                                                         fontWeight: FontWeight.w500,
//                                                         color: Color(0xff442B72),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 50, ), //115
//                                                     Radio(
//                                                       fillColor: MaterialStateProperty.resolveWith(
//                                                               (states) {
//                                                                 if (states.contains(MaterialState.selected)) {
//                                                               return Color(0xff442B72);}
//                                                             return Color(0xff442B72);}),
//                                                       value: 'male',
//                                                       groupValue: genderSelection[index],
//                                                       onChanged: (value) {
//                                                         setState(() {genderSelection[index] = 'male';});},
//                                                       activeColor: Color(0xff442B72),),
//                                                     Text(
//                                                       "Male".tr,
//                                                       style: TextStyle(
//                                                         fontSize: 15,
//                                                         fontFamily: 'Poppins-Regular',
//                                                         fontWeight: FontWeight.w500,
//                                                         color: Color(0xff442B72),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 10,
//                                                 )
//                                               ])),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                     ) : Container(),
//                     // SizedBox(height: 10),
//                     Center(
//                       child: ElevatedSimpleButton(
//                           txt: 'Send invitation'.tr,
//                           fontFamily: 'Poppins-Regular',
//                           width: 277,
//                           hight: 48,
//                           color: Color(0xFF442B72),
//                           fontSize: 16,
//                           onPress: () {
//                           setState(() {
//                             bool isValid = true;
//                             if (numberOfCards == 0 || numberOfCards == null) {
//                               numberOfChildrenError = true;
//                               isValid = false;
//                             } else {
//                               numberOfChildrenError = false;
//                             }
//
//                             if (_nameController.text.isEmpty ) {
//                               nameError = true;
//                               isValid = false;
//                             } else {
//                               nameError = false;
//                             }
//
//                             if (selectedValue.isEmpty ) {
//                               typeOfParentError = true;
//                               isValid = false;
//                             } else {
//                               typeOfParentError = false;
//                             }
//
//                             if (_phoneNumberController.text.isEmpty ) {
//                               phoneError = true;
//                               isValid = false;
//                             } else {
//                               phoneError = false;
//                             }
//                             // if (_phoneNumberController.text.isEmpty) {
//                             //   phoneError = true;
//                             //   isValid = false;
//                             // } else {
//                             //   phoneError = false;
//                             // }
//
//                             for (int i = 0; i < nameChildControllers.length; i++) {
//                               if (nameChildControllers[i].text.isEmpty) {
//                                 childNameErrors[i] = true;
//                                 isValid = false;
//                               } else {
//                                 childNameErrors[i] = false;
//                               }
//
//                               if (gradeControllers[i].text.isEmpty) {
//                                 childGradeErrors[i] = true;
//                                 isValid = false;
//                               } else {
//                                 childGradeErrors[i] = false;
//                               }
//                             }
//
//                             if (isValid) {
//                               _addDataToFirestore();
//                             }
//                           });
//                         },
//                         // onPressed:  _addDataToFirestore,
//
//                       ),
//                     ),
//
//                     //  Padding(
//                     //                               padding: EdgeInsets.symmetric(horizontal: 44.0),
//                     //                               child: Center(
//                     //                                 child: ElevatedSimpleButton(
//
//                     //                               ),
//                     //                             ),
//                     SizedBox(height: 70),
//                     //testttttt
//                     // TextField(
//                     //   controller: _phoneNumberController,
//                     //   keyboardType: TextInputType.phone,
//                     //   decoration: InputDecoration(
//                     //     labelText: 'Enter phone number',
//                     //     border: OutlineInputBorder(),
//                     //   ),
//                     //   onChanged: (value) {
//                     //     enteredPhoneNumber = value;
//                     //   },
//                     // ),
//                     // TextField(
//                     //   keyboardType: TextInputType.number,
//                     //   onChanged: (value) {
//                     //     setState(() {
//                     //       numberOfCards = int.tryParse(value) ?? 0;
//                     //       updateControllers(numberOfCards);
//                     //     });
//                     //   },
//                     //   decoration: InputDecoration(
//                     //     labelText: 'Enter number of cards',
//                     //     border: OutlineInputBorder(),
//                     //   ),
//                     // ),
//                     // numberOfChildrenError
//                     //     ? Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 48),
//                     //   child: Text(
//                     //     "Please enter your number of children".tr,
//                     //     style: TextStyle(color: Colors.red),
//                     //   ),
//                     // ):Container(),
//                   ],
//                 ),
//               ),
//             ),
//
//
//
//             // Expanded(
//             //   child: showCards
//             //       ? ListView.builder(
//             //     itemCount: numberOfCards,
//             //     itemBuilder: (context, index) {
//             //       return Center(
//             //         child: Column(
//             //           children: [
//             //             SizedBox(
//             //               width: 296,
//             //               height: 310,
//             //               child: Column(
//             //                 crossAxisAlignment: CrossAxisAlignment.center,
//             //                 children: [
//             //                   Container(
//             //                     decoration: BoxDecoration(
//             //                       color: Color(0xff771F98).withOpacity(0.03),
//             //                       borderRadius: BorderRadius.circular(14),
//             //                     ),
//             //                     child: Column(
//             //                       mainAxisAlignment: MainAxisAlignment.start,
//             //                       crossAxisAlignment: CrossAxisAlignment.start,
//             //                       children: [
//             //                         SizedBox(height: 10),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 12.0)
//             //                               : EdgeInsets.only(left: 12.0),
//             //                           child: Text.rich(
//             //                             TextSpan(
//             //                               children: [
//             //                                 TextSpan(
//             //                                   text: 'Child '.tr,
//             //                                   style: TextStyle(
//             //                                     color: Color(0xff771F98),
//             //                                     fontSize: 16,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                   ),
//             //                                 ),
//             //                                 TextSpan(
//             //                                   text: '${index + 1}',
//             //                                   style: TextStyle(
//             //                                     color: Color(0xff771F98),
//             //                                     fontSize: 16,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                   ),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 8),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 18.0)
//             //                               : EdgeInsets.only(left: 18.0),
//             //                           child: Text.rich(
//             //                             TextSpan(
//             //                               children: [
//             //                                 TextSpan(
//             //                                   text: 'Name'.tr,
//             //                                   style: TextStyle(
//             //                                     color: Color(0xFF442B72),
//             //                                     fontSize: 15,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                     height: 1.07,
//             //                                   ),
//             //                                 ),
//             //                                 TextSpan(
//             //                                   text: ' *',
//             //                                   style: TextStyle(
//             //                                     color: Colors.red,
//             //                                     fontSize: 15,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                     height: 1.07,
//             //                                   ),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 6),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 12.0)
//             //                               : EdgeInsets.only(left: 12.0),
//             //                           child: TextField(
//             //                             controller: nameChildControllers[index],
//             //                             decoration: InputDecoration(
//             //                               errorText: childNameErrors[index] ? 'Please enter child name' : null,
//             //                               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             //                               hintText: 'Enter child name',
//             //                               border: OutlineInputBorder(
//             //                                 borderRadius: BorderRadius.circular(10),
//             //                               ),
//             //
//             //                             ),
//             //
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 14),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 18.0)
//             //                               : EdgeInsets.only(left: 18.0),
//             //                           child: Text.rich(
//             //                             TextSpan(
//             //                               children: [
//             //                                 TextSpan(
//             //                                   text: 'Grade'.tr,
//             //                                   style: TextStyle(
//             //                                     color: Color(0xFF442B72),
//             //                                     fontSize: 15,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                     height: 1.07,
//             //                                   ),
//             //                                 ),
//             //                                 TextSpan(
//             //                                   text: ' *',
//             //                                   style: TextStyle(
//             //                                     color: Colors.red,
//             //                                     fontSize: 15,
//             //                                     fontFamily: 'Poppins-Bold',
//             //                                     fontWeight: FontWeight.w700,
//             //                                     height: 1.07,
//             //                                   ),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 6),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 12.0)
//             //                               : EdgeInsets.only(left: 12.0),
//             //                           child: TextField(
//             //                             controller: gradeControllers[index],
//             //                             decoration: InputDecoration(
//             //                               errorText: childGradeErrors[index] ? 'Please enter grade name' : null,
//             //                               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             //                               hintText: 'Enter child grade',
//             //                               border: OutlineInputBorder(
//             //                                 borderRadius: BorderRadius.circular(10),
//             //                               ),
//             //                             ),
//             //
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 14),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 18.0)
//             //                               : EdgeInsets.only(left: 18.0),
//             //                           child: Text(
//             //                             'Gender',
//             //                             style: TextStyle(
//             //                               color: Color(0xFF442B72),
//             //                               fontSize: 15,
//             //                               fontFamily: 'Poppins-Bold',
//             //                               fontWeight: FontWeight.w700,
//             //                               height: 1.07,
//             //                             ),
//             //                           ),
//             //                         ),
//             //                         SizedBox(height: 6),
//             //                         Padding(
//             //                           padding: (sharedpref?.getString('lang') == 'ar')
//             //                               ? EdgeInsets.only(right: 12.0)
//             //                               : EdgeInsets.only(left: 12.0),
//             //                           child: Row(
//             //                             children: [
//             //                               Expanded(
//             //                                 child: RadioListTile<String>(
//             //                                   title: Text('Male'),
//             //                                   value: 'male',
//             //                                   groupValue: genderSelection[index],
//             //                                   onChanged: (value) {
//             //                                     setState(() {
//             //                                       genderSelection[index] = value!;
//             //                                     });
//             //                                   },
//             //                                 ),
//             //                               ),
//             //                               Expanded(
//             //                                 child: RadioListTile<String>(
//             //                                   title: Text('Female'),
//             //                                   value: 'female',
//             //                                   groupValue: genderSelection[index],
//             //                                   onChanged: (value) {
//             //                                     setState(() {
//             //                                       genderSelection[index] = value!;
//             //                                     });
//             //                                   },
//             //                                 ),
//             //                               ),
//             //                             ],
//             //                           ),
//             //                         ),
//             //                       ],
//             //                     ),
//             //                   ),
//             //                 ],
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       );
//             //     },
//             //   )
//             //       : Container(),
//             // ),
//             // SizedBox(height: 20),
//             //
//             // SizedBox(height: 10),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     setState(() {
//             //       bool isValid = true;
//             //       if (numberOfCards == 0 || numberOfCards == null) {
//             //         numberOfChildrenError = true;
//             //         isValid = false;
//             //       } else {
//             //         numberOfChildrenError = false;
//             //       }
//             //
//             //       if (_nameController.text.isEmpty ) {
//             //         nameError = true;
//             //         isValid = false;
//             //       } else {
//             //         nameError = false;
//             //       }
//             //
//             //       if (_phoneNumberController.text.isEmpty ) {
//             //         phoneError = true;
//             //         isValid = false;
//             //       } else {
//             //         phoneError = false;
//             //       }
//             //       // if (_phoneNumberController.text.isEmpty) {
//             //       //   phoneError = true;
//             //       //   isValid = false;
//             //       // } else {
//             //       //   phoneError = false;
//             //       // }
//             //
//             //       for (int i = 0; i < nameChildControllers.length; i++) {
//             //         if (nameChildControllers[i].text.isEmpty) {
//             //           childNameErrors[i] = true;
//             //           isValid = false;
//             //         } else {
//             //           childNameErrors[i] = false;
//             //         }
//             //
//             //         if (gradeControllers[i].text.isEmpty) {
//             //           childGradeErrors[i] = true;
//             //           isValid = false;
//             //         } else {
//             //           childGradeErrors[i] = false;
//             //         }
//             //       }
//             //
//             //       if (isValid) {
//             //         _addDataToFirestore();
//             //       }
//             //     });
//             //   },
//             //   // onPressed:  _addDataToFirestore,
//             //   child: Text('Save'),
//             // ),
//             // SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
// void InvitationSendSnackBar(context, String message, color,
//     {Duration? duration}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       dismissDirection: DismissDirection.up,
//       duration: duration ?? const Duration(milliseconds: 2000),
//       backgroundColor: Colors.white,
//       margin: EdgeInsets.only(
//         bottom: MediaQuery.of(context).size.height - 150,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       behavior: SnackBarBehavior.floating,
//       content: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/images/saved.png',
//             width: 30,
//             height: 30,
//           ),
//           SizedBox(
//             width: 15,
//           ),
//           Text(
//             message,
//             style: TextStyle(
//               color: color,
//               fontSize: 16,
//               fontFamily: 'Poppins-Bold',
//               fontWeight: FontWeight.w700,
//               height: 1.23,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

