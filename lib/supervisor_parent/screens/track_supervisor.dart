import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:dotted_line/dotted_line.dart';
import 'dart:convert' as convert;

import '../../components/elevated_simple_button.dart';


class TrackSupervisor extends StatefulWidget {
  @override
  _TrackSupervisorState createState() => _TrackSupervisorState();
}

class _TrackSupervisorState extends State<TrackSupervisor> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _limit = 3;
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<DocumentSnapshot> _documents = [];
  List<Map<String, dynamic>> childrenData = [];
  final ScrollController _scrollController = ScrollController();
  bool hasArrived = false;
  String arrivalTime = '';
  int remainingTime = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Position? currentPosition;
  bool dataLoading = false;
  List<QueryDocumentSnapshot> data = [];
  GoogleMapController? controller;
  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
  late final String title;
  bool tracking = true;
  String _namedriver = ' ';
  String _photobus = ' ';
  String _busnumber = ' ';
  late DateTime estimatedArrivalTime;
  late Timer _timer;
  Timer? locationUpdateTimer;
  StreamSubscription<Position>? _positionStreamSubscription;



  double targetLatitude = 27.182;
  double targetLongitude = 31.186;
  //
  Future<List<GeoPoint>> getLocationsFromFirestore() async {
    List<GeoPoint> locations = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('locations').get();

    snapshot.docs.forEach((doc) {
      locations.add(doc['location']); // افترض أن لديك حقل اسمه location في المستند
    });

    return locations;
  }

  Future<int> getRemainingTime(List<GeoPoint> locations) async {
    String apiKey = 'AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E';
    String origins = '${locations.first.latitude},${locations.first.longitude}';
    String destinations = '${locations.last.latitude},${locations.last.longitude}';

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destinations&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = convert.json.decode(response.body);
      var duration = data['rows'][0]['elements'][0]['duration']['value']; // الوقت بالثواني
      return (duration / 60).round(); // تحويل الوقت إلى دقائق
    } else {
      throw Exception('Failed to fetch distance matrix');
    }
  }

  //
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
        arrivalTime = calculateArrivalTime(); // Update arrival time here
        hasArrived = checkIfArrived(position); // Update arrival status here
      });

      // Store the latitude and longitude values in Firestore
      final databaseReference = FirebaseFirestore.instance;
      databaseReference.collection('users').doc('current_location').set({
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude,
      });
    } catch (e) {
      print(e);
    }
  }
  //
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    return true;
  }
  //


  Future<void> updateCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = position;
      });

      // Store the latitude and longitude values in Realtime Database
      final databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child('users').child('current_location').set({
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude,
      });
    } catch (e) {
      print(e);
    }
  }
  //
  Future<int> calculateRemainingTime() async {
    List<GeoPoint> locations = await getLocationsFromFirestore();
    return await getRemainingTime(locations);
  }

  Future<void> fetchRemainingTime() async {
    int time = await calculateRemainingTime();
    setState(() {
      remainingTime = time;
    });
  }


  void _startListeningToPositionStream() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentPosition = position;
      });
    }, onError: (error) {
      print('Error in geolocation stream: $error');
    });
  }
  //
  void _stopListeningToPositionStream() {
    _positionStreamSubscription?.cancel();
  }
  //
  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (mounted) { // Check if the widget is still mounted
        int time = await calculateRemainingTime(); // Await the Future
        setState(() {
          remainingTime = time; // Assign the awaited value
        });
      }
    });
  }
  //
  //
  void initData() async {
    await getCurrentLocation();
    if (mounted) { // Check if the widget is still mounted
      print('Current position: ${currentPosition}');
      if (await _checkLocationPermission()) {
        // Enable MyLocation layer
        print('Location permission granted');
      } else {
        // Show message asking user to grant location permissions
        print('Location permission denied');
      }
    }
  }


  String calculateArrivalTime() {
    // Your logic to calculate the arrival time
    // This is just a placeholder example
    DateTime now = DateTime.now();
    DateTime arrival = now.add(Duration(minutes: 15)); // Assume bus arrives in 15 minutes
    return '${arrival.hour}:${arrival.minute}';
  }
  //
  bool checkIfArrived(Position position) {
    // Your logic to check if the bus has arrived
    // This is just a placeholder example
    // Replace this with actual logic to check if the bus has arrived
    return position.latitude == targetLatitude && position.longitude == targetLongitude;
  }


  BitmapDescriptor anotherCustomIcon = BitmapDescriptor.defaultMarker;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo frameInfo = await codec.getNextFrame();
    final Uint8List resizedImage =
    (await frameInfo.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return resizedImage;
  }


  Future<void> loadCustomIcon() async {
    final Uint8List imageData2 =
    await getBytesFromAsset("assets/images/yellow_bus_2.png", 90);
    anotherCustomIcon = BitmapDescriptor.fromBytes(imageData2);

    setState(() {});
  }

  TextDirection _getTextDirection(String text) {
    // Determine the text direction based on text content
    if (text.contains(RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF\uFE70-\uFEFF\uFB50-\uFDFF\u2000-\u206F\u202A-\u202E\u2070-\u209F\u20A0-\u20CF\u2100-\u214F\u2150-\u218F]'))) {
      // RTL language detected
      return TextDirection.rtl;
    } else {
      // LTR language detected
      return TextDirection.ltr;
    }
  }


  Future<void> getDataForBus() async {
    setState(() {
      dataLoading = true;
    });

    DocumentSnapshot supervisorDoc = await FirebaseFirestore.instance
        .collection('supervisor')
        .doc(sharedpref?.getString('id'))
        .get();

    if (supervisorDoc.exists) {
      String busId = supervisorDoc['bus_id'];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('busdata')
          .where(FieldPath.documentId, isEqualTo: busId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var busData = querySnapshot.docs.first;
        String namedriver = busData['namedriver'];
        String photobus = busData['busphoto'];
        String busnumber = busData['busnumber'];

        setState(() {
          _namedriver = namedriver;
          _photobus = photobus;
          _busnumber = busnumber;
        });
      }
      else {
        print('No bus data found');
      }
    }
    else {
      print('Supervisor document does not exist');
    }

    setState(() {
      dataLoading = false;
    });
  }



  @override
  void dispose() {
    _scrollController.dispose();
    locationUpdateTimer?.cancel();
    _stopListeningToPositionStream();
    _timer.cancel();
    super.dispose();
  }


  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchData();
    getDataForBus();
    loadCustomIcon();
    fetchRemainingTime();
    _startListeningToPositionStream();
    estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
    _startTimer();
    initData();
    locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateCurrentLocation();
    });

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentPosition = position;
      });


      // Update Realtime Database with the new position
      final databaseReference = FirebaseDatabase.instance.ref();
      databaseReference.child('users').child('current_location').set({
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude,
      });
    });
  }

  Future<void> _fetchData({String query = ""}) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    var query = _firestore.collection('parent').limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        _hasMoreData = false;
      });
    } else {
      List<Map<String, dynamic>> allChildren = [];
      String supervisorId = sharedpref!.getString('id') ?? '';

      for (var parentDoc in snapshot.docs) {
        List<dynamic> children = parentDoc['children'];
        List<Map<String, dynamic>> filteredChildren = children
            .where((child) => child['supervisor'] == supervisorId)
            .map((child) => child as Map<String, dynamic>)
            .toList();
        allChildren.addAll(filteredChildren);
      }

      setState(() {
        _lastDocument = snapshot.docs.last;
        _documents.addAll(snapshot.docs);
        childrenData.addAll(allChildren);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    LatLng startLocation = LatLng(currentPosition?.latitude ?? 0.0, currentPosition?.longitude ?? 0.0);

    List<LatLng> polylineCoordinates = [startLocation];
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('current_location'),
        position: startLocation,
        icon: anotherCustomIcon,
      ),
    };

    for (var doc in data) {
      var childData = doc.data() as Map<String, dynamic>;
      var latString = childData['lat'];
      var lngString = childData['lng'];

      if (latString != null && lngString != null) {
        try {
          var lat = double.parse(latString.toString());
          var lng = double.parse(lngString.toString());
          var childLocation = LatLng(lat, lng);

          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: childLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              // infoWindow: InfoWindow(
              //   title: childData['name'],
              // ),
            ),
          );

          // Check if the bus has reached the child location (e.g., within 50 meters)
          double distanceInMeters = Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            lat,
            lng,
          );

          if (distanceInMeters <= 50) {
            polylineCoordinates.add(childLocation);
          }

        } catch (e) {
          print('Invalid double: $e');
        }
      }
    }

    return Scaffold(
        endDrawer: SupervisorDrawer(),
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')
                      ? EdgeInsets.all(23.0)
                      : EdgeInsets.all(17.0),
                  child: Image.asset(
                    (sharedpref?.getString('lang') == 'ar')
                        ? 'assets/images/Layer 1.png'
                        : 'assets/images/fi-rr-angle-left.png',
                    width: 10,
                    height: 22,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
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
                'Tracking Bus'.tr,
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 350,
                    child: StreamBuilder<DatabaseEvent>(
                      stream:FirebaseDatabase.instance
                          .ref()
                          .child('users')
                          .child('current_location')
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                          var latitude = data['latitude'] ?? startLocation.latitude;
                          var longitude = data['longitude'] ?? startLocation.longitude;
                          var targetLocation = LatLng(latitude, longitude);

                          return dataLoading
                              ? Center(child: CircularProgressIndicator())
                              : GoogleMap(
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: true,
                            gestureRecognizers: Set()
                              ..add(Factory<EagerGestureRecognizer>(() =>
                                  EagerGestureRecognizer())),
                            initialCameraPosition: CameraPosition(
                              target: startLocation,
                              zoom: 12,
                            ),
                            markers: markers,
                            polylines: {
                              Polyline(
                                polylineId: PolylineId('route'),
                                points: polylineCoordinates,
                                color: Colors.red,
                                width: 5,
                              ),
                            },
                            onMapCreated: (GoogleMapController controller) {
                              this.controller = controller;
                            },
                          );
                        }
                        //   GoogleMap(
                        //   scrollGesturesEnabled: true,
                        //   gestureRecognizers: Set()
                        //     ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                        //   initialCameraPosition: CameraPosition(
                        //     target: targetLocation,
                        //     zoom: 12,
                        //   ),
                        //   markers: {
                        //     Marker(
                        //       markerId: MarkerId('current_location'),
                        //       position: targetLocation,
                        //       icon: anotherCustomIcon,
                        //     ),
                        //   },
                        //   onMapCreated: (mapController) {
                        //     setState(() {
                        //       controller = mapController;
                        //     });
                        //   },
                        // );
                        else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 45,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Theme(
                          data: ThemeData(
                            splashFactory: NoSplash.splashFactory,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ListTile(
                            onTap: () {
                              tracking = true;
                              setState(() {});
                            },
                            title: Column(
                              children: [
                                Text(
                                  'bus Tracking'.tr,
                                  style: TextStyle(
                                      color: const Color(0xFF432B72),
                                      fontSize: 16,
                                      fontFamily: tracking
                                          ? 'Poppins-SemiBold'
                                          : 'Poppins-Light',
                                      fontWeight: tracking
                                          ? FontWeight.w600
                                          : FontWeight.w400),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 2,
                                  width: tracking ? 75 : 0,
                                  color: const Color(0xFFFFC53E),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          // height: 32,
                          width: 1,
                          color: Colors.black,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Theme(
                          data: ThemeData(
                            splashFactory: NoSplash.splashFactory,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ListTile(
                            onTap: () {
                              tracking = false;
                              setState(() {});
                            },
                            title: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Text(
                                    'Bus Info'.tr,
                                    style: TextStyle(
                                        color: const Color(0xFF432B72),
                                        fontSize: 17,
                                        fontFamily: tracking
                                            ? 'Poppins-Light'
                                            : 'Poppins-SemiBold',
                                        fontWeight: tracking
                                            ? FontWeight.w400
                                            : FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  height: 2,
                                  width: tracking ? 0 : 75,
                                  color: const Color(0xFFFFC53E),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFD8D8D8),
                ),
                const SizedBox(
                  height: 25,
                ),





                tracking ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child:
                    ElevatedSimpleButton(txt: 'Start your journey',
                        width: 278,
                        hight: 48,
                        onPress: (){
                          fetchRemainingTime();
                          _startListeningToPositionStream();
                          estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
                          _startTimer();
                          initData();
                          locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
                            updateCurrentLocation();
                          });
                          Geolocator.getPositionStream().listen((Position position) {
                            setState(() {
                              currentPosition = position;
                            });


                            // Update Realtime Database with the new position
                            final databaseReference = FirebaseDatabase.instance.ref();
                            databaseReference.child('users').child('current_location').set({
                              'latitude': currentPosition!.latitude,
                              'longitude': currentPosition!.longitude,
                            });
                          });
                        },
                        color: Color(0xff442B72),
                        fontSize: 16)),
                    SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '$remainingTime', // Use the dynamic value here
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 29.71,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w700,
                              height: 1.23,
                            ),
                          ),
                          TextSpan(
                            text: ' Min.'.tr,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 29.71,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w700,
                              height: 1.23,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                      child: Text(
                        'To arrive'.tr,
                        style: TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 24.12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w300,
                          height: 1.23,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                  ],
                )
                    :
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child:
                        ElevatedSimpleButton(txt: 'Start your journey', width: 278, hight: 48, onPress: (){
                          fetchRemainingTime();
                          _startListeningToPositionStream();
                          estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
                          _startTimer();
                          initData();
                          locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
                            updateCurrentLocation();
                          });
                          Geolocator.getPositionStream().listen((Position position) {
                            setState(() {
                              currentPosition = position;
                            });


                            // Update Realtime Database with the new position
                            final databaseReference = FirebaseDatabase.instance.ref();
                            databaseReference.child('users').child('current_location').set({
                              'latitude': currentPosition!.latitude,
                              'longitude': currentPosition!.longitude,
                            });
                          });
                        }, color: Color(0xff442B72), fontSize: 16)),
                        SizedBox(height: 25,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bus Number'.tr,
                                    style: TextStyle(
                                      color: Color(0xFF432B72),
                                      fontSize: 17,
                                      fontFamily: 'Poppins-SemiBold',
                                      fontWeight: FontWeight.w600,
                                      height: 0.94,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '$_busnumber',
                                    textDirection:
                                    _getTextDirection(" 1458ى ر س "),
                                    style: TextStyle(
                                      color: Color(0xFF919191),
                                      fontSize: 17,
                                      fontFamily: 'Roboto-Regular',
                                      fontWeight: FontWeight.w400,
                                      height: 0.89,
                                    ),
                                    overflow: TextOverflow.ellipsis, //,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Driver Name'.tr,
                                    style: TextStyle(
                                      color: Color(0xFF432B72),
                                      fontSize: 17,
                                      fontFamily: 'Poppins-SemiBold',
                                      fontWeight: FontWeight.w600,
                                      height: 0.94,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    _namedriver,
                                    style: TextStyle(
                                      color: Color(0xFF919191),
                                      fontSize: 18,
                                      fontFamily: 'Poppins-Regular',
                                      fontWeight: FontWeight.w500,
                                      height: 0.89,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Text(
                            'Bus photos'.tr,
                            style: TextStyle(
                              color: Color(0xFF432B72),
                              fontSize: 17,
                              fontFamily: 'Poppins-SemiBold',
                              fontWeight: FontWeight.w600,
                              height: 0.94,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Container(
                              height: 170,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  InteractiveViewer(
                                      child:(_photobus == null || _photobus == '') ?
                                      Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                      Image.network(_photobus!,width: 144,height: 154.42,fit: BoxFit.cover,)
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  // InteractiveViewer(
                                  //     child:(_photobus == null || _photobus == '') ?
                                  //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                  //     Image.network(_photobus!,width: 104,height: 111.53,)
                                  // ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // InteractiveViewer(
                                  //     child:(_photobus == null || _photobus == '') ?
                                  //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                  //     Image.network(_photobus!,width: 104,height: 111.53,)
                                  // ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // InteractiveViewer(
                                  //     child:(_photobus == null || _photobus == '') ?
                                  //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                                  //     Image.network(_photobus!,width: 104,height: 111.53,)
                                  // ),
                                ],
                              )),
                        ),
                        // SizedBox(
                        //   height: 44,
                        // )
                      ],
                    ),
                  ),
                ),
                tracking?
                Expanded(
                  child:
                  Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: childrenData.length + 1,
                        itemBuilder: (context, index) {
                          if (index == childrenData.length) {
                            return _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Center(child: Container());
                          }

                          var child = childrenData[index];
                          String name = child['name'] ?? 'No Name';
                          bool isFirstOrLast = index == 0 || index == childrenData.length - 1;

                          if (isFirstOrLast) {
                            // name = 'welcome $name';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 23.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 70, // Adjust height as needed
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isFirstOrLast)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Text('- - -', style: TextStyle(
                                        color: Color(0xffFFC53E),),),
                                    )
                                  else SizedBox(width: 18,),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xff442B72),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                      radius: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: Color(0xFF442B72),
                                          fontSize: 15,
                                          fontFamily: 'Poppins-SemiBold',
                                          fontWeight: FontWeight.w600,
                                          height: 1.07,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      hasArrived
                                          ? Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'arrived :'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF13DB63),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' $arrivalTime '.tr,
                                              style: TextStyle(
                                                color: Color(0xFF13DB63),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'AM'.tr,
                                              style: TextStyle(
                                                color: Color(0xFF13DB63),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Text(
                                        'not yet'.tr,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400,
                                          height: 1.23,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      ( sharedpref?.getString('lang') == 'ar')
                          ? Positioned(
                        left: 299,
                        top: 35,
                        bottom: 85,
                        child: buildDashedLine(),
                      )
                          : Positioned(
                        top: 28,
                        bottom: 105,
                        child: buildDashedLine(),
                      )
                    ],
                  ),
                )
                    :
                Container()




              ]),
        ),

        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Color(0xff442B72),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileSupervisorScreen(
                    // onTapMenu: onTapMenu
                  )));
            },
            child: Image.asset(
              'assets/images/174237 1.png',
              height: 33,
              width: 33,
              fit: BoxFit.cover,
            )),
        bottomNavigationBar: Directionality(
            textDirection: Get.locale == Locale('ar')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomAppBar(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    height: 60,
                    color: const Color(0xFF442B72),
                    clipBehavior: Clip.antiAlias,
                    shape: const AutomaticNotchedShape(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38.5),
                                topRight: Radius.circular(38.5))),
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)))),
                    notchMargin: 7,
                    child: SizedBox(
                        height: 10,
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeForSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 7, right: 15)
                                      : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
                                      SizedBox(height: 3),
                                      Text(
                                        "Home".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceSupervisorScreen()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 9, left: 50)
                                      : EdgeInsets.only(right: 50, top: 2),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19),
                                      SizedBox(height: 3),
                                      Text(
                                        "Attendance".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(
                                      top: 12, bottom: 4, right: 10)
                                      : EdgeInsets.only(
                                      top: 8, bottom: 4, left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
                                      SizedBox(height: 2),
                                      Text(
                                        "Notifications".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: (sharedpref?.getString('lang') == 'ar')
                                    ? EdgeInsets.only(
                                    top: 10, bottom: 2, right: 10, left: 0)
                                    : EdgeInsets.only(
                                    top: 8, bottom: 2, left: 0, right: 10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/images/icons8_bus 1 (1).png',
                                        height: 22,
                                        width: 25),
                                    SizedBox(height: 3),
                                    Text(
                                      "Buses".tr,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )))))
    );
  }

  Widget buildDashedLine() {
    // double lineLength = students.length * 40.0;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: DottedLine(
        lineLength: double.infinity,
        // lineLength: lineLength,
        direction: Axis.vertical,
        dashColor: Color(0xffFFC53E),
      ),
    );
  }

}


// class _TrackSupervisorState extends State<TrackSupervisor> {
//   late final String title;
//   bool tracking = true;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   Set<Marker> markers = {};
//   GoogleMapController? controller;
//   LatLng startLocation = const LatLng(27.1819438, 31.1859626);
//   BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;
//   List<QueryDocumentSnapshot> data = [];
//   bool dataLoading = false;
//   Position? currentPosition;
//   Timer? locationUpdateTimer;
//   String _namedriver = ' ';
//   String _photobus = ' ';
//   String _busnumber = ' ';
//   String arrivalTime = '';
//   bool hasArrived = false;
//   StreamSubscription<Position>? _positionStreamSubscription;
//   late Timer _timer;
//   late DateTime estimatedArrivalTime;
//   int remainingTime = 0;
//   final _firestore = FirebaseFirestore.instance;
//
//
//   // Define target location (example coordinates)
//   double targetLatitude = 27.182;
//   double targetLongitude = 31.186;
//
//   Future<List<GeoPoint>> getLocationsFromFirestore() async {
//     List<GeoPoint> locations = [];
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('locations').get();
//
//     snapshot.docs.forEach((doc) {
//       locations.add(doc['location']); // افترض أن لديك حقل اسمه location في المستند
//     });
//
//     return locations;
//   }
//
//   // Future<int> getRemainingTime(List<GeoPoint> locations) async {
//   //   String apiKey = 'AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E';
//   //   String origins = '${locations.first.latitude},${locations.first.longitude}';
//   //   String destinations = '${locations.last.latitude},${locations.last.longitude}';
//   //
//   //   String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destinations&key=$apiKey';
//   //
//   //   http.Response response = await http.get(Uri.parse(url));
//   //
//   //   if (response.statusCode == 200) {
//   //     var data = convert.json.decode(response.body);
//   //     var duration = data['rows'][0]['elements'][0]['duration']['value']; // الوقت بالثواني
//   //     return (duration / 60).round(); // تحويل الوقت إلى دقائق
//   //   } else {
//   //     throw Exception('Failed to fetch distance matrix');
//   //   }
//   // }
//
//   Future<int> getRemainingTime(List<GeoPoint> locations) async {
//     String apiKey = 'AIzaSyDid2iv9pn1QZrPDCAbXGM7zTgcg6dWI1E';
//     String origins = '${locations.first.latitude},${locations.first.longitude}';
//     String destinations = '${locations.last.latitude},${locations.last.longitude}';
//
//     String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destinations&key=$apiKey';
//
//     http.Response response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       var data = convert.json.decode(response.body);
//       var duration = data['rows'][0]['elements'][0]['duration']['value']; // الوقت بالثواني
//       return (duration / 60).round(); // تحويل الوقت إلى دقائق
//     } else {
//       throw Exception('Failed to fetch distance matrix');
//     }
//   }
//   // Future<void> getCurrentLocation() async {
//   //   try {
//   //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //     setState(() {
//   //       currentPosition = position;
//   //       arrivalTime = calculateArrivalTime(); // Update arrival time here
//   //
//   //     });
//   //
//   //     // Store the latitude and longitude values in Firestore
//   //     final databaseReference = FirebaseFirestore.instance;
//   //     databaseReference.collection('users').doc('current_location').set({
//   //       'latitude': currentPosition!.latitude,
//   //       'longitude': currentPosition!.longitude,
//   //     });
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//   Future<void> getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         currentPosition = position;
//         arrivalTime = calculateArrivalTime(); // Update arrival time here
//         hasArrived = checkIfArrived(position); // Update arrival status here
//       });
//
//       // Store the latitude and longitude values in Firestore
//       final databaseReference = FirebaseFirestore.instance;
//       databaseReference.collection('users').doc('current_location').set({
//         'latitude': currentPosition!.latitude,
//         'longitude': currentPosition!.longitude,
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<bool> _checkLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return false;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }
//
//     return true;
//   }
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
//        else {
//         print('No bus data found');
//       }
//     } else {
//       print('Supervisor document does not exist');
//     }
//
//     setState(() {
//       dataLoading = false;
//     });
//   }
//
//   getData()async{
//     setState(() {
//       dataLoading =true;
//
//     });
//     QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('parent').get();
//     data.addAll(querySnapshot.docs);
//     setState(() {
//       dataLoading =false;
//
//     });
//   }
//
//   // Future<void> updateCurrentLocation() async {
//   //   try {
//   //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //     setState(() {
//   //       currentPosition = position;
//   //     });
//   //
//   //     // Store the latitude and longitude values in Realtime Database
//   //     final databaseReference = FirebaseDatabase.instance.reference();
//   //     databaseReference.child('users').child('current_location').set({
//   //       'latitude': currentPosition!.latitude,
//   //       'longitude': currentPosition!.longitude,
//   //     });
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//
//   Future<void> updateCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         currentPosition = position;
//       });
//
//       // Store the latitude and longitude values in Realtime Database
//       final databaseReference = FirebaseDatabase.instance.reference();
//       databaseReference.child('users').child('current_location').set({
//         'latitude': currentPosition!.latitude,
//         'longitude': currentPosition!.longitude,
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<int> calculateRemainingTime() async {
//     List<GeoPoint> locations = await getLocationsFromFirestore();
//     return await getRemainingTime(locations);
//   }
//
//   Future<void> fetchRemainingTime() async {
//     int time = await calculateRemainingTime();
//     setState(() {
//       remainingTime = time;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadCustomIcon();
//     fetchRemainingTime();
//     _startListeningToPositionStream();
//     getData();
//     getDataForBus();
//     estimatedArrivalTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 30);
//     _startTimer();
//     initData();
//
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
//   @override void dispose() {
//     locationUpdateTimer?.cancel();
//     _stopListeningToPositionStream();
//     _timer.cancel();
//     super.dispose();
//   }
//
//   void _startListeningToPositionStream() {
//     Geolocator.getPositionStream().listen((Position position) {
//       setState(() {
//         currentPosition = position;
//       });
//     }, onError: (error) {
//       print('Error in geolocation stream: $error');
//     });
//   }
//
//   void _stopListeningToPositionStream() {
//     _positionStreamSubscription?.cancel();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
//       if (mounted) { // Check if the widget is still mounted
//         int time = await calculateRemainingTime(); // Await the Future
//         setState(() {
//           remainingTime = time; // Assign the awaited value
//         });
//       }
//     });
//   }
//
//   // String calculateRemainingTime() {
//   //   // Calculate remaining time dynamically
//   //   DateTime now = DateTime.now();
//   //   Duration remainingDuration = estimatedArrivalTime.difference(now);
//   //   int remainingMinutes = remainingDuration.inMinutes;
//   //   return remainingMinutes.toString();
//   // }
//
//   void initData() async {
//     await getCurrentLocation();
//     if (mounted) { // Check if the widget is still mounted
//       print('Current position: ${currentPosition}');
//       if (await _checkLocationPermission()) {
//         // Enable MyLocation layer
//         print('Location permission granted');
//       } else {
//         // Show message asking user to grant location permissions
//         print('Location permission denied');
//       }
//     }
//   }
//
//   BitmapDescriptor anotherCustomIcon = BitmapDescriptor.defaultMarker;
//
//   Future<void> loadCustomIcon() async {
//     final Uint8List imageData2 =
//         await getBytesFromAsset("assets/images/yellow_bus_2.png", 90);
//     anotherCustomIcon = BitmapDescriptor.fromBytes(imageData2);
//
//     setState(() {});
//   }
//
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     final ByteData data = await rootBundle.load(path);
//     final Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     final FrameInfo frameInfo = await codec.getNextFrame();
//     final Uint8List resizedImage =
//         (await frameInfo.image.toByteData(format: ImageByteFormat.png))!
//             .buffer
//             .asUint8List();
//     return resizedImage;
//   }
//
//   String calculateArrivalTime() {
//     // Your logic to calculate the arrival time
//     // This is just a placeholder example
//     DateTime now = DateTime.now();
//     DateTime arrival = now.add(Duration(minutes: 15)); // Assume bus arrives in 15 minutes
//     return '${arrival.hour}:${arrival.minute}';
//   }
//
//   bool checkIfArrived(Position position) {
//     // Your logic to check if the bus has arrived
//     // This is just a placeholder example
//     // Replace this with actual logic to check if the bus has arrived
//     return position.latitude == targetLatitude && position.longitude == targetLongitude;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // String currentLatitude = currentPosition?.latitude?.toString() ?? '';
//     // String currentLongitude = currentPosition?.longitude?.toString() ?? '';
//     //
//     // LatLng targetLocation = startLocation;
//     // if (currentLatitude.isNotEmpty && currentLongitude.isNotEmpty) {
//     //   try {
//     //     targetLocation = LatLng(
//     //         double.parse(currentLatitude), double.parse(currentLongitude));
//     //   } catch (e) {
//     //     print('Invalid double: $e');
//     //   }
//     // }
//     String currentLatitude = currentPosition?.latitude?.toString() ?? '';
//     String currentLongitude = currentPosition?.longitude?.toString() ?? '';
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
//
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
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                     height: 350,
//                     child: StreamBuilder<DatabaseEvent>(
//                       stream:FirebaseDatabase.instance
//                           .ref()
//                           .child('users')
//                           .child('current_location')
//                           .onValue,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           var data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                           var latitude = data['latitude'] ?? startLocation.latitude;
//                           var longitude = data['longitude'] ?? startLocation.longitude;
//                           var targetLocation = LatLng(latitude, longitude);
//
//                           return dataLoading
//                               ? Center(child: CircularProgressIndicator())
//                               : GoogleMap(
//                             zoomControlsEnabled: false,
//                             scrollGesturesEnabled: true,
//                             gestureRecognizers: Set()
//                               ..add(Factory<EagerGestureRecognizer>(() =>
//                                   EagerGestureRecognizer())),
//                             initialCameraPosition: CameraPosition(
//                               target: startLocation,
//                               zoom: 12,
//                             ),
//                             markers: markers,
//                             polylines: {
//                               Polyline(
//                                 polylineId: PolylineId('route'),
//                                 points: polylineCoordinates,
//                                 color: Colors.red,
//                                 width: 5,
//                               ),
//                             },
//               onMapCreated: (GoogleMapController controller) {
//               this.controller = controller;
//               },
//               );
//               }
//               //   GoogleMap(
//                           //   scrollGesturesEnabled: true,
//                           //   gestureRecognizers: Set()
//                           //     ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
//                           //   initialCameraPosition: CameraPosition(
//                           //     target: targetLocation,
//                           //     zoom: 12,
//                           //   ),
//                           //   markers: {
//                           //     Marker(
//                           //       markerId: MarkerId('current_location'),
//                           //       position: targetLocation,
//                           //       icon: anotherCustomIcon,
//                           //     ),
//                           //   },
//                           //   onMapCreated: (mapController) {
//                           //     setState(() {
//                           //       controller = mapController;
//                           //     });
//                           //   },
//                           // );
//                          else if (snapshot.hasError) {
//                           return Center(child: Text('Error: ${snapshot.error}'));
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     )),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 SizedBox(
//                   height: 45,
//                   child: Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Flexible(
//                         flex: 5,
//                         child: Theme(
//                           data: ThemeData(
//                             splashFactory: NoSplash.splashFactory,
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                           ),
//                           child: ListTile(
//                             onTap: () {
//                               tracking = true;
//                               setState(() {});
//                             },
//                             title: Column(
//                               children: [
//                                 Text(
//                                   'bus Tracking'.tr,
//                                   style: TextStyle(
//                                       color: const Color(0xFF432B72),
//                                       fontSize: 16,
//                                       fontFamily: tracking
//                                           ? 'Poppins-SemiBold'
//                                           : 'Poppins-Light',
//                                       fontWeight: tracking
//                                           ? FontWeight.w600
//                                           : FontWeight.w400),
//                                 ),
//                                 const SizedBox(
//                                   height: 5,
//                                 ),
//                                 Container(
//                                   height: 2,
//                                   width: tracking ? 75 : 0,
//                                   color: const Color(0xFFFFC53E),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Flexible(
//                         flex: 1,
//                         child: Container(
//                           // height: 32,
//                           width: 1,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Flexible(
//                         flex: 3,
//                         child: Theme(
//                           data: ThemeData(
//                             splashFactory: NoSplash.splashFactory,
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                           ),
//                           child: ListTile(
//                             onTap: () {
//                               tracking = false;
//                               setState(() {});
//                             },
//                             title: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 7.0),
//                                   child: Text(
//                                     'Bus Info'.tr,
//                                     style: TextStyle(
//                                         color: const Color(0xFF432B72),
//                                         fontSize: 17,
//                                         fontFamily: tracking
//                                             ? 'Poppins-Light'
//                                             : 'Poppins-SemiBold',
//                                         fontWeight: tracking
//                                             ? FontWeight.w400
//                                             : FontWeight.w600),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 4,
//                                 ),
//                                 Container(
//                                   height: 2,
//                                   width: tracking ? 0 : 75,
//                                   color: const Color(0xFFFFC53E),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 6,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 1,
//                   color: const Color(0xFFD8D8D8),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 tracking
//                     ? Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // children.isNotEmpty?
//                             Text.rich(
//                               TextSpan(children: [
//                                 TextSpan(
//                                   text: '$remainingTime', // Use the dynamic value here
//                                   style: TextStyle(
//                                     color: Color(0xFF993D9A),
//                                     fontSize: 29.71,
//                                     fontFamily: 'Poppins-Medium',
//                                     fontWeight: FontWeight.w700,
//                                     height: 1.23,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: ' Min.'.tr,
//                                   style: TextStyle(
//                                     color: Color(0xFF993D9A),
//                                     fontSize: 29.71,
//                                     fontFamily: 'Poppins-Medium',
//                                     fontWeight: FontWeight.w700,
//                                     height: 1.23,
//                                   ),
//                                 ),
//                               ]),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'To arrive'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 24.12,
//                                 fontFamily: 'Poppins-Light',
//                                 fontWeight: FontWeight.w300,
//                                 height: 1.23,
//                               ),
//                             ),
//                              SizedBox(
//                               height: 30,
//                             ),
//                             // Stack(
//                             //   children: [
//                             //     ListView.separated(
//                             //       shrinkWrap: true,
//                             //       physics: NeverScrollableScrollPhysics(),
//                             //       itemBuilder: (context, index) {
//                             //         List children = data[index]['children'];
//                             //         if (index == data.length-1 ) {
//                             //           return Row(
//                             //             children: [
//                             //               (sharedpref?.getString('lang') == 'ar')?
//                             //               Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),):
//                             //               Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),),
//                             //               Column(
//                             //                 children: [
//                             //                   Image.asset(
//                             //                     'assets/images/Ellipse 6.png',
//                             //                     width: 50,
//                             //                     height: 50,
//                             //                   ),
//                             //                 ],
//                             //               ),
//                             //               const SizedBox(
//                             //                 width: 15,
//                             //               ),
//                             //               Column(
//                             //                 mainAxisAlignment: MainAxisAlignment.start,
//                             //                 crossAxisAlignment: CrossAxisAlignment.start,
//                             //                 children: [
//                             //                   for (var child in children)
//                             //                   Text(
//                             //                     '${child['name']}',
//                             //                     style: TextStyle(
//                             //                       color: Color(0xFF442B72),
//                             //                       fontSize: 15,
//                             //                       fontFamily: 'Poppins-SemiBold',
//                             //                       fontWeight: FontWeight.w600,
//                             //                       height: 1.07,
//                             //                     ),
//                             //                   ),
//                             //                   SizedBox(
//                             //                     height: 3,
//                             //                   ),
//                             //                   Text.rich(
//                             //                     TextSpan(
//                             //                         children: [
//                             //                           TextSpan(
//                             //                             text: 'arrived :'.tr,
//                             //                             style: TextStyle(
//                             //                               color: Color(0xFF13DB63),
//                             //                               fontSize: 13,
//                             //                               fontFamily: 'Poppins-Regular',
//                             //                               fontWeight: FontWeight.w400,
//                             //                               height: 1.23,
//                             //                             ),
//                             //                           ),
//                             //                           TextSpan(
//                             //                             text: ' 7:45 '.tr,
//                             //                             style: TextStyle(
//                             //                               color: Color(0xFF13DB63),
//                             //                               fontSize: 13,
//                             //                               fontFamily: 'Poppins-Regular',
//                             //                               fontWeight: FontWeight.w400,
//                             //                               height: 1.23,
//                             //                             ),
//                             //                           ),
//                             //                           TextSpan(
//                             //                             text: 'AM'.tr,
//                             //                             style: TextStyle(
//                             //                               color: Color(0xFF13DB63),
//                             //                               fontSize: 13,
//                             //                               fontFamily: 'Poppins-Regular',
//                             //                               fontWeight: FontWeight.w400,
//                             //                               height: 1.23,
//                             //                             ),
//                             //                           ),]
//                             //                     ),),
//                             //                 ],
//                             //               ),
//                             //             ],
//                             //           );
//                             //         }
//                             //         else if (index == 0 ) {
//                             //           return Row(
//                             //             children: [
//                             //               (sharedpref?.getString('lang') == 'ar')?
//                             //               Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),):
//                             //               Text(' - - -' , style: TextStyle(color: Color(0xffFFC53E),),),
//                             //               Column(
//                             //                 children: [
//                             //                   Padding(
//                             //                     padding: (sharedpref?.getString('lang') == 'ar')?
//                             //                     EdgeInsets.only(right: 5.0):
//                             //                     EdgeInsets.only(left: 0.0),
//                             //                     child: Image.asset(
//                             //                       'assets/images/Ellipse 6.png',
//                             //                       width: 50,
//                             //                       height: 50,
//                             //                     ),
//                             //                   ), SizedBox(
//                             //                     // width: 15,
//                             //                     height: 20,
//                             //                     child: Padding(
//                             //                       padding: (sharedpref?.getString('lang') == 'ar')?
//                             //                       EdgeInsets.only(right: 1.0):
//                             //                       EdgeInsets.only(left: 1.0),
//                             //                       child: DottedLine(
//                             //                         direction: Axis.vertical,
//                             //                         dashColor: Color(0xFF432B72),
//                             //                       ),
//                             //                     ),
//                             //                   )
//                             //                 ],
//                             //               ),
//                             //               const SizedBox(
//                             //                 width: 15,
//                             //               ),
//                             //               SizedBox(
//                             //                 height:0,
//                             //                 child: Column(
//                             //                   mainAxisAlignment: MainAxisAlignment.start,
//                             //                   crossAxisAlignment: CrossAxisAlignment.start,
//                             //                   children: [
//                             //                     for (var child in children)
//                             //                       Text(
//                             //                         '${child['name']}',
//                             //                         style: TextStyle(
//                             //                           color: Color(0xFF442B72),
//                             //                           fontSize: 15,
//                             //                           fontFamily: 'Poppins-SemiBold',
//                             //                           fontWeight: FontWeight.w600,
//                             //                           height: 1.07,
//                             //                         ),
//                             //                     ),
//                             //                     SizedBox(
//                             //                       height: 3,
//                             //                     ),
//                             //                     Text(
//                             //                       'arrived : 7:45 AM'.tr,
//                             //                       style: TextStyle(
//                             //                         color: Color(0xFF13DB63),
//                             //                         fontSize: 13,
//                             //                         fontFamily: 'Poppins-Regular',
//                             //                         fontWeight: FontWeight.w400,
//                             //                         height: 1.23,
//                             //                       ),
//                             //                     ),
//                             //                   ],
//                             //                 ),
//                             //               ),
//                             //             ],
//                             //           );
//                             //         }
//                             //         else {
//                             //           return Row(
//                             //             children: [
//                             //               Padding(
//                             //                 padding:
//                             //                 (sharedpref?.getString('lang') == 'ar')?
//                             //                 EdgeInsets.only(right: 25.0):
//                             //                 EdgeInsets.only(left: 25.0),
//                             //                 child: Image.asset(
//                             //                   'assets/images/Ellipse 6.png',
//                             //                   width: 50,
//                             //                   height: 50,
//                             //                 ),
//                             //               ),
//                             //               const SizedBox(
//                             //                 width: 15,
//                             //               ),
//                             //               Column(
//                             //                 mainAxisAlignment: MainAxisAlignment.start,
//                             //                 crossAxisAlignment: CrossAxisAlignment.start,
//                             //                 children: [
//                             //                   for (var child in children)
//                             //                     Text(
//                             //                       '${child['name']}',
//                             //                     style: TextStyle(
//                             //                       color: Color(0xFF442B72),
//                             //                       fontSize: 15,
//                             //                       fontFamily: 'Poppins-SemiBold',
//                             //                       fontWeight: FontWeight.w600,
//                             //                       height: 1.07,
//                             //                     ),
//                             //                   ),
//                             //                   SizedBox(
//                             //                     height: 3,
//                             //                   ),
//                             //                   Text(
//                             //                     'arrived : 7:45 AM'.tr,
//                             //                     style: TextStyle(
//                             //                       color: Color(0xFF13DB63),
//                             //                       fontSize: 13,
//                             //                       fontFamily: 'Poppins-Regular',
//                             //                       fontWeight: FontWeight.w400,
//                             //                       height: 1.23,
//                             //                     ),
//                             //                   ),
//                             //                 ],
//                             //               ),
//                             //             ],
//                             //           );
//                             //         }
//                             //       },
//                             //       separatorBuilder: (context, index) {
//                             //         if(index == 0) {return
//                             //           SizedBox(
//                             //             height: 0,
//                             //           );
//                             //         }else{
//                             //           return  SizedBox(
//                             //             height: 20,
//                             //           );}
//                             //       },
//                             //       itemCount: data.length,
//                             //     ),
//                             //
//                             //   ],
//                             // ) ,
//                             Stack(
//                               children: [
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: data.length,
//                                   itemBuilder: (BuildContext context, int index) {
//
//                                     List children = data[index]['children'];
//                                     if (data.isEmpty) {
//                                       Container();
//                                     } else
//                                       return Column(
//                                         children: [
//                                           for (var child in children)
//                                             // if (child['supervisor'] == sharedpref!.getString('id').toString())
//
//                                               if (index == data.length - 1 ||
//                                                 index == 0 )
//                                               // if (child['supervisor'] == sharedpref!.getString('id').toString())
//                                                 SizedBox(
//                                                 width: double.infinity,
//                                                 height: 70, //92
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     (sharedpref?.getString('lang') == 'ar')
//                                                         ? Text('- - -', style: TextStyle(
//                                                               color: Color(0xffFFC53E),),)
//                                                         : Padding(padding:
//                                                             const EdgeInsets.only(top: 15.0),
//                                                             child: Text(' - - -',
//                                                               style: TextStyle(color: Color(0xffFFC53E),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                     // FutureBuilder(
//                                                     //   future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
//                                                     //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//                                                     //     if (snapshot.hasError) {
//                                                     //       return Text('Something went wrong');
//                                                     //     }
//                                                     //
//                                                     //     if (snapshot.connectionState == ConnectionState.done) {
//                                                     //       if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
//                                                     //         return CircleAvatar(
//                                                     //           radius: 25,
//                                                     //           backgroundColor: Color(0xff442B72),
//                                                     //           child: CircleAvatar(
//                                                     //             backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                     //             radius: 25,
//                                                     //           ),
//                                                     //         );
//                                                     //       }
//                                                     //
//                                                     //       Map<String, dynamic>? data = snapshot.data?.data();
//                                                     //       if (data != null && data['busphoto'] != null) {
//                                                     //         return CircleAvatar(
//                                                     //           radius: 25,
//                                                     //           backgroundColor: Color(0xff442B72),
//                                                     //           child: CircleAvatar(
//                                                     //             backgroundImage: NetworkImage('${data['busphoto']}'),
//                                                     //             radius:25,
//                                                     //           ),
//                                                     //         );
//                                                     //       }
//                                                     //     }
//                                                     //
//                                                     //     return Container();
//                                                     //   },
//                                                     // ),
//                                                     CircleAvatar(
//                                                       radius: 25,
//                                                       backgroundColor: Color(0xff442B72),
//                                                       child: CircleAvatar(
//                                                         backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                         radius: 25,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       width: 15,
//                                                     ),
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 10.0),
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           // for (var child in children)
//                                                           // if (child['supervisor'] == sharedpref!.getString('id').toString())
//                                                             Text(
//                                                             '${child['name']}',
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xFF442B72),
//                                                               fontSize: 15,
//                                                               fontFamily:
//                                                               'Poppins-SemiBold',
//                                                               fontWeight:
//                                                               FontWeight.w600,
//                                                               height: 1.07,
//                                                             ),
//                                                           ),
//
//                                                           SizedBox(
//                                                             height: 3,
//                                                           ),
//
//                                                           hasArrived?
//                                                           Text.rich(
//                                                             TextSpan(children:
//                                                             [
//
//
//                                                               TextSpan(
//                                                                 text: 'arrived :'
//                                                                     .tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                       'Poppins-Regular',
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text: ' $arrivalTime '.tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                       'Poppins-Regular',
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text: 'AM'.tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                       'Poppins-Regular',
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               )
//                                                             ]),
//                                                           ) :
//                                                           Text(
//                                   'not yet'.tr,
//                                     style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 13,
//                                     fontFamily: 'Poppins-Regular',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.23,
//                                     ),)
//                                                         ],
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               )
//                                             else
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 23.0),
//                                                 child: SizedBox(
//                                                   width: double.infinity,
//                                                   height: 70, //92
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                     children: [
//                                                       // FutureBuilder(
//                                                       //   future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
//                                                       //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//                                                       //     if (snapshot.hasError) {
//                                                       //       return Text('Something went wrong');
//                                                       //     }
//                                                       //
//                                                       //     if (snapshot.connectionState == ConnectionState.done) {
//                                                       //       if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
//                                                       //         return CircleAvatar(
//                                                       //           radius: 25,
//                                                       //           backgroundColor: Color(0xff442B72),
//                                                       //           child: CircleAvatar(
//                                                       //             backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                       //             radius: 25,
//                                                       //           ),
//                                                       //         );
//                                                       //       }
//                                                       //
//                                                       //       Map<String, dynamic>? data = snapshot.data?.data();
//                                                       //       if (data != null && data['busphoto'] != null) {
//                                                       //         return CircleAvatar(
//                                                       //           radius: 25,
//                                                       //           backgroundColor: Color(0xff442B72),
//                                                       //           child: CircleAvatar(
//                                                       //             backgroundImage: NetworkImage('${data['busphoto']}'),
//                                                       //             radius:25,
//                                                       //           ),
//                                                       //         );
//                                                       //       }
//                                                       //     }
//                                                       //
//                                                       //     return Container();
//                                                       //   },
//                                                       // ),
//                                                       CircleAvatar(
//                                                         radius: 25,
//                                                         backgroundColor: Color(0xff442B72),
//                                                         child: CircleAvatar(
//                                                           backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                           radius: 25,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             '${child['name']}',
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xFF442B72),
//                                                               fontSize: 15,
//                                                               fontFamily:
//                                                                   'Poppins-SemiBold',
//                                                               fontWeight:
//                                                                   FontWeight.w600,
//                                                               height: 1.07,
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 3,
//                                                           ),
//                                                           hasArrived?
//                                                           Text.rich(
//                                                             TextSpan(children:
//                                                             [
//
//
//                                                               TextSpan(
//                                                                 text: 'arrived :'
//                                                                     .tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                   'Poppins-Regular',
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text: ' $arrivalTime '.tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                   'Poppins-Regular',
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text: 'AM'.tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(
//                                                                       0xFF13DB63),
//                                                                   fontSize: 13,
//                                                                   fontFamily:
//                                                                   'Poppins-Regular',
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                                   height: 1.23,
//                                                                 ),
//                                                               )
//                                                             ]),
//                                                           ) :
//                                                           Text(
//                                                             'not yet'.tr,
//                                                             style: TextStyle(
//                                                               color: Colors.red,
//                                                               fontSize: 13,
//                                                               fontFamily: 'Poppins-Regular',
//                                                               fontWeight: FontWeight.w400,
//                                                               height: 1.23,
//                                                             ),)
//                                                         ],
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                         ],
//                                       );
//                                   },
//                                 ),
//                                 (sharedpref?.getString('lang') == 'ar')
//                                     ? Positioned(
//                                         left: 299,
//                                         top: 35,
//                                         bottom: 85,
//                                         child: buildDashedLine(),
//                                       )
//                                     : Positioned(
//                                         top: 28,
//                                         bottom: 105,
//                                         child: buildDashedLine(),
//                                       )
//                               ],
//                             ),
//
//                             //     :
//                             // Container()
//                           ],
//                         ),
//                       )
//                     :
//                     // children.isNotEmpty?
//                     Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20.0),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Bus Number'.tr,
//                                         style: TextStyle(
//                                           color: Color(0xFF432B72),
//                                           fontSize: 17,
//                                           fontFamily: 'Poppins-SemiBold',
//                                           fontWeight: FontWeight.w600,
//                                           height: 0.94,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       Text(
//                                         '$_busnumber',
//                                         textDirection:
//                                             _getTextDirection(" 1458ى ر س "),
//                                         style: TextStyle(
//                                           color: Color(0xFF919191),
//                                           fontSize: 17,
//                                           fontFamily: 'Roboto-Regular',
//                                           fontWeight: FontWeight.w400,
//                                           height: 0.89,
//                                         ),
//                                         overflow: TextOverflow.ellipsis, //,
//                                       ),
//                                     ],
//                                   ),
//
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Driver Name'.tr,
//                                         style: TextStyle(
//                                           color: Color(0xFF432B72),
//                                           fontSize: 17,
//                                           fontFamily: 'Poppins-SemiBold',
//                                           fontWeight: FontWeight.w600,
//                                           height: 0.94,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 12,
//                                       ),
//                                       Text(
//                                         _namedriver,
//                                         style: TextStyle(
//                                           color: Color(0xFF919191),
//                                           fontSize: 18,
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           height: 0.89,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 30,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 22.0),
//                                 child: Text(
//                                   'Bus photos'.tr,
//                                   style: TextStyle(
//                                     color: Color(0xFF432B72),
//                                     fontSize: 17,
//                                     fontFamily: 'Poppins-SemiBold',
//                                     fontWeight: FontWeight.w600,
//                                     height: 0.94,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 22.0),
//                                 child: Container(
//                                     height: 170,
//                                     child: ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: <Widget>[
//                                         InteractiveViewer(
//                                             child:(_photobus == null || _photobus == '') ?
//                                             Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                                             Image.network(_photobus!,width: 144,height: 154.42,fit: BoxFit.cover,)
//                                         ),
//
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         // InteractiveViewer(
//                                         //     child:(_photobus == null || _photobus == '') ?
//                                         //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                                         //     Image.network(_photobus!,width: 104,height: 111.53,)
//                                         // ),
//                                         // SizedBox(
//                                         //   width: 10,
//                                         // ),
//                                         // InteractiveViewer(
//                                         //     child:(_photobus == null || _photobus == '') ?
//                                         //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                                         //     Image.network(_photobus!,width: 104,height: 111.53,)
//                                         // ),
//                                         // SizedBox(
//                                         //   width: 10,
//                                         // ),
//                                         // InteractiveViewer(
//                                         //     child:(_photobus == null || _photobus == '') ?
//                                         //     Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
//                                         //     Image.network(_photobus!,width: 104,height: 111.53,)
//                                         // ),
//                                       ],
//                                     )),
//                               ),
//                               SizedBox(
//                                 height: 44,
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                 //     :
//                 // Column(
//                 //   children: [
//                 //     SizedBox(height: 30,),
//                 //     Center(
//                 //       child: Image.asset('assets/images/nodata.png',
//                 //       width: 235,
//                 //       height:149),
//                 //     ),
//                 //     Text('No data found',
//                 //       style: TextStyle(
//                 //           color: Color(0xFF442B72),
//                 //           fontSize: 19,
//                 //           fontFamily: 'Poppins-Regular',
//                 //           fontWeight: FontWeight.w500,
//                 //           height: 0.38
//                 //       ),),
//                 //   ],
//                 // ),
//                 // SizedBox(height: 20,),
//                 // const SizedBox(
//                 //   height: 25,
//                 // ),
//                 // ElevatedButton(
//                 //     onPressed: (){
//                 //       Navigator.of(context).push(MaterialPageRoute(
//                 //           builder: (context) => TrackHaveData(
//                 //             // onTapMenu: onTapMenu
//                 //           )));
//                 // //     }, child: Text('if we have data')),
//                 ,
//                 const SizedBox(
//                   height: 90,
//                 ),
//               ],
//             ),
//           ),
//         ),
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
//                       // onTapMenu: onTapMenu
//                       )));
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
//                                 BorderRadius.all(Radius.circular(50)))),
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
//                                       (sharedpref?.getString('lang') == 'ar')
//                                           ? EdgeInsets.only(top: 7, right: 15)
//                                           : EdgeInsets.only(left: 15),
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
//                                       (sharedpref?.getString('lang') == 'ar')
//                                           ? EdgeInsets.only(top: 9, left: 50)
//                                           : EdgeInsets.only(right: 50, top: 2),
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
//                                       (sharedpref?.getString('lang') == 'ar')
//                                           ? EdgeInsets.only(
//                                               top: 12, bottom: 4, right: 10)
//                                           : EdgeInsets.only(
//                                               top: 8, bottom: 4, left: 20),
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
//                                         top: 10, bottom: 2, right: 10, left: 0)
//                                     : EdgeInsets.only(
//                                         top: 8, bottom: 2, left: 0, right: 10),
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
//   // Widget DashedLineInList() {
//   //   // double lineLength = students.length * 5;
//   //   return Padding(
//   //     padding: const EdgeInsets.only( left: 15.0),
//   //     child: DottedLine(
//   //       alignment: WrapAlignment.end,
//   //       // lineLength: lineLength,
//   //       direction: Axis.vertical,
//   //       dashColor: Color(0xFF432B72),
//   //     ),
//   //   );
//   // }
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
// }

// class DrawDottedHorizontalLine extends CustomPainter {
//   late Paint _paint;
//
//   DrawDottedHorizontalLine() {
//     _paint = Paint()
//       ..color = Colors.black //dots color
//       ..strokeWidth = 2 //dots thickness
//       ..strokeCap = StrokeCap.square; //dots corner edges
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (double i = -300; i < 300; i = i + 15) {
//       // 15 is space between dots
//       if (i % 3 == 0)
//         canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
