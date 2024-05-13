import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/parents_view.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'elevated_simple_button.dart';

class ProfileCardInSupervisor extends StatefulWidget {
  ProfileCardInSupervisor({super.key, });

  @override
  State<ProfileCardInSupervisor> createState() => _ProfileCardInSupervisorState();
}

class _ProfileCardInSupervisorState extends State<ProfileCardInSupervisor> {

  List<QueryDocumentSnapshot> data = [];


  getData()async{
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('supervisor').get();
    data.addAll(querySnapshot.docs);
    setState(() {
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:  101,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')?
            EdgeInsets.only( right: 19 ):
            EdgeInsets.only( left: 19 ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               GestureDetector(
                 onTap:  (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) =>
                         ProfileSupervisorScreen()),);
                 },
                 child: Image.asset('assets/images/Ellipse 16.png',
                 width: 62,
                 height: 62,),
               ),
                SizedBox(width: 18,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data?[0]['name'] }',
                    style: TextStyle(
                      color: Color(0xff442B72),
                      fontSize: 15,
                      fontFamily: 'Poppins-Bold',
                      fontWeight: FontWeight.w700,
                      // height: 1,
                    ),),
                    Text('${data?[0]['phoneNumber'] }',
                    style: TextStyle(
                      color: Color(0xff442B72),
                      fontSize: 12,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w400,
                    ),)
                  ],
                )
              ],
            ),),

      ),
    );
  }
}
