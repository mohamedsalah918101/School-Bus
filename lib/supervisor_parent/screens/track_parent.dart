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
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:label_marker/label_marker.dart';



import '../components/custom_app_bar.dart';

class TrackParent extends StatefulWidget {
  @override
  _TrackParentState createState() => _TrackParentState();
}

class _TrackParentState extends State<TrackParent> {
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
    await getBytesFromAsset("assets/images/bus 1.png", 120);
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
    return Scaffold(
      endDrawer: ParentDrawer(),
        key: _scaffoldKey,
        appBar:PreferredSize(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color:  Color(0x3F000000),
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
                onTap: (){
                  Navigator.of(context).pop();
                },
                 child: Padding(
                   padding: (sharedpref?.getString('lang') == 'ar')?
                    EdgeInsets.all( 23.0):
                    EdgeInsets.all( 17.0),
                   child: Image.asset(
                     (sharedpref?.getString('lang') == 'ar')?
                     'assets/images/Layer 1.png':
                     'assets/images/fi-rr-angle-left.png',
                     width: 10,
                     height: 22,),
                 ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                  GestureDetector(
                    onTap: (){
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
              title: Text('Tracking Bus'.tr ,
                style: const TextStyle(
                  color: Color(0xFF993D9A),
                  fontSize: 17,
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),),
              backgroundColor:  Color(0xffF8F8F8),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          preferredSize: Size.fromHeight(70),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 350,
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

                markers.add(
                    Marker(
                      markerId: const MarkerId('marker_1'),
                      position: const LatLng(27.1778429, 31.1859626),
                      icon: customIcon,
                      infoWindow:
                      // children.isNotEmpty?
                      InfoWindow(
                      title: 'Mariam Tarek'
            ),
                        onTap: (){
                        print('object');
                        }
                          //   :
                          // InfoWindow()
          ),
        );
                    markers.add(
                      Marker(
                        // consumeTapEvents: true,
                        markerId: const MarkerId('marker_2'),
                        position: const LatLng(27.190000, 31.200000),
                        icon: anotherCustomIcon,
                        infoWindow:
                            // children.isNotEmpty?
                        InfoWindow(
                          title: 'Ahmed Tarek'.tr,
                          // anchor: Offset(0, 0),
                          // snippet: '',
                          // backgroundColor: Colors.transparent,
                        )
                              // :
                              //   InfoWindow()
                      ),
                    );
                setState(() {});

                  }),
                ),

              ),
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
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Mariam',
                                    style: TextStyle(
                              color: const Color(0xFF432B72),
                            fontSize: 16,
                            fontFamily: tracking
                                ? 'Poppins-SemiBold'
                                : 'Poppins-Light' ,
                            fontWeight: tracking
                                ? FontWeight.w600
                                : FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: ' Tracking'.tr,
                                      style: TextStyle(
                                          color: const Color(0xFF432B72),
                                          fontSize: 16,
                                          fontFamily: tracking
                                              ? 'Poppins-SemiBold'
                                              : 'Poppins-Light' ,
                                          fontWeight: tracking
                                              ? FontWeight.w600
                                              : FontWeight.w400),
                                    )
                                  ]
                                )
                              ),
                              // Text(
                              //   'Mariam Tracking'.tr,

                              // ),
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
                                padding: const EdgeInsets.only(left:7.0),
                                child: Text(
                                  'Bus Info'.tr,
                                  style: TextStyle(
                                      color: const Color(0xFF432B72),
                                      fontSize: 17,
                                      fontFamily: tracking
                                          ? 'Poppins-Light'
                                          : 'Poppins-SemiBold' ,
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
                height: 25, //testttttttttttttt
              ),
              tracking
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // children.isNotEmpty?
                          Text.rich(
                          TextSpan(
                          children: [
                            TextSpan(
                            text: '25 ',
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 29.71,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w700,
                              height: 1.23,
                            ),
                          ),
                          TextSpan(
                            text: 'Min.'.tr,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 29.71,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w700,
                              height: 1.23,
                            ),
                          ),]
                      ),),
                                    //     :
                                    // Text(
                                    //   '0 Min.'.tr,
                                    //   style: TextStyle(
                                    //     color: Color(0xFF993D9A),
                                    //     fontSize: 29.71,
                                    //     fontFamily: 'Poppins-Medium',
                                    //     fontWeight: FontWeight.w700,
                                    //     height: 1.23,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Arrive to you.'.tr,
                                      style: TextStyle(
                                        color: Color(0xFF442B72),
                                        fontSize: 24.12,
                                        fontFamily: 'Poppins-Light',
                                        fontWeight: FontWeight.w300,
                                        height: 1.23,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/Vector (13)call.png',
                                width: 30,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Container(
                                height: 46,
                                width: 1,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Image.asset(
                                'assets/images/fi-rr-comment-alt (1).png',
                                width: 20,
                                height: 20,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                         // children.isNotEmpty?
                         Stack(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (index == 19 ) {
                                    return Row(
                                      children: [
                                        (sharedpref?.getString('lang') == 'ar')?
                                        Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),):
                                        Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),),
                                        Column(
                                          children: [
                                            Image.asset(
                                              'assets/images/Ellipse 6.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Manar Ali'.tr,
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
                                            Text(
                                              'arrived : 7:45 AM'.tr,
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
                                      ],
                                    );
                                  }
                                  else if (index == 0 ) {
                                    return Row(
                                      children: [
                                        (sharedpref?.getString('lang') == 'ar')?
                                        Text('- - -' , style: TextStyle(color: Color(0xffFFC53E),),):
                                        Text(' - - -' , style: TextStyle(color: Color(0xffFFC53E),),),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: (sharedpref?.getString('lang') == 'ar')?
                                              EdgeInsets.only(right: 5.0):
                                              EdgeInsets.only(left: 0.0),
                                              child: Image.asset(
                                                'assets/images/Ellipse 6.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                            ), SizedBox(
                                              // width: 15,
                                              height: 20,
                                              child: Padding(
                                                padding: (sharedpref?.getString('lang') == 'ar')?
                                                EdgeInsets.only(right: 1.0):
                                                EdgeInsets.only(left: 1.0),
                                                child: DottedLine(
                                                  direction: Axis.vertical,
                                                  dashColor: Color(0xFF432B72),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          height:50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Manar Ali'.tr,
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
                                              Text(
                                                'arrived : 7:45 AM'.tr,
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
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding:
                                    (sharedpref?.getString('lang') == 'ar')?
                                    EdgeInsets.only(right: 25.0):
                                    EdgeInsets.only(left: 25.0),
                                          child: Image.asset(
                                            'assets/images/Ellipse 6.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Manar Ali'.tr,
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
                                            Text(
                                              'arrived : 7:45 AM'.tr,
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
                                      ],
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  if(index == 0) {return
                                    SizedBox(
                                    height: 0,
                                  );
                                }else{
                                  return  SizedBox(
                                    height: 20,
                                  );}
                                },
                                itemCount: 20,
                              ),
                              (sharedpref?.getString('lang') == 'ar')?
                              Positioned(
                                left: 299,
                                top: 35,
                                bottom: 85,
                                child: buildDashedLine(),
                              ):
                              Positioned(
                                top: 35,
                                bottom: 85,
                                child: buildDashedLine(),
                              )
                            ],
                          )
                         //     :
                         // Container()
                        ],
                      ),
                    )
                  :
              // children.isNotEmpty?
              Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      " 1458 ى ر س ",
                                      textDirection: _getTextDirection(" 1458ى ر س "),
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
                                SizedBox(width: 65,),
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
                                      'Ahmed Emad'.tr,
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
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Bus photos'.tr,
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
                            Container(
                                height: 170,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                Image.asset('assets/images/photo container (1).png',
                                        width: 144, height: 154.42,),
                                        SizedBox(width: 10,),
                                        Image.asset('assets/images/photo container.png',
                                        width: 104, height: 111.53,),
                                    SizedBox(width: 10,),
                                    Image.asset('assets/images/Property 1=3.png',
                                        width: 104, height: 111.53,),
                                        SizedBox(width: 10,),
                                        Image.asset('assets/images/Property 1=4.png',
                                        width:104, height: 111.53,),
                                  ],
                                )
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            //   child: Row(
                            //     children: [
                            //       Image.asset('assets/images/Frame 135.png',
                            //       width: 56, height: 51,),
                            //       SizedBox(width: 10,),
                            //       Image.asset('assets/images/Frame 136.png',
                            //       width: 56, height: 51,),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 44,)
                          ],
                        ),
                      ),
                    )
              //     :
              // Column(
              //   children: [
              //     SizedBox(height: 30,),
              //     Center(
              //       child: Image.asset('assets/images/nodata.png',
              //       width: 235,
              //       height:149),
              //     ),
              //     Text('No data found',
              //       style: TextStyle(
              //           color: Color(0xFF442B72),
              //           fontSize: 19,
              //           fontFamily: 'Poppins-Regular',
              //           fontWeight: FontWeight.w500,
              //           height: 0.38
              //       ),),
              //   ],
              // ),
              // SizedBox(height: 20,),
              // const SizedBox(
              //   height: 25,
              // ),
              // ElevatedButton(
              //     onPressed: (){
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (context) => TrackHaveData(
              //             // onTapMenu: onTapMenu
              //           )));
              // //     }, child: Text('if we have data')),
             , const SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)),
            backgroundColor: Color(0xff442B72),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileParent(
                    // onTapMenu: onTapMenu
                  )));
            },
            child: Image.asset(
              'assets/images/174237 1.png',
              height: 33,
              width: 33,
            fit: BoxFit.cover,
          )

        ),
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
                                              HomeParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top:7 , right: 15):
                                  EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20
                                      ),
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
                                              NotificationsParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 7, left: 70):
                                  EdgeInsets.only( right: 70 ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 16.56,
                                          width: 16.2
                                      ),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6
                                      ),
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
                              GestureDetector(
                             onTap: () {
                    setState(() {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                        AttendanceParent()),
                    );
                    });
                    },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                  EdgeInsets.only(top: 10 , bottom:4 ,left: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (3).png',
                                          height: 18.75,
                                          width: 18.75
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Calendar".tr,
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
                                padding:
                                (sharedpref?.getString('lang') == 'ar')?
                                EdgeInsets.only(top: 10 , bottom: 2 ,right: 12,left: 15):
                                EdgeInsets.only(top: 10 , bottom: 2 ,left: 12,right: 15),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/images/icons8_bus 1 (1).png',
                                        height: 22,
                                        width: 25
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "Track".tr,
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
  // Widget DashedLineInList() {
  //   // double lineLength = students.length * 5;
  //   return Padding(
  //     padding: const EdgeInsets.only( left: 15.0),
  //     child: DottedLine(
  //       alignment: WrapAlignment.end,
  //       // lineLength: lineLength,
  //       direction: Axis.vertical,
  //       dashColor: Color(0xFF432B72),
  //     ),
  //   );
  // }
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

class DrawDottedHorizontalLine extends CustomPainter {
  late Paint _paint;

  DrawDottedHorizontalLine() {
    _paint = Paint()
      ..color = Colors.black //dots color
      ..strokeWidth = 2 //dots thickness
      ..strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -300; i < 300; i = i + 15) {
      // 15 is space between dots
      if (i % 3 == 0)
        canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
