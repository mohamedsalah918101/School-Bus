import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  Function() function;

  // double page;
  int pageNum;
  Widget image;
  String lable;

  BottomBarItem(
      {super.key,
      required this.function,
      required this.pageNum,
      required this.image,
      required this.lable});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        onTap: function,
        title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              image,
              const SizedBox(height: 5),
              Text(
                lable,
                style: const TextStyle(fontSize: 11,
                    fontFamily: 'Poppins-Regular',
                    color: Colors.white),
              )
            ]),
      ),
    );
  }
}
