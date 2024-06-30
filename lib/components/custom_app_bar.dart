import 'package:flutter/material.dart';
import 'package:school_account/components/home_drawer.dart';

import 'main_bottom_bar.dart';

class Custom {
  customAppBar(context, title) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.49),
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
          // Navigator.of(context).pushAndRemoveUntil(
          // MaterialPageRoute(
          //     builder: (context) => MainBottomNavigationBar(pageNum: 0)),
          //     (Route<dynamic> route) => false
        },
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 23,
          color: Color(0xff442B72),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => MainBottomNavigationBar(pageNum: 5),
              //         maintainState: false)
              // );
            },
            child:
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: const Icon(
                  Icons.menu_rounded,
                  size: 40,
                  color: Color(0xff442B72),
                ),
              ),
            ),
          ),
        ),
      ],
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF993D9A),
          fontSize: 17,
          fontFamily: 'Poppins-Bold',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
      backgroundColor: const Color(0xffF8F8F8),
    );
  }
  // HomeDrawer buildHomeDrawer(BuildContext context) {
  //   return HomeDrawer();
  // }
}
