import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_account/supervisor_parent/components/child_data_item.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/map_parent_second.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:label_marker/label_marker.dart';
import '../components/custom_app_bar.dart';

class MapParentScreen extends StatefulWidget {
  @override
  _MapParentScreenState createState() => _MapParentScreenState();
}

class _MapParentScreenState extends State<MapParentScreen> {
  late final String title;
  // List<ChildDataItem> children = [];
  bool tracking = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Set<Marker> markers = {};
  GoogleMapController? controller;
  LatLng startLocation = const LatLng(27.1778429, 31.1859626);
  BitmapDescriptor myIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    loadCustomIcon();
  }
  //
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor anotherCustomIcon = BitmapDescriptor.defaultMarker;

  Future<void> loadCustomIcon() async {
    final Uint8List imageData =
    await getBytesFromAsset("assets/images/bus 1.png", 90);
    customIcon = BitmapDescriptor.fromBytes(imageData);

    final Uint8List imageData2 = await getBytesFromAsset("assets/images/yellow_bus_2.png", 90);
    anotherCustomIcon = BitmapDescriptor.fromBytes(imageData2);

    setState(() {});
  }

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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    scrollGesturesEnabled: true,
                    gestureRecognizers: Set()
                      ..add(Factory<EagerGestureRecognizer>(() =>
                          EagerGestureRecognizer())),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(27.180134, 31.189283),
                      zoom: 12,
                    ),
                    markers: markers,
                    onMapCreated: ((mapController) {
                      setState(() {
                        controller = mapController;
                      });
                      setState(() {});

                    }),
                  )

                ),
                 Positioned(
                   bottom: 70,
                    right: 40,
                    child:  ElevatedSimpleButton(
                      txt: 'Set home location'.tr,
                      width: 278,
                      hight: 48,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              MapParentToHomeScreen()),);
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',

                    ),),
                (sharedpref?.getString('lang') == 'ar')?
                Positioned(
                  top: 20,
                  right: 15,
                  child:   GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child:  Image.asset(
                      'assets/images/Layer 1.png',
                    width: 22,
                    height: 22,),
                  ),):
                Positioned(
                  top: 20,
                  left: 15,
                  child:   GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child:  Image.asset(
                      'assets/images/fi-rr-angle-left.png',
                      width: 22,
                      height: 22,),
                  ),),
                Positioned(
                  top: 65,
                  right: 25,
                  child:  SizedBox(
                    width: 312,
                    height: 42,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search Name".tr,
                        hintStyle: TextStyle(
                            color: const Color(0xffC2C2C2),
                            fontSize: 12,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left:5 ,top: 12.0, bottom: 10),
                          child: Image.asset('assets/images/Vector (12)search.png',
                           ),
                        ),
                      ),
                    ),
                  ),),
              ],
            ),
          ),
      ),
    );
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
