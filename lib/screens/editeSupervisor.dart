import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_account/screens/notificationsScreen.dart';
import 'package:school_account/screens/profileScreen.dart';
import 'package:school_account/screens/supervisorScreen.dart';
import '../Functions/functions.dart';
import '../components/bottom_bar_item.dart';
import '../components/elevated_simple_button.dart';
import '../components/home_drawer.dart';
import '../components/main_bottom_bar.dart';
import '../components/text_from_field_login_custom.dart';
import '../controller/local_controller.dart';
import 'busesScreen.dart';
import 'homeScreen.dart';



class EditeSupervisor extends StatefulWidget{
  final String docid;
  final String oldName;
  final String? oldPhone;
  final String oldEmail;
 // const EditeSupervisor({super.key});
  const EditeSupervisor({super.key,
    required this.docid,
    required this.oldName,
    required this.oldPhone,
    required this.oldEmail,
  });
  @override
  State<EditeSupervisor> createState() => _EditeSupervisorState();
}


class _EditeSupervisorState extends State<EditeSupervisor> {
  // String docid='';
  TextEditingController _name = TextEditingController();
  TextEditingController _phonenumber = TextEditingController();
  TextEditingController _email = TextEditingController();
  MyLocalController ControllerLang = Get.find();
  //TextEditingController _namesupervisor=TextEditingController();
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
  //edite function
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  CollectionReference Supervisor = FirebaseFirestore.instance.collection('supervisor');
  editAddSupervisor() async {
    print('editAddParent called');

    if (formState.currentState != null) {
      print('formState.currentState is not null');

      if (formState.currentState!.validate()) {
        print('form is valid');

        try {
          print('updating document...');

          await Supervisor.doc(widget.docid).update({
            'phoneNumber': _phonenumber.text,
            'email': _email.text,
            'name':  _name.text,
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

  // editAddParent() async {
  //   print('editAddParent called');
  //   if (formState.currentState != null) {
  //     print('formState.currentState is not null');
  //     if (formState.currentState!.validate()) {
  //       print('form is valid');
  //       try {
  //         print('updating document...');
  //         await Supervisor.doc(widget.docid).update({
  //           'phoneNumber': _phonenumber.text,
  //           'email': _email.text,
  //           'name':  _name.text,
  //         });
  //         print('document updated successfully');
  //         setState(() {
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


// to lock in landscape view
  @override
  void initState() {
    super.initState();
    _name.text = widget.oldName!;
    _phonenumber.text = widget.oldPhone!;
    _email.text = widget.oldEmail!;
    // responsible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
    final GlobalKey<ScaffoldState> _scaffoldeditesupervisor = GlobalKey<ScaffoldState>();


    final _NameFocus = FocusNode();
    final _PhoneNumberFocus = FocusNode();
    final _EmailFocus = FocusNode();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldeditesupervisor,
        endDrawer: HomeDrawer(),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
           // reverse: true,
           // physics: BouncingScrollPhysics(),
            child: Form(
              key: formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: InkWell(
                            onTap: () {
                              // Navigate back to the previous page
                             // Navigator.pop(context);
                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SupervisorScreen()));
                            },
                            //onTap: ()=>exit(0),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 23,
                              color: Color(0xff442B72),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Supervisors".tr,
                            style: TextStyle(
                              color: Color(0xFF993D9A),
                              fontSize: 25,
                              fontFamily: 'Poppins-Bold',
                              fontWeight: FontWeight.w700,
                              height: 0.64,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: InkWell(onTap: (){
                            Scaffold.of(context).openEndDrawer();
                          },
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


                  const SizedBox(
                    height: 40,
                  ),

                  SizedBox(
                    height: 40,
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
                                        fontWeight:FontWeight.w700,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Name".tr,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: constrains.maxWidth / 1.2,
                                height: 38,
                                child: TextFormField(
                                  controller: _name,
                                  focusNode: _NameFocus,
                                  onFieldSubmitted: (value) {
                                    // move to the next field when the user presses the "Done" button
                                    FocusScope.of(context).requestFocus(_PhoneNumberFocus);
                                  },
                              style: TextStyle(color: Color(0xFF442B72)),
                                 // controller: _namesupervisor,
                                  cursorColor: const Color(0xFF442B72),
                                  //textDirection: TextDirection.ltr,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      vertical: 40),
                                  decoration:  InputDecoration(
                                    // labelText: 'Shady Ayman'.tr,
                                   // hintText:'Shady Ayman'.tr ,
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
                                height: 40,
                              ),

                              // دا كان كلمه السر
                              // Text(
                              //   'Password'.tr,
                              //   style: TextStyle(
                              //     color: Color(0xFF442B72),
                              //     fontSize: 15,
                              //     fontFamily: 'Poppins-Bold',
                              //     fontWeight: FontWeight.w700,
                              //     height: 1.07,
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
                                        fontWeight: FontWeight.w700,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Phone Number".tr,
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
                                  //   'Phone Number *'.tr,
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
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: constrains.maxWidth / 1.2,
                                height: 38,
                                child: TextFormField(
                                  controller: _phonenumber,
                                  focusNode: _PhoneNumberFocus,
                                  inputFormatters: <TextInputFormatter>[
                                    //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numbers
                                    LengthLimitingTextInputFormatter(13), // Limit the length programmatically
                                  ],
                                  onFieldSubmitted: (value) {
                                    // move to the next field when the user presses the "Done" button
                                    FocusScope.of(context).requestFocus(_EmailFocus);
                                  },
                                  style: TextStyle(color: Color(0xFF442B72)),
                                  //controller: _namesupervisor,
                                  cursorColor: const Color(0xFF442B72),
                                  //textDirection: TextDirection.ltr,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      vertical: 40),
                                  keyboardType: TextInputType.number,
                                  decoration:  InputDecoration(
                                   // labelText: 'Shady Ayman'.tr,
                                    //hintText:'01028765006'.tr ,
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
                              // TextFormFieldCustom(
                              //   width: constrains.maxWidth / 1.2,
                              //   hintTxt: 'Your Name'.tr,
                              // ),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:25,vertical: 0 ),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    'Email'.tr,
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
                              const SizedBox(
                                height: 10,
                              ),
                              // TextFormFieldCustom(
                              //   width: constrains.maxWidth / 1.2,
                              //   hintTxt: 'Your Name'.tr,
                              // ),
                              Container(
                                width: constrains.maxWidth / 1.2,
                                height: 38,
                                child: TextFormField(
                                  controller: _email,
                                  focusNode: _EmailFocus,
                                  style: TextStyle(color: Color(0xFF442B72)),
                                  //controller: _namesupervisor,
                                  cursorColor: const Color(0xFF442B72),
                                  //textDirection: TextDirection.ltr,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      vertical: 40),
                                  decoration:  InputDecoration(
                                    //labelText: 'Shady Ayman'.tr,
                                  //  hintText:'Shahd@gmail.com'.tr ,
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

                              SizedBox(
                                height: 50,
                              ),



                              SizedBox(
                                width: constrains.maxWidth / 1.2,
                                height: 48,
                                child: Center(
                                  // Otp pageلسه معملتهاش ودا الكود اللى بيودينى عليها
                                  child: ElevatedSimpleButton(
                                    txt: "Save".tr,
                                    onPress: (){
                                      editAddSupervisor();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SupervisorScreen()));
                                      // Navigator.push(
                                      //     context ,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>  HomeScreen(),
                                      //         maintainState: false)
                                      // );
                                    },
                                    width: constrains.maxWidth /1.2,
                                    hight: 48,
                                    color: const Color(0xFF442B72),
                                    fontSize: 16,




                                  ),
                                  // end of comment
                                ),
                              ) ,
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: (){
                                //  createDynamicLink(true,docid,_phonenumber.text,'supervisor');
                                },
                                  child: Text("Resend invitation".tr,style:TextStyle(color: Color(0xff442B72),fontSize: 14,fontFamily:"Poppins-Regular"),)),
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
            ),
          );
        }
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
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
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


        bottomNavigationBar:Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),

            child: BottomAppBar(

              color: const Color(0xFF442B72),
              clipBehavior: Clip.antiAlias,
              shape: const AutomaticNotchedShape( RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38.5),
                      topRight: Radius.circular(38.5))),
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(50)))),
              //CircularNotchedRectangle(),
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
                              Navigator.pushReplacement(
                                  context ,
                                  MaterialPageRoute(
                                      builder: (context) =>  HomeScreen(),
                                      maintainState: false));
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
                                  Image.asset('assets/imgs/school/supervisor (1) 1.png',
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
                      ]
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
}




