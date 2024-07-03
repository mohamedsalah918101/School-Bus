import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import '../../Functions/functions.dart';
import '../../model/ParentModel.dart';
import '../../model/SupervisorsModel.dart';
import 'elevated_simple_button.dart';

class ChildrenTakeBusCard extends StatefulWidget {
  ParentModel? childrenData;
  ChildrenTakeBusCard({super.key});

  @override
  State<ChildrenTakeBusCard> createState() => _ChildrenTakeBusCardState();
}

class _ChildrenTakeBusCardState extends State<ChildrenTakeBusCard> {
  final _firestore = FirebaseFirestore.instance;
  String parentName = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData()async{
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('parent').doc(sharedpref!.getString('id')).get();
      if (documentSnapshot.exists) {
        setState(() {
          parentName = documentSnapshot.get('name');
        });
        List<dynamic> children =  documentSnapshot.get('children');
        for(int i =0; i<children.length ;i++){
          DocumentSnapshot busSnapshot = await _firestore.collection('busdata').doc(children[i]['bus_id']).get();
          if (busSnapshot.exists) {
            List<dynamic> supervisors =  busSnapshot.get('supervisors');
            List<SupervisorsModel> supervisorsData =[];
            String busNumber='';
            busNumber =  busSnapshot.get('busnumber');

            for(int x =0; x<supervisors.length ;x++){
              supervisorsData.add(SupervisorsModel(name: supervisors[x]['name'],phone: supervisors[x]['phone'],id: supervisors[x]['id'],lat: supervisors[x]['lat'],lang:supervisors[x]['lang']));
            }
            childrenData.add(ParentModel(child_name: children[i]['name'],class_name: children[i]['grade'],bus_number: busNumber,supervisors: supervisorsData));

          }else{
            childrenData.add(ParentModel(child_name: children[i]['name'],class_name: children[i]['grade'],bus_number: '',supervisors: []));

          }

        }

      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 174,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: const EdgeInsets.only(top: 15.0 , left: 12, right: 12 , bottom: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/Ellipse 1.png',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shady Ayman'.tr,
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xFF432B72),
                            fontSize: 17,
                            fontFamily: 'Poppins-SemiBold',
                            fontWeight: FontWeight.w600,
                            height: 0.94,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Class: 1A'.tr,
                          style:
                          Theme.of(context).textTheme.headline6!.copyWith(
                            color: Color(0xFF919191),
                            fontSize: 12,
                            fontFamily: 'Poppins-Light',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Today’s Bus : '.tr,
                                style: TextStyle(
                                  color: Color(0xFF919191),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                              TextSpan(
                                text: '1458 ى ر س',
                                style: TextStyle(
                                  color: Color(0xFF442B72),
                                  fontSize: 12,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFF13DC64),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF13DC64),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              width: 5,
                              height: 5,
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Text(
                              'Available Today'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                color: Color(0xFF919191),
                                fontSize: 12,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              SizedBox(height: 15,),
                 Align(
                  alignment:
                  (sharedpref?.getString('lang') == 'ar') ?
                  Alignment.bottomLeft :
                  Alignment.bottomRight ,
                  child: SizedBox(
                    width: 93,
                    height: 40,
                    child: ElevatedSimpleButton(
                      txt: 'Track Bus'.tr,
                      width: 92,
                      hight: 40,
                      onPress: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                TrackParent()));},
                      txtColor: Colors.white,
                      color: const Color(0xFF442B72),
                      fontSize: 13, fontFamily: 'Poppins-Bold',
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}