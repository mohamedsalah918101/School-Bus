import 'package:flutter/material.dart';

import 'main_bottom_bar.dart';

class Custom {
  customAppBar(context, title) {
    return
           AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.49),
              ),
            ),
            shadowColor: Color(0x3F000000),
              // blurRadius: 12,
              // offset: Offset(-1, 4),
              // spreadRadius: 0,

            leading: GestureDetector(
              onTap: () {},
    // => Navigator.of(context).pushAndRemoveUntil(
                  // MaterialPageRoute(
                  //     builder: (context) => MainBottomNavigationBar(pageNum: 0)),
                  // (Route<dynamic> route) => false),
              child:  Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 23,
                color: Color(0xff442B72),
              ),
            ),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child:
            //     InkWell(
            //       onTap: () {},
            //       //   Navigator.push(
            //       //       context,
            //       //       MaterialPageRoute(
            //       //           builder: (context) => MainBottomNavigationBar(pageNum: 5),
            //       //           maintainState: false));
            //       // },
            //       child: Image.asset(
            //         'assets/images/Vector (11).png',
            //         width: 22,
            //         height: 22,
            //       ),
            //     ),
            //   ),
            // ],
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF993D9A),
                fontSize: 17,
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            backgroundColor: const Color(0xffF8F8F8),
             surfaceTintColor: Colors.transparent,


           );
    // ,]
    //   );
    // );
  }
}
