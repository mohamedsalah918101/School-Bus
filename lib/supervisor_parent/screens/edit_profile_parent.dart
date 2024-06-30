import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/parent_drawer.dart';

import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_parent.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';

import 'package:school_account/supervisor_parent/screens/home_parent.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_parent.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

class EditProfileParent extends StatefulWidget {
  const EditProfileParent({super.key});

  @override
  _EditProfileParentState createState() => _EditProfileParentState();
}

class _EditProfileParentState extends State<EditProfileParent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  File? _imageSecond;
  String _name = '';
  String _phoneNumber = '';
  String _address = '';
  String _imageUrl = '';
  String _imageUrlSecond = '';

  int? _invite;
  DateTime? _joinDate;
  int? _numberOfChildren;
  String _schoolId = '';
  int? _state;
  String _supervisorId = '';
  String _supervisorName = '';
  String _typeofParent = '';
  List<Map<String, dynamic>> _children = [];

  final _firestore = FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController secondParentNameController = TextEditingController();
  TextEditingController secondParentNumberController = TextEditingController();
  String _name2 = '';
  String _phoneNumber2 = '';
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final _yourGoogleAPIKey = 'AIzaSyAk-SGMMrKO6ZawG4OzaCSmJK5zAduv1NA';


  // List<Widget> cards = [];
  // int cardCount = 0;
  // bool AddCard = false;

  // void addCard() {
  //   setState(() {
  //     cardCount++;
  //     cards.add(AddAditionalData(cardCount));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchSecondUserData();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
      textColor: Colors.white,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilephoto/${DateTime.now().toString()}');
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
        await _updateUserProfilePhoto(imageUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _pickImageSecond(ImageSource src, StateSetter _setState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        _imageSecond = File(pickedFile.path);
      });
      _uploadImageSecondToFirebase();
    }
  }

  Future<void> _uploadImageSecondToFirebase() async {
    if (_imageSecond != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilephoto/${DateTime.now().toString()}');
        await storageRef.putFile(_imageSecond!);
        final imageUrlSecond = await storageRef.getDownloadURL();
        setState(() {
          _imageUrlSecond = imageUrlSecond;
        });
        await _updateSecondUserProfilePhoto(imageUrlSecond);
        // Optionally, update Firestore with the new image URL
        // await FirebaseFirestore.instance.collection('users').doc('user_id').update({'profilePhotoUrl': imageUrl});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateUserProfilePhoto(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .update({'parentImage': imageUrl});
    } catch (e) {
      print('Error updating user profile photo: $e');
    }
  }

  Future<void> _updateSecondUserProfilePhoto(String imageUrlSecond) async {
    try {
      await FirebaseFirestore.instance
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .update({'secondParentImage': imageUrlSecond});
    } catch (e) {
      print('Error updating user profile photo: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'];
          _phoneNumber = userDoc['phoneNumber'];
          _address = userDoc['address'];
          _imageUrl = userDoc['parentImage'];
          nameController.text = _name;
          numberController.text = _phoneNumber;
          locationController.text = _address;

          _invite = userDoc['invite'];
          _joinDate = userDoc['joinDate']?.toDate();
          _numberOfChildren = userDoc['numberOfChildren'];
          _schoolId = userDoc['schoolid'];
          _state = userDoc['state'];
          _supervisorId = userDoc['supervisor'];
          _supervisorName = userDoc['supervisor_name'];
          _typeofParent = userDoc['typeofParent'];

          // Process children list
          _children = userDoc['children']?.map<Map<String, dynamic>>((child) {
            return {
              'bus_id': child['bus_id'],
              'gender': child['gender'],
              'grade': child['grade'],
              'joinDateChild': child['joinDateChild']?.toDate(),
              'name': child['name'],
              'schoolid': child['schoolid'],
              'supervisor': child['supervisor'],
              'supervisor_name': child['supervisor_name'],
            };
          }).toList() ?? [];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchSecondUserData() async {
    try {
      final userDoc = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (userDoc.exists) {
        setState(() {
          _name2 = userDoc['secondParentName'];
          _phoneNumber2 = userDoc['secondParentNumber'];
          _imageUrlSecond = userDoc['secondParentImage'] ?? '';
          secondParentNameController.text = _name2;
          secondParentNumberController.text = _phoneNumber2;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .update({
        'parentImage': _imageUrl,
        'name': nameController.text,
        'phoneNumber': numberController.text,
        'address': locationController.text,

        'invite': _invite,
        'joinDate': _joinDate,
        'numberOfChildren': _numberOfChildren,
        'schoolid': _schoolId,
        'state': _state,
        'supervisorid': _supervisorId,
        'supervisor_name': _supervisorName,
        'typeofParent': _typeofParent,
        'children': _children.map((child) {
          return {
            'bus_id': child['bus_id'],
            'gender': child['gender'],
            'grade': child['grade'],
            'joinDateChild': child['joinDateChild'],
            'name': child['name'],
            'schoolid': child['schoolid'],
            'supervisor': child['supervisor'],
            'supervisor_name': child['supervisor_name'],
          };
        }).toList(),
        // Add other fields you want to update
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> _setSecondParentData() async {
    try {
      await FirebaseFirestore.instance
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .set({
        'secondParentName': secondParentNameController.text,
        'secondParentNumber': secondParentNumberController.text,
        'secondParentImage': _imageUrlSecond,
        // Add other fields you want to update
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: ParentDrawer(),
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
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
                      ? const EdgeInsets.all(23.0)
                      : const EdgeInsets.all(17.0),
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
              title: Padding(
                padding: (sharedpref?.getString('lang') == 'ar')
                    ? const EdgeInsets.only(left: 15.0)
                    : const EdgeInsets.only(left: 0.0),
                child: Text(
                  'Edit Profile'.tr,
                  style: const TextStyle(
                    color: Color(0xFF993D9A),
                    fontSize: 17,
                    fontFamily: 'Poppins-Bold',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              backgroundColor: const Color(0xffF8F8F8),
              surfaceTintColor: Colors.transparent,
            ),
          ),
        ),
        // Custom().customAppBar(context, 'Profile'.tr),
        body: SingleChildScrollView(
          child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')
                ? EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)
                : EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: Padding(
                      padding: (sharedpref?.getString('lang') == 'ar')
                          ? const EdgeInsets.only(right: 45.0)
                          : const EdgeInsets.only(left: 50.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                                radius: 52.5,
                                backgroundColor: const Color(0xff442B72),
                                child: CircleAvatar(
                                  backgroundImage: _imageUrl.isEmpty
                                      ? const AssetImage(
                                          "assets/images/Ellipse 1.png")
                                      : NetworkImage(_imageUrl)
                                          as ImageProvider,
                                  radius: 50.5,
                                )),
                          ),
                          (sharedpref?.getString('lang') == 'ar')
                              ? Positioned(
                                  bottom: 2,
                                  left: 55,
                                  child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xff442B72),
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                          'assets/images/image-editing 1.png',
                                        ),
                                      )),
                                )
                              : Positioned(
                                  bottom: 2,
                                  right: 48,
                                  child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xff442B72),
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                          'assets/images/image-editing 1.png',
                                        ),
                                      )),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 20),
                  child: Text(
                    'Name'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      // height:  0.94,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0xff442B72),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')
                      ? const EdgeInsets.symmetric(horizontal: 26.0)
                      : const EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 38,
                    child: TextFormField(
                      controller: nameController,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      cursorColor: const Color(0xFF442B72),
                      textDirection: (sharedpref?.getString('lang') == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlignVertical: TextAlignVertical.center,
                      scrollPadding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        counterText: "",
                        fillColor: const Color(0xFFF1F1F1),
                        filled: true,
                        contentPadding: (sharedpref?.getString('lang') == 'ar')
                            ? const EdgeInsets.fromLTRB(150, 20, 15, 40)
                            : const EdgeInsets.fromLTRB(15, 20, 150, 40),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        // enabledBorder: myInputBorder(),
                        // focusedBorder: myFocusBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 20),
                  child: Text(
                    'Number'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      // height:  0.94,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0xff442B72),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')
                      ? const EdgeInsets.symmetric(horizontal: 26.0)
                      : const EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 38,
                    child: TextFormField(
                      controller: numberController,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(13),
                      ],
                      cursorColor: const Color(0xFF442B72),
                      textDirection: (sharedpref?.getString('lang') == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      scrollPadding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        counterText: "",
                        fillColor: const Color(0xFFF1F1F1),
                        filled: true,
                        contentPadding: (sharedpref?.getString('lang') == 'ar')
                            ? const EdgeInsets.fromLTRB(40, 40, 15, 40)
                            : const EdgeInsets.fromLTRB(15, 40, 40, 40),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        // enabledBorder: myInputBorder(),
                        // focusedBorder: myFocusBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 20),
                  child: Text(
                    'Location *'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      // height:  0.94,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      color: Color(0xff442B72),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: (sharedpref?.getString('lang') == 'ar')
                      ? const EdgeInsets.symmetric(horizontal: 26.0)
                      : const EdgeInsets.symmetric(horizontal: 26.0),
                  child: SizedBox(
                    width: 322,
                    height: 45,
                    child: GooglePlacesAutoCompleteTextFormField(
                      textEditingController: locationController,
                      googleAPIKey: _yourGoogleAPIKey,
                      debounceTime: 800,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      cursorColor: const Color(0xFF442B72),
                      textDirection: (sharedpref?.getString('lang') == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      scrollPadding: const EdgeInsets.only(bottom: 100),
                      decoration: InputDecoration(
                        suffixIconColor: const Color(0xFF442B72),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/locations.png',
                          ),
                        ),
                        alignLabelWithHint: true,
                        counterText: "",
                        fillColor: const Color(0xFFF1F1F1),
                        filled: true,
                        contentPadding: (sharedpref?.getString('lang') == 'ar')
                            ? const EdgeInsets.fromLTRB(15, 5, 15, 5)
                            : const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Color(0xFF442B72),
                            width: 0.5,
                          ),
                        ),
                        // enabledBorder: myInputBorder(),
                        // focusedBorder: myFocusBorder(),
                      ),
                      getPlaceDetailWithLatLng: (prediction) {
                        print('placeDetails${prediction.lng}');
                      },
                      itmClick: (Prediction prediction) {
                        locationController.text = prediction.description!;
                        locationController.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: prediction.description!.length));
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 25),
                  child: Row(
                    children: [
                      Text(
                        'Additional Data'.tr,
                        style: const TextStyle(
                          color: Color(0xFF771F98),
                          fontSize: 19,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Dialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                        width: 337,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0, horizontal: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/closecircle.png',
                                                    width: 27,
                                                    height: 27,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Add Additional Data'.tr,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xFF432B72),
                                                    fontFamily:
                                                        'Poppins-SemiBold',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Stack(
                                                  children: [
                                                    GestureDetector(
                                                      onTap:(){ _pickImageSecond(ImageSource.gallery, setState);},
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFF1F1F1),
                                                        backgroundImage: _imageUrlSecond
                                                                .isEmpty
                                                            ? const AssetImage(
                                                                "assets/images/add_additional_data.png")
                                                            : NetworkImage(
                                                                    _imageUrlSecond)
                                                                as ImageProvider,
                                                        radius: 55,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: (){ _pickImageSecond(ImageSource.gallery, setState);},
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFF1F1F1),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.edit,
                                                            color: Colors.grey,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Name'.tr,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF442B72),
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.07,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: ' *',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: (sharedpref?.getString(
                                                            'lang') ==
                                                        'ar')
                                                    ? const EdgeInsets.symmetric(horizontal: 0.0)
                                                    : const EdgeInsets.symmetric(horizontal: 12.0),
                                                child: SizedBox(
                                                  width: 277,
                                                  height: 33,
                                                  child: TextFormField(
                                                    controller:
                                                        secondParentNameController,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    cursorColor:
                                                        const Color(0xFF442B72),
                                                    textDirection:
                                                        (sharedpref?.getString(
                                                                    'lang') ==
                                                                'ar')
                                                            ? TextDirection.rtl
                                                            : TextDirection.ltr,
                                                    scrollPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 30),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      counterText: "",
                                                      fillColor: const Color(
                                                          0xFFF1F1F1),
                                                      filled: true,
                                                      contentPadding: (sharedpref?.getString('lang') == 'ar')
                                                          ? const EdgeInsets.fromLTRB(0, 5, 17, 40)
                                                          : const EdgeInsets.fromLTRB(17, 5, 0, 40),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                      hintStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFFC2C2C2),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Poppins-Bold',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.33,
                                                      ),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      // enabledBorder: myInputBorder(),
                                                      // focusedBorder: myFocusBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 18,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Number'.tr,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF442B72),
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.07,
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: ' *',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: (sharedpref?.getString(
                                                            'lang') ==
                                                        'ar')
                                                    ? const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0.0)
                                                    : const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0),
                                                child: SizedBox(
                                                  width: 322,
                                                  height: 33,
                                                  child: TextFormField(
                                                    controller:
                                                        secondParentNumberController,
                                                    autofocus: true,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    inputFormatters: <TextInputFormatter>[
                                                      LengthLimitingTextInputFormatter(
                                                          13),
                                                    ],
                                                    cursorColor:
                                                        const Color(0xFF442B72),
                                                    textDirection:
                                                        (sharedpref?.getString(
                                                                    'lang') ==
                                                                'ar')
                                                            ? TextDirection.rtl
                                                            : TextDirection.ltr,
                                                    scrollPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 30),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      counterText: "",
                                                      fillColor: const Color(
                                                          0xFFF1F1F1),
                                                      filled: true,
                                                      contentPadding: (sharedpref?.getString('lang') == 'ar')
                                                          ? const EdgeInsets.fromLTRB(0, 5, 17, 5)
                                                          : const EdgeInsets.fromLTRB(17, 5, 0, 5),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                      hintStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFFC2C2C2),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Poppins-Bold',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1.33,
                                                      ),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      // enabledBorder: myInputBorder(),
                                                      // focusedBorder: myFocusBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Center(
                                                child: ElevatedSimpleButton(
                                                  txt: 'Add'.tr,
                                                  width: 222,
                                                  hight: 40,
                                                  onPress: () {
                                                    if (secondParentNameController
                                                            .text.isNotEmpty &&
                                                        secondParentNumberController
                                                            .text.isNotEmpty) {
                                                      _setSecondParentData();
                                                      // addCard();
                                                      // SizedBox(height: 20,);
                                                      Navigator.pop(context);
                                                    } else {
                                                      _showToast(
                                                          "Please Enter the Required Data");
                                                    }
                                                  },
                                                  color:
                                                      const Color(0xFF442B72),
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              });
                            },
                          );
                          // Dialoge.addAdditionalDataDialog(context);
                        },
                        child: Image.asset(
                          'assets/images/icons8_add 1.png',
                          width: 21.16,
                          height: 21.16,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: SizedBox(
                    width: 278,
                    height: 48,
                    child: ElevatedSimpleButton(
                      txt: 'Save'.tr,
                      width: 257,
                      hight: 42,
                      onPress: () {
                        if (nameController.text.isNotEmpty &&
                            numberController.text.isNotEmpty &&
                            locationController.text.isNotEmpty) {
                          _updateUserData();
                          DataSavedSnackBar(context, 'Data saved successfully');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfileParent()));
                        } else {
                          _showToast("Please Enter the Required Data");
                        }
                      },
                      color: const Color(0xFF442B72),
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
                // SizedBox(height: 10,),
                // AddedChildCard(),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: const Color(0xff442B72),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProfileParent(
                    // onTapMenu: onTapMenu
                    )));
          },
          child: Image.asset(
            'assets/images/174237 1.png',
            height: 33,
            width: 33,
            fit: BoxFit.cover,
          ),
        ),
        bottomNavigationBar: Directionality(
            textDirection: Get.locale == const Locale('ar')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomAppBar(
                    padding: const EdgeInsets.symmetric(vertical: 3),
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
                                          builder: (context) => HomeParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding: (sharedpref?.getString('lang') ==
                                          'ar')
                                      ? const EdgeInsets.only(top: 7, right: 15)
                                      : const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
                                      const SizedBox(height: 3),
                                      Text(
                                        "Home".tr,
                                        style: const TextStyle(
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
                                  padding: (sharedpref?.getString('lang') ==
                                          'ar')
                                      ? const EdgeInsets.only(top: 7, left: 70)
                                      : const EdgeInsets.only(right: 70),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 16.56,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Notifications".tr,
                                        style: const TextStyle(
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? const EdgeInsets.only(
                                              top: 12, bottom: 4, right: 10)
                                          : const EdgeInsets.only(
                                              top: 10, bottom: 4, left: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (3).png',
                                          height: 18.75,
                                          width: 18.75),
                                      const SizedBox(height: 3),
                                      Text(
                                        "Calendar".tr,
                                        style: const TextStyle(
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
                                          builder: (context) => TrackParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? const EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              right: 12,
                                              left: 15)
                                          : const EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              left: 12,
                                              right: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
                                      const SizedBox(height: 3),
                                      Text(
                                        "Track".tr,
                                        style: const TextStyle(
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
                            ],
                          ),
                        ))))));
  }
}
