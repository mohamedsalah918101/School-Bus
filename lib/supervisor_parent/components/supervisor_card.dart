import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'elevated_icon_button.dart';

class SupervisorCard extends StatelessWidget {
  const SupervisorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:
      (sharedpref?.getString('lang') == 'ar')?
      102: 100,
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
                          'Aya Essam'.tr,
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
                          Image.asset('assets/images/icons8_phone 1 (1).png' ,
                          width: 28,
                          height: 28,),
                          SizedBox(width: 9),
                          GestureDetector(
                            child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
                              width: 26,
                              height: 26,),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      ChatScreen()));},
                          ),],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
