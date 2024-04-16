import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/supervisor_parent/components/main_bottom_bar.dart';
import 'package:school_account/supervisor_parent/components/supervisor_card.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/edit_children.dart';
import 'elevated_simple_button.dart';

class ChildrenCard extends StatefulWidget {
  ChildrenCard({super.key, });

  @override
  State<ChildrenCard> createState() => _ChildrenCardState();
}

class _ChildrenCardState extends State<ChildrenCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')
                ? EdgeInsets.only(top: 15.0, right: 12,)
                : EdgeInsets.only(top: 15.0, left: 12,),
            child: Stack(
              children: [
                Column(
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
                            Row(
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
                                SizedBox(width: 55,),
                                Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? const EdgeInsets.only(right: 25.0)
                                      : const EdgeInsets.only(left: 25.0),
                                  child: PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    constraints: BoxConstraints.tightFor(width: 111, height: 100),
                                    color: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    offset: Offset(0, 30), // Custom offset to adjust menu position
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'item1',
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              (sharedpref?.getString('lang') == 'ar')
                                                  ? 'assets/images/edittt_white_translate.png'
                                                  : 'assets/images/edittt_white.png',
                                              width: 12.81,
                                              height: 12.76,),
                                            SizedBox(width: 7,),
                                            Text('Edit'.tr,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                                color: Color(0xFF432B72),
                                              ),),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'item2',
                                        child: Row(
                                          children: [
                                            Image.asset('assets/images/delete.png',
                                              width: 12.77,
                                              height: 13.81,),
                                            SizedBox(width: 7,),
                                            Text('Remove'.tr,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Color(0xFF432B72),
                                              ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (String value) {
                                      if (value == 'item1') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditChildren(),
                                          ),
                                        );
                                      } else if (value == 'item2') {
                                        Dialoge.RemoveChildDialog(context);
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/more.png',
                                      width: 20.8,
                                      height: 20.8,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Class: 1A'.tr,
                              style: Theme.of(context).textTheme.headline6!.copyWith(
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
                                    text: ' 1458 ى ر س',
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
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Supervisor : '.tr,
                                    style: TextStyle(
                                      color: Color(0xFF919191),
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Atef Aziz'.tr,
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
                          ],

                        )
                      ],
                    ),
                  ],
                ),
              ],
            )),

      ),
    );
  }
}
