import 'dart:async';

//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/components/elevated_simple_button.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';

//import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import '../main.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'notificationsScreen.dart';
import 'dart:io';
//import '../components/profile_child_card.dart';

class EditeProfile extends StatefulWidget {
  // final String docid;
  // final String oldNameEnglish;
  // final String? oldNameArabic;
  // final String oldAddress;
  // final String oldSchoolLogo;
  // final String oldCoordinatorName;
  // final String oldSupportNumber;
  const EditeProfile({super.key});

  // const EditeProfile({super.key,
  //   required this.docid,
  //   required this.oldNameEnglish,
  //   required this.oldNameArabic,
  //   required this.oldAddress,
  //   required this.oldSchoolLogo,
  //   required this.oldCoordinatorName,
  //   required this.oldSupportNumber,
  // });
  @override
  _EditeProfileState createState() => _EditeProfileState();
}

class _EditeProfileState extends State<EditeProfile> {

 // fun edite photo in db
  editPhotoProfile() async {
    print('editprofile called');

    if (formState.currentState != null) {
      print('formState.currentState is not null');

      if (formState.currentState!.validate()) {
        print('form is valid');

        try {
          print('updating document...');
          print(imageUrlprofile);
//profile.doc(widget.docid)
          await FirebaseFirestore.instance
              .collection('schooldata')
              .doc(sharedpref!.getString('id'))
              .update({

            'photo': imageUrlprofile ?? '',

          });

          print('document updated successfully');

          setState(() {
            // Trigger a rebuild of the widget tree if necessary
          });
        } catch (e) {
          print('Error updating document: $e');
          // Handle specific error cases here
        }
      } else {
        print('form is not valid');
      }
    } else {
      print('formState.currentState is null');
    }
  }




  final _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameEnglish = TextEditingController();
  TextEditingController _nameArabic = TextEditingController();
  TextEditingController _Address = TextEditingController();
  TextEditingController _coordinatorName = TextEditingController();
  TextEditingController _supportNumber = TextEditingController();
  final _NameArabicFocus = FocusNode();
  final _AddressFocus = FocusNode();
  final _CoordinatorFocus = FocusNode();
  final _SupporterFocus = FocusNode();
  Custom custom = Custom();

  File? _selectedImageprofileEdite;
  String? imageUrlprofile;

  Future _pickEditeImageProfileFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImageprofileEdite = File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        FirebaseStorage.instance.ref().child('EditeProfile');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =
        referenceDirImages.child('photoprofileedite');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      imageUrlprofile = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrlprofile');
      return imageUrlprofile;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final _yourGoogleAPIKey = 'AIzaSyAk-SGMMrKO6ZawG4OzaCSmJK5zAduv1NA';
  final _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  CollectionReference profile =
      FirebaseFirestore.instance.collection('schooldata');

  Future<String> _getImageUrl() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('schooldata')
            .doc(sharedpref!.getString('id'))
            .get();
    return snapshot.data()?['photo'] ?? '';
  }

  editProfile() async {
    print('editprofile called');

    if (formState.currentState != null) {
      print('formState.currentState is not null');

      if (formState.currentState!.validate()) {
        print('form is valid');

        try {
          print('updating document...');
//profile.doc(widget.docid)
          await FirebaseFirestore.instance
              .collection('schooldata')
              .doc(sharedpref!.getString('id'))
              .update({
            'nameEnglish': _nameEnglish.text,
            'nameArabic': _nameArabic.text,
            'address': _Address.text,
            'coordinatorName': _coordinatorName.text,
            'supportNumber': _supportNumber.text,
           // 'photo': imageUrlprofile ??'',
          });

          print('document updated successfully');

          setState(() {
            // Trigger a rebuild of the widget tree if necessary
          });
        } catch (e) {
          print('Error updating document: $e');
          // Handle specific error cases here
        }
      } else {
        print('form is not valid');
      }
    } else {
      print('formState.currentState is null');
    }
  }

  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFF442B72),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFF442B72),
          width: 0.5,
        ));
  }

  File? _selectedImageEditeProfile;
  String? editeprofileimageUrl;

  Future _pickEditeProfileImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImageEditeProfile = File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        FirebaseStorage.instance.ref().child('editeprofilephoto');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload = referenceDirImages.child('editeprofile');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      editeprofileimageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $editeprofileimageUrl');
      return editeprofileimageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }

  late Future<DocumentSnapshot<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    // _nameEnglish.text = widget.oldNameEnglish!;
    // _nameArabic.text=widget.oldNameArabic!;
    // _Address.text=widget.oldAddress!;
    // _coordinatorName.text=widget.oldCoordinatorName!;
    // _supportNumber.text=widget.oldSupportNumber!;
    // editeprofileimageUrl=widget.oldSchoolLogo!;

    _future = FirebaseFirestore.instance
        .collection('schooldata')
        .doc(sharedpref!.getString('id'))
        .get();
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
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
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 23,
                  color: Color(0xff442B72),
                ),
              ),
              //icon menu and drawer
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child:
                  InkWell(
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
              title: Text(
                'Edit Profile'.tr,
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
        //Custom().customAppBar(context, 'Edite Profile'),
        body: SingleChildScrollView(
          //reverse: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 //old stack
                 //  Stack(
                 //    children: [
                 //      Center(
                 //        child: Padding(
                 //          padding: const EdgeInsets.only(top: 20),
                 //          child: FutureBuilder<String>(
                 //            future: _getImageUrl(),
                 //            builder: (BuildContext context,
                 //                AsyncSnapshot<String> snapshot) {
                 //              if (snapshot.connectionState ==
                 //                  ConnectionState.waiting) {
                 //                return CircularProgressIndicator();
                 //              }
                 //
                 //              if (snapshot.hasError) {
                 //                return Text('Error: ${snapshot.error}');
                 //              }
                 //
                 //              if (!snapshot.hasData || snapshot.data == null) {
                 //                return GestureDetector(
                 //                  onTap: () async {
                 //                    await _pickEditeImageProfileFromGallery();
                 //                  },
                 //                  child: CircleAvatar(
                 //                    backgroundColor: Colors.white,
                 //                    radius: 50,
                 //                    child: Image.asset(
                 //                      'assets/imgs/school/Ellipse 2 (2).png',
                 //                      fit: BoxFit.cover,
                 //                      width: 100,
                 //                      height: 100,
                 //                    ),
                 //                  ),
                 //                );
                 //              }
                 //
                 //              return Image.network(
                 //                snapshot.data!,
                 //                width: 83,
                 //                height: 78.5,
                 //                fit: BoxFit.cover,
                 //              );
                 //            },
                 //          ),
                 //        ),
                 //      ),
                 //      Center(
                 //        child: Padding(
                 //          padding: const EdgeInsets.only(top: 95, left: 55),
                 //          child: Container(
                 //            decoration: BoxDecoration(
                 //              shape: BoxShape.circle,
                 //              border: Border.all(
                 //                  width: 3, color: Color(0xff432B72)),
                 //            ),
                 //            child: CircleAvatar(
                 //              backgroundColor: Colors.white,
                 //              radius: 10,
                 //              child: GestureDetector(
                 //                onTap: () {
                 //                  changePhotoDialog(context);
                 //                },
                 //                child: Image.asset(
                 //                  'assets/imgs/school/edite.png',
                 //                  fit: BoxFit.cover,
                 //                  width: 15,
                 //                  height: 15,
                 //                ),
                 //              ),
                 //            ),
                 //          ),
                 //        ),
                 //      ),
                 //    ],
                 //  ),
                  Stack(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child:
                                _selectedImageEditeProfile != null
                                    ? Image.file(
                                  _selectedImageEditeProfile!,  // Display the uploaded image
                                  width: 83,  // Set width as per your preference
                                  height: 78.5,  // Set height as per your preference
                                  fit: BoxFit.cover,  // Adjusts how the image fits in the container
                                ) :
                                CircleAvatar(
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
                                          return ClipOval(
                                            child: Image.network(
                                              data['photo'],
                                              //fit: BoxFit.fill,
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3, color: Color(0xff432B72)),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        changePhotoDialogProfile(context);
                                        // _pickProfileImageFromGallery();
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

                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "School information",
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: "Poppins-Bold",
                        color: Color(0xff771F98)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('School name in English'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    height: 45,
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null) {
                          return Text('No data available');
                        }

                        Map<String, dynamic>? data = snapshot.data!.data();
                        String nameEnglish = data?['nameEnglish'] ?? '';

                        // Update the text field with the retrieved data
                        _nameEnglish.text = nameEnglish;
                        // Set the cursor to the end of the text
                        _nameEnglish.selection = TextSelection.fromPosition(
                            TextPosition(offset: _nameEnglish.text.length));

                        return TextFormField(
                          controller: _nameEnglish,

                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Regular',
                          ),

                          textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                          onFieldSubmitted: (value) {
                            // move to the next field when the user presses the "Done" button
                            FocusScope.of(context).requestFocus(_NameArabicFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]+')), // Allow only English characters and spaces
                          ],
                          cursorColor: const Color(0xFF442B72),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFF442B72)),
                            alignLabelWithHint: true,
                            counterText: "",
                            fillColor: const Color(0xFFF1F1F1),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 5, 10, 5),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Container(
                  //   width: 320,
                  //   height: 45,
                  //   child: TextFormField(
                  //     controller: _nameEnglish,
                  //     onFieldSubmitted: (value) {
                  //       // move to the next field when the user presses the "Done" button
                  //       FocusScope.of(context).requestFocus(_NameArabicFocus);
                  //     },
                  //     style: TextStyle(color: Color(0xFF442B72)),
                  //     //controller: _namesupervisor,
                  //     cursorColor: const Color(0xFF442B72),
                  //     //textDirection: TextDirection.ltr,
                  //     scrollPadding: const EdgeInsets.symmetric(
                  //         vertical: 40),
                  //
                  //     decoration:  InputDecoration(
                  //       //labelText: 'Shady Ayman'.tr,
                  //       //hintText:'ElSalam School '.tr ,
                  //       hintStyle: TextStyle(color: Color(0xFF442B72)),
                  //       alignLabelWithHint: true,
                  //       counterText: "",
                  //       fillColor: const Color(0xFFF1F1F1),
                  //       filled: true,
                  //       contentPadding: const EdgeInsets.fromLTRB(
                  //           8, 5, 10, 5),
                  //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                  //       enabledBorder: myInputBorder(),
                  //       focusedBorder: myFocusBorder(),
                  //     ),
                  //
                  //   ),
                  // ),

                  SizedBox(
                    height: 20,
                  ),

                  Text('School name in Arabic'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    height: 45,
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null) {
                          return Text('No data available');
                        }

                        Map<String, dynamic>? data = snapshot.data!.data();
                        String nameEnglish = data?['nameArabic'] ?? '';

                        // Update the text field with the retrieved data
                        _nameArabic.text = nameEnglish;

                        return TextFormField(
                          controller: _nameArabic,
                          focusNode: _NameArabicFocus,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Regular',
                          ),

                          textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                          onFieldSubmitted: (value) {
                            // move to the next field when the user presses the "Done" button
                            FocusScope.of(context).requestFocus(_AddressFocus);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^[؀-ۿ ً ٌ ٍ َ ُ ِ ّ ْ]+$')), // Allow Arabic characters only
                          ],
                          cursorColor: const Color(0xFF442B72),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFF442B72)),
                            alignLabelWithHint: true,
                            counterText: "",
                            fillColor: const Color(0xFFF1F1F1),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 5, 10, 5),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: 320,
                  //   height: 45,
                  //   child: TextFormField(
                  //     controller: _nameArabic,
                  //     focusNode: _NameArabicFocus,
                  //     onFieldSubmitted: (value) {
                  //       // move to the next field when the user presses the "Done" button
                  //       FocusScope.of(context).requestFocus(_AddressFocus);
                  //     },
                  //     style: TextStyle(color: Color(0xFF442B72)),
                  //     //controller: _namesupervisor,
                  //     cursorColor: const Color(0xFF442B72),
                  //     //textDirection: TextDirection.ltr,
                  //     scrollPadding: const EdgeInsets.symmetric(
                  //         vertical: 40),
                  //
                  //     decoration:  InputDecoration(
                  //       //labelText: 'Shady Ayman'.tr,
                  //      // hintText:'مدرسة السلام الاعدادية الثانويه المشتركة'.tr ,
                  //       hintStyle: TextStyle(color: Color(0xFF442B72)),
                  //       alignLabelWithHint: true,
                  //       counterText: "",
                  //       fillColor: const Color(0xFFF1F1F1),
                  //       filled: true,
                  //       contentPadding: const EdgeInsets.fromLTRB(
                  //           8, 5, 10, 5),
                  //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                  //       enabledBorder: myInputBorder(),
                  //       focusedBorder: myFocusBorder(),
                  //     ),
                  //
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Address'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      )),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: 320,
                    height: 45,
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null) {
                          return Text('No data available');
                        }

                        Map<String, dynamic>? data = snapshot.data!.data();
                        String nameEnglish = data?['address'] ?? '';

                        // Update the text field with the retrieved data
                        _Address.text = nameEnglish;

                        return Form(
                          key: _formKey,

                          autovalidateMode: _autovalidateMode,
                          child: GooglePlacesAutoCompleteTextFormField(
                            focusNode: _AddressFocus,
                            cursorColor: Color(0xFF442B72),
                            textEditingController: _Address,
                            googleAPIKey: _yourGoogleAPIKey,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.purple),
                              suffixIcon: Image.asset(
                                "assets/imgs/school/icons8_Location.png",
                                width: 20,
                                height: 20,
                              ),
                              alignLabelWithHint: true,
                              counterText: "",
                              fillColor: Color(0xFFF1F1F1),
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(8, 10, 10, 5),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              hintStyle: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 10,
                                fontFamily: 'Inter-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color:
                                        Colors.black), // Customize border color
                              ),
                              enabledBorder: myInputBorder(),
                              focusedBorder: myFocusBorder(),
                            ),
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              // Set text color to purple
                              fontSize: 14,
                              fontFamily:
                                  'Poppins-Regular', // Customize font family
                            ),
                            maxLines: 1,
                            overlayContainer: (child) => Material(
                              elevation: 1.0,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              child: child,
                            ),
                            getPlaceDetailWithLatLng: (prediction) {
                              print('placeDetails${prediction.lng}');
                            },
                            itmClick: (Prediction prediction) =>
                                _Address.text = prediction.description!,
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //     width: 320,
                  //     height: 45,
                  //
                  //   child: Form(
                  //
                  //     key: _formKey,
                  //     autovalidateMode: _autovalidateMode,
                  //     child: GooglePlacesAutoCompleteTextFormField(
                  //
                  //       cursorColor: Color(0xFF442B72),
                  //       textEditingController: _Address,
                  //       googleAPIKey: _yourGoogleAPIKey,
                  //       decoration: InputDecoration(
                  //       //  errorText: _validateAddress ? "Please Enter Your Address" : null,
                  //         labelStyle: TextStyle(color: Colors.purple),
                  //         suffixIcon: Image.asset(
                  //           "assets/imgs/school/icons8_Location.png",
                  //           width: 20,
                  //           height: 20,
                  //         ),
                  //         alignLabelWithHint: true,
                  //         counterText: "",
                  //         fillColor: const Color(0xFFF1F1F1),
                  //         filled: true,
                  //         contentPadding: const EdgeInsets.fromLTRB(8, 10, 10, 5),
                  //         floatingLabelBehavior: FloatingLabelBehavior.never,
                  //         hintStyle: const TextStyle(
                  //           color: Color(0xFF442B72),
                  //           fontSize: 10,
                  //           fontFamily: 'Inter-Bold',
                  //           fontWeight: FontWeight.w700,
                  //           height: 1.5,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //           borderSide: BorderSide(color: Colors.black), // Customize border color
                  //         ),
                  //         enabledBorder: myInputBorder(),
                  //         focusedBorder: myFocusBorder(),
                  //
                  //
                  //       ),
                  //       style: TextStyle(
                  //         color: Color(0xFF442B72), // Set text color to purple
                  //         fontSize: 14,
                  //         fontFamily: 'Poppins-Regular', // Customize font family
                  //         //fontWeight: FontWeight.normal, // Customize font weight
                  //         // Add more text style properties as needed
                  //       ),
                  //       // validator: (value) {
                  //       //   if (value!.isEmpty) {
                  //       //     return 'Please enter some text';
                  //       //   }
                  //       //   return null;
                  //       // },
                  //       maxLines: 1,
                  //
                  //       overlayContainer: (child) => Material(
                  //         elevation: 1.0,
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(12),
                  //         child: child,
                  //       ),
                  //       getPlaceDetailWithLatLng: (prediction) {
                  //         print('placeDetails${prediction.lng}');
                  //       },
                  //       itmClick: (Prediction prediction) => _Address.text = prediction.description!,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "Personal information",
                    style: TextStyle(
                        fontSize: 19,
                        fontFamily: "Poppins-Bold",
                        color: Color(0xff771F98)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text('Coordinator Name'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    height: 45,
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null) {
                          return Text('No data available');
                        }

                        Map<String, dynamic>? data = snapshot.data!.data();
                        String nameEnglish = data?['coordinatorName'] ?? '';

                        // Update the text field with the retrieved data
                        _coordinatorName.text = nameEnglish;

                        return TextFormField(
                          controller: _coordinatorName,
                          focusNode: _CoordinatorFocus,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Regular',
                          ),

                          textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                          onFieldSubmitted: (value) {
                            // move to the next field when the user presses the "Done" button
                            FocusScope.of(context).requestFocus(_SupporterFocus);
                          },
                          cursorColor: const Color(0xFF442B72),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFF442B72)),
                            alignLabelWithHint: true,
                            counterText: "",
                            fillColor: const Color(0xFFF1F1F1),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 5, 10, 5),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: 320,
                  //   height: 45,
                  //   child: TextFormField(
                  //     controller: _coordinatorName,
                  //     focusNode: _CoordinatorFocus,
                  //     onFieldSubmitted: (value) {
                  //       // move to the next field when the user presses the "Done" button
                  //       FocusScope.of(context).requestFocus(_SupporterFocus);
                  //     },
                  //     style: TextStyle(color: Color(0xFF442B72)),
                  //     //controller: _namesupervisor,
                  //     cursorColor: const Color(0xFF442B72),
                  //     //textDirection: TextDirection.ltr,
                  //     scrollPadding: const EdgeInsets.symmetric(
                  //         vertical: 40),
                  //
                  //     decoration:  InputDecoration(
                  //       //labelText: 'Shady Ayman'.tr,
                  //       //hintText:'Shady Ayman'.tr ,
                  //       hintStyle: TextStyle(color: Color(0xFF442B72)),
                  //       alignLabelWithHint: true,
                  //       counterText: "",
                  //       fillColor: const Color(0xFFF1F1F1),
                  //       filled: true,
                  //       contentPadding: const EdgeInsets.fromLTRB(
                  //           8, 5, 10, 5),
                  //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                  //       enabledBorder: myInputBorder(),
                  //       focusedBorder: myFocusBorder(),
                  //     ),
                  //
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Support Number'.tr,
                      style: TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 320,
                    height: 45,
                    child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: _future,
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null) {
                          return Text('No data available');
                        }

                        Map<String, dynamic>? data = snapshot.data!.data();
                        String nameEnglish = data?['supportNumber'] ?? '';

                        // Update the text field with the retrieved data
                        _supportNumber.text = nameEnglish;

                        return TextFormField(
                          controller: _supportNumber,
                          focusNode: _SupporterFocus,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 14,
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Regular',
                          ),
                          cursorColor: const Color(0xFF442B72),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Color(0xFF442B72)),
                            alignLabelWithHint: true,
                            counterText: "",
                            fillColor: const Color(0xFFF1F1F1),
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 5, 10, 5),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: 320,
                  //   height: 45,
                  //   child: TextFormField(
                  //     keyboardType: TextInputType.number,
                  //     controller: _supportNumber,
                  //     focusNode: _SupporterFocus,
                  //     style: TextStyle(color: Color(0xFF442B72)),
                  //     //controller: _namesupervisor,
                  //     cursorColor: const Color(0xFF442B72),
                  //     //textDirection: TextDirection.ltr,
                  //     scrollPadding: const EdgeInsets.symmetric(
                  //         vertical: 40),
                  //
                  //     decoration:  InputDecoration(
                  //       //labelText: 'Shady Ayman'.tr,
                  //      // hintText:'01028765006'.tr ,
                  //       hintStyle: TextStyle(color: Color(0xFF442B72)),
                  //       alignLabelWithHint: true,
                  //       counterText: "",
                  //       fillColor: const Color(0xFFF1F1F1),
                  //       filled: true,
                  //       contentPadding: const EdgeInsets.fromLTRB(
                  //           8, 5, 10, 5),
                  //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                  //       enabledBorder: myInputBorder(),
                  //       focusedBorder: myFocusBorder(),
                  //     ),
                  //
                  //   ),
                  // ),
                  SizedBox(
                    height: 35,
                  ),
                  Center(
                      child: ElevatedSimpleButton(
                    txt: 'Save'.tr,
                    width: 320,
                    hight: 48,
                    onPress: () {
                      editProfile();
                      showSnackBarFun(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    color: Color(0xff432B72),
                    fontSize: 16,
                  )),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor: Color(0xff442B72),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
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

        bottomNavigationBar: Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: BottomAppBar(
              color: const Color(0xFF442B72),
              clipBehavior: Clip.antiAlias,
              shape: const AutomaticNotchedShape(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(38.5),
                          topRight: Radius.circular(38.5))),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)))),
              //CircularNotchedRectangle(),
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
                              horizontal: 2.0, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                    maintainState: false),
                              );
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset(
                                      'assets/imgs/school/icons8_home_1 1.png',
                                      height: 21,
                                      width: 21),
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset(
                                      'assets/imgs/school/clarity_notification-line (1).png',
                                      height: 22,
                                      width: 22),
                                  Text('Notification'.tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupervisorScreen(),
                                      maintainState: false));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset(
                                      'assets/imgs/school/empty_supervisor.png',
                                      height: 22,
                                      width: 22),
                                  Text("Supervisor".tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BusScreen(),
                                      maintainState: false));
                              // _key.currentState!.openDrawer();
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.vertical,
                                children: [
                                  Image.asset(
                                      'assets/imgs/school/ph_bus-light (1).png',
                                      height: 22,
                                      width: 22),
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
      ),
    );
  }

  showSnackBarFun(context) {
    SnackBar snackBar = SnackBar(
      // content: const Text('Invitation sent successfully',
      //     style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff442B72))
      // ),
      content: Row(
        children: [
          // Add your image here
          Image.asset(
            'assets/imgs/school/Vector (4).png',
            // Replace 'assets/image.png' with your image path
            width: 30, // Adjust width as needed
            height: 30, // Adjust height as needed
          ),
          SizedBox(width: 20), // Add some space between the image and the text
          Text(
            'Data saved successfully',
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins-Bold",
                color: Color(0xff4CAF50)),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  changePhotoDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
          // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: Container(
            height: 280,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Change profile picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF771F98),
                            fontSize: 19,
                            fontFamily: 'Poppins-Medium',
                            fontWeight: FontWeight.w600,
                            height: 1.23,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            _pickEditeImageProfileFromGallery();
                          },
                          child:
                              // _selectedImageprofileEdite != null
                              //     ? Image.file(
                              //   _selectedImageprofileEdite!,  // Display the uploaded image
                              //   width: 83,  // Set width as per your preference
                              //   height: 78.5,  // Set height as per your preference
                              //   fit: BoxFit.cover,  // Adjusts how the image fits in the container
                              // ):
                              CircleAvatar(
                                  backgroundColor: Color(0xffE2E1EE),
                                  child: Image.asset(
                                    "assets/imgs/school/Vectorphoto.png",
                                    width: 21,
                                    height: 16,
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Select profile picture',
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 15,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w400,
                            height: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Save',
                      width: 250,
                      hight: 45,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  changePhotoDialogProfile(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        // contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30,),
          ),
          child: Container(
            height: 280,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Change profile picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF771F98),
                            fontSize: 19,
                            fontFamily: 'Poppins-Medium',
                            fontWeight: FontWeight.w600,
                            height: 1.23,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: (){
                            _pickEditeImageProfileFromGallery();
                          },
                          child: CircleAvatar(
                              backgroundColor:Color(0xffE2E1EE),
                              child: Image.asset("assets/imgs/school/Vectorphoto.png",width: 21,height: 16,)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Select profile picture',
                          style: TextStyle(
                            color: Color(0xFF442B72),
                            fontSize: 15,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w400,
                            height: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedSimpleButton(
                      txt: 'Save',
                      width: 250,
                      hight: 45,
                      onPress: () {
                        //editPhotoProfile();
                        Navigator.pop(context);

                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
