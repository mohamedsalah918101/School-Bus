import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
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
import 'busesScreen.dart';
import 'homeScreen.dart';



class EditeBus extends StatefulWidget{
  final String docid;
  final String oldphotodriver;
  final String? olddrivername;
  final String olddriverphone;
  final String oldphotobus;
  final String olddnumberbus;
  const EditeBus({super.key,
  required this.docid,
  required this.oldphotodriver,
  required this.olddrivername,
  required this.olddriverphone,
  required this.oldphotobus,
  required this.olddnumberbus
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




  MyLocalController ControllerLang = Get.find();
  String? _selectedSupervisor;
  List<String> _supervisors = ['Supervisor 1', 'Supervisor 2', 'Supervisor 3'];
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

          await Bus.doc(widget.docid).update({
             'busnumber': _busnumbercontroller.text,
             //'busphoto': _imagebuscontroller.reactive,
            'imagedriver': imageUrldriver,
            'namedriver':_namedrivercontroller.text,
            'phonedriver':_phonedrivercontroller.text,

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
      return imageUrldriver;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }


  File ? _selectedImageBusEdite;
  String? imageUrldbus;
  Future _pickImagebusFromGallery() async{
    final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage ==null) return;
    setState(() {
      _selectedImageBusEdite=File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = FirebaseStorage.instance.ref().child('busphoto');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =referenceDirImages.child('busphotoedite');
    // Reference referenceDirImages =
    // referenceRoot.child('images');
    //
    // //Create a reference for the image to be stored


    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(returnedImage.path));
      //Success: get the download URL
      imageUrldbus = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrldbus');
      return imageUrldbus;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
      //Some error occurred
    }
  }
// to lock in landscape view
  @override
  void initState() {
    super.initState();
    //_imagedrivercontroller.reactive=widget.oldphotodriver!;
    _namedrivercontroller.text=widget.olddrivername!;
    _phonedrivercontroller.text=widget.olddriverphone!;
    _busnumbercontroller.text=widget.olddnumberbus!;
    imageUrldriver=widget.oldphotodriver!;
    imageUrldbus=widget.oldphotobus!;
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
        //resizeToAvoidBottomInset: false,
        endDrawer: HomeDrawer(),
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(onTap: (){},
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
                                    // GestureDetector(
                                    //   onTap: (){
                                    //     _pickImageDriverFromGallery();
                                    //     print('edit');
                                    //   },
                                    //   child:  CircleAvatar(
                                    //       radius: 30.5,
                                    //       backgroundColor: Color(0xff442B72),
                                    //       child: CircleAvatar(
                                    //         backgroundImage: NetworkImage( '$imageUrldriver'),
                                    //         radius: 30.5,)
                                    //   ),
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        _pickImageDriverFromGallery();
                                      },
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: _selectedImagedriverEdite!= null
                                            ? Image.file(_selectedImagedriverEdite!, width: 83, height: 78.5, fit: BoxFit.cover).image
                                            : AssetImage('assets/imgs/school/Ellipse 2 (1).png'),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 12),
                                  //   child:
                                  //   GestureDetector(
                                  //     onTap: (){
                                  //       _pickImageDriverFromGallery();
                                  //     },
                                  //
                                  //     child: CircleAvatar( radius:30, // Set the radius of the circle
                                  //       backgroundImage: AssetImage('assets/imgs/school/Ellipse 2 (1).png'),
                                  //     ),
                                  //   ),
                                  // ),
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
                                  keyboardType: TextInputType.number,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Stack(alignment: Alignment.topRight,
                                      children:[
                                        InteractiveViewer(
                                           // transformationController: _imagebuscontroller,
                                            child:
                                            //Image.network(widget.oldphotobus),
                                          Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,)
                                        ),

                                        Align(alignment: AlignmentDirectional.topEnd,
                                          child:
                                          Container(
                                              width:20,
                                              height: 20,
                                              decoration:BoxDecoration(
                                                  color: Color(0xFF442B72),
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child:
                                              GestureDetector(
                                                  onTap:(){
                                                    deletePhotoDialog(context);
                                                    //showSnackBarDeleteFun(context);
                                                  },
                                                  child:
                                                  Image.asset("assets/imgs/school/Vector (8).png",width:15,height: 15,)
                                              )),
                                        )]),
                                  // Stack(alignment: Alignment.topRight,
                                  //     children:[
                                  //       Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,),
                                  //       Align(alignment: AlignmentDirectional.topEnd,
                                  //         child:
                                  //         Container(
                                  //             width:20,
                                  //             height: 20,
                                  //             decoration:BoxDecoration(
                                  //                 color: Color(0xFF442B72),
                                  //                 borderRadius: BorderRadius.circular(20)
                                  //             ),
                                  //             child:
                                  //             GestureDetector(
                                  //                 onTap:(){
                                  //                   deletePhotoDialog(context);
                                  //                   //showSnackBarDeleteFun(context);
                                  //                 },
                                  //                 child:
                                  //                 Image.asset("assets/imgs/school/Vector (8).png",width:15,height: 15,)
                                  //             )),
                                  //       )]),
                                  // Stack(alignment: Alignment.topRight,
                                  //     children:[
                                  //       Image.asset("assets/imgs/school/Frame 137.png",width: 75,height: 74,),
                                  //       Align(alignment: AlignmentDirectional.topEnd,
                                  //         child:
                                  //         Container(
                                  //             width:20,
                                  //             height: 20,
                                  //             decoration:BoxDecoration(
                                  //                 color: Color(0xFF442B72),
                                  //                 borderRadius: BorderRadius.circular(20)
                                  //             ),
                                  //             child:
                                  //             GestureDetector(
                                  //                 onTap:(){
                                  //                   deletePhotoDialog(context);
                                  //                   //showSnackBarDeleteFun(context);
                                  //                 },
                                  //                 child:
                                  //                 Image.asset("assets/imgs/school/Vector (8).png",width:15,height: 15,)
                                  //             )),
                                  //       )]),

                                ],),



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
                                  keyboardType: TextInputType.number,
                                  maxLength: 11,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                    LengthLimitingTextInputFormatter(11), // Limit the length programmatically
                                  ],
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
                              Container(child:DropdownCheckboxEditeBus(
                                  items: [
                                    DropdownCheckboxItem(label: 'Ahmed Atef'),
                                    DropdownCheckboxItem(label: 'Shady Aymen'),
                                    DropdownCheckboxItem(label: 'Karem Ahmed'),
                                    DropdownCheckboxItem(label: 'Shady Aymen'),
                                    DropdownCheckboxItem(label: 'Karem Ahmed'),
                                  ], ),),

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
                                      Navigator.push(
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
          );
        }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            //height: 100,
            child: FloatingActionButton(
              backgroundColor:Color(0xff442B72),
              onPressed: () async {
               //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
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
                height: 55,
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
 deletePhotoDialog(context) {
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




