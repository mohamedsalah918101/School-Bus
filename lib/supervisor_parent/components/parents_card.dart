import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class ParentsCard extends StatefulWidget {
  int? numberOfNames;

  @override
  State<ParentsCard> createState() => _ParentsCardState(numberOfNames: 0);
}

class _ParentsCardState extends State<ParentsCard> {
  int? updatedDataLength;
  final int numberOfNames;

  _ParentsCardState({required this.numberOfNames});


  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchDataLength();
  }

  void _fetchDataLength() async {
    print('Executing Firestore query...');
    final supervisorId = sharedpref!.getString('id');
    QuerySnapshot snapshot = await _firestore
        .collection('supervisor')
        .where('supervisor', isEqualTo: supervisorId)
        .get();
    setState(() {
      updatedDataLength = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 98,
      child: Card(
        color: Color(0xffA79FD9).withOpacity(0.44),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: (sharedpref?.getString('lang') == 'ar')
              ? EdgeInsets.only(right: 25)
              : EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/parent 1.png',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(width: 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parents'.tr,
                        style: TextStyle(
                          color: Color(0xff442B72),
                          fontSize: 15,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          // height: 1,
                        ),
                      ),
                      Text(
                        '#${numberOfNames ?? 0}', // Displaying the length of the list
                        style: TextStyle(
                          color: Color(0xff442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Align(
                // alignment: AlignmentDirectional.bottomStart,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String busID = '';
                            DocumentSnapshot documentSnapshot = await _firestore
                                .collection('supervisor')
                                .doc(sharedpref!.getString('id'))
                                .get();
                            if (documentSnapshot.exists) {
                              busID = documentSnapshot.data().toString().contains('bus_id') ? documentSnapshot.get('bus_id') : '';
                            }
                            if (busID == '') {
                               // CantAddNewSupervisor(context) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => Dialog(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.transparent,
                                      // contentPadding: const EdgeInsets.all(20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                      child: SizedBox(
                                        height: 210,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () => Navigator.pop(context),
                                                          child: Image.asset(
                                                            'assets/images/Vertical container.png',
                                                            width: 27,
                                                            height: 27,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      'Alert'.tr,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color(0xFF442B72),
                                                        fontSize: 18,
                                                        fontFamily: 'Poppins-SemiBold',
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.23,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  'This supervisor hasn\'t been added to a bus yet.',
                                                  style: TextStyle(
                                                    color: Color(0xFF442B72),
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins-Light',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.23,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              // ElevatedSimpleButton(
                                              //   txt: 'Go to parents'.tr,
                                              //   width: 157,
                                              //   hight: 38,
                                              //   onPress: () async {
                                              //     // await sharedpref!.setInt('invit', 0);
                                              //
                                              //     // await sharedpref!.setString('id', '');
                                              //     Navigator.of(context).pushAndRemoveUntil(
                                              //         MaterialPageRoute(
                                              //             builder: (context) =>  ParentsView()),
                                              //             (Route<dynamic> route) => false);
                                              //   } ,
                                              //   color: const Color(0xFF442B72),
                                              //   fontSize: 16,
                                              //   fontFamily: 'Poppins-Regular',
                                              // ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //   content: Text('This supervisor hasn\'t been added to a bus yet.'),
                              // ));
                             else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddParents()),
                              );
                            }
                          },
                          child: Image.asset(
                            'assets/images/icons8_add_1 1 (1).png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                    SizedBox(height: 25),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ParentsView()),
                          );
                        },
                        child: Container(
                          width: 53,
                          height: 27,
                          decoration: BoxDecoration(
                            color: Color(0xff442B72),
                            borderRadius: (sharedpref?.getString('lang') == 'ar')
                                ? BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(5))
                                : BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Image.asset(
                              (sharedpref?.getString('lang') == 'ar')
                                  ? 'assets/images/Vector (13)leftpng.png'
                                  : 'assets/images/Vector (13)right.png',
                              width: 17.71,
                              height: 17.71,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
// import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
// import 'package:school_account/main.dart';
// import 'package:school_account/supervisor_parent/screens/add_parents.dart';
// import 'package:school_account/supervisor_parent/screens/parents_view.dart';
// import 'package:school_account/supervisor_parent/screens/track_parent.dart';
// import 'elevated_simple_button.dart';
//
// class ParentsCard extends StatefulWidget {
//    late final int dataLength;
//
//
//
//   ParentsCard({
//     Key? key,
//     required this.dataLength,
//
//
//   }) : super(key: key);
//
//   @override
//   State<ParentsCard> createState() => _ParentsCardState();
// }
//
// class _ParentsCardState extends State<ParentsCard> {
//    int? updatedDataLength ;
//    final _firestore = FirebaseFirestore.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     updatedDataLength = widget.dataLength;
//   }
//
//   @override
//   void didUpdateWidget(ParentsCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.dataLength != widget.dataLength) {
//       setState(() {
//         updatedDataLength = widget.dataLength;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return SizedBox(
//       width: double.infinity,
//       height:  98,
//       child: Card(
//         color: Color(0xffA79FD9).withOpacity(0.44),
//         surfaceTintColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//         child: Padding(
//           padding: (sharedpref?.getString('lang') == 'ar')?
//           EdgeInsets.only(right: 25, ):
//           EdgeInsets.only(left: 25, ),
//           child:  Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/images/parent 1.png',
//                     width: 60,
//                     height: 60,),
//                   SizedBox(width: 18,),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Parents'.tr,
//                         style: TextStyle(
//                           color: Color(0xff442B72),
//                           fontSize: 15,
//                           fontFamily: 'Poppins-Bold',
//                           fontWeight: FontWeight.w700,
//                           // height: 1,
//                         ),),
//                       Text( '#${updatedDataLength}', // Displaying the length of the list
//                         style: TextStyle(
//                           color: Color(0xff442B72),
//                           fontSize: 12,
//                           fontFamily: 'Poppins-Regular',
//                           fontWeight: FontWeight.w400,
//                         ),)
//                     ],
//                   ),
//
//                 ],
//               ),
//               Align(
//                 // alignment: AlignmentDirectional.bottomStart,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap:() async{
//                             String busID = '';
//                             DocumentSnapshot documentSnapshot = await _firestore
//                                 .collection('supervisor')
//                                 .doc(sharedpref!.getString('id'))
//                                 .get();
//                             if (documentSnapshot.exists) {
//                               busID = documentSnapshot.data().toString().contains('bus_id') ?  documentSnapshot.get('bus_id') :'';
//                             }
//                             if(busID == ''){
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text('This supervisor hadn\'t added to bus yet.'),
//                               ));
//                             }else {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) =>
//                                     AddParents()),);
//                             }  },
//                           child: Image.asset('assets/images/icons8_add_1 1 (1).png',
//                             width: 30,
//                             height: 30,),
//                         ),
//                         SizedBox(width: 15,)
//                       ],
//                     ),
//                     SizedBox(height: 25,),
//                     Align(
//                       alignment: AlignmentDirectional.bottomStart,
//                       child: GestureDetector(
//                           onTap:(){
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) =>
//                                     ParentsView()));
//                           },
//                           child: Container(
//                             width: 53,
//                             height: 27,
//                             decoration: BoxDecoration(
//                                 color: Color(0xff442B72),
//                                 borderRadius:
//                                 (sharedpref?.getString('lang') == 'ar')?
//                                 BorderRadius.only(
//                                     topRight: Radius.circular(15),
//                                     bottomLeft: Radius.circular(5)):
//                                 BorderRadius.only(
//                                     topLeft: Radius.circular(15),
//                                     bottomRight: Radius.circular(5))
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(7.0),
//                               child: Image.asset(
//                                 (sharedpref?.getString('lang') == 'ar')?
//                                 'assets/images/Vector (13)leftpng.png':
//                                 'assets/images/Vector (13)right.png',
//                                 width: 17.71,
//                                 height: 17.71,),
//                             ),
//                           )
//
//
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 4.0 , bottom: 0),
//                         //   child: Image.asset('assets/images/Group 237683.png',
//                         //   height: 43,
//                         //   width: 53,),
//                         // ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),),
//       ),
//     );
//   }
// }
