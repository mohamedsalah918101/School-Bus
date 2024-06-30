import 'package:flutter/material.dart';

class ChildDataItem extends StatelessWidget {
  String title, data;

  ChildDataItem({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF432B72),
            fontSize: 17,
            fontFamily: 'Poppins-SemiBold',
            fontWeight: FontWeight.w600,
            height: 0.94,
          ),
        ),
        const SizedBox(
          height: 5.3,
        ),
        Text(
          data,
          style: const TextStyle(
              color: Color(0xFF929292),
              fontSize: 18,fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
