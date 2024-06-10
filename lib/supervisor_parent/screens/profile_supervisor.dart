import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/classes/loading.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/edit_profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
import '../components/child_data_item.dart';


class ProfileSupervisorScreen extends StatefulWidget {
  @override
  _ProfileSupervisorScreenState createState() => _ProfileSupervisorScreenState();
}

class _ProfileSupervisorScreenState extends State<ProfileSupervisorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  List<ChildDataItem> children = [];
  List<QueryDocumentSnapshot> data = [];
  File ? _selectedImage;
  String? imageUrl;
  File? file ;
  final formState = GlobalKey<FormState>();

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
  //   Reference referenceDirImages = referenceRoot.child('images');
  //   Reference referenceImageToUpload = referenceDirImages.child('name');
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
  //     // Retry upload on failure
  //     try {
  //       print('Retrying upload...');
  //       UploadTask retryUploadTask = referenceImageToUpload.putFile(imageFile);
  //       TaskSnapshot retryTaskSnapshot = await retryUploadTask;
  //       imageUrl = await retryTaskSnapshot.ref.getDownloadURL();
  //       print('Image uploaded successfully on retry. URL: $imageUrl');
  //
  //       setState(() {});
  //     } catch (retryError) {
  //       print('Retry failed: $retryError');
  //     }
  //   }
  // }

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


  //function choose photo from gallery
  // Future _pickImageFromGallery() async{
  //   final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if(returnedImage ==null) return;
  //   setState(() {
  //     _selectedImage=File(returnedImage.path);
  //   });
  //
  //   //Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = FirebaseStorage.instance.ref().child('images');
  //   // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
  //   Reference referenceImageToUpload =referenceDirImages.child('profile_supervisor');
  //
  //
  //
  //   //Handle errors/success
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(returnedImage.path));
  //     //Success: get the download URL
  //     imageUrl = await referenceImageToUpload.getDownloadURL();
  //     print('Image uploaded successfully. URL: $imageUrl');
  //     return imageUrl;
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //     return '';
  //     //Some error occurred
  //   }
  // }

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('supervisor').get();
    // data.addAll(querySnapshot.docs);
    setState(() {
      data = querySnapshot.docs;
    });
  }





  @override
  void initState() {
    getData();
    setState(() {

    });
    // getDataForAcceptFilter();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Loading(),
      );
    }
//     var parentData = data.firstWhere(
//           (doc) => doc['state'] == 2 && doc['phoneNumber'] != null,
//
//     );
//
// // If the document is found and not null, return its name, otherwise display "No data found"
//     String parentName = parentData != null ? parentData['name'] : 'No data found';

    return Scaffold(
        backgroundColor: Colors.white,
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
                'Profile'.tr,
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
                sharedpref!.getInt('invit') == 1 ?
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: SizedBox(
                            width: 230,
                            child: Padding(
                              padding:  (sharedpref?.getString('lang') == 'ar') ?
                              EdgeInsets.only(right: 105.0 , top: 5):
                              EdgeInsets.only(left: 105.0 , top: 5 ),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _pickImageFromGallery();
                                      print('object');
                                    },
                                    child: FutureBuilder(
                                      future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Something went wrong');
                                        }
          
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
                                            return CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Color(0xff442B72),
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                                radius: 50,
                                              ),
                                            );
                                          }
          
                                          Map<String, dynamic>? data = snapshot.data?.data();
                                          if (data != null && data['busphoto'] != null) {
                                            return CircleAvatar(
                                              radius: 52,
                                              backgroundColor: Color(0xff442B72),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage('${data['busphoto']}'),
                                                radius:50,
                                              ),
                                            );
                                          }
                                        }
          
                                        return Container();
                                      },
                                    ),
          
                                  ),
                                  (sharedpref?.getString('lang') == 'ar')?
                                  Positioned(
                                    bottom: 2,
                                    left: 24,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 25.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          13), // Rounded top left corner
                                                      topRight: Radius.circular(
                                                          13), // Rounded top right corner
                                                    ),
                                                  ),
                                                  height: 220,
                                                  child: Column(
                                                    children: [
                                                      Text('Change profile picture'.tr,
                                                        style: TextStyle(
                                                            color: Color(0xff771F98),
                                                            fontSize: 19,
                                                            fontFamily: 'Poppins-Regular',
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      Padding(
                                                        padding: (sharedpref?.getString('lang') == 'ar')?
                                                        EdgeInsets.only(right: 20.0 , top: 15):
                                                        EdgeInsets.only(left: 20.0, top: 15),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              child: _selectedImage != null
                                                                  ? Image.file(
                                                                _selectedImage!,  // Display the uploaded image
                                                                width: 83,  // Set width as per your preference
                                                                height: 78.5,  // Set height as per your preference
                                                                fit: BoxFit.cover,  // Adjusts how the image fits in the container
                                                              )
                                                                  : Container(
                                                                width: 65, // Adjust size as needed
                                                                height: 65,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  border: Border.all(
                                                                    color: Color(0xffCCCCCC), // Adjust border color
                                                                    width: 2, // Adjust border width
                                                                  ),
                                                                ),
                                                                child: Align(alignment: Alignment.bottomCenter,
                                                                  child: CircleAvatar(radius: 20,
                                                                    backgroundImage: AssetImage("assets/imgs/school/Vector (14).png",)
                                                                    ,backgroundColor: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                              // child: Image.asset('assets/images/Vector (13)profile.png',
                                                              //   width: 55,
                                                              //   height: 55,),
                                                              onTap:()async {
          
                                                                // await _pickImageFromGallery();
          
                                                                print('objectttt');
                                                                setState(() {
          
                                                                });}  , // Call function when tapped
                                                            ),
                                                            if ( file != null ) Image.file(file!),
                                                            SizedBox(width: 15,),
                                                            Text('Select profile picture'.tr,
                                                              style: TextStyle(
                                                                  color: Color(0xff442B72),
                                                                  fontSize: 15,
                                                                  fontFamily: 'Poppins-Bold',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 40),
                                                      ElevatedSimpleButton(
                                                          txt: 'Save'.tr,
                                                          fontFamily: 'Poppins-Regular',
                                                          width: 278,
                                                          hight: 48,
                                                          onPress: (){},
                                                          color: Color(0xff442B72),
                                                          fontSize: 16)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color(0xff442B72),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset('assets/images/image-editing 1.png'),
                                        ),
                                      ),
                                    ),
                                  ):
                                  Positioned(
                                    bottom: 2,
                                    right: 24,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 25.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          13), // Rounded top left corner
                                                      topRight: Radius.circular(
                                                          13), // Rounded top right corner
                                                    ),
                                                  ),
                                                  height: 220,
                                                  child: Column(
                                                    children: [
                                                      Text('Change profile picture',
                                                        style: TextStyle(
                                                            color: Color(0xff771F98),
                                                            fontSize: 19,
                                                            fontFamily: 'Poppins-Regular',
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      Padding(
                                                        padding: (sharedpref?.getString('lang') == 'ar')?
                                                        EdgeInsets.only(right: 20.0 , top: 15):
                                                        EdgeInsets.only(left: 20.0, top: 15),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap:(){
                                                                _pickImageFromGallery();
                                                                print('object');
                                                              },
          
                                                              child: Image.asset('assets/images/Vector (13)profile.png',
                                                                width: 55,
                                                                height: 55,),
                                                            ),
                                                            SizedBox(width: 15,),
                                                            Text('Select profile picture',
                                                              style: TextStyle(
                                                                  color: Color(0xff442B72),
                                                                  fontSize: 15,
                                                                  fontFamily: 'Poppins-Bold',
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 40),
                                                      ElevatedSimpleButton(
                                                          txt: 'Save',
                                                          fontFamily: 'Poppins-Regular',
                                                          width: 278,
                                                          hight: 48,
                                                          onPress: (){
                                                            Navigator.of(context).pop();
                                                            // _pickImageFromGallery();
          
                                                          },
                                                          color: Color(0xff442B72),
                                                          fontSize: 16)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color(0xff442B72),
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Image.asset('assets/images/image-editing 1.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 55.0),
                          child: GestureDetector(
                            onTap: () {
                              if (data.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    EditProfileSupervisorScreen(
                                      //   docid: data[0].id,
                                      //   oldName: data[0].get('name'),
                                      //   oldNumber: data[0].get('phoneNumber'),
                                      //   oldEmail: data[0].get('email'),
                                      //   oldPhoto: data[0].get('busphoto'),
                                      // Image.asset( 'assets/images/Ellipse 1.png', ),
                                    )
                                )).then((value) {
                                  if (value == true && data.isNotEmpty) {
                                    getData();
                                  }
                                });
                              } else {
                                print('Data list is empty');
                              }
                            },
                            child: SizedBox(
                                width: 87,
                                height: 29,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFF432B72),
                                      )
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        (sharedpref?.getString('lang') == 'ar')?
                                        'assets/images/edittt_white_translate.png' :
                                        'assets/images/edittt_white.png',
                                        width: 13.45,
                                        height: 13.45,),
                                      SizedBox(width: 7,),
                                      Text('Edit'.tr,
                                        style: TextStyle(
                                          color: Color(0xff442B72),
                                          fontSize: 16,
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                        ),),
                                    ],
                                  ),)
                            ),
                          ),
                        ),
                      ],
          
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: FutureBuilder(
                        future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
          
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.data?.data() == null) {
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
          
                            sharedpref?.getString('lang') == 'en';
                            return Text(
                              '${data['name']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff442B72),
                              ),
                            );
                          }
          
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 148,
                              height: 65,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF432B72),
                                    )
                                ),
                                child: Padding(
                                  padding: (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(right: 12.0, top: 12):
                                  EdgeInsets.only(left: 12.0, top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Image.asset('assets/images/call_icon.png',
                                          width: 12,
                                          height: 12,),
                                      ),
                                      SizedBox(width: 7,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Number'.tr
                                            , style: TextStyle(
                                              fontSize: 14 ,
                                              height:  0.94,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700 ,
                                              color: Color(0xff442B72),),),
                                          SizedBox(height: 2,),
                                          FutureBuilder(
                                            future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('Something went wrong');
                                              }
          
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                if (snapshot.data?.data() == null) {
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
          
                                                sharedpref?.getString('lang') == 'en';
                                                return Text(
                                                  '${data['phoneNumber']}',
                                                  style: TextStyle(
                                                    fontSize: 11 ,
                                                    height:  2.94,
                                                    fontFamily: 'Poppins-Light',
                                                    fontWeight: FontWeight.w400 ,
                                                    color: Color(0xff442B72),),
                                                );
                                              }
          
                                              return Container();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),)
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                              width: 170,
                              height: 65,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF432B72),
                                    )
                                ),
                                child: Padding(
                                  padding: (sharedpref?.getString('lang') == 'ar')?
                                  EdgeInsets.only(right: 12.0 , top: 12):
                                  EdgeInsets.only(left: 12.0, top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Image.asset('assets/images/Vector (13)email.png',
                                          width: 16,
                                          height: 16,),
                                      ),
                                      SizedBox(width: 7,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Email'.tr,
                                            style: TextStyle(
                                              fontSize: 14 ,
                                              height:  0.94,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700 ,
                                              color: Color(0xff442B72),),),
                                          SizedBox(height: 0,),
                                          FutureBuilder(
                                            future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              if (snapshot.hasError) {
                                                return Text('Something went wrong');
                                              }
          
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                if (snapshot.data?.data() == null) {
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
          
                                                sharedpref?.getString('lang') == 'en';
                                                return Text(
                                                  '${data['email']}',
                                                  style: TextStyle(
                                                    fontSize: 11 ,
                                                    height:  2.94,
                                                    fontFamily: 'Poppins-Light',
                                                    fontWeight: FontWeight.w300 ,
                                                    color: Color(0xff442B72),
                                                  ),
                                                );
                                              }
          
                                              return Container();
                                            },
                                          ),
          
                                        ],
                                      ),
                                    ],
                                  ),
                                ),)
                          ),
                        ],
                      ),
                    )
          
                  ],
                )
              //no data
              :
              Center(
                child: Column(
                     children: [
                       SizedBox(height: 25,),
                       Image.asset('assets/images/Group 237679.png',
                       width: 97,
                       height: 97,),
                       // Text('Atef Latif',
                       // style: TextStyle(
                       //     color: Color(0xff442B72),
                       //     fontSize: 20,
                       //     fontFamily: 'Poppins-SemiBold',
                       //     fontWeight: FontWeight.w600
                       // ),),
                       FutureBuilder(
                         future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                           if (snapshot.hasError) {
                             return Text('Something went wrong');
                           }
          
                           if (snapshot.connectionState == ConnectionState.done) {
                             if (snapshot.data?.data() == null) {
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
                             return Text(
                               '${data['name']}',
                               style: TextStyle(
                                 color: Color(0xff442B72),
                                     fontSize: 20,
                                     fontFamily: 'Poppins-SemiBold',
                                     fontWeight: FontWeight.w600
                               ),
                             );
                           }
          
                           return Container();
                         },
                       ),
                       // Text('0128361532',
                       //   style: TextStyle(
                       //       color: Color(0xff442B72),
                       //       fontSize: 12,
                       //       fontFamily: 'Poppins-Light',
                       //       fontWeight: FontWeight.w400
                       //   ),
                       // )
                       FutureBuilder(
                         future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                           if (snapshot.hasError) {
                             return Text('Something went wrong');
                           }
          
                           if (snapshot.connectionState == ConnectionState.done) {
                             if (snapshot.data?.data() == null) {
                               return Text(
                                 'No data available',
                                 style: TextStyle(
                                   color: Color(0xff442B72),
                                         fontSize: 12,
                                         fontFamily: 'Poppins-Light',
                                         fontWeight: FontWeight.w400
                                 ),
                               );
                             }
          
                             Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                             return Text(
                               '${data['phoneNumber']}',
                               style: TextStyle(
                                 color: Color(0xff442B72),
                                       fontSize: 12,
                                       fontFamily: 'Poppins-Light',
                                       fontWeight: FontWeight.w400
                               ),
                             );
                           }
          
                           return Container();
                         },
                       ),
                     ],
                ),
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
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => ProfileSupervisorScreen(
              //     )));
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