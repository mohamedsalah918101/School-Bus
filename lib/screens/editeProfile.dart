import 'dart:async';


//
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_account/components/elevated_simple_button.dart';
import 'package:school_account/components/home_drawer.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
//import '../components/child_data_item.dart';
import '../components/custom_app_bar.dart';
import '../components/dialogs.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';
import 'notificationsScreen.dart';
import 'dart:io';
//import '../components/profile_child_card.dart';

class EditeProfile extends StatefulWidget {
  final String docid;
  final String oldNameEnglish;
  final String? oldNameArabic;
  final String oldAddress;
  final String oldSchoolLogo;
  final String oldCoordinatorName;
  final String oldSupportNumber;
  // const EditeSupervisor({super.key});
  const EditeProfile({super.key,
    required this.docid,
    required this.oldNameEnglish,
    required this.oldNameArabic,
    required this.oldAddress,
    required this.oldSchoolLogo,
    required this.oldCoordinatorName,
    required this.oldSupportNumber,
  });
  @override
  _EditeProfileState createState() => _EditeProfileState();
}

class _EditeProfileState extends State<EditeProfile> {
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
  File ? _selectedImageEditeProfile;
  String? editeprofileimageUrl;
  Future _pickEditeProfileImageFromGallery() async{
    final returnedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage ==null) return;
    setState(() {
      _selectedImageEditeProfile=File(returnedImage.path);
    });

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = FirebaseStorage.instance.ref().child('editeprofilephoto');
    // Reference referenceImageToUpload = referenceDirImages.child(returnedImage.path.split('/').last);
    Reference referenceImageToUpload =referenceDirImages.child('editeprofile');
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
  @override
  void initState() {
    super.initState();
    _nameEnglish.text = widget.oldNameEnglish!;
    _nameArabic.text=widget.oldNameArabic!;
    _Address.text=widget.oldAddress!;
    _coordinatorName.text=widget.oldCoordinatorName!;
    _supportNumber.text=widget.oldSupportNumber!;
    editeprofileimageUrl=widget.oldSchoolLogo!;
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     resizeToAvoidBottomInset: false,
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
            //icon menu and drawer
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
            title: Text('Edit Profile'.tr ,
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
      //Custom().customAppBar(context, 'Edite Profile'),
      body: SingleChildScrollView(
         reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.white, // Set background color to white
                          radius:50, // Set the radius according to your preference
                          child: Image.asset(
                            'assets/imgs/school/Ellipse 2 (2).png',
                            fit: BoxFit.cover,
                            width: 100, // Set width of the image
                            height: 100, // Set height of the image
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 95,left: 55),
                        child: GestureDetector(
                          onTap: (){
                            Dialoge.changePhotoDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 3,color: Color(0xff432B72))
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              // Set background color to white
                              radius:10, // Set the radius according to your preference
                              child: GestureDetector(
                                onTap: (){
                                  _pickEditeProfileImageFromGallery();
                                },
                                child: Image.asset(
                                  'assets/imgs/school/edite.png',
                                  fit: BoxFit.cover,
                                  width: 15, // Set width of the image
                                  height: 15, // Set height of the image
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),


              // Center(child: Text("Salam School",style: TextStyle(color: Color(0xff432B72),fontSize: 20,fontFamily: "Poppins-SemiBold"),)
              // ),
              SizedBox(height: 20,),
              Text("School information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                  color: Color(0xff771F98)),),
              SizedBox(height: 15,),
              Text('School name in English'.tr,style: TextStyle(color: Color(0xFF442B72),fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
              SizedBox(height: 10,),
              Container(
                width: 320,
                height: 45,
                child: TextFormField(
                  controller: _nameEnglish,
                  onFieldSubmitted: (value) {
                    // move to the next field when the user presses the "Done" button
                    FocusScope.of(context).requestFocus(_NameArabicFocus);
                  },
                  style: TextStyle(color: Color(0xFF442B72)),
                  //controller: _namesupervisor,
                  cursorColor: const Color(0xFF442B72),
                  //textDirection: TextDirection.ltr,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 40),

                  decoration:  InputDecoration(
                    //labelText: 'Shady Ayman'.tr,
                    //hintText:'ElSalam School '.tr ,
                    hintStyle: TextStyle(color: Color(0xFF442B72)),
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

              SizedBox(height: 20,),

              Text('School name in Arabic'.tr,style: TextStyle(color: Color(0xFF442B72),
                fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
              SizedBox(height: 10,),
              Container(
                width: 320,
                height: 45,
                child: TextFormField(
                  controller: _nameArabic,
                  focusNode: _NameArabicFocus,
                  onFieldSubmitted: (value) {
                    // move to the next field when the user presses the "Done" button
                    FocusScope.of(context).requestFocus(_AddressFocus);
                  },
                  style: TextStyle(color: Color(0xFF442B72)),
                  //controller: _namesupervisor,
                  cursorColor: const Color(0xFF442B72),
                  //textDirection: TextDirection.ltr,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 40),

                  decoration:  InputDecoration(
                    //labelText: 'Shady Ayman'.tr,
                   // hintText:'مدرسة السلام الاعدادية الثانويه المشتركة'.tr ,
                    hintStyle: TextStyle(color: Color(0xFF442B72)),
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
              SizedBox(height: 20,),
              Text('Address'.tr,style: TextStyle(color: Color(0xFF442B72),
                fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
              SizedBox(height: 10,),
              Container(
                width: 320,
                height: 45,
                child: TextFormField(
                  controller: _Address,
                  focusNode: _AddressFocus,
                  onFieldSubmitted: (value) {
                    // move to the next field when the user presses the "Done" button
                    FocusScope.of(context).requestFocus(_CoordinatorFocus);
                  },
                  style: TextStyle(color: Color(0xFF442B72)),
                  //controller: _namesupervisor,
                  cursorColor: const Color(0xFF442B72),
                  //textDirection: TextDirection.ltr,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 40),
                  decoration:  InputDecoration(
                    //labelText: 'Shady Ayman'.tr,
                  //  hintText:'16 Khaled st, Asyut,Egypt'.tr ,
                    hintStyle: TextStyle(color: Color(0xFF442B72)),
                    alignLabelWithHint: true,
                    counterText: "",
                    fillColor: const Color(0xFFF1F1F1),
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(
                        8, 5, 10, 5),
                    floatingLabelBehavior:  FloatingLabelBehavior.never,
                    enabledBorder: myInputBorder(),
                    focusedBorder: myFocusBorder(),
                    suffixIcon:Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/imgs/school/icons8_Location.png',
                        width: 10,
                        height: 10,
                      ),
                    ),
                    //Image.asset('assets/imgs/school/icons8_Location.png',width: 10,height: 10,)
                  ),

                ),
              ),
              SizedBox(height: 35,),
              Text("Personal information",style: TextStyle(fontSize: 19,fontFamily: "Poppins-Bold",
                  color: Color(0xff771F98)),),
              SizedBox(height: 25,),
              Text('Coordinator Name'.tr,style: TextStyle(color: Color(0xFF442B72),
                fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
              SizedBox(height: 10,),
              Container(
                width: 320,
                height: 45,
                child: TextFormField(
                  controller: _coordinatorName,
                  focusNode: _CoordinatorFocus,
                  onFieldSubmitted: (value) {
                    // move to the next field when the user presses the "Done" button
                    FocusScope.of(context).requestFocus(_SupporterFocus);
                  },
                  style: TextStyle(color: Color(0xFF442B72)),
                  //controller: _namesupervisor,
                  cursorColor: const Color(0xFF442B72),
                  //textDirection: TextDirection.ltr,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 40),

                  decoration:  InputDecoration(
                    //labelText: 'Shady Ayman'.tr,
                    //hintText:'Shady Ayman'.tr ,
                    hintStyle: TextStyle(color: Color(0xFF442B72)),
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
              SizedBox(height: 20,),
              Text('Support Number'.tr,style: TextStyle(color: Color(0xFF442B72),
                fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'Poppins-Bold',)),
              SizedBox(height: 10,),
              Container(
                width: 320,
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _supportNumber,
                  focusNode: _SupporterFocus,
                  style: TextStyle(color: Color(0xFF442B72)),
                  //controller: _namesupervisor,
                  cursorColor: const Color(0xFF442B72),
                  //textDirection: TextDirection.ltr,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 40),

                  decoration:  InputDecoration(
                    //labelText: 'Shady Ayman'.tr,
                   // hintText:'01028765006'.tr ,
                    hintStyle: TextStyle(color: Color(0xFF442B72)),
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
              SizedBox(height: 35,),
              Center(child: ElevatedSimpleButton(txt: 'Save'.tr, width: 320, hight: 48, onPress: (){
                showSnackBarFun(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
              }, color: Color(0xff432B72), fontSize: 16,)),
            SizedBox(height: 40,),
              Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
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
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
