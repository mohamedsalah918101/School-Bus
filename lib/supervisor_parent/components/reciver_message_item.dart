import 'package:flutter/material.dart';
import 'package:school_account/main.dart';

class ReciverMessageItem extends StatelessWidget {
  String messageContent, time;

  ReciverMessageItem(
      {super.key, required this.messageContent, required this.time,});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (sharedpref?.getString('lang') == 'ar') ?
      Alignment.topRight :
      Alignment.topLeft ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF771F98), width: 1.83333),
                color: Colors.transparent),
            constraints: const BoxConstraints(
              maxWidth: 224,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              messageContent,
              style: const TextStyle(
                color: Color(0xFF171717),
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
            width: 48,
            height: 19,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),
              color: (const Color(0xFFF1F1F1)),
            ),
            padding: const EdgeInsets.all(4),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 9,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
