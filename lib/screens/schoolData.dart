import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';

class SchoolData extends StatefulWidget{
  const SchoolData({super.key});
  // final String name;
  // final String phone;
  //const SchoolData({Key? key, required this.name, required this.phone}) : super(key: key);
  @override
  State<SchoolData> createState() => _SchoolDataState();
}


class _SchoolDataState extends State<SchoolData> {
  bool _validateNameEnglish = false;
  bool _validateNameArabic = false;
  bool _validateAddress = false;
  bool _validateCoordinatorName = false;
  bool _validateSupportNumber = false;
  MyLocalController ControllerLang = Get.find();
  TextEditingController _nameEnglish = TextEditingController();
  TextEditingController _nameArabic = TextEditingController();
  TextEditingController _Address = TextEditingController();
  TextEditingController _coordinatorName = TextEditingController();
  TextEditingController _supportNumber = TextEditingController();
  final _NameArabicFocus = FocusNode();
  final _AddressFocus = FocusNode();
  final _CoordinatorFocus = FocusNode();
  final _SupporterFocus = FocusNode();
  File ? _selectedImage;
  String? imageUrl;
  Future _pickImageFromGallery() async{
    final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage ==null) return;
    setState(() {
      _selectedImage=File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = FirebaseStorage.instance.ref().child('images');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =referenceDirImages.child('name');
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



//   Future _pickImageFromGallery() async{
//  final returnedImage=
//  await ImagePicker().pickImage(source: ImageSource.gallery);
//  if(returnedImage ==null) return;
//  setState(() {
//    _selectedImage=File(returnedImage!.path);
//  });
//  // String uniqueFileName=DateTime.now().microsecondsSinceEpoch.toString();
//  // Reference referenceRoot=FirebaseStorage.instance.ref();
//  // Reference referenceDirImages = referenceRoot.child('images');
//  // Reference referenceImageToUpload= referenceDirImages.child(uniqueFileName);
//
// }
// add to firestore schooldata
  final _firestore = FirebaseFirestore.instance;
  void _addDataToFirestore() async {
    //if (_formKey.currentState!.validate()) {
    // Define the data to add
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print("sss"+userId);
   // String documentId = FirebaseFirestore.instance.collection('schooldata').doc(FirebaseAuth.instance.currentUser!.uid).id;
    Map<String, dynamic> data = {
      // 'name': widget.name,
      // 'phoneNumber': widget.phone,
      'nameEnglish': _nameEnglish.text,
      'nameArabic': _nameArabic.text,
      'address':  _textController.text,
      'coordinatorName':_coordinatorName.text,
      'supportNumber':_supportNumber.text,
      'photo': imageUrl,
      'state':1
    };


    // Add the data to the Firestore collection
    //await _firestore.collection('schooldata').add(data).then((docRef)
   await _firestore.collection('schooldata').doc(sharedpref!.getString('id')).update(data).then((_)
       //.update(data).then((docRef)
    {
      sharedpref!.setInt("allData",1);
      // await _firestore.collection('schooldata').doc(userId)
      //print('Data added with document ID: ${docRef.id}');
     print('Data updated with document ID: $userId');
    }).catchError((error) {
      print('Failed to add data: $error');
    }
    );
    // Clear the text fields
    _nameEnglish.clear();
    _nameArabic.clear();
    _Address.clear();
    _coordinatorName.clear();
    _supportNumber.clear();
  }
// to lock in landscape view
  @override
  void initState() {
    super.initState();
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }
  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFFFFC53E),
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
  final _yourGoogleAPIKey = 'AIzaSyAk-SGMMrKO6ZawG4OzaCSmJK5zAduv1NA';
  final _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
// address new
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    print(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //غيرت resizeToAvoidBottomInset من false ل true علشان لما اكتب ال تيكست فيلد يظهر
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: InkWell(onTap: (){},
                //     child: const Icon(
                //       Icons.menu_rounded,
                //       size: 40,
                //       color: Color(0xff442B72),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Text(
                    "Welcome".tr,
                    style: TextStyle(
                      color: Color(0xFF993D9A),
                      fontSize: 25,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.bold,
                      height: 0.64,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Stack(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top:5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            //   child: InkWell(
                            //     onTap: ()
                            //     {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   MainBottomNavigationBar(pageNum: 5),
                            //               maintainState: false));
                            //     },
                            //     // child: Image.asset(
                            //     //   'assets/imgs/school/Vector (11).png',
                            //     //   width: 22,
                            //     //   height: 22,
                            //     // ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:

                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School logo".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              // Adjust horizontal padding
                              child: SizedBox(
                                width: constrains.maxWidth / 1.4,


                              ),



                            ),


                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.4,
                            //   hintTxt: 'Your Phone'.tr,
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap:()async {
                                await _pickImageFromGallery();}  , // Call function when tapped
                              child: _selectedImage != null
                                  ? Image.file(
                                _selectedImage!,  // Display the uploaded image
                                width: 83,  // Set width as per your preference
                                height: 78.5,  // Set height as per your preference
                                fit: BoxFit.cover,  // Adjusts how the image fits in the container
                              )
                              //     : FDottedLine(
                              //   color: Color(0xFF442B72),
                              //   strokeWidth: 2.0,
                              //   dottedLength: 8.0,
                              //   space: 3.0,
                              //   corner: FDottedLineCorner.all(6.0),
                              //
                              //   // Child widget
                              //   child: Container(
                              //     width: 83,
                              //     height: 78.5,
                              //     alignment: Alignment.center,
                              //     child: Column(
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.only(top:10),
                              //           child: Image.asset("assets/imgs/school/Vector (13).png",width: 29,height: 29,),
                              //         ),
                              //         SizedBox(height: 10,),
                              //         Text(
                              //           "School logo",
                              //           style: TextStyle(
                              //             color: Color(0xFF442B72),
                              //             fontSize: 11,
                              //             fontFamily: 'Poppins-Regular',
                              //           ),
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //   ),
                              // ),
                                  : Column(
                                children: [
                                  FDottedLine(
                                    color: Color(0xFF442B72),
                                    strokeWidth: 2.0,
                                    dottedLength: 8.0,
                                    space: 3.0,
                                    corner: FDottedLineCorner.all(6.0),

                                    // Child widget
                                    child: Container(
                                      width: 83,
                                      height: 78.5,
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:10),
                                            child: Image.asset("assets/imgs/school/Vector (13).png",width: 29,height: 29,),
                                          ),
                                          SizedBox(height: 10,),
                                          Text(
                                            "School logo",
                                            style: TextStyle(
                                              color: Color(0xFF442B72),
                                              fontSize: 11,
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    _selectedImage == null ? "Please Enter School logo" : "",
                                    style: TextStyle(
                                      color: Color(0xFFAD1519),
                                      fontSize: 11,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            // GestureDetector(
                            //   onTap: (){
                            //     _pickImageFromGallery();
                            //     // ImagePicker imagePicker=ImagePicker();
                            //     // imagePicker.pickImage(source: ImageSource.gallery);
                            //   },
                            //   child: FDottedLine(
                            //     color:Color(0xFF442B72),
                            //     strokeWidth: 2.0,
                            //     dottedLength: 8.0,
                            //     space: 3.0,
                            //     corner: FDottedLineCorner.all(6.0),
                            //
                            //     /// add widget
                            //     child: Container(
                            //       width: 100,
                            //       height: 100,
                            //       alignment: Alignment.center,
                            //       child: Text("School logo",style: TextStyle(color:Color(0xFF442B72),fontSize:11,fontFamily:'Poppins-Regular'   ),),
                            //     ),
                            //   ),
                            // ),
                            // _selectedImage !=null?Image.file(_selectedImage!) : Text(""),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School name in English".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text(
                                //   'School name in English'.tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _nameEnglish,
                                cursorColor: const Color(0xFF442B72),

                                style: TextStyle(color: Color(0xFF442B72)
                                ),

                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_NameArabicFocus);
                                },
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]+')), // Allow only English characters and spaces
                                ],


                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  errorText: _validateNameEnglish ? "Please Enter Your Name" : null,
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  hintText:"Your Name".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
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
                              ),
                            ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Your Name'.tr,
                            //
                            // ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "School name in Arabic".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _nameArabic,
                                focusNode: _NameArabicFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_AddressFocus);
                                },
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^[؀-ۿ ً ٌ ٍ َ ُ ِ ّ ْ]+$')), // Allow Arabic characters only
                                ],
                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  errorText: _validateNameArabic ? "Please Enter Your Name" : null,
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  hintText:"Your Name".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
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
                              ),
                            ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: 'Your Name'.tr,
                            // ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Address".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
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
                              height: 10,
                            ),
                            // Container(
                            //   width: constrains.maxWidth / 1.2,
                            //   height: 45,
                            //   child: TextFormField(
                            //     controller: _Address,
                            //     focusNode: _AddressFocus,
                            //     cursorColor: const Color(0xFF442B72),
                            //     onFieldSubmitted: (value) {
                            //       // move to the next field when the user presses the "Done" button
                            //       FocusScope.of(context).requestFocus(_CoordinatorFocus);
                            //     },
                            //     style: TextStyle(color: Color(0xFF442B72)),
                            //     //textDirection: TextDirection.ltr,
                            //     scrollPadding: const EdgeInsets.symmetric(
                            //         vertical: 40),
                            //     decoration:  InputDecoration(
                            //         suffixIcon: Image.asset("assets/imgs/school/icons8_Location.png",width: 23,height: 23,),
                            //         //Icon(Icons.location_on,color: Color(0xFF442B72),size: 23,),
                            //       alignLabelWithHint: true,
                            //       counterText: "",
                            //       fillColor: const Color(0xFFF1F1F1),
                            //       filled: true,
                            //       contentPadding: const EdgeInsets.fromLTRB(
                            //           8, 30, 10, 5),
                            //     //  hintText:"".tr,
                            //       floatingLabelBehavior:  FloatingLabelBehavior.never,
                            //       hintStyle: const TextStyle(
                            //         color: Color(0xFFC2C2C2),
                            //         fontSize: 12,
                            //         fontFamily: 'Inter-Bold',
                            //         fontWeight: FontWeight.w700,
                            //         height: 1.33,
                            //       ),
                            //       enabledBorder: myInputBorder(),
                            //        focusedBorder: myFocusBorder(),
                            //
                            //     ),
                            //   ),
                            // ),
                            // Form(
                            //   key: _formKey,
                            //   autovalidateMode: _autovalidateMode,
                            //   child: GooglePlacesAutoCompleteTextFormField(
                            //     textEditingController: _textController,
                            //     googleAPIKey: _yourGoogleAPIKey,
                            //     decoration: const InputDecoration(
                            //
                            //       labelText: 'Address',
                            //       labelStyle: TextStyle(color: Colors.purple),
                            //       border: OutlineInputBorder(),
                            //     ),
                            //     validator: (value) {
                            //       if (value!.isEmpty) {
                            //         return 'Please enter some text';
                            //       }
                            //       return null;
                            //     },
                            //     // proxyURL: _yourProxyURL,
                            //     maxLines: 1,
                            //     overlayContainer: (child) => Material(
                            //       elevation: 1.0,
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(12),
                            //       child: child,
                            //     ),
                            //     getPlaceDetailWithLatLng: (prediction) {
                            //       print('placeDetails${prediction.lng}');
                            //     },
                            //     itmClick: (Prediction prediction) =>
                            //     _textController.text = prediction.description!,
                            //   ),
                            // ),

                            Container(
                              height: 45,
                              width: constrains.maxWidth / 1.2,

                              child: Form(
                                key: _formKey,

                                autovalidateMode: _autovalidateMode,
                                child: GooglePlacesAutoCompleteTextFormField(

                                  cursorColor: Color(0xFF442B72),
                                  textEditingController: _textController,
                                  googleAPIKey: _yourGoogleAPIKey,
                                  decoration: InputDecoration(
                                    errorText: _validateAddress ? "Please Enter Your Address" : null,
                                    labelStyle: TextStyle(color: Colors.purple),
                                    suffixIcon: Image.asset(
                                      "assets/imgs/school/icons8_Location.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    alignLabelWithHint: true,
                                    counterText: "",
                                    fillColor: const Color(0xFFF1F1F1),
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(8, 10, 10, 5),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    hintStyle: const TextStyle(
                                      color: Color(0xFFC2C2C2),
                                      fontSize: 10,
                                      fontFamily: 'Inter-Bold',
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.black), // Customize border color
                                    ),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFocusBorder(),

                                  ),

                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
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
                                  itmClick: (Prediction prediction) => _textController.text = prediction.description!,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Coordinator Name".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,

                              height: 44,
                              child: TextFormField(
                                controller: _coordinatorName,
                                focusNode: _CoordinatorFocus,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  FocusScope.of(context).requestFocus(_SupporterFocus);
                                },
                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  errorText: _validateCoordinatorName ? "Please Enter Name" : null,
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  hintText:"Name".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
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

                              ),
                            ),
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: "Name".tr,
                            // ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child:
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      //color: Colors.black, // Setting default text color to black
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Support Number".tr,
                                        style: TextStyle(color: Color(0xFF442B72)),
                                      ),
                                      TextSpan(
                                        text: " *".tr,
                                        style: TextStyle(color: Color(0xFFAD1519)),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text(
                                //   "Support Number".tr,
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
                            SizedBox(height: 10,),
                            Container(
                              width: constrains.maxWidth / 1.2,
                              height: 44,
                              child: TextFormField(
                                controller: _supportNumber,
                                focusNode: _SupporterFocus,
                                keyboardType: TextInputType.number,
                                cursorColor: const Color(0xFF442B72),
                                style: TextStyle(color: Color(0xFF442B72)),
                                textInputAction: TextInputAction.next, // Move to the next field when "Done" is pressed
                                maxLength: 11,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                  LengthLimitingTextInputFormatter(11), // Limit the length programmatically
                                ],
                                onFieldSubmitted: (value) {
                                  // move to the next field when the user presses the "Done" button
                                  // FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
                                },
                                //textDirection: TextDirection.ltr,
                                scrollPadding: const EdgeInsets.symmetric(
                                    vertical: 40),
                                decoration:  InputDecoration(
                                  errorText: _validateSupportNumber ? "Please Enter Number" : null,
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: const Color(0xFFF1F1F1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      8, 30, 10, 5),
                                  hintText:"Number".tr,
                                  floatingLabelBehavior:  FloatingLabelBehavior.never,
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
                            // TextFormFieldCustom(
                            //   width: constrains.maxWidth / 1.2,
                            //   hintTxt: "Number".tr,
                            // ),

                            SizedBox(
                              //height: constrains.maxWidth /13,
                              height: 40,
                            ),

                            SizedBox(
                              width: constrains.maxWidth / 1.2,
                              child: Center(
                                child: ElevatedSimpleButton(
                                  txt: "Submit".tr,
                                  onPress: () async {
                                    setState(() {
                                      _nameEnglish.text.isEmpty ? _validateNameEnglish = true :  _validateNameEnglish = false;
                                      _nameArabic.text.isEmpty ? _validateNameArabic = true :  _validateNameArabic = false;
                                      _textController.text.isEmpty ? _validateAddress = true :  _validateAddress = false;
                                      _coordinatorName.text.isEmpty ? _validateCoordinatorName = true :  _validateCoordinatorName = false;
                                      _supportNumber.text.isEmpty ? _validateSupportNumber = true :  _validateSupportNumber = false;

                                      // _phoneNumberController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
                                    });
                               if(_supportNumber.text.length == 11 && ! _nameEnglish.text.isEmpty &&
                                   !_nameArabic.text.isEmpty
                                   && !_textController.text.isEmpty
                                   &&!_coordinatorName.text.isEmpty &&!_supportNumber.text.isEmpty&& _selectedImage!= null) {
                                 _addDataToFirestore();
                                 Navigator.push(

                                     context ,
                                     MaterialPageRoute(
                                         builder: (context) =>  HomeScreen(),
                                         maintainState: false));
                                           }else{
                                 // ScaffoldMessenger.of(context).showSnackBar(
                                 //     SnackBar(content: Text('Please,enter valid number')));
                               }

                                  },
                                  width: constrains.maxWidth /1.2,
                                  hight: 48,
                                  color: const Color(0xFF442B72),
                                  fontSize: 16,


                                ),
                                // end of comment
                              ),
                            ) ,

                            const SizedBox(
                              height: 60,
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

              ],
            ),
          );
        }
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //
        // floatingActionButton:


        //   Padding(
        //     padding: const EdgeInsets.all(2.0),
        //     child: SizedBox(
        //       //height: 100,
        //       child: FloatingActionButton(
        //         onPressed: () async {
        //
        //         },
        //         child: Image.asset(
        //           'assets/imgs/school/Ellipse 2.png',
        //           fit: BoxFit.fill,
        //         ),
        // ),
        //     ),
        //   ),


        // bottomNavigationBar:Directionality(
        //   textDirection: TextDirection.ltr,
        //   child: ClipRRect(
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(25),
        //       topRight: Radius.circular(25),
        //     ),
        //
        //     child: BottomAppBar(
        //
        //       color: const Color(0xFF442B72),
        //       clipBehavior: Clip.antiAlias,
        //       shape: const CircularNotchedRectangle(),
        //       //shape of notch
        //       notchMargin: 7,
        //       child: SizedBox(
        //         height: 50,
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 0.0),
        //           child: SingleChildScrollView(
        //             child: Row(
        //               mainAxisSize: MainAxisSize.max,
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: <Widget>[
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(
        //                       horizontal: 2.0,
        //                       vertical:5),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  HomeScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/icons8_home_1 1.png',
        //                               height: 21, width: 21),
        //                           Text("Home".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 8),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  NotificationScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/clarity_notification-line (1).png',
        //                               height: 22, width: 22),
        //                           Text('Notification'.tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left:100),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) =>  SupervisorScreen(),
        //                               maintainState: false));
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/empty_supervisor.png',
        //                               height: 22, width: 22),
        //                           Text("Supervisor".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize:10)),
        //                         ]
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding:
        //                   const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        //                   child: GestureDetector(
        //                     onTap: () {
        //                       Navigator.push(
        //                           context ,
        //                           MaterialPageRoute(
        //                               builder: (context) => BusScreen(),
        //                               maintainState: false));
        //                       // _key.currentState!.openDrawer();
        //                     },
        //                     child: Wrap(
        //                         crossAxisAlignment: WrapCrossAlignment.center,
        //                         direction: Axis.vertical,
        //                         children: [
        //                           Image.asset('assets/imgs/school/ph_bus-light (1).png',
        //                               height: 22, width: 22),
        //                           Text("Buses".tr,
        //                               style: TextStyle(
        //                                   color: Colors.white, fontSize: 10)),
        //                         ]),
        //                   ),
        //                 ),
        //               ]
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}




