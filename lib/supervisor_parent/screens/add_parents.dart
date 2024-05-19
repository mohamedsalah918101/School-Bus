import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:school_account/Functions/functions.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';

class AddParents extends StatefulWidget {
  @override
  _AddParentsState createState() => _AddParentsState();
}

class _AddParentsState extends State<AddParents> {
  List<TextEditingController> nameChildControllers = [];
  List<TextEditingController> gradeControllers = [];
  late final int selectedImage;
  final _nameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _numberOfChildrenController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  bool NumberOfChildrenCard = false;
  bool selectedGenderGroupValue = true;
  bool nameError = true;
  bool phoneError = true;
  bool numberOfChildrenError = true;
  bool nameChildeError = true;
  bool GradeError = true;
  bool typeOfParentError = true;
  bool showList = false;
  String selectedValue = '';
  bool _phoneNumberEntered = true;
  bool allChildFieldsFilled = false;

  void _addDataToFirestore() async {
    int numberOfChildren = int.parse(_numberOfChildrenController.text);
    List<Map<String, dynamic>> childrenData = List.generate(
      numberOfChildren,
          (index) => {
        'name': nameChildControllers[index].text,
        'grade': gradeControllers[index].text,
      },
    );

    Map<String, dynamic> data = {
      'typeOfParent': selectedValue,
      'name': _nameController.text,
      'numberOfChildren': _numberOfChildrenController.text,
      'phoneNumber': _phoneNumberController.text,
      'children': childrenData,
      'state': 0,
      'invite': 0
    };

    try {
      print('Checking parent existence...');
      var check = await addParentCheck(_phoneNumberController.text);
      if (!check) {
        print('Parent does not exist. Checking for update...');
        var res = await checkUpdate(_phoneNumberController.text);
        if (!res) {
          print('Adding new parent to Firestore...');
          await _firestore.collection('parent').add(data).then((docRef) async {
            print('Data added with document ID: ${docRef.id}');
            String docid = docRef.id;
            var res = await createDynamicLink(
                false, docid, _phoneNumberController.text, 'parent');
            if (res == "success") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Invitation sent successfully'),
                backgroundColor: Color(0xFFFF3C3C),
              ));
              await _firestore.collection('parent').doc(docid).update({'invite':1});
              count =0;              showList =false;
              setState(() {

              });
              _nameController.clear();
              _phoneNumberController.clear();
              _numberOfChildrenController.clear();
              nameChildControllers.clear();
              gradeControllers.clear();

            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Invitation doesn\'t sent'),
                backgroundColor: Color(0xFF4CAF50),
              ));
            }

          }).catchError((error) {
            print('Failed to add data: $error');
          });
        } else {
        if(invitCheck == 0){
          var res = await createDynamicLink(
              false, docID, _phoneNumberController.text, 'parent');
          if (res == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Invitation sent successfully'),
              backgroundColor: Color(0xFFFF3C3C),
            ));
            await _firestore.collection('parent').doc(docID).update(
                {'invite': 1});
            count = 0;
            showList = false;
            setState(() {

            });
            _nameController.clear();
            _phoneNumberController.clear();
            _numberOfChildrenController.clear();
            nameChildControllers.clear();
            gradeControllers.clear();
          }}else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This phone number is already added.'),
        ));}
         // await _firestore.collection('parent').doc(docID).update(data);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This phone number is already added.'),
        ));
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  // void _addDataToFirestore() async {
  //   setState(() {});
  //   int numberOfChildren = int.parse(_numberOfChildrenController.text);
  //   List<Map<String, dynamic>> childrenData = List.generate(
  //     numberOfChildren,
  //     (index) => {
  //       'name': nameChildControllers[index].text,
  //       'grade': gradeControllers[index].text,
  //     },
  //   );
  //
  //   Map<String, dynamic> data = {
  //     'typeOfParent': selectedValue,
  //     'name': _nameController.text,
  //     'numberOfChildren': _numberOfChildrenController.text,
  //     'phoneNumber': _phoneNumberController.text,
  //     'childern': childrenData,
  //     'state': 0,
  //     'invite': 1
  //     // 'gender': gender
  //   };
  //   // Add the data to the Firestore collection
  //   var check = await addParentCheck(_phoneNumberController.text);
  //   if (!check) {
  //     var res = await checkUpdate(_phoneNumberController.text);
  //     if (!res) {
  //       await _firestore.collection('parent').add(data).then((docRef) async {
  //         String docid = docRef.id;
  //         print('Data added with document ID: ${docRef.id}');
  //         var res = await createDynamicLink(
  //             true, docid, _phoneNumberController.text, 'parent');
  //         if (res == "success") {
  //           InvitationSendSnackBar(
  //               context, 'Invitation sent successfully', Color(0xFFFF3C3C));
  //         } else {
  //           InvitationSendSnackBar(
  //               context, 'Invitation doesn\'t sent', Color(0xFF4CAF50));
  //         }
  //         _nameController.clear();
  //         _phoneNumberController.clear();
  //         _numberOfChildrenController.clear();
  //         nameChildControllers.clear();
  //         nameChildControllers.clear();
  //         gradeControllers.clear();
  //       }).catchError((error) {
  //         print('Failed to add data: $error');
  //       });
  //       // Clear the text fields
  //     } else {
  //       await _firestore.collection('parent').doc(docID).update(data);
  //     }
  //   }
  //   else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('this phone already added')));
  //   }
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> NumberOfChildren = [];

  final nameChildController = TextEditingController();

  // final gradeController = TextEditingController();
  List<String> genderSelection = [];
  int count = 0;
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        body: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.0),
                      child: Image.asset(
                        (sharedpref?.getString('lang') == 'ar')
                            ? 'assets/images/Layer 1.png'
                            : 'assets/images/fi-rr-angle-left.png',
                        width: 20,
                        height: 22,
                      ),
                    ),
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 40)
                        : EdgeInsets.only(left: 40),
                    child: Text(
                      'Parents'.tr,
                      style: TextStyle(
                        color: Color(0xFF993D9A),
                        fontSize: 16,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icons8_Add_Male_User_Group 1.png',
                          width: 27,
                          height: 27,
                        ),
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Color(0xff442B72),
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if(children.isEmpty)
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 25.0)
                        : EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Parent'.tr,
                      style: TextStyle(
                        fontSize: 19,
                        // height:  0.94,
                        fontFamily: 'Poppins-Bold',
                        fontWeight: FontWeight.w700,
                        color: Color(0xff771F98),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 42.0)
                        : EdgeInsets.only(left: 42.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Parent'.tr,
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
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: Stack(
                      children: [
                        Container(
                          width: 277,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Color(0xFFF1F1F1),
                            border: Border.all(
                              color: Color(0xFFFFC53E),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showList = !showList;
                                  });
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 17.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showList = !showList;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showList = !showList;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: Text(
                                                selectedValue!.isNotEmpty
                                                    ? selectedValue
                                                    : 'Choose your type',
                                                style: TextStyle(
                                                  color: Color(0xFF9E9E9E),
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins-Bold',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.33,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: selectedValue!.isNotEmpty
                                                ? 160
                                                : 90,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showList =
                                                    !showList; // Toggle the visibility of the list
                                              });
                                            },
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Image.asset(
                                                  'assets/images/Vectorbottom (12).png',
                                                ),
                                              ),
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
                        ),
                        if (showList)
                          Container(
                            height: 140,
                            child: Card(
                              surfaceTintColor: Colors.transparent,
                              color: Colors.white,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Father',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Color(0xFF9E9E9E),
                                        fontSize: 12,
                                        fontFamily: 'Poppins-Bold',
                                        fontWeight: FontWeight.w700,
                                        height: 1.33,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 'Father';
                                        showList = false;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: ListTile(
                                      title: Text(
                                        'Mother',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Bold',
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 'Mother';
                                          showList = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  typeOfParentError
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            "Please enter your type".tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  // selectedValue == null || selectedValue.isEmpty
                  //     ? Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 48),
                  //   child: Text(
                  //     "Please enter your type".tr,
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  // )
                  //     : Container(),
                  // typeOfParentError?
                  // selectedValue!.isEmpty?
                  // Container():
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 48),
                  //   child: Text(
                  //     "Please enter your type".tr,
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  // ):
                  //     Container(),
                  SizedBox(
                    height: 11,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 42.0)
                        : EdgeInsets.only(left: 42.0),
                    child: Text.rich(
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
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.0),
                    child: SizedBox(
                      width: 277,
                      height: 40,
                      child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color: Color(0xFF442B72),
                          ),
                          cursorColor: const Color(0xFF442B72),
                          textDirection: (sharedpref?.getString('lang') == 'ar')
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          // autofocus: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textAlign: (sharedpref?.getString('lang') == 'ar')
                              ? TextAlign.right
                              : TextAlign.left,
                          scrollPadding: EdgeInsets.symmetric(vertical: 30),
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            counterText: "",
                            fillColor: const Color(0xFFF1F1F1),
                            filled: true,
                            contentPadding:
                                (sharedpref?.getString('lang') == 'ar')
                                    ? EdgeInsets.fromLTRB(166, 0, 17, 40)
                                    : EdgeInsets.fromLTRB(17, 0, 0, 40),
                            hintText: 'Please enter your name'.tr,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintStyle: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 12,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: Color(0xFFFFC53E),
                                  width: 0.5,
                                )),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(
                                color: Color(0xFFFFC53E),
                                width: 0.5,
                              ),
                            ),

                            // enabledBorder: myInputBorder(),
                            // focusedBorder: myFocusBorder(),
                          )),
                    ),
                  ),
                  nameError
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            "Please enter your name".tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  // :Container(),

                  SizedBox(
                    height: 17,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 42.0)
                        : EdgeInsets.only(left: 42.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Phone Number'.tr,
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
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.0),
                    child: SizedBox(
                      width: 277,
                      height: 65,
                      child: IntlPhoneField(
                        cursorColor: Color(0xFF442B72),
                        controller: _phoneNumberController,
                        dropdownIconPosition: IconPosition.trailing,
                        invalidNumberMessage: " ",
                        style: TextStyle(color: Color(0xFF442B72), height: 1.5),
                        dropdownIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xff442B72),
                        ),
                        decoration: InputDecoration(
                          fillColor: Color(0xffF1F1F1),
                          filled: true,
                          hintText: 'Phone Number'.tr,
                          hintStyle: TextStyle(
                              color: Color(0xFFC2C2C2),
                              fontSize: 12,
                              fontFamily: "Poppins-Bold"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                              color: !_phoneNumberEntered
                                  ? Colors.red // Red border if phone number not entered
                                  : Color(0xFFFFC53E),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFC53E),
                              width: 0.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            // Set border color when the text field is focused
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color(0xFFFFC53E),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),

                        initialCountryCode: 'EG',
                        // Set initial country code if needed
                        onChanged: (phone) {
                          // Update the enteredPhoneNumber variable with the entered phone number
                        },
                      ),
                    ),
                  ),

                  phoneError
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48 , ),
                          child: Text(
                            "Please enter your phone number".tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                  SizedBox(
                    height: 17,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 42.0)
                        : EdgeInsets.only(left: 42.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Number of children'.tr,
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
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.0),
                    child: SizedBox(
                      width: 277,
                      height: 40,
                      child: TextFormField(
                        onChanged: (val) {
                          String input = _numberOfChildrenController.text;
                          count = int.tryParse(input) ?? 0;
                         // count = count - nameChildControllers.length;
                          for (int i = 0; i < count; i++) {
                            genderSelection.add('male');
                            TextEditingController nameController =
                                TextEditingController();
                            TextEditingController gradeController =
                                TextEditingController();

                            nameChildControllers.add(nameController);
                            gradeControllers.add(gradeController);
                          }
                        },
                        controller: _numberOfChildrenController,
                        style: TextStyle(
                          color: Color(0xFF442B72),
                        ),
                        cursorColor: Color(0xFF442B72),
                        textDirection: (sharedpref?.getString('lang') == 'ar')
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        // autofocus: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: (sharedpref?.getString('lang') == 'ar')
                            ? TextAlign.right
                            : TextAlign.left,
                        scrollPadding: EdgeInsets.symmetric(vertical: 30),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          counterText: "",
                          fillColor: const Color(0xFFF1F1F1),
                          filled: true,
                          contentPadding:
                              (sharedpref?.getString('lang') == 'ar')
                                  ? EdgeInsets.fromLTRB(166, 0, 17, 40)
                                  : EdgeInsets.fromLTRB(17, 0, 0, 40),
                          hintText: 'Please enter your number children'.tr,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFC53E),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(
                              color: Color(0xFFFFC53E),
                              width: 0.5,
                            ),
                          ),
                          // enabledBorder: myInputBorder(),
                          // focusedBorder: myFocusBorder(),
                        ),
                      ),
                    ),
                  ),
                  numberOfChildrenError
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            "Please enter your number of children".tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: (sharedpref?.getString('lang') == 'ar')
                        ? EdgeInsets.only(right: 25.0, left: 30)
                        : EdgeInsets.only(left: 25.0, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Children'.tr,
                          style: TextStyle(
                            fontSize: 19,
                            // height:  0.94,
                            fontFamily: 'Poppins-Bold',
                            fontWeight: FontWeight.w700,
                            color: Color(0xff771F98),
                          ),
                        ),
                        GestureDetector(
                            // onTap: (){
                            //   setState(() {
                            //     // modifyText();
                            //     addChild();
                            //     NumberOfChildrenCard = !NumberOfChildrenCard;
                            //   });
                            onTap: () {

                                // modifyText();
                                //addChild();

                           //     NumberOfChildrenCard = !NumberOfChildrenCard;
                                if (visible)
                                  visible = false;
                                else
                                  visible = true;
                                setState(() {});



                            },
                            child: NumberOfChildrenCard
                                ? Image.asset(
                                    'assets/images/iconamoon_arrow-up-2-thin (1).png',
                                    width: 34,
                                    height: 34,
                                  )
                                : Image.asset(
                                    'assets/images/iconamoon_arrow-up-2-thin.png',
                                    width: 34,
                                    height: 34,
                                  )),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                      padding: (sharedpref?.getString('lang') == 'ar')
                          ? EdgeInsets.only(right: 21.0)
                          : EdgeInsets.only(left: 25.0),
                      child: Container(
                        width:
                            (sharedpref?.getString('lang') == 'ar') ? 310 : 318,
                        height: 1,
                        color: Color(0xFF442B72),
                      )),
                  NumberOfChildrenCard
                      ? Padding(
                          padding: (sharedpref?.getString('lang') == 'ar')
                              ? EdgeInsets.only(right: 25.0, left: 20)
                              : EdgeInsets.only(left: 25.0, right: 20),
                          child: SizedBox(
                            height: NumberOfChildren.length * 325,
                            width: double.infinity,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(10),
                              itemCount: NumberOfChildren.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    NumberOfChildren[index],
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  Center(
                    child: Visibility(
                      visible: visible,
                      child: Column(
                        children: [
                          for (int i = 0; i < count; i++)
                            SizedBox(
                                width: 296,
                                height: 310,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color:
                                            Color(0xff771F98).withOpacity(0.03),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                (sharedpref?.getString('lang') ==
                                                    'ar')
                                                    ? EdgeInsets.only(right: 12.0)
                                                    : EdgeInsets.only(left: 12.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Child '.tr,
                                                        style: TextStyle(
                                                          color: Color(0xff771F98),
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins-Bold',
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '${i + 1}',
                                                        style: TextStyle(
                                                          color: Color(0xff771F98),
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins-Bold',
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding:
                                                (sharedpref?.getString('lang') ==
                                                    'ar')
                                                    ? EdgeInsets.only(right: 18.0)
                                                    : EdgeInsets.only(left: 18.0),
                                                child: Text.rich(
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
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.0),
                                                child: SizedBox(
                                                  width: 277,
                                                  height: 38,
                                                  child: TextFormField(
                                                   controller: nameChildControllers[i],
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                    cursorColor:
                                                    const Color(0xFF442B72),
                                                    textDirection: (sharedpref
                                                        ?.getString('lang') ==
                                                        'ar')
                                                        ? TextDirection.rtl
                                                        : TextDirection.ltr,
                                                    // autofocus: true,
                                                    textInputAction:
                                                    TextInputAction.next,
                                                    keyboardType: TextInputType.text,
                                                    textAlign: (sharedpref
                                                        ?.getString('lang') ==
                                                        'ar')
                                                        ? TextAlign.right
                                                        : TextAlign.left,
                                                    scrollPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 30),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      counterText: "",
                                                      fillColor:
                                                      const Color(0xFFF1F1F1),
                                                      filled: true,
                                                      contentPadding: (sharedpref
                                                          ?.getString(
                                                          'lang') ==
                                                          'ar')
                                                          ? EdgeInsets.fromLTRB(
                                                          0, 0, 17, 20)
                                                          : EdgeInsets.fromLTRB(
                                                          17, 0, 0, 10),
                                                      hintText:
                                                      'Please enter your child name'
                                                          .tr,
                                                      floatingLabelBehavior:
                                                      FloatingLabelBehavior.never,
                                                      hintStyle: const TextStyle(
                                                        color: Color(0xFF9E9E9E),
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins-Bold',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.33,
                                                      ),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              nameChildeError
                                                  ? Container()
                                                  : Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child:  nameChildControllers[i].text.isEmpty
                                               ? Text( "Please enter your child name",
                                                style: TextStyle(
                                                    color: Colors.red
                                                )):SizedBox()
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                padding:
                                                (sharedpref?.getString('lang') ==
                                                    'ar')
                                                    ? EdgeInsets.only(right: 18.0)
                                                    : EdgeInsets.only(left: 18.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Grade'.tr,
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
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 18.0),
                                                child: SizedBox(
                                                  width: 277,
                                                  height: 38,
                                                  child: TextFormField(
                                                    controller: gradeControllers[i],
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins-Light',
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.33,
                                                    ),
                                                    cursorColor:
                                                    const Color(0xFF442B72),
                                                    textDirection: (sharedpref
                                                        ?.getString('lang') ==
                                                        'ar')
                                                        ? TextDirection.rtl
                                                        : TextDirection.ltr,
                                                    // autofocus: true,
                                                    textInputAction:
                                                    TextInputAction.done,
                                                    keyboardType:
                                                    TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: (sharedpref
                                                        ?.getString('lang') ==
                                                        'ar')
                                                        ? TextAlign.right
                                                        : TextAlign.left,
                                                    scrollPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 30),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      counterText: "",
                                                      fillColor:
                                                      const Color(0xFFF1F1F1),
                                                      filled: true,
                                                      contentPadding: (sharedpref
                                                          ?.getString(
                                                          'lang') ==
                                                          'ar')
                                                          ? EdgeInsets.fromLTRB(
                                                          0, 0, 17, 15)
                                                          : EdgeInsets.fromLTRB(
                                                          17, 0, 0, 10),
                                                      hintText:
                                                      'Please enter your child grade'
                                                          .tr,
                                                      floatingLabelBehavior:
                                                      FloatingLabelBehavior.never,
                                                      hintStyle: const TextStyle(
                                                        color: Color(0xFF9E9E9E),
                                                        fontSize: 12,
                                                        fontFamily: 'Poppins-Bold',
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.33,
                                                      ),
                                                      focusedBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                      OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(7)),
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFFFC53E),
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      // enabledBorder: myInputBorder(),
                                                      // focusedBorder: myFocusBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GradeError
                                                  ? Container()
                                                  : Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child:
                                                gradeControllers[i].text.isEmpty
                                                    ? Text(
                                                  "Please enter your child grade",
                                                  style: TextStyle(color: Colors.red),
                                                )
                                                    : SizedBox(),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Padding(
                                                  padding: (sharedpref
                                                      ?.getString('lang') ==
                                                      'ar')
                                                      ? EdgeInsets.only(right: 18.0)
                                                      : EdgeInsets.only(left: 18.0),
                                                  child: Text(
                                                    'Gender'.tr,
                                                    style: TextStyle(
                                                      color: Color(0xFF442B72),
                                                      fontSize: 15,
                                                      fontFamily: 'Poppins-Bold',
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.07,
                                                    ),
                                                  )),
                                              // SizedBox(height: 12,),
                                              Padding(
                                                  padding: (sharedpref
                                                      ?.getString('lang') ==
                                                      'ar')
                                                      ? EdgeInsets.only(right: 15.0)
                                                      : EdgeInsets.only(left: 15.0),
                                                  child: Row(children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: 'female',
                                                          groupValue:
                                                          genderSelection[i],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              genderSelection[i] =
                                                              'female';
                                                            });
                                                          },
                                                          fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  (states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .selected)) {
                                                                  return Color(
                                                                      0xff442B72);
                                                                }
                                                                return Color(0xff442B72);
                                                              }),
                                                          activeColor: Color(
                                                              0xff442B72), // Set the color of the selected radio button
                                                        ),
                                                        Text(
                                                          "Female".tr,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                            'Poppins-Regular',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Color(0xff442B72),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 50, //115
                                                        ),
                                                        Radio(
                                                          fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  (states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .selected)) {
                                                                  return Color(
                                                                      0xff442B72);
                                                                }
                                                                return Color(0xff442B72);
                                                              }),
                                                          value: 'male',
                                                          groupValue:
                                                          genderSelection[i],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              genderSelection[i] =
                                                              'male';
                                                            });
                                                          },
                                                          activeColor:
                                                          Color(0xff442B72),
                                                        ),
                                                        Text(
                                                          "Male".tr,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                            'Poppins-Regular',
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Color(0xff442B72),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ])),
                                            ],
                                          )),
                                      SizedBox(height:10)
                                    ])),
                       
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44.0),
                    child: Center(
                      child: ElevatedSimpleButton(
                          txt: 'Send invitation'.tr,
                          fontFamily: 'Poppins-Regular',
                          width: 277,
                          hight: 48,
                          onPress: () async {
                            setState(() {
                              if (selectedValue.isEmpty) {
                                typeOfParentError = false;
                              } else {
                                typeOfParentError = true;
                              }

                              if (_nameController.text.isEmpty) {
                                nameError = false;
                              } else {
                                nameError = true;
                              }

                              if (_phoneNumberController.text.length < 10) {
                                phoneError = false;
                              } else {
                                phoneError = true;
                              }

                              if (_numberOfChildrenController.text.isEmpty) {
                                numberOfChildrenError = false;
                              } else {
                                numberOfChildrenError = true;
                              }
                              bool allChildFieldsFilled = true;
                              for (int i = 0; i < nameChildControllers.length; i++) {
                                if (nameChildControllers[i].text.isEmpty || gradeControllers[i].text.isEmpty) {
                                  allChildFieldsFilled = false;
                                  print('failed');
                                  break;
                                } else {
                                  allChildFieldsFilled = true;
                                  GradeError = true;
                                  nameChildeError = true;
                                  print('done');
                                }
                              }
                              if (!allChildFieldsFilled) {
                                GradeError = false;
                                nameChildeError = false;
                              } else if (allChildFieldsFilled) {
                                GradeError = true;
                                nameChildeError = true;
                              }

                            });
                            if (
                                // allChildFieldsFilled &&
                                // GradeError &&
                                // nameChildeError &&

                                typeOfParentError &&
                                    nameError &&
                                    phoneError &&
                                    numberOfChildrenError
                            // && GradeError
                            ) {
                              _addDataToFirestore();
                              print('object send done');
                              NumberOfChildrenCard = false;
                              setState(() {});
                            }
                          },
                          color: Color(0xFF442B72),
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              )),
            ),
          ],
        ),
        // extendBody: false,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            )),
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 7, right: 15)
                                          : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(top: 9, left: 50)
                                          : EdgeInsets.only(right: 50, top: 2),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19),
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 12, bottom: 4, right: 10)
                                          : EdgeInsets.only(
                                              top: 8, bottom: 4, left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
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
                                      (sharedpref?.getString('lang') == 'ar')
                                          ? EdgeInsets.only(
                                              top: 10,
                                              bottom: 2,
                                              right: 10,
                                              left: 0)
                                          : EdgeInsets.only(
                                              top: 8,
                                              bottom: 2,
                                              left: 0,
                                              right: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
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

void InvitationSendSnackBar(context, String message, color,
    {Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.up,
      duration: duration ?? const Duration(milliseconds: 2000),
      backgroundColor: Colors.white,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/saved.png',
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'Invitation sent successfully'.tr,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: 'Poppins-Bold',
              fontWeight: FontWeight.w700,
              height: 1.23,
            ),
          ),
        ],
      ),
    ),
  );
}
// void addChild() {
//   setState(() {
//     String input = _numberOfChildrenController.text;
//     // List<Map<String, bool>> genderSelection = [];
//
//     int count = int.tryParse(input) ?? 0;
//     NumberOfChildren.clear();
//     nameChildControllers.clear();
//     gradeControllers.clear();
//     genderSelection.clear();
//
//     for (int i = 0; i < count; i++) {
//       bool isFemale = false;
//       bool isMale = false;
//       genderSelection.add('');
//       TextEditingController nameController = TextEditingController();
//       TextEditingController gradeController = TextEditingController();
//
//       nameChildControllers.add(nameController);
//       gradeControllers.add(gradeController);
//       NumberOfChildren.add(SizedBox(
//           width: double.infinity,
//           height: 310,
//           child: Column(children: [
//             Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xff771F98).withOpacity(0.03),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 12.0)
//                           : EdgeInsets.only(left: 12.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Child '.tr,
//                               style: TextStyle(
//                                 color: Color(0xff771F98),
//                                 fontSize: 16,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             TextSpan(
//                               text: '${i + 1}',
//                               style: TextStyle(
//                                 color: Color(0xff771F98),
//                                 fontSize: 16,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 18.0)
//                           : EdgeInsets.only(left: 18.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Name'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 18.0),
//                       child: SizedBox(
//                         width: 277,
//                         height: 38,
//                         child: TextFormField(
//                           onChanged: (value) {
//                             setState(() {});
//                           },
//                           controller: nameController,
//                           style: TextStyle(
//                             color: Color(0xFF442B72),
//                             fontSize: 12,
//                             fontFamily: 'Poppins-Light',
//                             fontWeight: FontWeight.w400,
//                             height: 1.33,
//                           ),
//                           cursorColor: const Color(0xFF442B72),
//                           textDirection:
//                           (sharedpref?.getString('lang') == 'ar')
//                               ? TextDirection.rtl
//                               : TextDirection.ltr,
//                           // autofocus: true,
//                           textInputAction: TextInputAction.next,
//                           keyboardType: TextInputType.text,
//                           textAlign: (sharedpref?.getString('lang') == 'ar')
//                               ? TextAlign.right
//                               : TextAlign.left,
//                           scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                           decoration: InputDecoration(
//                             alignLabelWithHint: true,
//                             counterText: "",
//                             fillColor: const Color(0xFFF1F1F1),
//                             filled: true,
//                             contentPadding:
//                             (sharedpref?.getString('lang') == 'ar')
//                                 ? EdgeInsets.fromLTRB(0, 0, 17, 20)
//                                 : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                             hintText: 'Please enter your child name'.tr,
//                             floatingLabelBehavior:
//                             FloatingLabelBehavior.never,
//                             hintStyle: const TextStyle(
//                               color: Color(0xFF9E9E9E),
//                               fontSize: 12,
//                               fontFamily: 'Poppins-Bold',
//                               fontWeight: FontWeight.w700,
//                               height: 1.33,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     nameChildeError
//                         ? Container()
//                         : Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                       child: Text(
//                         "Please enter your child name".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Padding(
//                       padding: (sharedpref?.getString('lang') == 'ar')
//                           ? EdgeInsets.only(right: 18.0)
//                           : EdgeInsets.only(left: 18.0),
//                       child: Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Grade'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF442B72),
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' *',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 15,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.07,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 18.0),
//                       child: SizedBox(
//                         width: 277,
//                         height: 38,
//                         child: TextFormField(
//                           onChanged: (value) {
//                             setState(() {});
//                           },
//                           controller: gradeControllers[i],
//                           style: TextStyle(
//                             color: Color(0xFF442B72),
//                             fontSize: 12,
//                             fontFamily: 'Poppins-Light',
//                             fontWeight: FontWeight.w400,
//                             height: 1.33,
//                           ),
//                           cursorColor: const Color(0xFF442B72),
//                           textDirection:
//                           (sharedpref?.getString('lang') == 'ar')
//                               ? TextDirection.rtl
//                               : TextDirection.ltr,
//                           // autofocus: true,
//                           textInputAction: TextInputAction.done,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.digitsOnly
//                           ],
//                           textAlign: (sharedpref?.getString('lang') == 'ar')
//                               ? TextAlign.right
//                               : TextAlign.left,
//                           scrollPadding: EdgeInsets.symmetric(vertical: 30),
//                           decoration: InputDecoration(
//                             alignLabelWithHint: true,
//                             counterText: "",
//                             fillColor: const Color(0xFFF1F1F1),
//                             filled: true,
//                             contentPadding:
//                             (sharedpref?.getString('lang') == 'ar')
//                                 ? EdgeInsets.fromLTRB(0, 0, 17, 15)
//                                 : EdgeInsets.fromLTRB(17, 0, 0, 10),
//                             hintText: 'Please enter your child grade'.tr,
//                             floatingLabelBehavior:
//                             FloatingLabelBehavior.never,
//                             hintStyle: const TextStyle(
//                               color: Color(0xFF9E9E9E),
//                               fontSize: 12,
//                               fontFamily: 'Poppins-Bold',
//                               fontWeight: FontWeight.w700,
//                               height: 1.33,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(7)),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFFFC53E),
//                                 width: 0.5,
//                               ),
//                             ),
//                             // enabledBorder: myInputBorder(),
//                             // focusedBorder: myFocusBorder(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     GradeError
//                         ? Container()
//                         : Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                       child: Text(
//                         "Please enter your child grade".tr,
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     Padding(
//                         padding: (sharedpref?.getString('lang') == 'ar')
//                             ? EdgeInsets.only(right: 18.0)
//                             : EdgeInsets.only(left: 18.0),
//                         child: Text(
//                           'Gender'.tr,
//                           style: TextStyle(
//                             color: Color(0xFF442B72),
//                             fontSize: 15,
//                             fontFamily: 'Poppins-Bold',
//                             fontWeight: FontWeight.w700,
//                             height: 1.07,
//                           ),
//                         )),
//                     // SizedBox(height: 12,),
//                     Padding(
//                         padding: (sharedpref?.getString('lang') == 'ar')
//                             ? EdgeInsets.only(right: 15.0)
//                             : EdgeInsets.only(left: 15.0),
//                         child: Row(children: [
//                           Row(
//                             children: [
//                               Radio(
//                                 value: 'female',
//                                 groupValue: genderSelection[i],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     genderSelection[i] = 'female';
//                                   });
//                                 },
//                                 fillColor: MaterialStateProperty.resolveWith(
//                                         (states) {
//                                       if (states
//                                           .contains(MaterialState.selected)) {
//                                         return Color(0xff442B72);
//                                       }
//                                       return Color(0xff442B72);
//                                     }),
//                                 activeColor: Color(
//                                     0xff442B72), // Set the color of the selected radio button
//                               ),
//                               Text(
//                                 "Female".tr,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontFamily: 'Poppins-Regular',
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xff442B72),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 50, //115
//                               ),
//                               Radio(
//                                 fillColor: MaterialStateProperty.resolveWith(
//                                         (states) {
//                                       if (states
//                                           .contains(MaterialState.selected)) {
//                                         return Color(0xff442B72);
//                                       }
//                                       return Color(0xff442B72);
//                                     }),
//                                 value: 'male',
//                                 groupValue: genderSelection[i],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     genderSelection[i] = 'male';
//                                   });
//                                 },
//                                 activeColor: Color(0xff442B72),
//                               ),
//                               Text(
//                                 "Male".tr,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontFamily: 'Poppins-Regular',
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xff442B72),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           )
//                         ])),
//                   ],
//                 ))
//           ])));
//     }
//     setState(() {});
//   });
// }