import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/Functions/functions.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../classes/dropdownCheckbox.dart';
import '../classes/dropdownCheckboxEditeBus.dart';
import '../classes/dropdowncheckboxitem.dart';
import '../components/bottom_bar_item.dart';
import '../components/dialogs.dart';
import '../components/elevated_simple_button.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import '../main.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';



class EditeBus extends StatefulWidget{
  final String docid;
  final String? oldphotodriver;
  final String? olddrivername;
  final String? olddriverphone;
  final List? oldphotobus;
  final String? olddnumberbus;
  List<DropdownCheckboxItem>allSupervisors;
   EditeBus({super.key,
  required this.docid,
  required this.oldphotodriver,
  required this.olddrivername,
  required this.olddriverphone,
  required this.oldphotobus,
  required this.olddnumberbus,
     required this.allSupervisors
  });
  //const EditeBus({super.key});
  @override
  State<EditeBus> createState() => _EditeBusState();
}


class _EditeBusState extends State<EditeBus> {
  final GlobalKey<ScaffoldState> _scaffoldeditebus = GlobalKey<ScaffoldState>();
  final TransformationController _imagedrivercontroller = TransformationController();
  final TransformationController _imagebuscontroller = TransformationController();
  TextEditingController _namedrivercontroller = TextEditingController();
  TextEditingController _phonedrivercontroller = TextEditingController();
  TextEditingController _busnumbercontroller = TextEditingController();
  TextEditingController _supervisorController = TextEditingController();




  MyLocalController ControllerLang = Get.find();
  String? _selectedSupervisor;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  CollectionReference Bus = FirebaseFirestore.instance.collection('busdata');
  editAddBus() async {
    print('editAddBus called');

    if (formState.currentState != null) {
      print('formState.currentState is not null');

      if (formState.currentState!.validate()) {
        print('form is valid');

        try {
          print('updating document...');
          List<Map<String, dynamic>> supervisorsList = List.generate(
            selectedItems.length,
                (index) {
              FirebaseFirestore.instance
                  .collection('supervisor')
                  .doc(selectedItems[index].docID)
                  .update({'bus_id':widget.docid
              });
              return {
                'name': selectedItems[index].label,
                'phone': selectedItems[index].phone,
                'id': selectedItems[index].docID,
              };
            },
          );

          await Bus.doc(widget.docid).update({
             'busnumber': _busnumbercontroller.text,
            'supervisors':supervisorsList,
            'imagedriver': imageUrldriver  ?? '',
            'namedriver':_namedrivercontroller.text,
            'phonedriver':_phonedrivercontroller.text,
            'busphoto':imageUrldbus ??'',
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
  File ? _selectedImagedriverEdite;
  String? imageUrldriver;

  //String _selectedImageDriver = '';
  Future _pickImageDriverFromGallery() async{
    final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage ==null) return;
    setState(() {
      _selectedImagedriverEdite=File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = FirebaseStorage.instance.ref().child('photo');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =referenceDirImages.child('driver');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      imageUrldriver = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrldriver');

      print('Image uploaded successfully. URL: $imageUrldbus');
      // await Bus.doc(widget.docid).update({
      //   'imagedriver': imageUrldriver,
      // });

      setState(() {
        _selectedImagedriverEdite = File(returnedImage.path);
      });
      return imageUrldriver;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }

// image of bus only one image
  // File ? _selectedImageBusEdite;
  // String? imageUrldbus;
  // Future _pickImagebusFromGallery() async{
  //   final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if(returnedImage ==null) return;
  //   setState(() {
  //     _selectedImageBusEdite=File(returnedImage.path);
  //   });
  //
  //   //Get a reference to storage root
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirImages = FirebaseStorage.instance.ref().child('busphoto');
  //   // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
  //   Reference referenceImageToUpload =referenceDirImages.child('busphotoedite');
  //   // Reference referenceDirImages =
  //   // referenceRoot.child('images');
  //   //
  //   // //Create a reference for the image to be stored
  //
  //
  //   //Handle errors/success
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(returnedImage.path));
  //     //Success: get the download URL
  //     imageUrldbus = await referenceImageToUpload.getDownloadURL();
  //     print('Image uploaded successfully. URL: $imageUrldbus');
  //     await Bus.doc(widget.docid).update({
  //       'busphoto': imageUrldbus,
  //     });
  //     return imageUrldbus;
  //   } catch (error) {
  //     print('Error uploading image: $error');
  //     return '';
  //     //Some error occurred
  //   }
  // }

  File? _selectedImageBusEdite;
  List<String> imageUrldbus = [];
  Future<void> _pickImagebusFromGallery() async {
    final List<XFile>? returnedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 600,
    );
    if (returnedImages == null || returnedImages.isEmpty) return;

    setState(() {
      for (var image in returnedImages) {
        _selectedImageBusEdite = File(image.path);
        _uploadImage(_selectedImageBusEdite!);
      }
    });
  }

  Future<void> _uploadImage(File image) async {
    // Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('busphoto');
    Reference referenceImageToUpload = referenceDirImages.child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Handle errors/success
    try {
      // Store the file
      await referenceImageToUpload.putFile(image);
      // Success: get the download URL
      String imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {
        imageUrldbus.add(imageUrl);
      });
      await Bus.doc(widget.docid).update({
        'busphoto': imageUrldbus,
      });
      print('Image uploaded successfully. URL: $imageUrl');
    } catch (error) {
      print('Error uploading image: $error');
    }
  }



//fun to get current schoolid
  String? _schoolId;

  Future<void> getSchoolId() async {
    try {
      // Get the SharedPreferences instance
      // final prefs = await SharedPreferences.getInstance();

      // Retrieve the school ID from SharedPreferences
      _schoolId = sharedpref!.getString('id');
      print("SCHOOLIDshh$_schoolId");
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
  List<QueryDocumentSnapshot> data = [];
  List<DropdownCheckboxItem> items=[];
  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('supervisor')
        .where('schoolid', isEqualTo: _schoolId)
        .where('state', isEqualTo: 1)
        //.where('bus_id', isEqualTo: '')
        .get();

    // data.addAll(querySnapshot.docs);
    for(int i=0;i<querySnapshot.docs.length;i++)
    {
    var contain = selectedItems.where((element) => element.docID == querySnapshot.docs[i].id);
    if (contain.isEmpty)
      items.add(DropdownCheckboxItem(label:querySnapshot.docs[i].get('name'),docID: querySnapshot.docs[i].id,phone: querySnapshot.docs[i].get('phoneNumber'),isChecked: false));

    else
      items.add(DropdownCheckboxItem(label:querySnapshot.docs[i].get('name'),docID: querySnapshot.docs[i].id,phone: querySnapshot.docs[i].get('phoneNumber'),isChecked: true));


    }
    setState(() {

    });
  }

  // fun delete busphoto
  String docid='';

  // void _deletebusphoto() {
  //   FirebaseFirestore.instance.collection('busdata').doc(widget.docid).set(
  //     {'busphoto': FieldValue.delete()},
  //     SetOptions(
  //       merge: true,
  //     ),
  //   );
  // }
  //old delete one image
  void _deletebusphoto() {
    FirebaseFirestore.instance.collection('busdata').doc(widget.docid).update({
      'busphoto': FieldValue.delete(),
    }).then((_) {
      FirebaseFirestore.instance.collection('busdata').doc(widget.docid).update({
        'busphoto': '',
      });
    }).catchError((error) {
      print("Failed to delete busphoto: $error");
    });
  }
  Future<void> _deleteImageFromStorageAndFirestore(int index) async {
    String imageUrl = imageUrldbus[index];
    Reference photoRef = FirebaseStorage.instance.refFromURL(imageUrl);

    try {
      await photoRef.delete();
      setState(() {
        imageUrldbus.removeAt(index);
      });
      await FirebaseFirestore.instance.collection('busdata').doc(widget.docid).update({
        'busphoto': FieldValue.arrayRemove([imageUrl]),
      });
      print('Image deleted successfully.');
    } catch (error) {
      print('Error deleting image: $error');
    }
  }
  void _deleteImage(int index) {
    setState(() {

      imageUrldbus.removeAt(index);
    });
    _deleteImageFromStorageAndFirestore(index);
  }
  //new delete
  // void _deletebusphoto(String photoUrlToDelete) {
  //   if (widget.oldphotobus != null) {
  //     List<dynamic> updatedPhotos = List<dynamic>.from(widget.oldphotobus!);
  //
  //     // Remove the photoUrlToDelete from the list
  //     updatedPhotos.remove(photoUrlToDelete);
  //
  //     // Update Firestore document with the updated photos list
  //     FirebaseFirestore.instance.collection('busdata').doc(widget.docid).update({
  //       'busphoto': updatedPhotos,
  //     }).then((_) {
  //       print('Photo deleted successfully.');
  //     }).catchError((error) {
  //       print('Failed to delete photo: $error');
  //     });
  //   }
  // }


// to lock in landscape view
  @override
  void initState() {

    super.initState();
    selectedItems.clear();
    selectedItems=widget.allSupervisors;
    //_imagedrivercontroller.reactive=widget.oldphotodriver!;
    _namedrivercontroller.text=widget.olddrivername!;
    _phonedrivercontroller.text=widget.olddriverphone!;
    _busnumbercontroller.text=widget.olddnumberbus!;
   // imageUrldbus=widget.oldphotobus!;
    // Initialize imageUrldbus with all the images from oldphotobus, ensuring it's not null
    if (widget.oldphotobus != null) {
      imageUrldbus = List<String>.from(widget.oldphotobus!.map((item) => item.toString()));
    }

    imageUrldriver=widget.oldphotodriver!;
    getSchoolId();
    getData();

    //imageUrldriver=widget.oldphotodriver!;
    //imageUrldbus=widget.oldphotobus!;
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
          color:  Color(0xFF442B72),
          width: 0.5,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color:  Color(0xFF442B72),
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
    //final GlobalKey<ScaffoldState> _scaffoldeditebus = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldeditebus,
        resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
        backgroundColor: const Color(0xFFFFFFFF),
        body:GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(builder: (context, constrains) {
            return
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        SizedBox(width: 20,),
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
                          child: InkWell(onTap: (){
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
                   // reverse: true,
                    child: Form(
                      key: formState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),


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
                                  padding: const EdgeInsets.only(top:5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child:
                                            Stack(
                                              children:
                                              [
                                                _selectedImagedriverEdite != null
                                                    ? Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(width: 2, color: Color(0xff432B72)),
                                                  ),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        child: ClipOval(
                                                          child: Image.file(
                                                  _selectedImagedriverEdite!,  // Display the uploaded image
                                                  width: 83,  // Set width as per your preference
                                                  height: 78.5,  // Set height as per your preference
                                                  fit: BoxFit.cover,  // Adjusts how the image fits in the container
                                                ),
                                                        ),
                                                      ),
                                                    ) :
                                                GestureDetector(
                                                onTap: () {
                                                  _pickImageDriverFromGallery();
                                                },
                                                child:
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(width: 2, color: Color(0xff432B72)),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                    (widget.oldphotodriver == null || widget.oldphotodriver == '') ?
                                                    _selectedImagedriverEdite!= null
                                                        ? Image.file(_selectedImagedriverEdite!, width: 83, height: 78.5, fit: BoxFit.cover).image
                                                        : AssetImage('assets/imgs/school/Ellipse 2 (1).png'):
                                                    NetworkImage(widget.oldphotodriver!),
                                                   // NetworkImage(_selectedImageDriver),
                                                  ),
                                                ),

                                              ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 40, left: 45),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(width: 2, color: Color(0xff432B72)),
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      radius: 8,
                                                      child:
                                                      GestureDetector(
                                                        onTap: (){
                                                          _pickImageDriverFromGallery();

                                                        },
                                                        child: Image.asset(
                                                          'assets/imgs/school/edite.png',
                                                          fit: BoxFit.cover,
                                                          width: 12,
                                                          height: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     _pickImageDriverFromGallery();
                                            //   },
                                            //   child: Stack(
                                            //     children: [
                                            //       Center(
                                            //         child: Padding(
                                            //           padding: const EdgeInsets.only(top: 20),
                                            //           child: _selectedImagedriverEdite != null
                                            //               ? Image.file(
                                            //             _selectedImagedriverEdite!,
                                            //             width: 83,
                                            //             height: 78.5,
                                            //             fit: BoxFit.cover,
                                            //           )
                                            //               : CircleAvatar(
                                            //             backgroundColor: Colors.white,
                                            //             radius: 50,
                                            //             child: widget.oldphotodriver == null || widget.oldphotodriver == ''
                                            //                 ? Image.asset(
                                            //               'assets/imgs/school/Ellipse 2 (1).png',
                                            //               fit: BoxFit.cover,
                                            //               width: 100,
                                            //               height: 100,
                                            //             )
                                            //                 : Image.network(
                                            //               widget.oldphotodriver!,
                                            //               fit: BoxFit.fill,
                                            //               width: 90,
                                            //               height: 90,
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       Center(
                                            //         child: Padding(
                                            //           padding: const EdgeInsets.only(top: 95, left: 55),
                                            //           child: Container(
                                            //             decoration: BoxDecoration(
                                            //               shape: BoxShape.circle,
                                            //               border: Border.all(width: 3, color: Color(0xff432B72)),
                                            //             ),
                                            //             child: CircleAvatar(
                                            //               backgroundColor: Colors.white,
                                            //               radius: 10,
                                            //               child: Image.asset(
                                            //                 'assets/imgs/school/edite.png',
                                            //                 fit: BoxFit.cover,
                                            //                 width: 15,
                                            //                 height: 15,
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),

                                          ),


                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                                            child: Align(
                                              alignment: AlignmentDirectional.topStart,
                                              child:
                                              RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(text:"Driver photo",style: TextStyle(color: Color(0xff442B72),fontSize: 15,height: 1.07,fontFamily:'Poppins-Bold' )),
                                                      TextSpan(text: " *",style: TextStyle(color: Color(0xffDB4446),fontSize: 15,height: 1.07,fontFamily:'Poppins-Bold'))
                                                    ]
                                                ),
                                              ),

                                            ),
                                          ),
                                        ],
                                      ),
                                      // Padding(

                                      const SizedBox(
                                        height: 30,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:35,vertical: 0 ),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child:
                                          RichText(
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
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: 'Your Name'.tr,
                                      // ),
                                      SizedBox(height: 15,),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 38,
                                        child: TextField(
                                          style: TextStyle(color: Color(0xFF442B72)),
                                           controller: _namedrivercontroller,
                                          cursorColor: const Color(0xFF442B72),
                                          //textDirection: TextDirection.ltr,
                                          scrollPadding: const EdgeInsets.symmetric(
                                              vertical: 40),
                                          decoration:  InputDecoration(
                                            // labelText: 'Shady Ayman'.tr,

                                            hintStyle: TextStyle(color: Color(0xff442B72)),
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding: const EdgeInsets.fromLTRB(
                                                8, 5, 10, 5),
                                            floatingLabelBehavior:  FloatingLabelBehavior.never,
                                            enabledBorder: myInputBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),

                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:35,vertical: 0),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child:
                                          RichText(
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
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: 'Your Number'.tr,
                                      // ),
                                      SizedBox(height: 15,),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 38,
                                        child: TextField(
                                          style: TextStyle(color: Color(0xFF442B72)),
                                           controller: _phonedrivercontroller,
                                          cursorColor: const Color(0xFF442B72),
                                          //textDirection: TextDirection.ltr,
                                          scrollPadding: const EdgeInsets.symmetric(
                                              vertical: 40),
                                          keyboardType: TextInputType.phone,

                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                            LengthLimitingTextInputFormatter(11), // Limit the length programmatically
                                          ],
                                          decoration:  InputDecoration(
                                            // labelText: 'Shady Ayman'.tr,
                                          //  hintText:'01028765006'.tr ,
                                            hintStyle: TextStyle(color: Color(0xff442B72)),
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding: const EdgeInsets.fromLTRB(
                                                8, 5, 10, 5),
                                            floatingLabelBehavior:  FloatingLabelBehavior.never,
                                            enabledBorder: myInputBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),

                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:35,vertical: 0 ),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
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
                                      SizedBox(
                                        height: 15,
                                      ),

                                      // Align(alignment: AlignmentDirectional.center,
                                      //   child: Container(
                                      //     width: 290, // Adjust width as needed
                                      //     height: 75, // Adjust height as needed
                                      //     decoration: BoxDecoration(
                                      //       // borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                                      //       image: DecorationImage(
                                      //         image: AssetImage('assets/imgs/school/Frame 136.png'), // Provide the path to your image
                                      //         fit: BoxFit.fill, // Adjust the fit as needed
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // bus photo 25/6
                            //           Row(
                            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //             children: [
                            //
                            //               // Stack(alignment: Alignment.topRight,
                            //               //     children:[
                            //               //       // InteractiveViewer(
                            //               //       //    // transformationController: _imagebuscontroller,
                            //               //       //     child:(widget.oldphotobus == null || widget.oldphotobus == '') ?
                            //               //       //     //Image.network(widget.oldphotobus),
                            //               //       //   Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,):
                            //               //       //         Image.network(widget.oldphotobus!,width: 75,height: 74,fit: BoxFit.cover,)
                            //               //       // ),
                            //               //       _selectedImageBusEdite != null
                            //               //           ? Image.file(
                            //               //         _selectedImageBusEdite!,  // Display the uploaded image
                            //               //         width: 83,  // Set width as per your preference
                            //               //         height: 78.5,  // Set height as per your preference
                            //               //         fit: BoxFit.cover,  // Adjusts how the image fits in the container
                            //               //       ) :
                            //               //       GestureDetector(
                            //               //         onTap: () {
                            //               //           _pickImagebusFromGallery();
                            //               //         },
                            //               //         child: InteractiveViewer(
                            //               //           child: _selectedImageBusEdite != null
                            //               //               ? Image.file(_selectedImageBusEdite!, width: 75, height: 74, fit: BoxFit.cover)
                            //               //               : (widget.oldphotobus == null || widget.oldphotobus == '')
                            //               //               ?     FDottedLine(
                            //               //             color: Color(0xFF442B72),
                            //               //             strokeWidth: 0.8,
                            //               //             dottedLength: 10,
                            //               //             space: 5.0,
                            //               //             corner:
                            //               //             FDottedLineCorner.all(6.0),
                            //               //
                            //               //             // Child widget
                            //               //             child: Container(
                            //               //               width: 275,
                            //               //               height: 75,
                            //               //               alignment: Alignment.center,
                            //               //               child: Row(
                            //               //                 children: [
                            //               //                   Padding(
                            //               //                     padding:
                            //               //                     const EdgeInsets
                            //               //                         .only(left: 80),
                            //               //                     child: Image.asset(
                            //               //                       "assets/imgs/school/icons8_image_document_1 1.png",
                            //               //                       width: 24,
                            //               //                       height: 24,
                            //               //                     ),
                            //               //                   ),
                            //               //                   SizedBox(
                            //               //                     width: 10,
                            //               //                   ),
                            //               //                   Text(
                            //               //                     "upload image",
                            //               //                     style: TextStyle(
                            //               //                       color:
                            //               //                       Color(0xFF442B72),
                            //               //                       fontSize: 14,
                            //               //                       fontFamily:
                            //               //                       'Poppins-Regular',
                            //               //                     ),
                            //               //                   ),
                            //               //                 ],
                            //               //               ),
                            //               //             ),
                            //               //           )
                            //               //           //Image.asset("assets/imgs/school/Frame 137.png", width: 75, height: 74)
                            //               //               : Image.network(widget.oldphotobus!, width: 75, height: 74, fit: BoxFit.cover),
                            //               //         ),
                            //               //       ),
                            //               //
                            //               //       Align(alignment: AlignmentDirectional.topEnd,
                            //               //         child:
                            //               //         Container(
                            //               //             width:20,
                            //               //             height: 20,
                            //               //             decoration:BoxDecoration(
                            //               //                 color: Color(0xFF442B72),
                            //               //                 borderRadius: BorderRadius.circular(20)
                            //               //             ),
                            //               //             child:
                            //               //             GestureDetector(
                            //               //                 onTap:(){
                            //               //                   deletePhotoDialog(context);
                            //               //                   //showSnackBarDeleteFun(context);
                            //               //                 },
                            //               //                 child:
                            //               //                 Image.asset("assets/imgs/school/Vector (8).png",width:15,height: 15,)
                            //               //             )),
                            //               //       )
                            //               //     ]),
                            //             Stack(
                            //             alignment: Alignment.topRight,
                            //             children: [
                            //               _selectedImageBusEdite != null
                            //                   ? Image.file(
                            //                 _selectedImageBusEdite!, // Display the uploaded image
                            //                 width: 83, // Set width as per your preference
                            //                 height: 78.5, // Set height as per your preference
                            //                 fit: BoxFit.cover, // Adjusts how the image fits in the container
                            //               )
                            //                   : GestureDetector(
                            //                 onTap: () {
                            //                   _pickImagebusFromGallery();
                            //                 },
                            //                 child: InteractiveViewer(
                            //                   child:
                            //                   _selectedImageBusEdite != null
                            //                       ? Image.file(_selectedImageBusEdite!,
                            //                       width: 75, height: 74, fit: BoxFit.cover)
                            //                       : (widget.oldphotobus == null || widget.oldphotobus == '')
                            //                       ?
                            //                   FDottedLine(
                            //                     color: Color(0xFF442B72),
                            //                     strokeWidth: 1.4,
                            //                     dottedLength: 10,
                            //                     space: 5.0,
                            //                     corner: FDottedLineCorner.all(6.0),
                            //
                            //                     // Child widget
                            //                     child: Container(
                            //                       width: 275,
                            //                       height: 75,
                            //                       alignment: Alignment.center,
                            //                       child: Row(
                            //                         children: [
                            //                           Padding(
                            //                             padding: const EdgeInsets.only(left: 80),
                            //                             child: Image.asset(
                            //                               "assets/imgs/school/icons8_image_document_1 1.png",
                            //                               width: 24,
                            //                               height: 24,
                            //                             ),
                            //                           ),
                            //                           SizedBox(
                            //                             width: 10,
                            //                           ),
                            //                           Text(
                            //                             "upload image",
                            //                             style: TextStyle(
                            //                               color: Color(0xFF442B72),
                            //                               fontSize: 14,
                            //                               fontFamily: 'Poppins-Regular',
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   )
                            //                       :
                            //                   Wrap(
                            //                     children: imageUrldbus.map((imageUrl) {
                            //                         return Padding(
                            //                           padding: const EdgeInsets.all(4.0),
                            //                           child: Container(
                            //                             decoration: BoxDecoration(
                            //                               border: Border.all(
                            //                                 color: Color(0xFF442B72), // border color
                            //                                 width: 2, // border width
                            //                               ),
                            //                               borderRadius: BorderRadius.circular(5),),
                            //                             child: Image.network(
                            //                               imageUrl,
                            //                               height: 100,
                            //                               width: 80,
                            //                               fit: BoxFit.cover,
                            //                             ),
                            //                           ),
                            //                         );
                            //                     }).toList(),
                            //                   ),
                            //
                            //                       // old bus photo
                            //                   // Image.network(widget.oldphotobus!,
                            //                   //     width: 75, height: 74, fit: BoxFit.cover),
                            //
                            //                 ),
                            //               ),
                            //               if (_selectedImageBusEdite != null || (widget.oldphotobus != null && widget.oldphotobus != ''))
                            //                 Align(
                            //                   alignment: AlignmentDirectional.topEnd,
                            //                   child: Container(
                            //                     width: 20,
                            //                     height: 20,
                            //                     decoration: BoxDecoration(
                            //                       color: Color(0xFF442B72),
                            //                       borderRadius: BorderRadius.circular(20),
                            //                     ),
                            //                     child: GestureDetector(
                            //                       onTap: () {
                            //                         deletePhotoDialog(context);
                            //                         //showSnackBarDeleteFun(context);
                            //                       },
                            //                       child: Image.asset(
                            //                         "assets/imgs/school/Vector (8).png",
                            //                         width: 15,
                            //                         height: 15,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //             ],
                            //           )
                            //
                            //
                            // ],),

                            Align(
                              alignment: AlignmentDirectional.center,
                              child: GestureDetector(
                                onTap: () async {
                                  //await _pickImagebusFromGallery();
                                },
                                child: imageUrldbus.isNotEmpty
                                    ? Container(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 35,right: 5),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageUrldbus.length,
                                            itemBuilder: (context, index) {
                                              return Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Color(0xFF442B72), // border color
                                                          width: 2, // border width
                                                        ),
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Image.network(
                                                        imageUrldbus[index],
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
                                                        deletePhotoDialog(context,index);// Call delete function
                                                      },
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFF442B72),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 15,
                                                          color: Colors.white,
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
                                      if (imageUrldbus.length < 5) // Show FDottedLine if less than 5 images chosen
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await _pickImagebusFromGallery();
                                            },
                                            child: FDottedLine(
                                              color: Color(0xFF442B72),
                                              strokeWidth: 0.8,
                                              dottedLength: 10,
                                              space: 5.0,
                                              corner: FDottedLineCorner.all(6.0),
                                              child: Container(
                                                width: 150,
                                                height: 75,
                                                alignment: Alignment.center,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Color(0xFF442B72),
                                                        size: 24,
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
                                    ],
                                  ),
                                )
                                    : GestureDetector(
                                  onTap: () async {
                                    await _pickImagebusFromGallery();
                                  },
                                      child: FDottedLine(
                                  color: Color(0xFF442B72),
                                  strokeWidth: 0.8,
                                  dottedLength: 10,
                                  space: 5.0,
                                  corner: FDottedLineCorner.all(6.0),
                                  child: Container(
                                      width: 275,
                                      height: 75,
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 80),
                                            child: Icon(
                                              Icons.image,
                                              color: Color(0xFF442B72),
                                              size: 24,
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
                            ),

                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:35,vertical: 0 ),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child:
                                          RichText(
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
                                      // TextFormFieldCustom(
                                      //   width: constrains.maxWidth / 1.3,
                                      //   hintTxt: "Your Number".tr,
                                      // ),
                                      SizedBox(height: 15,),
                                      Container(
                                        width: constrains.maxWidth / 1.3,
                                        height: 38,
                                        child: TextField(
                                          style: TextStyle(color: Color(0xFF442B72)),
                                          controller: _busnumbercontroller,
                                          cursorColor: const Color(0xFF442B72),
                                          keyboardType: TextInputType.name,

                                          //textDirection: TextDirection.ltr,
                                          scrollPadding: const EdgeInsets.symmetric(
                                              vertical: 40),
                                          decoration:  InputDecoration(
                                            // labelText: 'Shady Ayman'.tr,
                                            //hintText:'ي ر س 1458'.tr ,
                                            hintStyle: TextStyle(color: Color(0xff442B72)),
                                            alignLabelWithHint: true,
                                            counterText: "",
                                            fillColor: const Color(0xFFF1F1F1),
                                            filled: true,
                                            contentPadding: const EdgeInsets.fromLTRB(
                                                8, 5, 10, 5),
                                            floatingLabelBehavior:  FloatingLabelBehavior.never,
                                            enabledBorder: myInputBorder(),
                                            focusedBorder: myFocusBorder(),
                                          ),

                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:35,vertical: 0 ),
                                        child: Align(
                                          alignment: AlignmentDirectional.topStart,
                                          child:
                                          RichText(
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

                                      SizedBox(height: 15,),

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
                                      //old checkbox
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
                                      //       hintText: "Atef Karim",
                                      //       floatingLabelBehavior: FloatingLabelBehavior.never,
                                      //       hintStyle: const TextStyle(
                                      //         color: Color(0xff442B72),
                                      //         fontSize: 12,
                                      //         fontFamily: 'Inter-Bold',
                                      //         fontWeight: FontWeight.w700,
                                      //         height: 1.33,
                                      //       ),
                                      //       // enabledBorder: OutlineInputBorder(
                                      //       //   borderSide: BorderSide(color: Color(0xff442B72),width: 0.5,),
                                      //       // ),
                                      //       // focusedBorder: OutlineInputBorder(
                                      //       //   borderSide: BorderSide(color: Color(0xFF442B72),width: 0.5,),
                                      //       // ),
                                      //       enabledBorder: myInputBorder(),
                                      //       focusedBorder: myFocusBorder(),
                                      //     ),
                                      //
                                      //   ),
                                      // ),
                                      Container(
                                        child:DropdownCheckboxEditeBus
                                        //DropdownCheckbox
                                          (
                                            controller: _supervisorController,
                                            items:
                                            items
                                        ),),
                                      // Container(child:DropdownCheckboxEditeBus(
                                      //     items: [
                                      //       DropdownCheckboxItem(label: 'Ahmed Atef'),
                                      //       DropdownCheckboxItem(label: 'Shady Aymen'),
                                      //       DropdownCheckboxItem(label: 'Karem Ahmed'),
                                      //       DropdownCheckboxItem(label: 'Shady Aymen'),
                                      //       DropdownCheckboxItem(label: 'Karem Ahmed'),
                                      //     ], ),),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      SizedBox(
                                        width: constrains.maxWidth / 1.3,
                                        child: Center(

                                          child: ElevatedSimpleButton(
                                            txt: "Save".tr,
                                            onPress: (){
                                              editAddBus();
                                              showSnackBarFun(context);
                                              Navigator.pushReplacement(
                                                  context ,
                                                  MaterialPageRoute(
                                                      builder: (context) =>  BusScreen(),
                                                      maintainState: false)
                                              );
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
                                        height: 40,
                                      ),

                                      Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
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
                    ),
                  ),
            ),
                ],
              );
          }
          ),
        ),
        //extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor:Color(0xff442B72),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
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


        bottomNavigationBar:
        Directionality(
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
              shape: const AutomaticNotchedShape( RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.5),
                      topRight: Radius.circular(38.5))),
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(50)))),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical:5),
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              Navigator.push(
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
                              Navigator.push(
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
                              Navigator.push(
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
                              Navigator.push(
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
                                  Image.asset('assets/imgs/school/fillbus.png',
                                      height: 20, width: 20),
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
            'assets/imgs/school/Vector (4).png', // Replace 'assets/image.png' with your image path
            width: 30, // Adjust width as needed
            height: 30, // Adjust height as needed
          ),
          SizedBox(width: 20), // Add some space between the image and the text
          Text(
            'Data saved successfully',
            style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff4CAF50)),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 170,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
 deletePhotoDialog(context,int index) {
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
          child: SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Align(alignment: AlignmentDirectional.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Are you sure you want to',
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 20,
                              fontFamily: 'Poppins-Regular',
                              //fontWeight: FontWeight.w400,
                              height: 1.23,
                            ),
                          ),
                          Center(
                            child: Text(
                              'delete photo?',
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 20,
                               fontFamily: 'Poppins-Regular',
                               // fontWeight: FontWeight.w400,
                                height: 1.23,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      ElevatedSimpleButton(
                        txt: 'Delete',
                        width: 120,
                        hight: 38,
                        onPress: () => {
                        _deleteImage(index),
                        Navigator.pop(context),
                          showSnackBarDeleteFun(context),
                        }

                        // Navigator.of(context).pushAndRemoveUntil(
                        // MaterialPageRoute(
                        //     builder: (context) => const SignUpScreen()),
                        //     (Route<dynamic> route) => false)
                        ,
                        color: const Color(0xFF442B72),
                        fontSize: 16,
                      ),
                      const Spacer(),
                      ElevatedSimpleButton(
                        txt: 'Cancel',
                        width: 120,
                        hight: 38,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        color: const Color(0xffffffff),
                        fontSize: 16,
                        txtColor: Color(0xFF442B72),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
  showSnackBarDeleteFun(context) {
    SnackBar snackBar = SnackBar(

      // content: const Text('Invitation sent successfully',
      //     style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff442B72))
      // ),
      content: Row(
        children: [
          // Add your image here
          Image.asset(
            'assets/imgs/school/Vector (4).png', // Replace 'assets/image.png' with your image path
            width: 30, // Adjust width as needed
            height: 30, // Adjust height as needed
          ),
          SizedBox(width: 20), // Add some space between the image and the text
          Text(
            'Image deleted successfully',
            style: TextStyle(fontSize: 16,fontFamily: "Poppins-Bold",color: Color(0xff4CAF50)),
          ),
        ],
      ),
      backgroundColor: Color(0xffFFFFFF),
      duration: Duration(seconds: 2),

      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 170,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}




