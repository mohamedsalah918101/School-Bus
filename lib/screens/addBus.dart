import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../Functions/functions.dart';
import '../classes/dropdownCheckbox.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBus extends StatefulWidget {
  const AddBus({super.key});

  @override
  State<AddBus> createState() => _AddBusState();
}

class _AddBusState extends State<AddBus> {
  void showSupervisorErrorMessage(BuildContext context) {
    setState(() {
      supervisorerror = false;
    });
  }

//fun to get current schoolid
  String? _schoolId;

  Future<void> getSchoolId() async {
    try {
      // Get the SharedPreferences instance
      // final prefs = await SharedPreferences.getInstance();

      // Retrieve the school ID from SharedPreferences
      _schoolId = sharedpref!.getString('id');
      print("SCHOOLID$_schoolId");
      // If the school ID is not found in SharedPreferences, you can handle this case
      if (_schoolId == null) {
        // You can either throw an exception or set a default value
        throw Exception('School ID not found in SharedPreferences');
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error retrieving school ID: $e');
    }
  }

  MyLocalController ControllerLang = Get.find();
  String? _selectedSupervisor;
  List<String> _supervisors = ['Supervisor 1', 'Supervisor 2', 'Supervisor 3'];
  TextEditingController _driverName = TextEditingController();
  TextEditingController _driverNumber = TextEditingController();
  TextEditingController _busNumber = TextEditingController();
  TextEditingController _supervisor = TextEditingController();
  TextEditingController _supervisorController = TextEditingController();
  final _driverNameFocus = FocusNode();
  final _driverNumberFocus = FocusNode();
  final _busNumberFocus = FocusNode();
  final _supervisorFocus = FocusNode();

// add to firestore
  final _firestore = FirebaseFirestore.instance;
  File? _selectedImagedriver;
 // File? _selectedImagebus;
  String? imageUrl;
 // String? busimage;
  bool _validateDriverName = false;
  bool _validateDriverNumber = false;
  bool _validateBusNumber = false;
  bool namedrivererror = true;
  bool drivernumbererror = true;
  bool busnumbererror = true;
  bool supervisorerror = true;
  bool driverphotoerror = true;

  //function choose photo from gallery
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImagedriver = File(returnedImage.path);
    });

    //Get a reference to storage root

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages =
        FirebaseStorage.instance.ref().child('photo');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload = referenceDirImages.child('driver');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');
      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }

  List<QueryDocumentSnapshot> data = [];
  List<DropdownCheckboxItem>  items = [];

  // getData()async{
  //   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('supervisor').where('state', isEqualTo: 1) // Example condition
  //       .get();
  //
  //  // data.addAll(querySnapshot.docs);
  //   for(int i=0;i<querySnapshot.docs.length;i++)
  //     {
  //       items.add(DropdownCheckboxItem(label:querySnapshot.docs[i].get('name'),docID: querySnapshot.docs[i].id,phone: querySnapshot.docs[i].get('phoneNumber')));
  //     }
  //   setState(() {
  //
  //   });
  // }
  getData() async {
    // Get the current school ID from SharedPreferences
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('supervisor')
        .where('schoolid', isEqualTo: _schoolId) // Filter by school ID
        .where('state', isEqualTo: 1)
        .where('bus_id', isEqualTo: '') // ضفت شرط جديد ان ميظهرش اى مشرف عنده bus id
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      items.add(DropdownCheckboxItem(
          label: querySnapshot.docs[i].get('name'),
          docID: querySnapshot.docs[i].id,
          phone: querySnapshot.docs[i].get('phoneNumber')));
    }
    // if (items.isEmpty) {
    //   showSnackBarFun(context, 'You must add a supervisor first', Colors.red, 'assets/imgs/school/icons8_cancel 2.png');
    // }

    setState(() {});
  }

  //fun image bus from gallery
  // Future _pickBusImageFromGallery() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnedImage == null) return;
  //   setState(() {
  //     _selectedImagebus = File(returnedImage.path);
  //   });
  //
  //   //Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = FirebaseStorage.instance.ref().child('img');
  //   // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
  //   Reference referenceImageToUpload = referenceDirImages.child('bus');
  //   // Reference referenceDirImages =
  //   // referenceRoot.child('images');
  //   //
  //   // //Create a reference for the image to be stored
  //
  //   //Handle errors/success
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(returnedImage.path));
  //     //Success: get the download URL
  //     busimage = await referenceImageToUpload.getDownloadURL();
  //     print('Image uploaded successfully. URL: $busimage');
  //     return busimage;
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //     return '';
  //     //Some error occurred
  //   }
  // }
  List<XFile>? _imageFiles;
  List<String> busImageUrls = [];
  //File? _selectedImagebus;
  String? busimage;
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];


  Future<void> _pickBusImagesFromGallery() async {
    int remainingSlots = 5 - _selectedImages.length;

    if (remainingSlots > 0) {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 800, // Adjust as needed
        maxHeight: 600, // Adjust as needed
      );

      if (pickedFiles != null) {
        setState(() {
          _selectedImages.addAll(
            pickedFiles.map((xfile) => File(xfile.path)).take(remainingSlots),
          );
          if (_selectedImages.length > 5) {
            _selectedImages = _selectedImages.sublist(0, 5);
          }
          _uploadImages();
        });
      }
    } else {
      print ("You can select up to 5 images.");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('You can select up to 5 images.'),
      //   ),
      // );
    }
  }

  Future<void> _uploadImages() async {
    busImageUrls.clear();

    for (File imageFile in _selectedImages) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('img');
      Reference referenceImageToUpload = referenceDirImages.child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      try {
        await referenceImageToUpload.putFile(imageFile);
        String downloadUrl = await referenceImageToUpload.getDownloadURL();
        busImageUrls.add(downloadUrl);
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }


  void _addDataToFirestore() async {
    // if (_driverName.text.isEmpty || _driverNumber.text.isEmpty || _busNumber.text.isEmpty || _selectedImage == null || _selectedImagebus == null) {
    //   // Show an error message or do something else if any of the required fields are empty or null
    //   return;
    // }
    //if (_formKey.currentState!.validate()) {
    // Define the data to add

    List<Map<String, dynamic>> supervisorsList = List.generate(
      selectedItems.length,
      (index) => {
        'name': selectedItems[index].label,
        'phone': selectedItems[index].phone,
        'id': selectedItems[index].docID,
      },
    );
    Map<String, dynamic> data = {
      'namedriver': _driverName.text,
      'phonedriver': _driverNumber.text,
      'busnumber': _busNumber.text,
      'supervisors': supervisorsList,
      'imagedriver': imageUrl ?? '',
      'busphoto':busImageUrls,
      'schoolid': _schoolId
    };
    if (selectedItems.isEmpty) {
      showSupervisorErrorMessage(context);
      return;
    }
    // Add the data to the Firestore collection
    await _firestore.collection('busdata').add(data).then((docRef) {
      print('Data added with document ID: ${docRef.id}');
      List.generate(
        selectedItems.length,
        (index) {
          return FirebaseFirestore.instance
              .collection('supervisor')
              .doc(selectedItems[index].docID)
              .update({'bus_id': docRef.id});
        },
      );
    }).catchError((error) {
      print('Failed to add data: $error');
    });
    // Clear the text fields
    _driverName.clear();
    _driverNumber.clear();
    _busNumber.clear();
    _supervisor.clear();
    // setState(() {
    //   _selectedImage = null;
    //   _selectedImagebus = null;
    // });
  }
  // Function to delete an image from selectedImages list
  void _deleteImage(int index) {
    setState(() {
      _selectedImages.removeAt(index); // Remove image at specified index
    });
  }
// to lock in landscape view
  @override
  void initState() {
    super.initState();
    getSchoolId();
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    selectedItems.clear();
    getData();
  }

  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFFFFF),
          endDrawer: HomeDrawer(),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LayoutBuilder(builder: (context, constrains) {
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: InkWell(
                            // onTap: ()=>exit(0),
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              // Navigate back to the previous page
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 23,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Buses".tr,
                              style: TextStyle(
                                color: Color(0xFF993D9A),
                                fontSize: 16,
                                fontFamily: 'Poppins-Bold',
                                fontWeight: FontWeight.bold,
                                height: 0.64,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: InkWell(
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: const Icon(
                                Icons.menu_rounded,
                                size: 40,
                                color: Color(0xff442B72),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      //reverse: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(
                          //   height: 10,
                          // ),

                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                // child:Image.asset("assets/imgs/school/Frame 154.png",width: 65,height: 65,),
                                                // CircleAvatar( radius:30, // Set the radius of the circle
                                                //   backgroundImage: AssetImage('assets/imgs/school/Frame 154.png'),
                                                // ),
                                                child: Stack(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await _pickImageFromGallery();
                                                      },
                                                      // Call function when tapped
                                                      child:
                                                          ClipOval(
                                                            child: _selectedImagedriver !=
                                                                    null
                                                                ? Image.file(
                                                                    _selectedImagedriver!,
                                                                    // Display the uploaded image
                                                                    width: 65,
                                                                    // Set width as per your preference
                                                                    height: 65,
                                                                    // Set height as per your preference
                                                                    fit: BoxFit
                                                                        .cover, // Adjusts how the image fits in the container
                                                                  )
                                                                :
                                                            Container(
                                                                    width: 65,
                                                                    // Adjust size as needed
                                                                    height: 65,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border
                                                                          .all(
                                                                        color: Color(
                                                                            0xffCCCCCC),
                                                                        // Adjust border color
                                                                        width:
                                                                            2, // Adjust border width
                                                                      ),
                                                                    ),
                                                                    child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius: 20,
                                                                        backgroundImage:
                                                                            AssetImage(
                                                                          "assets/imgs/school/Vector (14).png",
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                    ),
                                                    Positioned(
                                                      child: Container(
                                                          width: 20,
                                                          // Adjust size as needed
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xffCCCCCC),
                                                              // Adjust border color
                                                              width:
                                                                  2, // Adjust border width
                                                            ),
                                                          ),
                                                          child: Image.asset(
                                                            "assets/imgs/school/image-editing 1 1.png",
                                                            width: 11,
                                                            height: 11,
                                                          )),
                                                      bottom: -10,
                                                      left: 80,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 45, left: 50),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(width: 2, color: Color(0xffCCCCCC)),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.white,
                                                          radius: 9,
                                                          child:
                                                          GestureDetector(
                                                            onTap: (){
                                                              _pickImageFromGallery();
                                                              // _pickProfileImageFromGallery();
                                                            },
                                                            child: Image.asset(
                                                              'assets/imgs/school/image-editing 1 1.png',
                                                              fit: BoxFit.cover,
                                                              width: 14,
                                                              height: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 0),
                                                child: Align(
                                                  alignment: AlignmentDirectional
                                                      .topStart,
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: "Driver photo",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff442B72),
                                                              fontSize: 15,
                                                              height: 1.07,
                                                              fontFamily:
                                                                  'Poppins-Bold')),
                                                      TextSpan(
                                                          text: " *",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffDB4446),
                                                              fontSize: 15,
                                                              height: 1.07,
                                                              fontFamily:
                                                                  'Poppins-Bold'))
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                              //error message on null photo
                                              // if (_selectedImage == null)
                                              //   Padding(
                                              //     padding: const EdgeInsets.only(left: 12, top: 4),
                                              //     child: Text(
                                              //       "Please select a photo",
                                              //       style: TextStyle(color: Colors.red),
                                              //     ),
                                              //   ),
                                            ],
                                          ),
                                          driverphotoerror
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 32),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .topStart,
                                                    child: Text(
                                                      "Please enter driver photo"
                                                          .tr,
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      // Padding(

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Driver Name".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFF442B72)),
                                                ),
                                                TextSpan(
                                                  text: " *".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFFAD1519)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Text(
                                          //   'Driver Name'.tr,
                                          //   style: TextStyle(
                                          //     color: Color(0xFF442B72),
                                          //     fontSize: 15,
                                          //     fontFamily: 'Poppins-Bold',
                                          //     fontWeight: FontWeight.w700,
                                          //     height: 1.07,
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 40,
                                        child: TextFormField(
                                          controller: _driverName,
                                          focusNode: _driverNameFocus,
                                          cursorColor: const Color(0xFF442B72),
                                          style:
                                              TextStyle(color: Color(0xFF442B72)),
                                          textInputAction: TextInputAction.next,
                                          // Move to the next field when "Done" is pressed
                                          onFieldSubmitted: (value) {
                                            // move to the next field when the user presses the "Done" button
                                            FocusScope.of(context)
                                                .requestFocus(_driverNumberFocus);
                                          },
                                          //textDirection: TextDirection.ltr,
                                          scrollPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 40),
                                          decoration: InputDecoration(
                                            // errorText: _validateDriverName ? "Please Enter Name" : null,
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    8, 30, 10, 5),
                                            hintText: "Your Name".tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFC2C2C2),
                                              fontSize: 12,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.33,
                                            ),
                                            enabledBorder: myInputBorder(),
                                            // focusedBorder: myFocusBorder(),
                                            // enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),
                                          // onFieldSubmitted: (value) {
                                          //   // move to the next field when the user presses the "Done" button
                                          //   FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                          // },
                                        ),
                                      ),
                                      namedrivererror
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 32),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional.topStart,
                                                child: Text(
                                                  "Please enter your name".tr,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: 'Your Name'.tr,
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Driver Number".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFF442B72)),
                                                ),
                                                TextSpan(
                                                  text: " *".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFFAD1519)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 38,
                                        child: TextFormField(
                                          controller: _driverNumber,
                                          focusNode: _driverNumberFocus,
                                          onFieldSubmitted: (value) {
                                            // move to the next field when the user presses the "Done" button
                                            FocusScope.of(context)
                                                .requestFocus(_busNumberFocus);
                                          },
                                          style:
                                              TextStyle(color: Color(0xFF442B72)),
                                          // controller: _namesupervisor,
                                          cursorColor: const Color(0xFF442B72),
                                          //textDirection: TextDirection.ltr,
                                          scrollPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 40),
                                          keyboardType: TextInputType.number,
                                          maxLength: 11,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                            // Allow only numbers
                                            LengthLimitingTextInputFormatter(11),
                                            // Limit the length programmatically
                                          ],
                                          decoration: InputDecoration(
                                            //errorText: _validateDriverNumber ? "Please Enter Phone Number" : null,
                                            // labelText: 'Shady Ayman'.tr,
                                            hintText: 'Your Number'.tr,
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFC2C2C2),
                                              fontSize: 12,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.33,
                                            ),
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    8, 20, 10, 5),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            enabledBorder: myInputBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),
                                        ),
                                      ),
                                      drivernumbererror
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 32),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional.topStart,
                                                child: Text(
                                                  "Please enter phone number".tr,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: 'Your Number'.tr,
                                      // ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: Text(
                                            'Bus Photos'.tr,
                                            style: TextStyle(
                                              color: Color(0xFF442B72),
                                              fontSize: 15,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.07,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // textform field without icon location
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.2,
                                      //   hintTxt: ''.tr,
                                      //
                                      //
                                      // ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      //old container
                                      // Align(
                                      //   alignment: AlignmentDirectional.center,
                                      //   child: GestureDetector(
                                      //     onTap: () async {
                                      //       await _pickBusImagesFromGallery();
                                      //     }, // Call function when tapped
                                      //     child:
                                      //     // _selectedImagebus != null
                                      //     //     ? Image.file(
                                      //     //         _selectedImagebus!,
                                      //     //         // Display the uploaded image
                                      //     //         width: 275,
                                      //     //         // Set width as per your preference
                                      //     //         height: 75,
                                      //     //         // Set height as per your preference
                                      //     //         fit: BoxFit
                                      //     //             .cover, // Adjusts how the image fits in the container
                                      //     //       )
                                      //     //     :
                                      //     _selectedImages.isNotEmpty
                                      //         ?
                                      //     Container(
                                      //       height: 100,
                                      //       child: ListView.builder(
                                      //         scrollDirection: Axis.horizontal,
                                      //         itemCount: _selectedImages.length,
                                      //         itemBuilder: (context, index) {
                                      //           return Stack(
                                      //             children:[
                                      //             Padding(
                                      //               padding: const EdgeInsets.all(8.0),
                                      //               child: Container(
                                      //                 decoration: BoxDecoration(
                                      //                   border: Border.all(
                                      //                     color: Color(0xFF442B72), // border color
                                      //                     width: 2, // border width
                                      //                   ),
                                      //                   borderRadius: BorderRadius.circular(5),
                                      //                 ),
                                      //                 child: Image.file(
                                      //                   _selectedImages[index],
                                      //                   width: 100,
                                      //                   height: 100,
                                      //                   fit: BoxFit.cover,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //               Positioned(
                                      //                 top: 0,
                                      //                 right: 0,
                                      //                 child: GestureDetector(
                                      //                   onTap: () {
                                      //                     _deleteImage(index); // Call delete function
                                      //                   },
                                      //                   child: Container(
                                      //                     width: 20,
                                      //                     height: 20,
                                      //                     decoration: BoxDecoration(
                                      //                       color: Color(0xFF442B72),
                                      //                       borderRadius: BorderRadius.circular(20),
                                      //                     ),
                                      //                     child: Image.asset(
                                      //                       "assets/imgs/school/Vector (8).png",
                                      //                       width: 15,
                                      //                       height: 15,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ]
                                      //           );
                                      //         },
                                      //       ),
                                      //     ):
                                      //
                                      //     FDottedLine(
                                      //             color: Color(0xFF442B72),
                                      //             strokeWidth: 0.8,
                                      //             dottedLength: 10,
                                      //             space: 5.0,
                                      //             corner:
                                      //                 FDottedLineCorner.all(6.0),
                                      //
                                      //             // Child widget
                                      //             child: Container(
                                      //               width: 275,
                                      //               height: 75,
                                      //               alignment: Alignment.center,
                                      //               child: Row(
                                      //                 children: [
                                      //                   Padding(
                                      //                     padding:
                                      //                         const EdgeInsets
                                      //                             .only(left: 80),
                                      //                     child: Image.asset(
                                      //                       "assets/imgs/school/icons8_image_document_1 1.png",
                                      //                       width: 24,
                                      //                       height: 24,
                                      //                     ),
                                      //                   ),
                                      //                   SizedBox(
                                      //                     width: 10,
                                      //                   ),
                                      //                   Text(
                                      //                     "upload image",
                                      //                     style: TextStyle(
                                      //                       color:
                                      //                           Color(0xFF442B72),
                                      //                       fontSize: 14,
                                      //                       fontFamily:
                                      //                           'Poppins-Regular',
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //
                                      //   ),
                                      //   // Container(
                                      //   //   width: 290, // Adjust width as needed
                                      //   //   height: 75, // Adjust height as needed
                                      //   //   decoration: BoxDecoration(
                                      //   //     // borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                      //   //     image: DecorationImage(
                                      //   //       image: AssetImage('assets/imgs/school/Frame 136.png'), // Provide the path to your image
                                      //   //       fit: BoxFit.fill, // Adjust the fit as needed
                                      //   //     ),
                                      //   //   ),
                                      //   // ),
                                      // ),
                                      Align(
                                        alignment: AlignmentDirectional.center,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await _pickBusImagesFromGallery();
                                          }, // Call function when tapped
                                          child: _selectedImages.isNotEmpty
                                              ?
                                          Container(
                                            height: 100,
                                            child:
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 30),
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: _selectedImages.length,
                                                      itemBuilder: (context, index) {
                                                        return Stack(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Color(0xFF442B72), // border color
                                                                    width: 2, // border width
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: Image.file(
                                                                  _selectedImages[index],
                                                                  width: 100,
                                                                  height: 100,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  _deleteImage(index); // Call delete function
                                                                },
                                                                child: Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xFF442B72),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  child: Image.asset(
                                                                    "assets/imgs/school/Vector (8).png",
                                                                    width: 15,
                                                                    height: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                if (_selectedImages.length < 5) // Show FDottedLine if less than 5 images chosen
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: FDottedLine(
                                                      color: Color(0xFF442B72),
                                                      strokeWidth: 0.8,
                                                      dottedLength: 10,
                                                      space: 5.0,
                                                      corner: FDottedLineCorner.all(6.0),
                                                      // Child widget
                                                      child: Container(
                                                        width: 150,
                                                        height: 75,
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 10),
                                                              child: Image.asset(
                                                                "assets/imgs/school/icons8_image_document_1 1.png",
                                                                width: 24,
                                                                height: 24,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              "Upload image",
                                                              style: TextStyle(
                                                                color: Color(0xFF442B72),
                                                                fontSize: 14,
                                                                fontFamily: 'Poppins-Regular',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          )
                                              : FDottedLine(
                                            color: Color(0xFF442B72),
                                            strokeWidth: 0.8,
                                            dottedLength: 10,
                                            space: 5.0,
                                            corner: FDottedLineCorner.all(6.0),
                                            // Child widget
                                            child: Container(
                                              width: 275,
                                              height: 75,
                                              alignment: Alignment.center,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 80),
                                                    child: Image.asset(
                                                      "assets/imgs/school/icons8_image_document_1 1.png",
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Upload image",
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins-Regular',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),



                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Bus Number".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFF442B72)),
                                                ),
                                                TextSpan(
                                                  text: " *".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFFAD1519)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 40,
                                        child: TextFormField(
                                          controller: _busNumber,
                                          focusNode: _busNumberFocus,
                                          cursorColor: const Color(0xFF442B72),
                                          style:
                                              TextStyle(color: Color(0xFF442B72)),
                                          textInputAction: TextInputAction.next,
                                          // Move to the next field when "Done" is pressed
                                          onFieldSubmitted: (value) {
                                            // move to the next field when the user presses the "Done" button
                                            //  FocusScope.of(context).requestFocus(_driverNumberFocus);
                                          },
                                          //textDirection: TextDirection.ltr,
                                          scrollPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 40),
                                          decoration: InputDecoration(
                                            //errorText: _validateBusNumber ? "Please Enter Bus Number" : null,
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    8, 30, 10, 5),
                                            hintText: "Your Number".tr,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFC2C2C2),
                                              fontSize: 12,
                                              fontFamily: 'Poppins-Bold',
                                              fontWeight: FontWeight.w700,
                                              height: 1.33,
                                            ),
                                            enabledBorder: myInputBorder(),
                                            // focusedBorder: myFocusBorder(),
                                            // enabledBorder: _nameuser ? myInputBorder() : myErrorBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),
                                          // onFieldSubmitted: (value) {
                                          //   // move to the next field when the user presses the "Done" button
                                          //   FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                          // },
                                        ),
                                      ),
                                      busnumbererror
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 32),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional.topStart,
                                                child: Text(
                                                  "Please enter bus number".tr,
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: "Your Number".tr,
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35, vertical: 0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                //color: Colors.black, // Setting default text color to black
                                                fontSize: 15,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Supervisor".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFF442B72)),
                                                ),
                                                TextSpan(
                                                  text: " *".tr,
                                                  style: TextStyle(
                                                      color: Color(0xFFAD1519)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: "Supervisor".tr,
                                      // ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      // Container(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   height: 45,
                                      //   child: TextFormField(
                                      //     cursorColor: const Color(0xFF442B72),
                                      //     style: TextStyle(color: Color(0xFF442B72)),
                                      //     //textDirection: TextDirection.ltr,
                                      //     scrollPadding: const EdgeInsets.symmetric(
                                      //         vertical: 40),
                                      //     decoration:  InputDecoration(
                                      //       suffixIcon:
                                      //       //Image.asset("assets/imgs/school/Vector (5).png"),
                                      //       Icon(Icons.keyboard_arrow_down,color: Color(0xFF442B72),size: 40,),
                                      //       alignLabelWithHint: true,
                                      //       counterText: "",
                                      //       fillColor: const Color(0xFFF1F1F1),
                                      //       filled: true,
                                      //       contentPadding: const EdgeInsets.fromLTRB(
                                      //           8, 30, 10, 5),
                                      //         hintText:"Supervisor".tr,
                                      //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                                      //       hintStyle: const TextStyle(
                                      //         color: Color(0xFFC2C2C2),
                                      //         fontSize: 12,
                                      //         fontFamily: 'Inter-Bold',
                                      //         fontWeight: FontWeight.w700,
                                      //         height: 1.33,
                                      //       ),
                                      //       enabledBorder: myInputBorder(),
                                      //       focusedBorder: myFocusBorder(),
                                      //
                                      //     ),
                                      //   ),
                                      // ),
                                      // old container
                                      // Container(
                                      //   width: MediaQuery.of(context).size.width / 1.3,
                                      //   height: 45,
                                      //   child: DropdownButtonFormField<String>(
                                      //     value: _selectedSupervisor,
                                      //     onChanged: (String? newValue) {
                                      //       setState(() {
                                      //         _selectedSupervisor = newValue;
                                      //       });
                                      //     },
                                      //     items: _supervisors.map((String supervisor) {
                                      //       return DropdownMenuItem<String>(
                                      //         value: supervisor,
                                      //         child: Text(supervisor),
                                      //       );
                                      //     }
                                      //     ).toList(),
                                      //     decoration: InputDecoration(
                                      //       // suffixIcon: Icon(
                                      //       //   Icons.keyboard_arrow_down,
                                      //       //   color: Color(0xFF442B72),
                                      //       //   size: 40,
                                      //       // ),
                                      //       alignLabelWithHint: true,
                                      //       counterText: "",
                                      //       fillColor: const Color(0xFFF1F1F1),
                                      //       filled: true,
                                      //       contentPadding: const EdgeInsets.fromLTRB(8, 30, 10, 5),
                                      //       hintText: "Supervisor",
                                      //       floatingLabelBehavior: FloatingLabelBehavior.never,
                                      //       hintStyle: const TextStyle(
                                      //         color: Color(0xFFC2C2C2),
                                      //         fontSize: 12,
                                      //         fontFamily: 'Inter-Bold',
                                      //         fontWeight: FontWeight.w700,
                                      //         height: 1.33,
                                      //       ),
                                      //       enabledBorder: OutlineInputBorder(
                                      //         borderSide: BorderSide(color: Color(0xFFFFC53E)),
                                      //       ),
                                      //       focusedBorder: OutlineInputBorder(
                                      //         borderSide: BorderSide(color: Color(0xFFFFC53E)),
                                      //       ),
                                      //     ),
                                      //
                                      //   ),
                                      // ),
                                      Container(
                                        child: DropdownCheckbox(
                                            controller: _supervisorController,
                                            items: items),
                                      ),
                                      supervisorerror
                                          ? Container()
                                          : Padding(
                                        padding: const EdgeInsets.only(left: 32),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child: Text(
                                            "Please choose supervisor".tr,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),

                                      // supervisorerror?Container(): Padding(
                                      //   padding: const EdgeInsets.only(left: 32),
                                      //   child: Align( alignment: AlignmentDirectional.topStart,
                                      //     child: Text(
                                      //       "Please choose supervisor".tr,
                                      //       style: TextStyle(color: Colors.red),
                                      //     ),
                                      //   ),
                                      // ),
                                      //end empty code
                                      // DropdownButtonFormField(value:null,items: [], onChanged: (value){}),
                                      // DropdownButton<String>(
                                      //   hint: Text('Select an option'),
                                      //   items: [],
                                      //   onChanged: (value) {
                                      //     // Handle the dropdown value change
                                      //   },
                                      // ),
                                      SizedBox(
                                        height: 60,
                                      ),

                                      SizedBox(
                                        width: constrains.maxWidth / 1.3,
                                        child: Center(
                                          child: ElevatedSimpleButton(
                                            txt: "Add".tr,
                                            onPress: () {
                                              setState(() {
                                                if (_driverName.text.isEmpty) {
                                                  namedrivererror = false;
                                                } else {
                                                  namedrivererror = true;
                                                }
                                                if (_driverNumber.text.isEmpty) {
                                                  drivernumbererror = false;
                                                } else {
                                                  drivernumbererror = true;
                                                }
                                                if (_busNumber.text.isEmpty) {
                                                  busnumbererror = false;
                                                } else {
                                                  busnumbererror = true;
                                                }
                                                if (_supervisorController.text.isEmpty) {
                                                  supervisorerror = false;
                                                } else {
                                                  supervisorerror = true;
                                                }
                                                if (_selectedImagedriver == null) {
                                                  driverphotoerror = false;
                                                } else {
                                                  driverphotoerror = true;
                                                }
                                              });

                                              if (_driverNumber.text.length == 11 &&
                                                  namedrivererror &&
                                                  drivernumbererror &&
                                                  busnumbererror &&
                                                  _selectedImagedriver != null &&
                                                  driverphotoerror &&
                                                  items != null && items.isNotEmpty) {
                                                _addDataToFirestore();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BusScreen(),
                                                    maintainState: false,
                                                  ),
                                                );
                                              } else {
                                                if (items == null || items.isEmpty) {
                                                  showSnackBarFun(
                                                      context,
                                                      'You must add a supervisor first',
                                                      Colors.red,
                                                      'assets/imgs/school/icons8_cancel 2.png'
                                                  );
                                                } else {
                                                  // showSnackBarFun(
                                                  //     context,
                                                  //     'Please, enter valid number',
                                                  //     Colors.red,
                                                  //     'assets/imgs/school/icons8_cancel 2.png'
                                                  // );
                                                }
                                              }
                                            },

                                            width: constrains.maxWidth / 1.2,
                                            hight: 48,
                                            color: const Color(0xFF442B72),
                                            fontSize: 16,
                                          ),
                                          // end of comment
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              //height: 100,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
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
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                //CircularNotchedRectangle(),
                //shape of notch
                notchMargin: 7,
                child: SizedBox(
                  height: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         selectedIconIndex = 0; // Update the index for the Home icon
                          //       });
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => HomeScreen(),
                          //           maintainState: false,
                          //         ),
                          //       );
                          //     },
                          //     child: Wrap(
                          //       crossAxisAlignment: WrapCrossAlignment.center,
                          //       direction: Axis.vertical,
                          //       children: [
                          //         Image.asset(
                          //           selectedIconIndex == 0
                          //               ? 'assets/imgs/school/icons8_home_1 1.png' // Image for selected state
                          //               : 'assets/imgs/school/fillhome.png', // Image for unselected state
                          //           height: 21,
                          //           width: 21,
                          //         ),
                          //         Text(
                          //           "Home".tr,
                          //           style: TextStyle(color: Colors.white, fontSize: 10),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                Navigator.push(
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
                                Navigator.push(
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SupervisorScreen(),
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
                                Navigator.push(
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
                                        'assets/imgs/school/fillbus.png',
                                        height: 20,
                                        width: 20),
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
      ),
    );
  }
  showSnackBarFun(context,msg,color,photo) {
    SnackBar snackBar = SnackBar(

      // content: const Text('Invitation sent successfully',
      //     style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff442B72))
      // ),
      content: Row(
        children: [
          // Add your image here
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              photo,
              // 'assets/imgs/school/Vector (4).png', // Replace 'assets/image.png' with your image path
              width: 30, // Adjust width as needed
              height: 30, // Adjust height as needed
            ),
          ),
          SizedBox(width: 10), // Add some space between the image and the text
          Text(
            msg,
            style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color:color),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 165,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
