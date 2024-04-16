import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  String messageContent, time, times, type;

  NotificationItem(
      {super.key,
      required this.messageContent,
      required this.time,
      required this.times,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 95,
          minWidth: double.infinity,
        ),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Card(
          color: Color(0xffffffff),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      type == 'Taken From School' .tr
                          ? 'assets/images/house2.png'
                          : type == 'Arrival Reminder'.tr || type == 'Delays'.tr
                              ? 'assets/images/locationtick.png'
                              : 'assets/images/alarm.png' ,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      type,
                      style: TextStyle(
                        color: type == 'Taken From School'.tr
                            ? const Color(0xFFFFC53D)
                            : type == 'Arrival Reminder'.tr || type == 'Delays'.tr
                                ? const Color(0xFF771F98)
                                : const Color(0xFFDA1622),
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        height: 1.07,
                      ),
                    ),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: time,
                        style: const TextStyle(
                          color: Color(0xFF442B72),
                          fontSize: 12,
                          fontFamily: 'Poppins-SemiBold',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                          ),
                          TextSpan(
                            text: times.tr,
                            style: TextStyle(
                              color: Color(0xFF442B72),
                              fontSize: 12,
                              fontFamily: 'Poppins-SemiBold',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                        ],

                      )


                    )
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  messageContent,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
