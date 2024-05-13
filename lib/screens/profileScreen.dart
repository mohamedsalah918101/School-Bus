import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/screens/editeProfile.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import '../components/home_drawer.dart';
import '../main.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'notificationsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math' as math;


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  bool isEditingProfile = false;
  List<QueryDocumentSnapshot> data = [];
  File ? _selectedImageProfile;
  String? profileimageUrl;
  Future _pickProfileImageFromGallery() async{
    final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage ==null) return;
    setState(() {
      _selectedImageProfile=File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = FirebaseStorage.instance.ref().child('profilephoto');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =referenceDirImages.child('profile');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored


    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      profileimageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $profileimageUrl');
      return profileimageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }
  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('schooldata').get();
    data.addAll(querySnapshot.docs);
    setState(() {
      data = querySnapshot.docs;
    });
   }
  late User? currentUser;
  late User? _currentUser;

  late String? _currentId;
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    // supervisorsStream = FirebaseFirestore.instance.collection('supervisor').snapshots();
    // responsible
    getData();
    //getDocumentData(currentId!);
    //getUserProfileData();
    // setState(() {
    //   filteredData = data;
    // });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _getCurrentIdFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currentId = prefs.getString('id');
  }
   String? currentId;
  Future<void> getCurrentIdFromSharedPreferences() async {
    // Call the getCurrentId() function to retrieve the current ID
    String? id = await getCurrentId();

    // Update the state with the retrieved ID
    setState(() {
      currentId = id;
    });
  }

  Future<DocumentSnapshot> getDocumentData(String documentId) async {
    return await FirebaseFirestore.instance.collection('schooldata').doc(documentId).get();
  }
  Future<String?> getCurrentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentId'); // Replace 'currentId' with your preference key
  }
  // void _editProfileDocumentFromSharedPreferences() async {
  //   String? currentId = await getCurrentId();
  //
  //   if (currentId != null) {
  //     // Retrieve other data associated with the current ID (e.g., from Firestore)
  //     // For example, you might have a function to fetch document data based on ID
  //     DocumentSnapshot snapshot = await getDocumentData(currentId);
  //
  //     // Use the retrieved data in the _editProfileDocument function
  //     _editProfileDocument(
  //       currentId,
  //       snapshot['nameEnglish'],
  //       snapshot['nameArabic'],
  //       snapshot['address'],
  //       snapshot['coordinatorName'],
  //       snapshot['supportNumber'],
  //       snapshot['photo'],
  //     );
  //   } else {
  //     // Handle case where current ID is not found in shared preferences
  //     print('Current ID not found in shared preferences');
  //   }
  // }

  void _editProfileDocument(String documentId, String nameenglish,
      String namearabic, String address,String coordinatorname,String supportnumbner,String schoollogo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditeProfile(
          docid: documentId,
          oldNameEnglish: nameenglish,
          oldNameArabic: namearabic,
          oldAddress: address,
            oldSchoolLogo:schoollogo,
            oldCoordinatorName:coordinatorname,
            oldSupportNumber:supportnumbner,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
        key: _scaffoldKey,
      endDrawer: HomeDrawer(),
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
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
            leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 23,
                color: Color(0xff442B72),
              ),

            ),
            //menu icon and drawer
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child:
            //     InkWell(
            //       onTap: (){
            //         _scaffoldKey.currentState!.openEndDrawer();
            //       },
            //       child: const Icon(
            //         Icons.menu_rounded,
            //         color: Color(0xff442B72),
            //         size: 35,
            //       ),
            //     ),
            //   ),
            // ],
            title: Text('Profile'.tr ,
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
        //Custom().customAppBar(context, 'Profile'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //
                //     Center(
                //       child: Stack(
                //         children: [
                //
                //           Center(
                //             child: Padding(
                //               padding: const EdgeInsets.only(top: 20),
                //               child: CircleAvatar(
                //                 backgroundColor: Colors.white, // Set background color to white
                //                 radius:50, // Set the radius according to your preference
                //                 child: Image.asset(
                //                   'assets/imgs/school/Ellipse 2 (2).png',
                //                   fit: BoxFit.cover,
                //                   width: 100, // Set width of the image
                //                   height: 100, // Set height of the image
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Center(
                //             child: Padding(
                //               padding: const EdgeInsets.only(top: 95,left: 55),
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   border: Border.all(width: 3,color: Color(0xff432B72))
                //                 ),
                //                 child: CircleAvatar(
                //                   backgroundColor: Colors.white,
                //                   // Set background color to white
                //                   radius:10, // Set the radius according to your preference
                //                   child: Image.asset(
                //                     'assets/imgs/school/edite.png',
                //                     fit: BoxFit.cover,
                //                     width: 15, // Set width of the image
                //                     height: 15, // Set height of the image
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ]
                //       ),
                //     ),
                //     SizedBox(width: 55,),
                //     ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=>EditeProfile()));
                //       },
                //       style: ElevatedButton.styleFrom(
                //         primary: Colors.white,
                //         //elevation: 4, // Change the elevation to adjust the shadow
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8.0),
                //             side: BorderSide(color: Color(0xff432B72))
                //
                //         ),
                //       ),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           // Icon(Icons.,color: Color(0xff432B72),),
                //           Transform(
                //               alignment: Alignment.center,
                //               transform: Matrix4.rotationY(math.pi),
                //               child: Icon(Icons.edit_outlined, color: Color(0xFF442B72),size: 20,)
                //           ),
                //           SizedBox(width: 8), // Adjust the spacing between icon and text
                //           Text('Edite',style: TextStyle(color: Color(0xff432B72),fontSize: 16,fontFamily: "Poppins-Regular"),), // Replace 'Button Text' with your desired text
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                //
                Stack(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 50,
                                      ); // Display error icon if fetch fails
                                    }

                                    if (snapshot.connectionState == ConnectionState.done) {
                                      Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                                      // Check if data contains photo URL
                                      if (data != null && data.containsKey('photo')) {
                                        return Image.network(
                                          data['photo'],
                                          fit: BoxFit.fill,
                                          width: 90,
                                          height: 90,
                                        );
                                      } else {
                                        return Image.asset(
                                          'assets/imgs/school/Ellipse 2 (2).png', // Default image if photo URL is missing
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        );
                                      }
                                    }

                                    return CircularProgressIndicator(); // Display loading indicator while fetching data
                                  },
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 95, left: 55),
                              child: GestureDetector(
                                onTap: () {
                                  Dialoge.changePhotoDialog(context); // Open photo change dialog on tap
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3, color: Color(0xff432B72)),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    child:
                                    // GestureDetector(
                                    //   onTap:()async {
                                    //     await _pickProfileImageFromGallery();}  , // Call function when tapped
                                    //   child: _selectedImageProfile != null
                                    //       ? Image.file(
                                    //     _selectedImageProfile!,  // Display the uploaded image
                                    //     width: 83,  // Set width as per your preference
                                    //     height: 78.5,  // Set height as per your preference
                                    //     fit: BoxFit.cover,  // Adjusts how the image fits in the container
                                    //   )
                                    //       :
                                    //   Container(
                                    //
                                    //     width: 65, // Adjust size as needed
                                    //     height: 65,
                                    //     decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //
                                    //       border: Border.all(
                                    //         color: Color(0xffCCCCCC), // Adjust border color
                                    //         width: 2, // Adjust border width
                                    //       ),
                                    //     ),
                                    //     child: Align(alignment: Alignment.bottomCenter,
                                    //       child: CircleAvatar(radius: 20,
                                    //
                                    //         backgroundImage: AssetImage("assets/imgs/school/Vector (14).png",)
                                    //         ,backgroundColor: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    GestureDetector(
                                      onTap: (){
                                        _pickProfileImageFromGallery();
                                      },
                                      child: Image.asset(
                                        'assets/imgs/school/edite.png',
                                        fit: BoxFit.cover,
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Center(
                    //   child: Stack(
                    //     children: [
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(top: 20),
                    //           child: CircleAvatar(
                    //             backgroundColor: Colors.white,
                    //             radius: 50,
                    //             child: Image.asset(
                    //               'assets/imgs/school/Ellipse 2 (2).png',
                    //               fit: BoxFit.cover,
                    //               width: 100,
                    //               height: 100,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(top: 95, left: 55),
                    //           child: GestureDetector(
                    //             onTap: (){
                    //               Dialoge.changePhotoDialog(context);
                    //             },
                    //             child: Container(
                    //
                    //               decoration: BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 border: Border.all(width: 3, color: Color(0xff432B72)),
                    //               ),
                    //               child: CircleAvatar(
                    //                 backgroundColor: Colors.white,
                    //                 radius: 10,
                    //
                    //                 child: Image.asset(
                    //                   'assets/imgs/school/edite.png',
                    //                   fit: BoxFit.cover,
                    //                   width: 15,
                    //                   height: 15,
                    //
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                      top:15,
                      right: 5,
                      child: ElevatedButton(
                         onPressed: () {
                        //   // String currentUserId = sharedpref!.getString('id');
                        //   // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                        //   //     .collection('schooldata')
                        //   //     .where('id', isEqualTo: currentUserId)
                        //   //     .get();
                        //   // if (querySnapshot.docs.isNotEmpty) {
                        //   //   DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
                        //   //   _editProfileDocument(
                        //   //     documentSnapshot.id,
                        //   //     documentSnapshot['nameEnglish'],
                        //   //     documentSnapshot['nameArabic'],
                        //   //     documentSnapshot['address'],
                        //   //     documentSnapshot['coordinatorName'],
                        //   //     documentSnapshot['supportNumber'],
                        //   //     documentSnapshot['photo'],
                        //   //   );
                        //   // }
                        // // لسه معملتش ان الداته تتنقل لصفحه الايديت

                             _editProfileDocument(
                            data[0].id,
                            data[0]['nameEnglish'],
                            data[0]['nameArabic'],
                            data[0]['address'],
                            data[0]['coordinatorName'],
                            data[0]['supportNumber'],
                            data[0]['photo']
                          );

                         },
                        // onPressed: () async {
                        //   DocumentSnapshot? userProfile = await getUserProfileData();
                        //
                        //   if (userProfile != null) {
                        //     _editProfileDocument(
                        //       userProfile.id,
                        //       userProfile['nameEnglish'],
                        //       userProfile['nameArabic'],
                        //       userProfile['address'],
                        //       userProfile['coordinatorName'],
                        //       userProfile['supportNumber'],
                        //       userProfile['schoolLogo'],
                        //     );
                        //     // Handle retrieved user profile data
                        //     print('User Profile Data: ${userProfile.data()}');
                        //   } else {
                        //     // Handle error
                        //     print('Failed to fetch user profile data');
                        //   }
                        // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Color(0xff432B72)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset("assets/imgs/school/icons8_edit_1 1 (1).png",width: 17,height: 17,),
                            // Transform(
                            //   alignment: Alignment.center,
                            //   transform: Matrix4.rotationY(math.pi),
                            //   child:
                            //   Icon(Icons.edit_outlined, color: Color(0xFF442B72), size: 20),
                            // ),
                            SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: TextStyle(color: Color(0xff432B72), fontSize: 16, fontFamily: "Poppins-Regular"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
               //func get data
                FutureBuilder(
                  future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Center(
                        child: Text(
                          data['nameEnglish'],
                          style: TextStyle(color: Color(0xff432B72),fontSize: 20,fontFamily: "Poppins-SemiBold"
                          ),
                        ),
                      );
                    }

                    return CircularProgressIndicator();
                  },
                ),

               // old code
                // Center(child: Text("Salam School",style: TextStyle(color: Color(0xff432B72),fontSize: 20,fontFamily: "Poppins-SemiBold"),)
                // ),
                SizedBox(height: 20,),
                Text("School information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                    color: Color(0xff771F98)),),
                SizedBox(height: 15,),

                ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                          SizedBox(width: 8), // add some space between the leading and title
                          Text('School name in English'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                        ],
                      ),
                    ),

                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'); // Display error message if fetch fails
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        // Once data is retrieved
                        Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                        // Check if data is available and contains the desired subtitle field
                        if (data != null && data.containsKey('nameEnglish')) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              data['nameEnglish'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF442B72),
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        } else {
                          return Text('Name of school not found'); // Handle missing data scenario
                        }
                      }

                      return SizedBox(); // Placeholder for subtitle while loading
                    },
                  ),
                ),
           // old listtile
                // ListTile(
                //   contentPadding: EdgeInsets.zero, // remove default padding
                //   title: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Row(
                //       children: [
                //         Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                //         SizedBox(width: 8), // add some space between the leading and title
                //         Text('School name in English'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                //       ],
                //     ),
                //   ),
                //
                //   subtitle: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                //     child: Text("Salam School",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                //   ),
                // ),
                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('School name in Arabic'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'); // Display error message if fetch fails
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        // Once data is retrieved
                        Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                        // Check if data is available and contains the desired subtitle field
                        if (data != null && data.containsKey('nameArabic')) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              data['nameArabic'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF442B72),
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        } else {
                          return Text('Name of school not found'); // Handle missing data scenario
                        }
                      }

                      return SizedBox(); // Placeholder for subtitle while loading
                    },
                  ),
                ),

                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Address'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'); // Display error message if fetch fails
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        // Once data is retrieved
                        Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                        // Check if data is available and contains the desired subtitle field
                        if (data != null && data.containsKey('address')) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              data['address'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF442B72),
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        } else {
                          return Text('Address of school not found'); // Handle missing data scenario
                        }
                      }

                      return SizedBox(); // Placeholder for subtitle while loading
                    },
                  ),
                ),

                SizedBox(height: 10,),
                Text("Personal information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                    color: Color(0xff771F98)),),
                SizedBox(height: 15,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Coordinator Name'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'); // Display error message if fetch fails
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        // Once data is retrieved
                        Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                        // Check if data is available and contains the desired subtitle field
                        if (data != null && data.containsKey('coordinatorName')) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              data['coordinatorName'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF442B72),
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        } else {
                          return Text('Name of school not found'); // Handle missing data scenario
                        }
                      }

                      return SizedBox(); // Placeholder for subtitle while loading
                    },
                  ),
                ),

                SizedBox(height: 20,),
                ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset('assets/imgs/school/Vector (7).png',width: 22,height: 22,),
                        SizedBox(width: 8), // add some space between the leading and title
                        Text('Support Number'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                      ],
                    ),
                  ),

                  subtitle: FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('schooldata').doc(sharedpref!.getString('id')).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong'); // Display error message if fetch fails
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        // Once data is retrieved
                        Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

                        // Check if data is available and contains the desired subtitle field
                        if (data != null && data.containsKey('supportNumber')) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Text(
                              data['supportNumber'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF442B72),
                                fontFamily: "Poppins",
                              ),
                            ),
                          );
                        } else {
                          return Text('Name of school not found'); // Handle missing data scenario
                        }
                      }

                      return SizedBox(); // Placeholder for subtitle while loading
                    },
                  ),
                ),
                //old listile
                // ListTile(
                //   contentPadding: EdgeInsets.zero, // remove default padding
                //   title: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Row(
                //       children: [
                //         Image.asset('assets/imgs/school/Vector24.png',width: 18,height: 18,),
                //         SizedBox(width: 8), // add some space between the leading and title
                //         Text('Support Number'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
                //       ],
                //     ),
                //   ),
                //
                //   subtitle: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                //     child: Text("01028765006",style: TextStyle(fontSize: 12,color: Color(0xFF442B72 ),fontFamily: "Poppins"),),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton:
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          //height: 100,
          child: FloatingActionButton(
            backgroundColor: Color(0xff442B72),
            onPressed: () async {
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
            },
            child: Image.asset(
              'assets/imgs/school/busbottombar.png',
              width: 35,
              height: 35,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),


      bottomNavigationBar:
      Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),

          child: BottomAppBar(

            color: const Color(0xFF442B72),
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            //shape of notch
            notchMargin: 7,
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                            vertical:5),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                              context ,
                              MaterialPageRoute(
                                  builder: (context) =>  HomeScreen(),
                                  maintainState: false),
                            );
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/icons8_home_1 1.png',
                                    height: 21, width: 21),
                                Text("Home".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context ,
                                MaterialPageRoute(
                                    builder: (context) =>  NotificationScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/clarity_notification-line (1).png',
                                    height: 22, width: 22),
                                Text('Notification'.tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:100),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context ,
                                MaterialPageRoute(
                                    builder: (context) =>  SupervisorScreen(),
                                    maintainState: false));
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/empty_supervisor.png',
                                    height: 22, width: 22),
                                Text("Supervisor".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize:10)),
                              ]
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.pushReplacement(
                                context ,
                                MaterialPageRoute(
                                    builder: (context) => BusScreen(),
                                    maintainState: false));
                            // _key.currentState!.openDrawer();
                          },
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.vertical,
                              children: [
                                Image.asset('assets/imgs/school/ph_bus-light (1).png',
                                    height: 22, width: 22),
                                Text("Buses".tr,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
