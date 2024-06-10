import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';


class EditProfileSupervisorScreen extends StatefulWidget {

  // const EditProfileSupervisorScreen({super.key,
  //
  //   });
  @override
  _EditProfileSupervisorScreenState createState() => _EditProfileSupervisorScreenState();
}

class _EditProfileSupervisorScreenState extends State<EditProfileSupervisorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  bool nameError = true;
  bool phoneError = true;
  File ? _selectedImage;
  String? imageUrl;
  File? file ;
  final formState = GlobalKey<FormState>();

  // GlobalKey<FormState> formState = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  CollectionReference Supervisor = FirebaseFirestore.instance.collection('supervisor');
  // List<ChildDataItem> children = [];

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });

    // Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child('name'); // استخدم اسم مناسب أو مولد تلقائيًا

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');
      // Update Firestore with the new image URL
      await editProfile();
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  editProfile() async {
    print('editprofile called');

    if (formState.currentState != null) {
      print('formState.currentState is not null');

      if (formState.currentState!.validate()) {
        print('form is valid');

        try {
          print('updating document...');
          await FirebaseFirestore.instance.collection('supervisor').doc(sharedpref!.getString('id')).update({
            'phoneNumber': _phoneNumberController.text,
            'email': _emailController.text,
            'name': _nameController.text,
            'busphoto': imageUrl,
          });

          print('document updated successfully');

          setState(() {
            // Trigger a rebuild of the widget tree if necessary
          });
        } catch (e) {
          print('Error updating document: $e');
        }
      } else {
        print('form is not valid');
      }
    } else {
      print('formState.currentState is null');
    }
  }


  // Future<void> _pickImageFromGallery() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? returnedImage = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (returnedImage == null) {
  //     print('No image selected');
  //     return;
  //   }
  //
  //   File imageFile = File(returnedImage.path);
  //
  //   if (!imageFile.existsSync()) {
  //     print('The selected image file does not exist');
  //     return;
  //   }
  //
  //   setState(() {
  //     _selectedImage = imageFile;
  //   });
  //
  //   // Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = referenceRoot.child('images_supervisor');
  //   Reference referenceImageToUpload = referenceDirImages.child('profile_supervisor');
  //
  //   try {
  //     // Store the file
  //     UploadTask uploadTask = referenceImageToUpload.putFile(imageFile);
  //
  //     // Get the download URL
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     imageUrl = await taskSnapshot.ref.getDownloadURL();
  //     print('Image uploaded successfully. URL: $imageUrl');
  //
  //     setState(() {});
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //   }
  // }

  //test

  // Future _pickImageFromGallery() async{
  //   final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if(returnedImage ==null) return;
  //   setState(() {
  //     _selectedImage=File(returnedImage.path);
  //   });
  //
  //   //Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = FirebaseStorage.instance.ref().child('images_supervisor');
  //   Reference referenceImageToUpload =referenceDirImages.child('profile_supervisor');
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(returnedImage.path));
  //     //Success: get the download URL
  //     imageUrl = await referenceImageToUpload.getDownloadURL();
  //     print('Image uploaded successfully. URL: $imageUrl');
  //     setState(() {
  //
  //     });
  //     return imageUrl;
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //     return '';
  //     //Some error occurred
  //   }
  // }

//   editProfile() async {
//     print('editprofile called');
//
//     if (formState.currentState != null) {
//       print('formState.currentState is not null');
//
//       if (formState.currentState!.validate()) {
//         print('form is valid');
//
//         try {
//           print('updating document...');
// //profile.doc(widget.docid)
//           await FirebaseFirestore.instance.collection('supervisor').doc(sharedpref!.getString('id')).update({
//             'phoneNumber': _phoneNumberController.text,
//             'email': _emailController.text,
//             'name':_nameController.text,
//             'busphoto':imageUrl,
//
//           });
//
//           print('document updated successfully');
//
//           setState(() {
//             // Trigger a rebuild of the widget tree if necessary
//           });
//         } catch (e) {
//           print('Error updating document: $e');
//           // Handle specific error cases here
//         }
//       } else {
//         print('form is not valid');
//       }
//     } else {
//       print('formState.currentState is null');
//     }
//   }


  // editAddSupervisor() async {
  //   print('editAddParent called');
  //   if (formState.currentState != null) {
  //     print('formState.currentState is not null');
  //     if (formState.currentState!.validate()) {
  //       print('form is valid');
  //       try {
  //         setState(() {
  //
  //         });
  //         print('updating document...');
  //
  //         await Supervisor.doc(widget.docid).update({
  //           'phoneNumber': _phoneNumberController.text,
  //           'name': _nameController.text,
  //           'email': _emailController.text,
  //           'busphoto':imageUrl,
  //         });
  //         print('document updated successfully');
  //
  //         setState(() {
  //           // _pickImageFromGallery();
  //         });
  //       } catch (e) {
  //         print('Error updating document: $e');
  //       }
  //     } else {
  //       print('form is not valid');
  //     }
  //   } else {
  //     print('formState.currentState is null');
  //   }
  // }
  late Future<DocumentSnapshot<Map<String, dynamic>>> _future;

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _future = FirebaseFirestore.instance.collection('supervisor').doc(sharedpref!.getString('id')).get();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawer: SupervisorDrawer(),
        key: formState,
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
                  padding: (sharedpref?.getString('lang') == 'ar')?
                  EdgeInsets.all( 23.0):
                  EdgeInsets.all( 17.0),
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
        // Custom().customAppBar(context, 'Profile'.tr),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: formState,
            child: SingleChildScrollView(
                child:
                // children.isNotEmpty?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: 230,
                        child: Padding(
                          padding:(sharedpref?.getString('lang') == 'ar')?
                          EdgeInsets.only(right: 120.0 ):
                          EdgeInsets.only(left: 120.0 ),
                          child: Stack(
                            children: [
                              // CircleAvatar(
                              //     radius: 52.5,
                              //     backgroundColor: Color(0xff442B72),
                              //     child: CircleAvatar(
                              //       backgroundImage: NetworkImage( '$imageUrl',),
                              //       radius: 50.5,)
                              // ),


                              GestureDetector(
                                onTap: (){
                                  print('object');
                                  _pickImageFromGallery();
                                },
                                child: FutureBuilder(
                                  future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                                        return Text(
                                          'No data available',
                                          style: TextStyle(
                                            color: Color(0xff442B72),
                                            fontSize: 12,
                                            fontFamily: 'Poppins-Regular',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      }

                                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                      String? busphoto = data['busphoto'] as String?;
                                      String imageUrl = busphoto ?? 'assets/images/Logo (4).png';
                                      return CircleAvatar(
                                        radius: 52.5,
                                        backgroundColor: Color(0xff442B72),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(imageUrl) ,
                                          radius: 50.5,
                                        ),
                                      );
                                    }

                                    return CircularProgressIndicator();
                                  },
                                ),
                              ),
                              (sharedpref?.getString('lang') == 'ar')?
                              Positioned(
                                bottom: 2,
                                left: 10,
                                child:  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff442B72),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0),),),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Image.asset(
                                        'assets/images/image-editing 1.png' ,),
                                    )
                                ),
                              ):
                              Positioned(
                                bottom: 2,
                                right: 10,
                                child:  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff442B72),
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0),),),
                                    child: GestureDetector(
                                      onTap: (){
                                        print('test');
                                        _pickImageFromGallery();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                          'assets/images/image-editing 1.png' ,),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child:
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Name'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.07,
                              ),
                            ),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ,
                    SizedBox(height: 10,),
                    Center(
                      child: SizedBox(
                        width: 277,
                        height: 38,
                        child:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: _future,
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                              return Text('No data available');
                            }

                            Map<String, dynamic>? data = snapshot.data!.data();
                            String name = data?['name'] ?? '';

                            // Update the text field with the retrieved data
                            _nameController.text = name;

                            return TextFormField(
                              controller:  _nameController,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 14,
                                //fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins-Regular',
                              ),
                            scrollPadding:  EdgeInsets.symmetric(
                                  vertical: 30),
                              textDirection: (sharedpref?.getString('lang') == 'ar') ?
                                TextDirection.rtl:
                                TextDirection.ltr,
                              cursorColor: const Color(0xFF442B72),
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF442B72),
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                (sharedpref?.getString('lang') == 'ar') ?
                                    EdgeInsets.fromLTRB(0, 15, 17, 50):
                                    EdgeInsets.fromLTRB(17, 15, 0, 50),
                                // const EdgeInsets.fromLTRB(8, 5, 10, 5),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    nameError ? Container(): Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        "Please enter your name".tr,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child:
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Number'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.07,
                              ),
                            ),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.w700,
                                height: 1.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) ,
                    SizedBox(height: 10,),
                    Center(
                      child: SizedBox(
                        width: 277,
                        height: 38,
                        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: _future,
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                              return Text('No data available');
                            }

                            Map<String, dynamic>? data = snapshot.data!.data();
                            String PhoneNumber = data?['phoneNumber'] ?? '';

                            // Update the text field with the retrieved data
                            _phoneNumberController.text = PhoneNumber;
                            return TextFormField(
                              controller:  _phoneNumberController,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 14,
                                //fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins-Regular',
                              ),
                              scrollPadding:  EdgeInsets.symmetric(
                                  vertical: 30),
                              textDirection: (sharedpref?.getString('lang') == 'ar') ?
                              TextDirection.rtl:
                              TextDirection.ltr,
                              keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(11),
                                  FilteringTextInputFormatter.digitsOnly],
                              cursorColor: const Color(0xFF442B72),
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                (sharedpref?.getString('lang') == 'ar') ?
                                EdgeInsets.fromLTRB(0, 15, 17, 50):
                                EdgeInsets.fromLTRB(17, 15, 0, 50),
                                // const EdgeInsets.fromLTRB(8, 5, 10, 5),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    phoneError ? Container(): Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        "Please enter your phone Number".tr,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child:
                      Text(
                        'Email'.tr,
                        style: TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 15,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          height: 1.07,
                        ),
                      ),
                    ) ,
                    SizedBox(height: 10,),
                    Center(
                      child: SizedBox(
                        width: 277,
                        height: 38,
                        child:  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: _future,
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                              return Text('No data available');
                            }

                            Map<String, dynamic>? data = snapshot.data!.data();
                            String email = data?['email'] ?? '';

                            // Update the text field with the retrieved data
                            _emailController.text = email;

                            return TextFormField(
                              controller:  _emailController,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 14,
                                //fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins-Regular',
                              ),
                              scrollPadding:  EdgeInsets.symmetric(
                                  vertical: 30),
                              textDirection: (sharedpref?.getString('lang') == 'ar') ?
                              TextDirection.rtl:
                              TextDirection.ltr,
                              cursorColor: const Color(0xFF442B72),
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                                alignLabelWithHint: true,
                                counterText: "",
                                fillColor: const Color(0xFFF1F1F1),
                                filled: true,
                                contentPadding:
                                (sharedpref?.getString('lang') == 'ar') ?
                                EdgeInsets.fromLTRB(0, 15, 17, 50):
                                EdgeInsets.fromLTRB(17, 15, 0, 50),
                                // const EdgeInsets.fromLTRB(8, 5, 10, 5),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  borderSide: BorderSide(
                                    color: Color(0xFF442B72),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // TextFormField(
                        //   style: TextStyle(
                        //     color: Color(0xFF442B72),
                        //   ),
                        //   controller: _emailController,
                        //   cursorColor: const Color(0xFF442B72),
                        //   textDirection: (sharedpref?.getString('lang') == 'ar') ?
                        //   TextDirection.rtl:
                        //   TextDirection.ltr,
                        //   scrollPadding:  EdgeInsets.symmetric(
                        //       vertical: 30),
                        //   decoration:  InputDecoration(
                        //     alignLabelWithHint: true,
                        //     counterText: "",
                        //     fillColor: const Color(0xFFF1F1F1),
                        //     filled: true,
                        //     contentPadding:
                        //     (sharedpref?.getString('lang') == 'ar') ?
                        //     EdgeInsets.fromLTRB(0, 0, 17, 40):
                        //     EdgeInsets.fromLTRB(17, 0, 0, 40),
                        //     hintText:''.tr,
                        //     floatingLabelBehavior:  FloatingLabelBehavior.never,
                        //     hintStyle: const TextStyle(
                        //       color: Color(0xFF442B72),
                        //       fontSize: 12,
                        //       fontFamily: 'Poppins-Light',
                        //       fontWeight: FontWeight.w400,
                        //       height: 1.33,
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(7)),
                        //       borderSide: BorderSide(
                        //         color: Color(0xFF442B72),
                        //         width: 0.5,
                        //       ),),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(7)),
                        //       borderSide: BorderSide(
                        //         color: Color(0xFF442B72),
                        //         width: 0.5,
                        //       ),
                        //     ),
                        //     // enabledBorder: myInputBorder(),
                        //     // focusedBorder: myFocusBorder(),
                        //   ),
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Center(
                      child: ElevatedSimpleButton(
                          txt: 'Save'.tr,
                          fontFamily: 'Poppins-Regular',
                          width: 278,
                          hight: 48,
                          onPress: (){
                            if (_nameController.text.length == 0) {
                              nameError = false;
                              setState(() {

                              });
                            } else if (_nameController.text.length > 0) {
                              nameError = true;
                              setState(() {

                              });
                            }
                            if (_phoneNumberController.text.length < 11) {
                              phoneError = false;
                              setState(() {

                              });
                            } else if (_phoneNumberController.text.length > 10) {
                              phoneError = true;
                              setState(() {

                              });
                            }
                            // if (_emailController.text.length < 1) {
                            //   emailError = false;
                            //   setState(() {
                            //
                            //   });
                            // } else if (_emailController.text.length > 0) {
                            //   emailError = true;
                            //   setState(() {
                            //
                            //   });
                            // }
                            if(

                            nameError &&
                                // emailError &&
                                phoneError){
                              editProfile();
                              setState(() {

                              });
                              DataSavedSnackBar(context, 'Data saved successfully');
                              Navigator.pop(context , true);
                            }
                          },
                          color: Color(0xFF442B72),
                          fontSize: 16),
                    ),


                  ],
                )
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
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
                                              HomeForSupervisor()),
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
                                              AttendanceSupervisorScreen()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 9, left: 50):
                                  EdgeInsets.only( right: 50, top: 2 ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19
                                      ),
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
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 12 , bottom:4 ,right: 10):
                                  EdgeInsets.only(top: 8 , bottom:4 ,left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
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
                                              TrackSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(top: 10 , bottom: 2 ,right: 10,left: 0):
                                  EdgeInsets.only(top: 8 , bottom: 2 ,left: 0,right: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5
                                      ),
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
                              ),
                            ],
                          ),
                        ))))));
  }
}