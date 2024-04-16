import 'package:flutter/material.dart';
import 'package:school_account/main.dart';

class SenderMessageItem extends StatelessWidget {
  String messageContent, time;

  SenderMessageItem(
      {super.key, required this.messageContent, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
       alignment: (sharedpref?.getString('lang') == 'ar') ?
       Alignment.topLeft :
       Alignment.topRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (const Color(0xFF771F98)),
            ),
            constraints: const BoxConstraints(
              maxWidth: 224,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              messageContent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.83,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Container(
            width: 60,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),
              color: (const Color(0xFFF1F1F1)),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 9,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  'assets/images/icon _checkmark circle_.png',
                  height: 20,
                  width: 23,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
