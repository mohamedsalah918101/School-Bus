import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/decline_invitation_supervisore.dart';
import 'package:school_account/supervisor_parent/screens/final_invitation_supervisor.dart';
import '../components/elevated_simple_button.dart';

class AcceptInvitationSupervisor extends StatefulWidget {
  final String? schoolDataDocumentId;
  // String schoolDataDocumentId = sharedpref?.getString('id') ?? '';


  const AcceptInvitationSupervisor({super.key,  this.schoolDataDocumentId});

  @override
  State<AcceptInvitationSupervisor> createState() => _AcceptInvitationSupervisorState();
}

class _AcceptInvitationSupervisorState extends State<AcceptInvitationSupervisor> {
  String _schoolIdText = 'Loading...';
  String _schoolNameText = 'Loading...';
  String NameText = 'Loading...';
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getSchoolIdFromSupervisor(sharedpref!.getString('id').toString());
    // Use the schoolDataDocumentId in the initState method
    print('Supervisor class received document ID: ${widget.schoolDataDocumentId}');
  }

  Future<void> _getSchoolIdFromSupervisor(String supervisorId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference supervisorDocRef = _firestore.collection('supervisor').doc(sharedpref!.getString('id').toString());

    DocumentSnapshot supervisorDoc = await supervisorDocRef.get();
    if (supervisorDoc.exists) {
      var data = supervisorDoc.data() as Map<String, dynamic>;
      String? schoolId = data['schoolid'] as String?;
      String? schoolName = data['schoolname'] as String?;
      String? SupervisorName = data['name'] as String?;

      // Display the values in a Text widget
      setState(() {
        _schoolIdText = schoolId ?? 'No school ID found';
        _schoolNameText = schoolName ?? 'No school name found';
        NameText = SupervisorName ?? 'No Supervisor name found';
      });
    } else {
      print("Supervisor document does not exist.");
    }
  }

  // Future<String?> _getSchoolIdFromSupervisor(String supervisorId) async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final DocumentReference supervisorDocRef = _firestore.collection('supervior').doc(supervisorId);
  //
  //   DocumentSnapshot supervisorDoc = await supervisorDocRef.get();
  //   if (supervisorDoc.exists) {
  //     var data = supervisorDoc.data() as Map<String, dynamic>;
  //      data['schoolid'] as String?;
  //      data['schoolname'] as String?;
  //     // print($ata['schoolid'] as String?)
  //   } else {
  //     print("Supervisor document does not exist.");
  //     return null;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFFFFF),
          body: LayoutBuilder(builder: (context, constrains) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight,
                minWidth: constrains.maxWidth,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Group 237669.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/Invite-amico 1.png',
                        width: constrains.maxWidth / 1.77,
                        height: constrains.maxWidth / 1.77,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'You have an invitation \n'.tr,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 19,
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            TextSpan(
                              text: 'from $_schoolNameText School to \n '
                                  'join the application as a bus \n '
                                  'supervisor for your school'.tr,
                              style: TextStyle(
                                color: Color(0xFF442B72),
                                fontSize: 19,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedSimpleButton(
                            txt: 'Accept'.tr,
                            fontFamily: 'Poppins-Regular',
                            width: 117,
                            hight: 38,
                            onPress: () async {
                              await  FirebaseFirestore.instance.collection('supervisor').doc(sharedpref!.getString('id')).update(
                                  {'invite': 1,'state':1});
                              sharedpref!.setInt('invitstate',1);
                              sharedpref!.setInt('invit',1);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FinalAcceptInvitationSupervisor(
                                  )));

                              setState(() {
                              });


                              await _firestore.collection('notification').add({
                                'item': 'Invitation Accepted',
                                'timestamp': FieldValue.serverTimestamp(),
                                'SchoolId': _schoolIdText ,
                                'SupervisorId': sharedpref!.getString('id') ,
                                'SchoolName': _schoolNameText ,
                                'SupervisorName': NameText ,
                              });


                            },
                            color: Color(0xFF442B72),
                            fontSize: 16),
                        SizedBox(width: 15,),
                        SizedBox(
                            height: 39,
                            width: 117,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color(0xFF442B72),
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                child: SizedBox(
                                  width: 117,
                                  height: 38,
                                  child: Center(
                                    child: Text(
                                        'Decline'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF442B72),
                                            fontFamily: 'Poppins-Regular',
                                            fontWeight: FontWeight.w600 ,
                                            fontSize: 16)
                                    ),
                                  ),
                                ), onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DeclineInvitationForSupervisor(
                                    )));
                              },
                              ),
                            ))
                      ],
                    ),

                    const SizedBox(
                      height: 44,
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}