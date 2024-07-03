import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import '../../model/ParentModel.dart';
import '../../model/SupervisorsModel.dart';
import 'elevated_icon_button.dart';

class SupervisorCard extends StatefulWidget {
  const SupervisorCard({super.key});

  @override
  State<SupervisorCard> createState() => _SupervisorCardState();
}

class _SupervisorCardState extends State<SupervisorCard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  String parentName = '';
  List<ParentModel> childrenData = [];
  bool isLoading = true;

  String _supervisorName = '';


  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (userDoc.exists) {
        setState(() {
          _supervisorName = userDoc['supervisor_name'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  getData() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          parentName = documentSnapshot.get('name');
        });
        List<dynamic> children = documentSnapshot.get('children');
        for (int i = 0; i < children.length; i++) {
          DocumentSnapshot busSnapshot = await _firestore
              .collection('busdata')
              .doc(children[i]['bus_id'])
              .get();
          if (busSnapshot.exists) {
            List<dynamic> supervisors = busSnapshot.get('supervisors');
            List<SupervisorsModel> supervisorsData = [];
            String busNumber = '';
            busNumber = busSnapshot.get('busnumber');

            for (int x = 0; x < supervisors.length; x++) {
              supervisorsData.add(SupervisorsModel(
                  name: supervisors[x]['name'],
                  phone: supervisors[x]['phone'],
                  id: supervisors[x]['id'],
                  lat: supervisors[x]['lat'],
                  lang: supervisors[x]['lang']));
            }
            childrenData.add(ParentModel(
                child_name: children[i]['name'],
                class_name: children[i]['grade'],
                bus_number: busNumber,
                supervisors: supervisorsData));
          } else {
            childrenData.add(ParentModel(
                child_name: children[i]['name'],
                class_name: children[i]['grade'],
                bus_number: '',
                supervisors: []));
          }
        }
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: (sharedpref?.getString('lang') == 'ar') ? 102 : 100,
      child: Card(
        elevation: 10,
        color: const Color(0xFF442B72),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/Ellipse 6.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _supervisorName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'Poppins-SemiBold',
                                    fontWeight: FontWeight.w600,
                                    height: 0.94,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Supervisor'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Bus : 1458 ى ر س'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icons8_phone 1 (1).png',
                                    width: 28,
                                    height: 28,
                                  ),
                                  SizedBox(width: 9),
                                  GestureDetector(
                                    child: Image.asset(
                                      'assets/images/icons8_chat 1 (1).png',
                                      width: 26,
                                      height: 26,
                                    ),
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(builder: (context) =>
                                      //         ChatScreen()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
      );

  }
}
